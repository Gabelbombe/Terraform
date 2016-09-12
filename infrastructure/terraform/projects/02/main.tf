variable "region" {}

variable "atlas_environment" {}
variable "atlas_username" {}
variable "atlas_token" {}
variable "name" {}
variable "cert_name" {}
variable "key_name" {}
variable "vpc_cidr" {}
variable "public_subnets" {}
variable "private_subnets" {}
variable "azs" {}

variable "bastion_instance_type" {}
variable "nat_instance_type" {}

variable "openvpn_instance_type" {}
variable "openvpn_ami" {}
variable "openvpn_admin_user" {}
variable "openvpn_admin_pw" {}
variable "openvpn_cidr" {}

variable "db_name" {}
variable "db_username" {}
variable "db_password" {}
variable "db_engine" {}
variable "db_engine_version" {}
variable "db_port" {}

variable "db_az" {}
variable "db_multi_az" {}
variable "db_instance_type" {}
variable "db_storage_gbs" {}
variable "db_iops" {}
variable "db_storage_type" {}
variable "db_apply_immediately" {}
variable "db_publicly_accessible" {}
variable "db_storage_encrypted" {}
variable "db_maintenance_window" {}
variable "db_backup_retention_period" {}
variable "db_backup_window" {}

variable "aws_web_latest_name" {}
variable "aws_web_pinned_name" {}
variable "aws_web_pinned_version" {}

variable "web_instance_type" {}
variable "web_blue_nodes" {}
variable "web_green_nodes" {}

provider "aws" {
  region = "${var.region}"
}

atlas {
  name = "${var.atlas_username}/${var.atlas_environment}"
}

# Access
module "certs" {
  source = "../../certs"

  name = "${var.cert_name}"
}

module "keys" {
  source = "../../keys"

  name = "${var.key_name}"
}

module "keypair" {
  source = "../../aws/access/keypair"

  name     = "${var.name}"
  pub_path = "${module.keys.pub_path}"
}

# Network
module "vpc" {
  source = "../../aws/network/vpc"

  name = "${var.name}-vpc"
  cidr = "${var.vpc_cidr}"
}

module "public_subnet" {
  source = "../../aws/network/public_subnet"

  name   = "${var.name}-public"
  cidrs  = "${var.public_subnets}"
  azs    = "${var.azs}"
  vpc_id = "${module.vpc.vpc_id}"
}

module "bastion" {
  source = "../../aws/network/bastion"

  name          = "${var.name}-bastion"
  instance_type = "${var.bastion_instance_type}"
  region        = "${var.region}"
  key_name      = "${var.key_name}"
  vpc_id        = "${module.vpc.vpc_id}"
  vpc_cidr      = "${module.vpc.vpc_cidr}"
  subnet_ids    = "${module.public_subnet.subnet_ids}"
}

module "nat" {
  source = "../../aws/network/nat"

  name           = "${var.name}-nat"
  public_subnets = "${var.public_subnets}"
  instance_type  = "${var.nat_instance_type}"
  region         = "${var.region}"
  key_name       = "${var.key_name}"
  vpc_id         = "${module.vpc.vpc_id}"
  vpc_cidr       = "${module.vpc.vpc_cidr}"
  subnet_ids     = "${module.public_subnet.subnet_ids}"
  key_path       = "${module.keys.pem_path}"
  bastion_host   = "${module.bastion.ip}"
  bastion_user   = "${module.bastion.user}"
}

module "openvpn" {
  source = "../../aws/network/openvpn"

  name          = "${var.name}-openvpn"
  ami           = "${var.openvpn_ami}"
  instance_type = "${var.openvpn_instance_type}"
  admin_user    = "${var.openvpn_admin_user}"
  admin_pw      = "${var.openvpn_admin_pw}"
  vpn_cidr      = "${var.openvpn_cidr}"
  key_name      = "${var.key_name}"
  key_path      = "${module.keys.pem_path}"
  vpc_id        = "${module.vpc.vpc_id}"
  vpc_cidr      = "${module.vpc.vpc_cidr}"
  subnet_ids    = "${module.public_subnet.subnet_ids}"
  bastion_host  = "${module.bastion.ip}"
  bastion_user  = "${module.bastion.user}"
  ssl_cert      = "${module.certs.crt_path}"
  ssl_key       = "${module.certs.key_path}"
}

module "private_subnet" {
  source = "../../aws/network/private_subnet"

  name   = "${var.name}-private"
  cidrs  = "${var.private_subnets}"
  azs    = "${var.azs}"
  vpc_id = "${module.vpc.vpc_id}"

  nat_instance_ids = "${module.nat.instance_ids}"
}

module "rds_mysql" {
  source = "../../aws/data/rds"

  name           = "${var.name}-mysql"
  vpc_id         = "${module.vpc.vpc_id}"
  vpc_cidr       = "${module.vpc.vpc_cidr}"
  subnet_ids     = "${module.private_subnet.subnet_ids}"
  db_name        = "${var.db_name}"
  username       = "${var.db_username}"
  password       = "${var.db_password}"
  engine         = "${var.db_engine}"
  engine_version = "${var.db_engine_version}"
  port           = "${var.db_port}"

  az                      = "${var.db_az}"
  multi_az                = "${var.db_multi_az}"
  instance_type           = "${var.db_instance_type}"
  storage_gbs             = "${var.db_storage_gbs}"
  iops                    = "${var.db_iops}"
  storage_type            = "${var.db_storage_type}"
  apply_immediately       = "${var.db_apply_immediately}"
  publicly_accessible     = "${var.db_publicly_accessible}"
  storage_encrypted       = "${var.db_storage_encrypted}"
  maintenance_window      = "${var.db_maintenance_window}"
  backup_retention_period = "${var.db_backup_retention_period}"
  backup_window           = "${var.db_backup_window}"
}

# Compute
module "aws_artifacts_web" {
  source = "../../aws/artifact"

  atlas_username = "${var.atlas_username}"
  latest_name    = "${var.aws_web_latest_name}"
  pinned_name    = "${var.aws_web_pinned_name}"
  pinned_version = "${var.aws_web_pinned_version}"
}

module "web" {
  source = "../../aws/compute/simple"

  name               = "${var.name}-web"
  vpc_cidr           = "${var.vpc_cidr}"
  azs                = "${var.azs}"
  key_name           = "${var.key_name}"
  public_subnet_ids  = "${module.public_subnet.subnet_ids}"
  private_subnet_ids = "${module.private_subnet.subnet_ids}"
  vpc_id             = "${module.vpc.vpc_id}"
  ssl_cert_crt       = "${module.certs.crt_path}"
  ssl_cert_key       = "${module.certs.key_path}"

  atlas_username    = "${var.atlas_username}"
  atlas_environment = "${var.atlas_environment}"
  atlas_token       = "${var.atlas_token}"

  instance_type = "${var.web_instance_type}"
  blue_ami      = "${module.aws_artifacts_web.latest}"
  blue_nodes    = "${var.web_blue_nodes}"
  green_ami     = "${module.aws_artifacts_web.pinned}"
  green_nodes   = "${var.web_green_nodes}"
}

output "configuration" {
  value = <<CONFIGURATION

OpenVPN IP: ${module.openvpn.ip}
Bastion IP: ${module.bastion.ip}

The environment is accessible via an OpenVPN connection:
  Server:   ${module.openvpn.ip}
  Username: ${var.openvpn_admin_user}
  Password: ${var.openvpn_admin_pw}

You can administer the OpenVPN Access Server here:
  https://${module.openvpn.ip}/admin

CONFIGURATION
}
