resource "aws_security_group" "SG_GP" {
  name        = var.SG_name
  description = "Allow TLS inbound traffic"
  vpc_id      = var.vpc_id


  ingress {
    description = var.ingress_description
    from_port   = var.in_port
    to_port     = var.in_port
    protocol    = var.in_protocol
    cidr_blocks = var.in_cidr_block
  }
  ingress {
    description = var.ssh_description
    from_port   = var.ssh_port
    to_port     = var.ssh_port
    protocol    = var.ssh_protocol
    cidr_blocks = var.in_cidr_block
  }

  egress {
    description = var.egress_description
    from_port   = var.eg_port
    to_port     = var.eg_port
    protocol    = var.eg_protocol
    cidr_blocks = var.eg_cidr_block
  }


}
