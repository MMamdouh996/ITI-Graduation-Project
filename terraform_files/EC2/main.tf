resource "aws_instance" "ec2" {
  ami                         = var.ec2_ami
  instance_type               = var.ec2_type
  vpc_security_group_ids      = var.SG_id
  subnet_id                   = var.ec2_subnet
  associate_public_ip_address = var.pub_ip_state
  key_name                    = var.key_pair
  iam_instance_profile        = aws_iam_instance_profile.my_instance_profile.name
  tags = {
    Name = var.instance_name
  }

  provisioner "remote-exec" {
    inline = [
      "echo 'Wait untill SSH is ready' "
    ]
    connection {
      type        = "ssh"
      user        = var.user_name
      private_key = file(var.private_key_path) # file(local.private_key_path)
      host        = aws_instance.ec2.public_ip
    }
  }
  provisioner "local-exec" {
    # command = "ansible-playbook  ansible/playbook.yaml -i ansible/inventory.ini "
    # command = "ansible-playbook  -i ${aws_instance.ec2.public_ip}, --private-key ${var.private_key_path} control-machine-playbook.yaml"
    # echo "ansible-playbook  -u ${var.user_name} -i ${aws_instance.ec2.public_ip}, --private-key ./${var.key_name}.pem ansible/playbook.yaml "

    command = <<-EOF
      ansible-playbook  -u ${var.user_name} -i ${aws_instance.ec2.public_ip}, --private-key ./${var.key_pair}.pem ../Ansible/control-machine-playbook.yaml
      echo "JumpHost Configuration Done Using Ansible Playbook"
    EOF
  }



  depends_on = [
    aws_iam_instance_profile.my_instance_profile
  ]
}

resource "aws_iam_instance_profile" "my_instance_profile" {
  name = "my-ec2-instance-profile"

  role = var.role_name
  # aws_iam_role.my_role.name

}
