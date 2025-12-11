variable "project_id" {
  description = "ID of the Google Cloud Project"
  type        = string
}

variable "project_name" {
  description = "Name of the Google Cloud Project"
  type        = string
}

variable "domain_name" {
  description = "The DNS name of the zone (e.g. example.com)"
  type        = string
}

variable "lb_ip_address" {
  description = "IP address of the Load Balancer"
  type        = string
}
