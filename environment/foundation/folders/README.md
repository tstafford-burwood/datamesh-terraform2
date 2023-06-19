# 01-Folder Heirarchy

![](../../../docs/resource-hierarchy.png)

This module deploys a folder heirarchy that is split into two different categories:
* Foundation
* Deployments

Folder Structure

* **Foundation** contains projects and resources that is goverened and control usually by Central IT. The resources under this folder are shared to the `Deployments` folder.
* **Deployments** contains projects and resources consumed by the research community.

## Org Policies Deployed

* `constraints/iam/automaticIamGrantsForDefaultServiceAccounts`
* `constraints/iam/disableServiceAccountCreation`
* `constraints/iam/disableServiceAccountKeyCreation`
* `constraints/compute/disableNestedVirtualization`
* `constraints/storage/publicAccessPrevention`
* `constraints/storage.uniformBucketLevelAccess`
* `constraints/gcp.resourceLocations`
* `constraints/sql.restrictPublicIp`
* `constraints/compute.requireShieldedVm`
* `constraints/compute.skipDefaultNetworkCreation`
* `constraints/compute.vmExternalIpAccess`
* `constraints/compute.vmCanIpForward`
* `constraints/compute.requireOsLogin`

### Configure Parent Folder

This modules deploys a folder hierarchy under the parent folder id listed in the [constants.tf](../../foundation/constants/constants.tf) using the value listed in the `sde_folder_id`.

## Expected outcome

```
. Parent Folder
.. DEV - fldr
├── Foundation SDE - fldr
└── Deployments SDE - fldr
    └── workspace-1-sde - fldr
```

### Additional Research Folders

The default deployment creates one research workspace folder with multiple projects underneath of it. To create multiple folders, update the variable `researcher_workspace_folders`

```diff
# variables.tf
variable "researcher_workspace_folders" {
  
  description = "List of  researcher workspaces names"
  type        = list(string)
  default = [
    "workspace-1",
+    "workspace-2"
  ]
}
```

<!-- TFDOC OPTS files:1 show_extra:1 -->
<!-- BEGIN TFDOC -->

## Files

| name | description | modules | resources |
|---|---|---|---|
| [backend.tf](./backend.tf) | None |  |  |
| [central-logging.tf](./central-logging.tf) | None | <code>centralized-logging</code> | <code>random_id</code> |
| [main.tf](./main.tf) | Module-level locals and resources. | <code>constants</code> | <code>google_folder</code> · <code>google_folder_iam_audit_config</code> · <code>time_sleep</code> |
| [org-pol.tf](./org-pol.tf) | None | <code>google</code> | <code>google_folder_organization_policy</code> |
| [outputs.tf](./outputs.tf) | Module outputs. |  |  |
| [variables.tf](./variables.tf) | Module variables. |  |  |
| [versions.tf](./versions.tf) | Version pins. |  |  |

## Variables

| name | description | type | required | default | producer |
|---|---|:---:|:---:|:---:|:---:|
| [audit_log_config](variables.tf#L7) | Permission type for which logging is to be configured. Can be `DATA_READ`, `DATA_WRITE`, or `ADMIN_READ`. Leave emtpy list to turn off. | <code>list&#40;string&#41;</code> |  | <code>&#91;&#34;DATA_READ&#34;, &#34;DATA_WRITE&#34;, &#34;ADMIN_READ&#34;&#93;</code> |  |
| [audit_service](variables.tf#L13) | Service which will be enabled for audit logging. | <code>string</code> |  | <code>&#34;storage.googleapis.com&#34;</code> |  |
| [domain_restricted_sharing_allow](variables.tf#L35) | List one or more Cloud Identity or Google Workspace custom IDs whose principals can be added to IAM policies. Leave empty to not enable. | <code>list&#40;string&#41;</code> |  | <code>&#91;&#93;</code> |  |
| [enforce](variables.tf#L48) | Whether this policy is enforce. | <code>bool</code> |  | <code>true</code> |  |
| [folder_name](variables.tf#L19) | Top level folder name | <code>string</code> |  | <code>&#34;HIPAA&#34;</code> |  |
| [researcher_workspace_folders](variables.tf#L1) | List of folder to create for researcher workspaces | <code>list&#40;string&#41;</code> |  | <code>&#91;&#93;</code> |  |
| [resource_location_restriction_allow](variables.tf#L42) | This list constraint defines the set of locations where location-based GCP resources can be created. | <code>list&#40;string&#41;</code> |  | <code>&#91;&#34;in:us-central1-locations&#34;&#93;</code> |  |
| [vms_allowed_external_ip](variables.tf#L29) | This list constraint defines the set of Compute Engine VM instances that are allowed to use external IP addresses, every element of the list must be identified by the VM instance name, in the form: projects/PROJECT_ID/zones/ZONE/instances/INSTANCE | <code>list&#40;string&#41;</code> |  | <code>&#91;&#93;</code> |  |

## Outputs

| name | description | sensitive | consumers |
|---|---|:---:|---|
| [deployments_folder_id](outputs.tf#L11) | The deployment folder id. |  | <code>egress-project</code> · <code>workspace-project</code> · <code>data-lake</code> · <code>cloud-composer-dags</code> |
| [environemnt_folder_id](outputs.tf#L1) |  |  | <code>data-ops-project</code> |
| [foundation_folder_id](outputs.tf#L6) |  |  | <code>data-lake</code> · <code>data-ops-project</code> · <code>image-project</code> |
| [ids](outputs.tf#L18) | Folder ids. |  |  |
| [names](outputs.tf#L25) | Folder names. |  |  |

<!-- END TFDOC -->
