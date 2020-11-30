provider "aws" {
    region = var.region
    profile = var.profile
}

locals {
  user_data = <<EOF
#!/bin/bash
echo "Hello Terraform!"
EOF
}

module "mongo-instance" {
  source = "../../../../modules/multi-region/ec2"

  instance_count = var.instance_count

  name          = var.instance_name 
  use_name_prefix = var.use_name_prefix
  name_prefix   = var.name_prefix
  use_num_suffix = var.use_num_suffix
  ami           = var.ami 
  instance_type = var.instance_type
  subnet_id     = var.subnet_id
  private_ips   = var.private_ips
  hostnames     = var.hostnames
  vpc_security_group_ids = [module.sg.this_security_group_id]
  associate_public_ip_address = false
  # exec_script   = var.exec_script 
  key_name      = var.key_name
  key_file      = var.key_file
#   ansible_playbooks = ["/Users/skrishnamurthy/do-ansible/sysadmin-config.yml","/Users/skrishnamurthy/do-ansible/zabbix-agent.yml"]

  user_data_base64 = base64encode(local.user_data)

  root_block_device = [
    {
      volume_type = "gp2"
      volume_size = 20
    },
  ]

  ebs_block_device = [
    # {
    #   device_name = "/dev/sdb" // tmp
    #   volume_type = "gp2"
    #   volume_size = 10
    #   delete_on_termination = true
    # },
    {
      device_name = "/dev/sdf"
      volume_type = "gp2"
      volume_size = 16
      delete_on_termination = true
    },
    {
      device_name = "/dev/sdg"
      volume_type = "gp2"
      volume_size = 20
      delete_on_termination = true
    },
    {
      device_name = "/dev/sdh"
      volume_type = "gp2"
      volume_size = 22
      delete_on_termination = true
    },
    {
      device_name = "/dev/sdi"
      volume_type = "gp2"
      volume_size = 24
      delete_on_termination = true
    },
    {
      device_name = "/dev/sdj"
      volume_type = "gp2"
      volume_size = 200
      delete_on_termination = true
    },
  ]

  tags = {
    "Env"      = "DevOps"
    "Location" = var.region
  }
}

module "sg" {
  source = "../../../../modules/multi-region/security-group"

  create                 = true
  name                   = format("%s-%s",var.name_prefix, var.sg_name)
  description            = "Mongo Security Group"
  vpc_id                 = var.vpc_id
  tags                   = {
      Name = format("%s-%s",var.name_prefix, var.sg_name)
  }

  ##########
  # Ingress
  ##########
  # Rules by names - open for default CIDR
#   ingress_cidr_blocks      = ["0.0.0.0/0", "0.0.0.0/0", "192.168.20.21/32"]
#   ingress_rules            = ["all-icmp", "ssh-tcp", "zabbix-eng"]
  ingress_with_cidr_blocks = concat(var.default_ingress_rules, var.custom_ingress_rules)
  # [
  #   {
  #     from_port   = -1
  #     to_port     = -1
  #     protocol    = "icmp"
  #     description = "All IPV4 ICMP"
  #     cidr_blocks = "0.0.0.0/0"
  #   },
  #   {
  #     from_port   = 22
  #     to_port     = 22
  #     protocol    = "tcp"
  #     description = "all ssh"
  #     cidr_blocks = "0.0.0.0/0"
  #   },
  #   {
  #     from_port   = 80
  #     to_port     = 80
  #     protocol    = "tcp"
  #     description = "all http"
  #     cidr_blocks = "0.0.0.0/0"
  #   },
  #   {
  #     from_port   = 8080
  #     to_port     = 8080
  #     protocol    = "tcp"
  #     description = "all http"
  #     cidr_blocks = "0.0.0.0/0"
  #   },
  #   {
  #     from_port   = 443
  #     to_port     = 443
  #     protocol    = "tcp"
  #     description = "all https"
  #     cidr_blocks = "0.0.0.0/0"
  #   },
  #   {
  #     from_port   = 10050
  #     to_port     = 10050
  #     protocol    = "tcp"
  #     description = "zabbix-eng"
  #     cidr_blocks = "192.168.20.21/32"
  #   },
  #   {
  #     from_port   = 8008
  #     to_port     = 8009
  #     protocol    = "tcp"
  #     description = "JMX, RMI ports for monitoring from zabbix-eng"
  #     cidr_blocks = "192.168.20.21/32"
  #   },
  #   {
  #     from_port   = 10050
  #     to_port     = 10050
  #     protocol    = "tcp"
  #     description = "euc-zbx"
  #     cidr_blocks = "10.235.4.10/32"
  #   },
  #   {
  #     from_port   = 8008
  #     to_port     = 8009
  #     protocol    = "tcp"
  #     description = "JMX, RMI ports for monitoring from euc-zbx"
  #     cidr_blocks = "10.235.4.10/32"
  #   },
  #   {
  #     # Ephemeral ports for inbound traffic for outbound connections
  #     from_port   = 32768
  #     to_port     = 65535
  #     protocol    = "tcp"
  #     description = "Ephemeral ports"
  #     cidr_blocks = "0.0.0.0/0"
  #   },
  # ]

  #########
  # Egress
  #########
  # Rules by names - open for default CIDR
  egress_rules = concat(var.default_egress_rules, var.custom_egress_rules)
  # ["all-all"]
}

output "output_sg" {
    value = module.sg
}