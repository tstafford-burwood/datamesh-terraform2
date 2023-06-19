#-----------------------------
# PROJECT IAM MEMBER VARIABLES
#-----------------------------

variable "project_id" {
  description = "The project ID where IAM roles and members will be set at."
  type        = string
  default     = ""
}

variable "project_member" {
  description = "The member to apply the IAM role to. Possible options use the following syntax: user:{emailid}, serviceAccount:{emailid}, group:{emailid}, domain:{domain}."
  type        = string
  default     = ""
}

variable "project_iam_role_list" {
  description = "The IAM role(s) to assign to the member at the defined project."
  type        = list(string)
  default     = []
}