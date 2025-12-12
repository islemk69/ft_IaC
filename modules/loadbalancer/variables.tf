variable "project_id" {
  description = "ID of the Google Cloud Project"
  type        = string
}

variable "project_name" {
  description = "Name of the Google Cloud Project"
  type        = string
}

variable "domain_name" {
  description = "Domain name"
  type        = string
  default     = "sanitraq.fr"
}

variable "subdomain" {
  description = "Subdomain"
  type        = string
}

variable "instance_group" {
  description = "The Instance Group URL to route traffic to"
  type        = string
}