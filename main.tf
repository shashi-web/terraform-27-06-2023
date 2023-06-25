
module "myapp_vpc" {
  source     = "./modules/vpc"
  cidr_block = var.cidr_block

}

module "myapp_subnet" {
  source            = "./modules/subnets"
  subnet_cidr_block = var.subnet_cidr_block
  vpc_id            = module.myapp_vpc.vpc_id

}

module "myapp_route_tables" {
  source    = "./modules/route_table"
  vpc_id    = module.myapp_vpc.vpc_id
  subnet_id = module.myapp_subnet.subnet_id

}

module "myapp_security_groups" {
  source    = "./modules/security_groups"
  vpc_id      = module.myapp_vpc.vpc_id

}

module "nginx_server" {
  source      = "./modules/instance"
  vpc_id      = module.myapp_vpc.vpc_id
  subnet_id   = module.myapp_subnet.subnet_id
  image_name  = var.image_name
  public_key  = var.public_key
  security_group_id = module.myapp_security_groups.security_group_id
  script_file = "nginx-entry-script.sh"
  server_name = "nginx-1"
  keyname = "nginx"

}

