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
  # provisioner "local-exec" {
  #   command = "echo 'Jumphost_machine ansible_user=ubuntu ansible_host=${self.public_ip}  ansible_ssh_private_key_file=./mamdouh-final-key.pem' > ../Ansible/inventory.ini "
  # }
  provisioner "remote-exec" {
    inline = [
      "echo 'Wait untill SSH is ready' ;mkdir ~/k8s "
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
      ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook  -u ${var.user_name} -i ${aws_instance.ec2.public_ip}, --private-key ../${var.key_pair}.pem ../Ansible/control-machine-playbook.yaml
      echo "JumpHost Configuration Done Using Ansible Playbook"
      scp -i ../${var.key_pair}.pem -r ../k8s/* ${var.user_name}@${aws_instance.ec2.public_ip}:~/k8s/
    EOF
  }



  depends_on = [
    aws_iam_instance_profile.my_instance_profile, var.eks_dependant_resource
  ]
}

resource "aws_iam_instance_profile" "my_instance_profile" {
  name = "my-ec2-instance-profile"

  role = var.role_name
  # aws_iam_role.my_role.name

}
