resource "aws_subnet" "subnet-GP" {
  vpc_id                  = var.vpc-id
  cidr_block              = var.subnet_cidr
  availability_zone       = var.subnet_AZ
  map_public_ip_on_launch = var.auto_assign_public_ip_state
  tags                    = var.tags

}

resource "aws_route_table_association" "route_table_association" {
  subnet_id = aws_subnet.subnet-GP.id

  route_table_id = var.route_table_id
  depends_on     = [var.route_table_association_dependant]
}
