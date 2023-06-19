# [Using Airflow UI Access Control - Cloud Composer 1](https://cloud.google.com/composer/docs/airflow-rbac#airflow-1_1)

Cloud Composer supports the community version of Airflow UI Access Control. This functionality allows to reduce DAG visibility in Airflow UI and DAG UI based on user role.

Access to Airflow UI and DAG UI and visibility of data and operations in those UIs is controlled at two levels in Cloud Composer:

1. Access to the Airflow UI and DAG UI in Cloud Composer is controlled by IAM. Users must first authenticate to Identity-Aware Proxy with proper IAM permissions. Afterwards, they can access the Airflow UI. Once users have access to the Airflow UI, IAM does not provide any additional fine-grained permission control in the Airflow UI or DAG UI.
1. Apache Airflow Access Control model provides an additional layer that controls visibility and access within individual pages and DAGs in Airflow UI and DAG UI.

>Caution :warning: Apache Airflow Access Control is a feature of Airflow, with its own model of users, roles, permissions, which is different from IAM.

## Register users in the Airflow UI

The first time the Terraform scripts to deploy Cloud Composer are ran, the Airflow configuration varaibled `[webserver]rbac_user_registration_role` is set to `Admin`. This allows the first user that logs into the Airlflow UI to be granted the `Admin` role within Apache Airflow. If the Terraform script is ran a second time, Terraform will chnage this value to `Public`, which keeps the user's registration, but removes all permissions for the Airflow UI. This is another layer that prevents user access.

## [How to add new users to the `Admin` role](https://cloud.google.com/composer/docs/airflow-rbac#registering-users)

1. Go to the Environments page in the Google Cloud console
1. Select the `Airflow` web link below Airflow webserver. This will launch a new tab and open up the Airflow Console UI.
1. From the Airflow Console UI > Select **Security** > **List Users**
1. Select the [ + ] icon to add a new user record.
1. Set the username field to the user's primary email address.
1. Under roles, assign `Admin` role.
1. Click Save.
>**Note**: When a user with an email address matching a preregistered user record logs in to Airflow UI for the first time, their username is replaced with the user ID currently (at the time of first login) identified by their email address. The relationship between Google identities (email addresses) and user accounts (user IDs) is not fixed. Google groups cannot be preregistered.


## Configure DAG-level permissions

The Per-folder Roles Registration feature automatically creates a custom Airflow role for each subfolder directly inside the /dags folder and grants this role DAG-level access to all DAGs that have their source file stored in that respective subfolder. This streamlines management of custom Airflow roles and their access to DAGs.

To use this configuration, follow the [Google Doc instructions](https://cloud.google.com/composer/docs/airflow-rbac#dag-permissions-auto).


## How to ugprade Cloud Composer

To upgrade Cloud Composer update the [image_version](./variables.tf#L49) variable to the desired version. The latest Cloud Composer images are found [here](https://cloud.google.com/composer/docs/concepts/versioning/composer-versions).

### Example

To upgrade from `composer-1.20.2-airflow-1.10.15` to `composer-1.20.7-airflow-1.10.15` change the default value.

```diff
variable "image_version" {
  description = "The version of Airflow running in the Cloud Composer environment. Latest version found [here](https://cloud.google.com/composer/docs/concepts/versioning/composer-versions)."
  type        = string
  - default     = "composer-1.20.2-airflow-1.10.15"
  + default     = "composer-1.20.7-airflow-1.10.15"
}
```

## Scaling Environments

You can scale environments vertically and horizontally. Other resources like the web server and Cloud SQL instance can be adjusted. The steps are detailed in the [Google Doc here](https://cloud.google.com/composer/docs/scale-environments), and the values to change in code are in the [variables.tf](./variables.tf) file.