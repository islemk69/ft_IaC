variable "gcp_project_id" {
  description = "L'ID du projet Google Cloud"
  type        = string
}

variable "gcp_region" {
  description = "La région de déploiement (Ex: Paris, Frankfurt, US)"
  type        = string
  default     = "US"
}

variable "gcp_zone" {
  description = "La zone par défaut"
  type        = string
  default     = "us-central1-a"
}

variable "machine_type" {
  description = "Taille de l'instance (small, medium, large)"
  type        = string
  default     = "small"
}

variable "db_password" {
  description = "Mot de passe de la base de données"
  type        = string
  sensitive   = true 
}

variable "alert_email" {
  description = "Email address for alerts"
  type        = string
}