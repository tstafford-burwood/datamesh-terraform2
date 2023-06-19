# Terraform Module Healthcare Dataset

This module will create the toplevel logical grouping of a dataset and optional data stores in FHIR or HL7 formats.

The module will not work with schemas or streaming configs.

## Example

The below example will create 2 Healthcare Datasets in different regions with different timezone settings and a FHIR datastore in the first, `dataset` dataset.

```hcl
module "healthcare_dataset" {
    source = "./"

    project_id = "my-project"
    dataset = {
        dataset1 = {
            region    = "us-central1"
            time_zone = null
        },
        dataset2 = {
            region = "us-east1"
            time_zone = "America/New_York"
        }
    }
    fhir_store = {
        "fhir-datastore" = {
            dataset                       = "dataset"
            version                       = "r4"
            enable_update_create          = false
            disable_referential_integrity = false
            disable_resource_versioning   = false
            enable_history_import         = false
        },
}
```
<!-- BEGIN TFDOC -->

## Variables

| name | description | type | required | default |
|---|---|:---:|:---:|:---:|
| [dataset](variables.tf#L6) | The resource name of the Cloud Healthcare Dataset. | <code title="map&#40;object&#40;&#123;&#10;  region    &#61; string &#35;Location of the Healthcare Dataset.&#10;  time_zone &#61; string &#35;Timezone. if null will default to UTC&#10;&#10;&#10;&#125;&#41;&#41;">map&#40;object&#40;&#123;&#8230;&#125;&#41;&#41;</code> | ✓ |  |
| [project_id](variables.tf#L1) | The Project Id. | <code>string</code> | ✓ |  |

<!-- END TFDOC -->
