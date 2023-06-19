import os
from google.oauth2 import id_token
from google.auth import impersonated_credentials
# import google.auth
import google.auth.transport.requests
from google.auth.transport.requests import AuthorizedSession

print('====================================================================================================')
print('Calling Cloud Run ...')
print('----------------------------------------------------------------------------------------------------')

service_account = os.environ.get("SERVICE_ACCOUNT") # 'cloudops-asset-inventory-sa@project-id.iam.gserviceaccount.com'
print(f"service_account: {service_account}")
target_audience = os.environ.get("TARGET_AUDIENCE") # 'https://hello-world-1-weky7tye5q-uc.a.run.app'
print(f"target_audience: {target_audience}")
url = os.environ.get("URL")  # 'https://hello-world-1-weky7tye5q-uc.a.run.app'
print(f"            url: {url}")
print('====================================================================================================')

credentials, project_id = google.auth.default()

target_scopes = ['https://www.googleapis.com/auth/cloud-platform']

target_credentials = impersonated_credentials.Credentials(
    source_credentials=credentials,
    target_principal=service_account,
    target_scopes=target_scopes,
    delegates=[],
    lifetime=3600)

creds = impersonated_credentials.IDTokenCredentials(
    target_credentials,
    target_audience=target_audience)

authed_session = AuthorizedSession(creds)

# make authenticated request and print the response, status_code
resp = authed_session.get(url)
print(resp.status_code)
print(resp.text)

# to verify an ID Token
request = google.auth.transport.requests.Request()
token = creds.token
print(token)
print(id_token.verify_token(token, request))