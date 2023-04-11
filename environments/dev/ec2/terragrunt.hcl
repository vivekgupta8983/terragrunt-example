terraform {
  source = "tfr:///terraform-aws-modules/ec2/aws?version=4.3.0"
}

include "remote_state" {
  path = find_in_parent_folders("backend.hcl")
}

locals {
  region = "us-east-1"
  environment = "Developement"
}

inputs = {

  name = "single-instance"

  ami                    = "ami-ebd02392"
  instance_type          = "t2.micro"
  key_name               = "user1"
  monitoring             = true
  vpc_security_group_ids = ["sg-12345678"]
  subnet_id              = "subnet-eddcdzz4"
  
  # vpc_id                   = "vpc-0e585631b6dd11e7a"
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

  
  tags = {
    Environment = "dev"
    Terraform   = "true"
  }
}