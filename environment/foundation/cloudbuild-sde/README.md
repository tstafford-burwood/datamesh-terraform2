# Terraform Module for Provisioning Cloud Build Service Account IAM Roles and Cloud Build triggers

## Branching Strategy
![](../../../docs/branch-strategy.png)

---

This stage performs two tasks:
- Create pipelines to run each task
- Create an environment

<!-- TFDOC OPTS files:1 show_extra:1 -->
<!-- BEGIN TFDOC -->

## Files

| name | description | modules | resources |
|---|---|---|---|
| [backend.tf](./backend.tf) | None |  |  |
| [main.tf](./main.tf) | Module-level locals and resources. | <code>constants</code> · <code>folder_iam</code> | <code>google_cloudbuild_trigger</code> |
| [triggers-container.tf](./triggers-container.tf) | None |  | <code>google_cloudbuild_trigger</code> |
| [triggers-researchers.tf](./triggers-researchers.tf) | None |  | <code>google_cloudbuild_trigger</code> |
| [variables.tf](./variables.tf) | Module variables. |  |  |

## Variables

| name | description | type | required | default | producer |
|---|---|:---:|:---:|:---:|:---:|
| [github_owner](variables.tf#L2) | GitHub Organization Name | <code>string</code> | ✓ |  |  |
| [github_repo_name](variables.tf#L7) | Name of GitHub Repo | <code>string</code> | ✓ |  |  |
| [branch_name](variables.tf#L18) | Regex matching branches to build. Exactly one a of branch name, tag, or commit SHA must be provided. The syntax of the regular expressions accepted is the syntax accepted by RE2 and described at https://github.com/google/re2/wiki/Syntax | <code>string</code> |  | <code>&#34;&#94;main&#36;&#34;</code> |  |
| [iam_role_list](variables.tf#L24) | The IAM role(s) to assign to the member at the defined folder. | <code>list&#40;string&#41;</code> |  | <code title="&#91;&#10;  &#34;roles&#47;bigquery.dataOwner&#34;,&#10;  &#34;roles&#47;cloudbuild.builds.builder&#34;,&#10;  &#34;roles&#47;composer.environmentAndStorageObjectAdmin&#34;,&#10;  &#34;roles&#47;compute.instanceAdmin.v1&#34;,&#10;  &#34;roles&#47;compute.networkAdmin&#34;,&#10;  &#34;roles&#47;iam.serviceAccountAdmin&#34;,&#10;  &#34;roles&#47;iam.serviceAccountUser&#34;,&#10;  &#34;roles&#47;pubsub.admin&#34;,&#10;  &#34;roles&#47;resourcemanager.projectCreator&#34;,&#10;  &#34;roles&#47;resourcemanager.projectIamAdmin&#34;,&#10;  &#34;roles&#47;serviceusage.serviceUsageConsumer&#34;,&#10;  &#34;roles&#47;storage.admin&#34;,&#10;  &#34;roles&#47;resourcemanager.folderCreator&#34;&#10;&#93;">&#91;&#8230;&#93;</code> |  |
| [plan_trigger_disabled](variables.tf#L12) | Whether the trigger is disabled or not. If true, the trigger will never result in a build. | <code>bool</code> |  | <code>false</code> |  |

<!-- END TFDOC -->
<!-- 
The purpose of this directory is to apply defined IAM roles to a Cloud Build Service Account at the folder level.

## General Usage

1. From a best practice approach a new branch should generally be created from the `master` or `main` branch when working on new features or updates.
    1. Run `git checkout -b <BRANCH_NAME>`
1. Change into the desired directory that needs to have infrastructure code updated.
1. Edit either the `main.tf`, `variables.tf`, or `terraform.tfvars` file, depending on what needs to be updated.
1. If there are variables which are needed but not present in the `.tfvars` file those can be added and updated as needed.
1. In order to limit any auto-approved changes being made to your infrastructure there are two options.
    1. If you want to merge back into master you can edit out any `apply` steps within the Cloud Build YAML file that this pipeline is associated to so that only an `init` and `plan` are ran to show what the potential Terraform changes will do.
    1. If you are working out of a feature branch you can create a new Cloud Build trigger to monitor the feature branch, create a new Cloud Build YAML with only an `init` and `plan` step, then verify that the `plan` output is good to proceed forward with.
1. Save your files, `git add <files>`, `git commit -m "<MESSAGE>"`, `git push`.
1. If you were working out of a feature branch you can merge back into `master`.
    1. `git checkout <master or main>`, `git merge <FEATURE_BRANCH> --no-ff`
1. A manual pipeline run may need to be started after a merge is done if no edits have been done on the `included_files` after the merge. These are generally the `.tfvars` files which are monitored for changes to start the pipeline.

Below is an example of how to update the `.tfvars` file in order to update IAM roles for the Cloud Build Service account.

```diff
iam_role_list = [
  "roles/bigquery.dataOwner",
  "roles/cloudbuild.builds.builder",
  "roles/composer.environmentAndStorageObjectAdmin",
  "roles/compute.instanceAdmin.v1",
  "roles/compute.networkAdmin",
  "roles/iam.serviceAccountAdmin",
  "roles/iam.serviceAccountUser",
  "roles/pubsub.admin",
  "roles/resourcemanager.projectCreator",
  "roles/resourcemanager.projectIamAdmin",
  "roles/serviceusage.serviceUsageConsumer",
+ "roles/storage.admin",
+ "roles/pubsub.viewer"
]
``` -->
