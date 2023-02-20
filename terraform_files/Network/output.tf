output "vpc-id" {
  value = aws_vpc.vpc-GP.id
}
output "igw-route-table-id" {
  value = aws_route_table.igw-route-GP.id
}
output "nat-route-table-id" {
  value = aws_route_table.nat-route-GP.id
}
