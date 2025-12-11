variable "project_id" {
  description = "ID of the Google Cloud Project"
  type        = string
}

variable "project_name" {
  description = "Name of the Google Cloud Project"
  type        = string
}

variable "region" { type = string }
variable "machine_type" { type = string }
variable "vpc_id" { type = string }
variable "subnet_id" { type = string }
variable "db_host" { type = string }
variable "db_user" { type = string }
variable "db_password" {
   type = string
   sensitive = true
}
variable "db_name" { type = string }