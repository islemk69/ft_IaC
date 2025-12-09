variable "region" {
  description = "Region for the network resources"
  type        = string
}

variable "subnet_cidr" {
  description = "CIDR range for the subnet"
  type        = string
  default     = "10.0.1.0/24"
}

variable "project_id" {
   type        = string
}