resource "aws_security_group" "vpc_endpoints_sg" {
  name_prefix = "ec2messages_endpoint"
  vpc_id      = module.endpoints_vpc.vpc_id

    ingress {
        description      = "TLS from VPC"
        from_port        = 443
        to_port          = 443
        protocol         = "tcp"
        cidr_blocks      = [module.endpoints_vpc.vpc_cidr_block]
    }

    egress {
        from_port        = 0
        to_port          = 0
        protocol         = "-1"
        cidr_blocks      = ["0.0.0.0/0"]
        ipv6_cidr_blocks = ["::/0"]
    }
}

resource "aws_vpc_endpoint" "ec2messages" {
  service_name       = "com.amazonaws.us-east-1.ec2messages"
  vpc_id             = module.endpoints_vpc.vpc_id
  vpc_endpoint_type  = "Interface"
  security_group_ids = [aws_security_group.vpc_endpoints_sg.id]

  subnet_ids          = module.endpoints_vpc.private_subnets
  private_dns_enabled = true

  tags = merge(local.tags, { Name = "vpc-endpoints-ec2messages" })
}

resource "aws_vpc_endpoint" "ssmmessages" {
  service_name       = "com.amazonaws.us-east-1.ssmmessages"
  vpc_id             = module.endpoints_vpc.vpc_id
  vpc_endpoint_type  = "Interface"
  security_group_ids = [aws_security_group.vpc_endpoints_sg.id]

  subnet_ids          = module.endpoints_vpc.private_subnets
  private_dns_enabled = true

  tags = merge(local.tags, { Name = "vpc-endpoints-ssmmessages" })
}

resource "aws_vpc_endpoint" "ssm" {
  service_name       = "com.amazonaws.us-east-1.ssm"
  vpc_id             = module.endpoints_vpc.vpc_id
  vpc_endpoint_type  = "Interface"
  security_group_ids = [aws_security_group.vpc_endpoints_sg.id]

  subnet_ids          = module.endpoints_vpc.private_subnets
  private_dns_enabled = true

  tags = merge(local.tags, { Name = "vpc-endpoints-ssm" })
}

