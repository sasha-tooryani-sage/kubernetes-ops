variable "region" { type = string }
variable "profile" { type = string }
variable "instance_count" { type = number }
variable "use_name_prefix" { type = bool }
variable "name_prefix" { type = string }
variable "instance_name" { type = string }
variable "vpc_id" { type = string }
variable "subnet_suffix" { type = string }
variable "ami" { type = string }
variable "use_num_suffix" { type = bool }
variable "instance_type" { type = string }
variable "subnet_id" { type = string }
variable "private_ips" { type = list(string) }
variable "hostnames" { type = list(string) }
variable "exec_script" { type = string }
variable "key_name" { type = string }
variable "key_file" { type = string }
variable "sg_name" { type = string }
variable "ebs_block_devices" {}
variable "security_group_id" {}