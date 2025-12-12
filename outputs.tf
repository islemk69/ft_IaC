output "project_id" {
  value = module.project.project_id
}

output "public_ip" {
  description = "The public IP"
  value       = module.loadbalancer.lb_ip
}

output "doc_url" {
  description = "The url of the doc bucket"
  value       = module.bucket-doc.url
}

output "url" {
  description = "The app url"
  value       = module.network.url
}