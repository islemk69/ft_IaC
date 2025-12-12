variable "project_id" {
  description = "ID of the Google Cloud Project"
  type        = string
}

variable "project_name" {
  description = "Name of the Google Cloud Project"
  type        = string
}

variable "global_address" {
  description = "IP address"
  type        = string
}

variable "cert_id" {
  description = "SSL Certificate ID"
  type        = string
}

variable "instance_group" {
  description = "The Instance Group URL to route traffic to"
  type        = string
}