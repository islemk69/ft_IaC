variable "billing_account" {
  description = "Le compte de facturatin Google Cloud"
  type        = string
}

variable "gcp_project_name" {
  description = "Le nom du projet Google Cloud"
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

variable "alert_email" {
  description = "L'addresse e-mail pour les alertes"
  type        = string
}

variable "domain_name" {
  description = "Le nom de domaine"
  type        = string
}

variable "subdomain" {
  description = "Subdomain"
  type        = string
}

variable "cloudflare_api_token" {
  description = "Cloudflare API Token"
  type        = string
  sensitive   = true
}