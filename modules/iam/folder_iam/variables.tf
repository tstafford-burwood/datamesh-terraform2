#----------------------------
# FOLDER IAM MEMBER VARIABLES
#----------------------------

variable "folder_id" {
  description = "The ID of the Folder to associate IAM roles and members."
  type        = string
  default     = ""
}

variable "iam_role_list" {
  description = "The IAM role(s) to assign to the member at the defined folder."
  type        = list(string)
  default     = []
}

variable "folder_member" {
  description = "The member to apply the IAM role to. Possible options use the following syntax: user:{emailid}, serviceAccount:{emailid}, group:{emailid}, domain:{domain}."
  type        = string
  default     = ""
}