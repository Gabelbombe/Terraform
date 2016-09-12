#--------------------------------------------------------------
# AWS
#--------------------------------------------------------------

# If you update the region, some of the amis that this example
# uses may be unavailable as they are specific to us-east-1
region = "us-east-1"

#--------------------------------------------------------------
# General
#--------------------------------------------------------------

# If you change the atlas_environment name, be sure this name
# change is reflected when doing `terraform remote config` and
# `terraform push` commands - changing this WILL affect your
# terraform.tfstate file, so use caution
atlas_environment = "project1"
name              = "terraform"
cert_name         = "terraform_cert"
key_name          = "terraform_key"

#--------------------------------------------------------------
# Network
#--------------------------------------------------------------

vpc_cidr          = "10.139.0.0/16"
private_subnets   = "10.139.1.0/24,10.139.2.0/24,10.139.3.0/24"
ephemeral_subnets = "10.139.11.0/24,10.139.12.0/24,10.139.13.0/24"
public_subnets    = "10.139.101.0/24,10.139.102.0/24,10.139.103.0/24"

# Some subnets may only be able to be created in specific availability
# zones depending on your AWS account
azs = "us-east-1b,us-east-1d,us-east-1e"

# Bastion
bastion_instance_type = "t2.micro"

# NAT
nat_instance_type = "t2.micro"

# OpenVPN
openvpn_instance_type = "t2.micro"
openvpn_ami           = "ami-b62d20de"
openvpn_admin_user    = "vpnadmin"
openvpn_admin_pw      = "sdEKxN2dwDK4FziU6QEKjUeegcC8ZfBYA3fzMgqXfocgQvWGRw"
openvpn_cidr          = "172.27.139.0/24"

#--------------------------------------------------------------
# Data
#--------------------------------------------------------------

# db_name, db_username, and db_password should be
# changed to reflect your preferences
db_name           = "test_database"
db_username       = "dbuser"
db_password       = "dbpass"
db_engine         = "mysql"
db_engine_version = "5.6.17"
db_port           = "5432"

db_az                      = "us-east-1b"
db_multi_az                = "false"
db_instance_type           = "db.t2.micro"
db_storage_gbs             = "100"
db_iops                    = "1000"
db_storage_type            = "gp2"
db_apply_immediately       = "true"
db_publicly_accessible     = "false"
db_storage_encrypted       = "false"
db_maintenance_window      = "mon:04:03-mon:04:33"
db_backup_retention_period = "7"
db_backup_window           = "10:19-10:49"

#--------------------------------------------------------------
# AWS Artifacts
#--------------------------------------------------------------

# If any of these artifact names are changed in the Packer templates,
# they must also be changed here
aws_web_latest_name         = "aws-centos-web"
aws_web_pinned_name         = "aws-centos-web"
aws_web_pinned_version      = "latest"

#--------------------------------------------------------------
# Web
#--------------------------------------------------------------

web_instance_type = "t2.micro"
web_blue_nodes = "2"
web_green_nodes = "0"
