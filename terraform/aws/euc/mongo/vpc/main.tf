provider "aws" {
    region = var.region
    profile = var.profile
}

module "vpc" {
  source = "../../../modules/multi-region/vpc"

  create_subnet = false
  create_default_network_acl = false
  create_network_acl = true
  vpc_id = var.vpc_id
  subnet_ids = var.subnet_id
  name = "mongo"
  subnet_suffix = var.subnet_suffix

  
  inbound_acl_rules = concat(
    local.network_acls["default_inbound"],
    local.network_acls["public_inbound"],
  )
  outbound_acl_rules = concat(
    local.network_acls["default_outbound"],
    local.network_acls["public_outbound"],
  )

  subnet_tags = {
    Name = "mongo-tf"
  }
  tags = {
    Owner       = "devops"
    Environment = "devops"
  }
}

locals {
  network_acls = {
    default_inbound = var.default_inbound
    default_outbound = var.default_outbound
    public_inbound = var.custom_inbound
    public_outbound = var.custom_outbound
  }
}