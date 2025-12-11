variable "project_id" {
  description = "ID of the Google Cloud Project"
  type        = string
}

variable "project_name" {
  description = "Name of the Google Cloud Project"
  type        = string
}

variable "region" {
  type = string
}

variable "dir_path" {
  description = "Path of the folder to store in bucket"
  type        = string
}