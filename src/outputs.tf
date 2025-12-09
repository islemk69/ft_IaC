output "load_balancer_ip" {
  description = "The public IP of the Load Balancer"
  value       = module.loadbalancer.lb_ip
}

output "db_private_ip" {
  description = "The private IP of the Database"
  value       = module.database.db_instance_ip
  sensitive   = true
}

