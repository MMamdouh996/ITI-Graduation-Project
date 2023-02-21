resource "aws_security_group" "SG_GP" {
  name        = var.SG_name
  description = "Allow TLS inbound traffic"
  vpc_id      = var.vpc_id

}


resource "aws_security_group_rule" "ingress" {
  type      = "ingress"
  for_each  = toset(var.in_port)
  from_port = each.value
  to_port   = each.value
  protocol  = var.in_protocol

  cidr_blocks = var.ipv4_in_cidr_block
  # ipv6_cidr_blocks  = var.ipv6_in_cidr_block
  security_group_id = aws_security_group.SG_GP.id
}

resource "aws_security_group_rule" "egress" {
  type      = "egress"
  from_port = var.eg_port
  to_port   = var.eg_port
  protocol  = var.eg_protocol

  cidr_blocks = var.ipv4_eg_cidr_block
  # ipv6_cidr_blocks  = var.ipv6_eg_cidr_block
  security_group_id = aws_security_group.SG_GP.id
}

# ingress {
#   description = var.ingress_description
#   from_port   = v
#   to_port     = 
#   protocol    = 
#   cidr_blocks = 
# }
# ingress {
#   description = var.ssh_description
#   from_port   = var.ssh_port
#   to_port     = var.ssh_port
#   protocol    = var.ssh_protocol
#   cidr_blocks = var.in_cidr_block
# }

# egress {
#   description = var.egress_description
#   from_port   = var.eg_port
#   to_port     = var.eg_port
#   protocol    = var.eg_protocol
#   cidr_blocks = var.eg_cidr_block
# }


