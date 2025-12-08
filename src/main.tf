module "network" {
  source = "./modules/network"

  region      = local.selected_region
  subnet_cidr = "10.0.1.0/24"
}

module "database" {
  source = "./modules/database"

  region      = local.selected_region
  vpc_id      = module.network.vpc_id
  db_password = var.db_password

  depends_on = [module.network]
}

module "autoscaling" {
  source = "./modules/autoscaling"

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

  instance_group = module.autoscaling.instance_group
}
