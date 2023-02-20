resource "aws_instance" "public-ec2-x" {
  ami                         = var.ec2_ami
  instance_type               = var.ec2_type
  vpc_security_group_ids      = var.SG_id
  subnet_id                   = var.ec2_subnet
  associate_public_ip_address = var.pub_ip_state
  key_name                    = var.key_pair
  tags = {
    Name = var.instance_name
  }

  #   provisioner "local-exec" {
  #     command = var.pub_ip_state ? "echo public-instance-${var.instnace-number}-public-ip: ${self.public_ip} >> required_ips.txt" : "echo private-instance-${var.instnace-number}-private-ip: ${self.private_ip} >> required_ips.txt"
  #   }



}
