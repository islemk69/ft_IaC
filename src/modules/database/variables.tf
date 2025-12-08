variable "region" {
  description = "Region for database"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID where the database will be connected"
  type        = string
}

variable "db_password" {
  description = "Database user password"
  type        = string
  sensitive   = true
}
