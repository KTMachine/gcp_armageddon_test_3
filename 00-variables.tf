# Variables for the Terraform configuration
variable "invictus_project_id" {
  description = "Invictus Inc. GCP project ID"
  type = string
  default = "Invictus-65"
}

variable "member1_project_id" {
  description = "Member 1 GCP project ID"
  type = string
  default = "service-p1-462917"
}

variable "member2_project_id" {
  description = "Member 2 GCP project ID"
  type = string
  default = "service-p2-462917"
}

