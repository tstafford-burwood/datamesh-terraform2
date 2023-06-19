# [Create an Access Policy](https://cloud.google.com/access-context-manager/docs/create-access-policy)

This page describes how to create an organization-level access policy for your organization and scoped policies for the folders and projects in your organization.

* **Note**:  An organization can only have one organization-level access policy and can contain multiple scoped policies for the folders and projects in the organization.

## Requirements

* Ensure you have the `roles/accesscontextmanager.policyAdmin` to use Access Context Manager.

## Create an organization-level access policy

Check if an Org Level policy already exists by running ```gcloud access-context-manager policies list --organization=<ORG_ID>```. If not, run the following command:

```
gcloud access-context-manager policies create \
--organization ORGANIZATION_ID --title POLICY_TITLE
```

## Create a scoped access policy and delegate the policy

To create a scoped access policy:
```
gcloud access-context-manager policies create \
--organization ORGANIZATION_ID [--scopes=SCOPE] --title POLICY_TITLE
```
* **SCOPE** is the folder or project on which this policy is applicable. You can specify only one folder or project as the scope, and the scope must exist within the specified organization. If you don't specify a scope, the policy applies to the entire organization.

## Delegate

To delegate administration by binding a principal and role with a scoped access policy, use the add-iam-policy-binding command.

```
gcloud access-context-manager policies add-iam-policy-binding \
[POLICY] --member=PRINCIPAL --role=ROLE
```

* **POLICY** is ID of the policy or fully qualified identifier for the policy. Must be of the form `accessPolicies/<policy id>`. Use the list command above to get the ID number of the policy.

* **PRINCIPAL** is the principal to add the binding for. Specify in the following format: user|group|serviceAccount:email or domain:domain.

* **ROLE** is the role name to assign to the principal. The role name is the complete path of a predefined role, such as `roles/accesscontextmanager.policyAdmin`, `roles/accesscontextmanager.policyReader`, or the role ID for a custom role, such as organizations/{ORGANIZATION_ID}/roles/accesscontextmanager.policyReader.

> **Note**: You will want to make the Cloud Build Service Account or Terraform Service Account a Policy Admin.
