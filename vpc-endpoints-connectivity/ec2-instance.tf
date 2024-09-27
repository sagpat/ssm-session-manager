module "vpc_endpoints_instance" {
  source = "terraform-aws-modules/ec2-instance/aws"

  name                   = "vpc-endpoints-instance"
  instance_type          = "t2.micro"
  iam_instance_profile   = aws_iam_instance_profile.ssm_instance_profile.name
  monitoring             = true
  vpc_security_group_ids = [aws_security_group.ec2_instance_sg.id]
  subnet_id              = module.endpoints_vpc.private_subnets[0]

  metadata_options = {
    "http_endpoint" : "enabled"
    "http_tokens" : "optional"
    "http_put_response_hop_limit" : 1
  }

  tags = merge(local.tags, { Name = "vpc-endpoints-instance" })
}