data "aws_availability_zones" "this" {}

module "endpoints_vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name                   = "endpoints-vpc"
  cidr                   = "10.2.0.0/20"
  azs                    = data.aws_availability_zones.this.names
  private_subnets        = ["10.2.0.0/24"]
  enable_nat_gateway     = false
  single_nat_gateway     = false
  one_nat_gateway_per_az = false

  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = merge(local.tags, { Name = "endpoints-vpc" })
}

resource "aws_security_group" "ec2_instance_sg" {
  name_prefix = "ec2_instance_sg"
  vpc_id      = module.endpoints_vpc.vpc_id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["10.0.0.0/8"]
  }
}