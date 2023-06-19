# Terraform Module for Data Catalog Tag Template

This module will create a tag template and you can add one or more typed fields to the tag template.

## Example

Create a single Tag Template with 3 fields.

```hcl
module "tag_template" {
  source = "../tag-template"

  project_id = "test-data-ops-a4cd"
  region     = "us-central1"
  fields = [{
  field_id       = "data_governor"
  display_name   = "Data Governor"
  description    = ""
  is_required    = true
  primitive_type = "string"
  display_names  = []

  }, {
  field_id       = "business_owner"
  display_name   = "Business Owner"
  description    = ""
  is_required    = false
  primitive_type = "double"
  display_names  = []
  }, {
  field_id       = "data_classification"
  display_name   = "Data Classification"
  description    = ""
  is_required    = true
  primitive_type = null
  display_names  = ["Private", "Confidential"]
  }
]

}

```
<!-- BEGIN TFDOC -->

## Variables

| name | description | type | required | default |
|---|---|:---:|:---:|:---:|
| [project_id](variables.tf#L1) | GCP project id. | <code></code> | ✓ |  |
| [display_name](variables.tf#L17) | The display name for this template. | <code>string</code> |  | <code>&#34;Demo Tag Template&#34;</code> |
| [fields](variables.tf#L30) | Used to create one or more typed fields. | <code title="list&#40;object&#40;&#123;&#10;  field_id       &#61; string&#10;  display_name   &#61; string&#10;  description    &#61; string&#10;  is_required    &#61; bool&#10;  primitive_type &#61; string&#10;  display_names  &#61; list&#40;string&#41;&#10;&#125;&#41;&#41;">list&#40;object&#40;&#123;&#8230;&#125;&#41;&#41;</code> |  | <code>&#91;&#93;</code> |
| [force_delete](variables.tf#L24) | Deletion of any possible tags using this template. Must be set to `true` in order to delete the tag template. | <code>bool</code> |  | <code>true</code> |
| [region](variables.tf#L11) | Template location region. | <code>string</code> |  | <code>&#34;us-central1&#34;</code> |
| [tag_template_id](variables.tf#L5) | The ID of the tag template to create. | <code>string</code> |  | <code>&#34;my_template&#34;</code> |

## Outputs

| name | description | sensitive |
|---|---|:---:|
| [id](outputs.tf#L1) | Id of the resource |  |
| [name](outputs.tf#L6) | The resource name of the tag template in URL format |  |

<!-- END TFDOC -->
