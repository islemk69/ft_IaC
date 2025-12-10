module "project" {
  source = "./modules/project"

  project_name    = var.gcp_project_name
  billing_account = var.billing_account
}

module "network" {
  source = "./modules/network"
  depends_on = [module.project]

  project_id   = module.project.project_id
  project_name = var.gcp_project_name

  region      = local.selected_region
  subnet_cidr = "10.0.1.0/24"

}

module "database" {
  source = "./modules/database"
  depends_on = [module.network]

  project_id   = module.project.project_id
  project_name = var.gcp_project_name

  region      = local.selected_region
  vpc_id      = module.network.vpc_id
}

module "autoscaling" {
  source = "./modules/autoscaling"
  depends_on = [module.project]

  project_id   = module.project.project_id
  project_name = var.gcp_project_name

  region       = local.selected_region
  machine_type = local.selected_machine_type
  vpc_id       = module.network.vpc_id
  subnet_id    = module.network.subnet_id

  db_host     = module.database.db_instance_ip
  db_user     = module.database.db_user
  db_password = module.database.db_password
  db_name     = module.database.db_name
}

module "loadbalancer" {
  source = "./modules/loadbalancer"
  depends_on = [module.project]

  project_id   = module.project.project_id
  project_name = var.gcp_project_name
  domain_name  = var.domain_name
  instance_group = module.autoscaling.instance_group
}


module "monitoring" {
  source = "./modules/monitoring"
  depends_on = [module.project]

  project_id  = module.project.project_id
  alert_email = var.alert_email
}