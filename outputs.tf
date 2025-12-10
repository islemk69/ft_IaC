output "project_id" {
  value = module.project.project_id
}

output "load_balancer_ip" {
  description = "The public IP of the Load Balancer"
  value       = module.loadbalancer.lb_ip
}

output "db_private_ip" {
  description = "The database private IP"
  value       = module.database.db_instance_ip
  sensitive   = true
}

output "db_password" {
  description = "The database password"
  value       = module.database.db_password
  sensitive   = true
}