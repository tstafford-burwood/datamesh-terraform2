# Terraform Module for Artifact Registry

This module is used to create an Artifact Registry Repository in a defined GCP project and has a defined artifact format type such as Docker, Python, etc.

## Usage

Below is an example of how to use this module.

```terraform

module "artifact_registry_repository" {
  source = "./modules/artifact_registry"

  artifact_repository_project_id  = "project1234"
  artifact_repository_name        = "repository"
  artifact_repository_format      = "DOCKER"
  artifact_repository_location    = "us-east1"
  artifact_repository_description = "Artifact Repository created with Terraform"
  artifact_repository_labels      = {"artifact":"repository"}
}
```

## Providers

| Name | Version |
|------|---------|
| google-beta | n/a |

## Resources

| Name |
|------|
| [google-beta_google_artifact_registry_repository](https://registry.terraform.io/providers/hashicorp/google-beta/latest/docs/resources/google_artifact_registry_repository) |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| artifact\_repository\_description | The user-provided description of the repository. | `string` | `"Artifact Registry Repository created with Terraform."` | no |
| artifact\_repository\_format | The format of packages that are stored in the repository. You can only create alpha formats if you are a member of the [alpha user group](https://cloud.google.com/artifact-registry/docs/supported-formats#alpha-access). DOCKER, MAVEN (Preview), NPM (Preview), PYTHON (Preview), APT (alpha), YUM (alpha). | `string` | `""` | no |
| artifact\_repository\_labels | Labels with user-defined metadata. This field may contain up to 64 entries. Label keys and values may be no longer than 63 characters. Label keys must begin with a lowercase letter and may only contain lowercase letters, numeric characters, underscores, and dashes. | `map(string)` | `{}` | no |
| artifact\_repository\_location | The name of the location this repository is located in. | `string` | `""` | no |
| artifact\_repository\_name | The name of the repository that will be provisioned. | `string` | `""` | no |
| artifact\_repository\_project\_id | The ID of the project in which the resource belongs. If it is not provided, the provider project is used. | `string` | `""` | no |

## Outputs

| Name | Description |
|------|-------------|
| id | An identifier for the resource with format projects/{{project}}/locations/{{location}}/repositories/{{repository\_id}}. |
| name | The name of the repository, for example: `projects/p1/locations/us-central1/repositories/repo1` |