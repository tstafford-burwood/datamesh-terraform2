#!/bin/bash

# This fixes a certbot error about an incorrect dependency version
sudo pip install 'zope.interface>=5.3.0a1'

EAB_KID=$(gcloud secrets versions access "latest" --secret "eab-kid" --project=asu-ke-rto-admin)
EAB_HMAC_KEY=$(gcloud secrets versions access "latest" --secret "eab-hmac-key" --project=asu-ke-rto-admin)
# Request certificate if the keys exist (they must be added manually)
if [ ! -z "$EAB_KID" -a ! -z "$EAB_HMAC_KEY" ]
then
  certbot certonly \
    --standalone \
    --non-interactive \
    --agree-tos \
    --email asre-support@asu.edu \
    --server https://acme.sectigo.com/v2/InCommonRSAOV \
    --eab-kid $${EAB_KID} \
    --eab-hmac-key $${EAB_HMAC_KEY} \
    --domain ${hostname} --cert-name DVcert
fi

# Check that the certs got created, and create self-signed ones if not
if [ ! -d "/etc/letsencrypt/live/DVcert" ]
then
  openssl req -newkey rsa:4096 \
            -x509 \
            -sha256 \
            -days 3650 \
            -nodes \
            -out /etc/letsencrypt/live/DVcert/fullchain.pem \
            -keyout /etc/letsencrypt/live/DVcert/privkey.pem \
            -subj "CN=${hostname}"
else
  # If the ACME certs are there setup a renewal cron job
echo "43 0 */14 * * root certbot renew -q" > /etc/crontab
fi

# Get database password from secrets manager so it's not visible in the metadata.
PG_PASSWORD=$(gcloud secrets versions access "latest" --secret "filemage-database-password")

# Need .pgpass to avoid password prompt.
echo "${pg_host}:5432:filemage-db:filemage:$${PG_PASSWORD}" >> .pgpass
echo "${pg_host}:5432:postgres:filemage:$${PG_PASSWORD}" >> .pgpass
chmod 600 .pgpass

# Configure the pg_partman extension and associated schema.
# Ideally this would only be done once but since these
# commands are idempotent we can run this on each instance boot
# to keep the automation simple.
PGPASSFILE=.pgpass psql -h ${pg_host} -U filemage -d filemage-db << EOF
CREATE SCHEMA IF NOT EXISTS partman;
CREATE EXTENSION IF NOT EXISTS pg_partman SCHEMA partman;
GRANT ALL ON SCHEMA partman TO filemage;
GRANT ALL ON ALL TABLES IN SCHEMA partman TO filemage;
GRANT EXECUTE ON ALL FUNCTIONS IN SCHEMA partman TO filemage;
GRANT EXECUTE ON ALL PROCEDURES IN SCHEMA partman TO filemage;
EOF

PGPASSFILE=.pgpass psql -h ${pg_host} -U filemage -d postgres << EOF
CREATE EXTENSION IF NOT EXISTS pg_cron;
SELECT cron.schedule('pg-partman-background', '30 * * * *', 'SELECT partman.run_maintenance(p_analyze := false, p_jobmon := true)');
UPDATE cron.job SET database = 'filemage-db' WHERE jobname = 'pg-partman-background';
EOF

rm .pgpass

# Each instance needs to present the same host key when accessed
# through the load balancer. For demo purposes we are going to
# use a hardcoded key, in a production environment you should
# generate a unique key.
gcloud secrets versions access "latest" --secret "filemage-host-key-secret" > /etc/filemage/ssh_host_rsa_key
chmod 600 /etc/filemage/ssh_host_rsa_key

# Write the application config.
cat > /etc/filemage/config.yml << EOF
workspace_port: 443
authentication_log:
  enabled: yes
  path: /var/log/filemage/auth.log
  format: logfmt
  max_size_mb: 10
  max_backups: 3
  max_age_days: 28
  compress: yes
ftp_log:
  enabled: yes
  path: /var/log/filemage/ftp.log
  format: logfmt
  max_size_mb: 10
  max_backups: 3
  max_age_days: 28
  compress: yes
ftp_require_tls: yes
http_cors_origins:
  - ${hostname}
http_session_age: 3600
lockout:
  enabled: true
  max_attempts: 5
  interval: 15
  ban_duration: 120
metrics:
  service: google_cloud
pg_host: ${pg_host}
pg_user: filemage
pg_password: $${PG_PASSWORD}
pg_database: filemage-db
pg_ssl_mode: require
sftp_host_keys:
  - /etc/filemage/ssh_host_rsa_key
sftp_key_exchanges:
  - curve25519-sha256@libssh.org
  - ecdh-sha2-nistp256
  - ecdh-sha2-nistp384
  - ecdh-sha2-nistp521
  - diffie-hellman-group14-sha256
sftp_log:
  enabled: yes
  path: /var/log/filemage/sftp.log
  format: logfmt
  max_size_mb: 10
  max_backups: 3
  max_age_days: 28
  compress: yes
tls_certificate: /etc/letsencrypt/live/DVcert/fullchain.pem
tls_certificate_key: /etc/letsencrypt/live/DVcert/privkey.pem
tls_min_version: 1.2
tls_ciphers:
  - TLS_ECDHE_RSA_WITH_CHACHA20_POLY1305_SHA256
  - TLS_ECDHE_ECDSA_WITH_CHACHA20_POLY1305_SHA256
  - TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
  - TLS_ECDHE_ECDSA_WITH_AES_128_GCM_SHA256
  - TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
  - TLS_ECDHE_ECDSA_WITH_AES_256_GCM_SHA384
  - TLS_RSA_WITH_AES_128_GCM_SHA256
  - TLS_RSA_WITH_AES_256_GCM_SHA384
workspace_disable_share: yes
workspace_public_url: https://${hostname}/workspace/
EOF

# Write the same session secret to each instance so cookies can be shared across instances.
APP_SECRET=$(gcloud secrets versions access "latest" --secret "filemage-application-secret")
echo $APP_SECRET > /opt/filemage/.secret

systemctl restart filemage

filemage init --email ktinnin@asu.edu --password ChangeMe123! --reset

# Disable the database that comes pre-installed on the image.
systemctl stop postgresql
systemctl disable postgresql