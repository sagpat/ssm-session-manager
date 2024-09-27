#-----------------------------------------
# Internet Gateway
#-----------------------------------------
resource "aws_internet_gateway" "aws_main_igw" {
  vpc_id = aws_vpc.main_vpc.id
  tags   = merge(local.tags, { Name = "aws-main-igw" })
}

#-----------------------------------------
# NAT Gateway and EIP
#-----------------------------------------
resource "aws_eip" "nat" {
  domain = "vpc"
  tags   = merge(local.tags, { Name = "aws-eip" })
}

resource "aws_nat_gateway" "natgw" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public_subnet.id
  tags          = merge(local.tags, { Name = "aws-nat-gateway-${aws_subnet.public_subnet.id}" })
}
