#--------------------- VPC -------------------#
resource "aws_vpc" "vpc-GP" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = var.enable_dns_hostnames
  enable_dns_support   = var.enable_dns_support
  tags = {
    Name = var.vpc_name
  }
}
#--------------------- Internet Gateway -------------------#

resource "aws_internet_gateway" "igw-GP" {
  vpc_id = aws_vpc.vpc-GP.id

  tags = {
    Name = "igw-tag-name"
  }
}

resource "aws_route_table" "igw-route-GP" {
  vpc_id = aws_vpc.vpc-GP.id

  route {
    cidr_block = var.route_table_in_cidr
    gateway_id = aws_internet_gateway.igw-GP.id
  }
  tags = {
    Name = "IGW_route-GP"
  }
}


#--------------------- NAT Gateway -------------------#
resource "aws_eip" "eip-GP" {}

resource "aws_nat_gateway" "nat-GP" {

  allocation_id = aws_eip.eip-GP.id
  subnet_id     = var.nat-subnet-id
  depends_on    = [var.nat-dependant-subnet-id]

}


resource "aws_route_table" "nat-route-GP" {
  vpc_id = aws_vpc.vpc-GP.id

  route {
    cidr_block = var.route_table_in_cidr
    gateway_id = aws_nat_gateway.nat-GP.id
  }

  tags = {
    Name = "NAT_route-GP"
  }
}
