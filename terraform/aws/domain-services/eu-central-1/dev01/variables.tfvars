###############################
# Env Name
###############################
environment_name = "dev01"

###############################
# Common tags
###############################
environment_tags = {
  ops_managed_by  = "terraform",
  ops_source_repo = "do-infrastructure",
  ops_owners      = "devops",
}

###############################
# VPC
###############################
vpc_cidr        = "10.54.0.0/16"
private_subnets = ["10.54.0.0/18", "10.54.64.0/18", "10.54.128.0/18"]
public_subnets  = ["10.54.224.0/19"]
zones           = ["a", "b", "c"]

# ###############################
# # EKS Cluster
# ###############################
# cluster_version = "1.20"
# cluster_endpoint_public_access_cidrs = [
#   "0.0.0.0/0",
#   "1.1.1.1/32",
# ]
# cluster_endpoint_private_access_cidrs = [
#   "10.0.0.0/8",
#   "172.16.0.0/12",
#   "192.168.0.0/16",
#   "100.64.0.0/16",
# ]
# map_roles = [
#   {
#     rolearn  = "arn:aws:iam::66666666666:role/role1"
#     username = "role1"
#     groups   = ["system:masters"]
#   },
# ]
# map_users = [
#   {
#     userarn  = "arn:aws:iam::725654443526:user/username"
#     username = "username"
#     groups   = ["system:masters"]
#   },
# ]
# node_groups = {
#   ng1 = {
#     version          = "1.20"
#     disk_size        = 20
#     desired_capacity = 2
#     max_capacity     = 4
#     min_capacity     = 1
#     instance_types   = ["t3.small"]
#     # additional_tags  = var.environment_tags
#     k8s_labels       = {}
#   }
# }
