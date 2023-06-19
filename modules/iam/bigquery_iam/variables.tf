variable "project_id" {
  description = "The project ID where IAM roles and members will be set at."
  type        = string
}

variable "dataset_id" {
  description = "The BigQuery dataset ID."
  type        = string
}

variable "member" {
  description = "The member to apply the IAM role to. Possible options use the following syntax: user:{emailid}, serviceAccount:{emailid}, group:{emailid}, domain:{domain}."
  type        = string
}

variable "bq_iam_list" {
  description = "The role that should be applied."
  type        = list(string)
}