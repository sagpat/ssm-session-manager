#-----------------------------------------
# VPC and Subnets
#-----------------------------------------
resource "aws_vpc" "main_vpc" {
  cidr_block = "10.1.0.0/16"

  tags = merge(local.tags, { Name = "aws_main_vpc" })
}

resource "aws_subnet" "public_subnet" {
  vpc_id            = aws_vpc.main_vpc.id
  cidr_block        = "10.1.0.0/24"
  availability_zone = "us-west-2a"

  tags = merge(local.tags, { Name = "public-subnet" })
}

resource "aws_subnet" "private_subnet" {
  vpc_id            = aws_vpc.main_vpc.id
  cidr_block        = "10.1.1.0/24"
  availability_zone = "us-west-2a"

  tags = merge(local.tags, { Name = "private-subnet" })
}


#-----------------------------------------
# Routes for private subnet.
# These route table will route traffic to the private instance connecting to SSM Session Manager.
#-----------------------------------------
resource "aws_route_table" "private_sn_rt" {
  vpc_id = aws_vpc.main_vpc.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.natgw.id
  }

  tags = merge(local.tags, { Name = "private-sn-rt" })
}

resource "aws_route_table_association" "private_subnet_association" {
  subnet_id      = aws_subnet.private_subnet.id
  route_table_id = aws_route_table.private_sn_rt.id
}

#-----------------------------------------
# Route table for public subnet
#-----------------------------------------
resource "aws_route_table" "public_sn_rt" {
  vpc_id = aws_vpc.main_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.aws_main_igw.id
  }

  tags = merge(local.tags, { Name = "public-sn-rt" })
}

resource "aws_route_table_association" "public_subnet_association" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_sn_rt.id
}