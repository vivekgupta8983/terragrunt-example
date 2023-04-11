terraform {
  source = "tfr:///terraform-aws-modules/eks/aws?version=19.12.0"
}

include "remote_state" {
  path = find_in_parent_folders("backend.hcl")
}

locals {
  region = "us-east-1"
  environment = "Developement"
}

inputs = {
  cluster_name    = "${local.environment}-cluster"
  cluster_version = "1.24"

  cluster_endpoint_public_access  = true

  cluster_addons = {
    coredns = {
      most_recent = true
    }
    kube-proxy = {
      most_recent = true
    }
    vpc-cni = {
      most_recent = true
    }
  }

  vpc_id                   = "vpc-0e585631b6dd11e7a"
  subnet_ids               = [ "subnet-09c718d9f477d44d1","subnet-075adef9b9453fcb6","subnet-0aa60edda19a4b2c3","subnet-06c745413df49bf66","subnet-062bcb570e6a3d72c","subnet-0dd001338ba0ca8d7"]
#   private_subnets = [
#   "subnet-06c745413df49bf66",
#   "subnet-062bcb570e6a3d72c",
#   "subnet-0dd001338ba0ca8d7",
# ]
#   public_subnets = [
#     "subnet-09c718d9f477d44d1",
#     "subnet-075adef9b9453fcb6",
#     "subnet-0aa60edda19a4b2c3",
#   ]

  # EKS Managed Node Group(s)
  # eks_managed_node_group_defaults = {
  #   instance_types = ["m6i.large", "m5.large", "m5n.large", "m5zn.large"]
  # }

  eks_managed_node_groups = {
    blue = {}
    green = {
      min_size     = 1
      max_size     = 10
      desired_size = 1

      instance_types = ["t3.micro"]
      capacity_type  = "SPOT"
    }
  }

  tags = {
    Environment = "dev"
    Terraform   = "true"
  }
}