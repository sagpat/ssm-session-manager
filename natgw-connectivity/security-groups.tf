#-----------------------------------------
# Security Groups
#-----------------------------------------

# data "http" "my_ip" {
#   url = "https://ipinfo.io/ip"
# }

resource "aws_security_group" "private_instance_sg" {
  vpc_id = aws_vpc.main_vpc.id
  name   = "private-instance-sg"
  ingress {
    description = "Allow HTTP traffic"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow HTTP traffic from natgw"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["${aws_nat_gateway.natgw.public_ip}/32"]
  }

  egress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  description = "Security group for EC2 instance allowing outbound HTTPS"
  tags        = merge(local.tags, { Name = "private-instance-sg" })
}
