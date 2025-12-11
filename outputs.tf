output "project_id" {
  value = module.project.project_id
}

output "public_ip" {
  description = "The public IP of the Load Balancer"
  value       = module.loadbalancer.lb_ip
}

output "public_ip_http" {
  description = "The public IP of the Load Balancer"
  value       = module.loadbalancer.lb_ip_http
}