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
    command = <<-EOF

      echo "Jumphost_machine ansible_user=${var.user_name} ansible_host=${self.public_ip}  ansible_ssh_private_key_file=../mamdouh-final-key.pem" > ${var.jumphost_inventory_file_path}
      echo "workernode ansible_user=${var.node_username} ansible_host=${var.node_instance_ip}  ansible_ssh_private_key_file=../mamdouh-final-key.pem ansible_ssh_common_args='-o StrictHostKeyChecking=no -o ProxyCommand=\"ssh -i ../mamdouh-final-key.pem -W %h:%p -q ${var.user_name}@${self.public_ip} \"' " > ${var.worker_inventory_file_path}
      echo "ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook  ${var.worker_playbook_file_path} -i ${var.worker_inventory_file_path}" > ansible-commands.sh
      ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook  ${var.worker_playbook_file_path} -i ${var.worker_inventory_file_path}
      echo "ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook  ${var.jumphost_playbook_file_path} -i ${var.jumphost_inventory_file_path}" >> ansible-commands.sh
      ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook  ${var.jumphost_playbook_file_path} -i ${var.jumphost_inventory_file_path}
      
      echo "JumpHost Configuration Done Using Ansible Playbook"

    EOF
  }
  # ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook  ${var.worker_playbook_file_path} -i ${var.worker_inventory_file_path}
  # sleep 10
  # ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook  ${var.jumphost_playbook_file_path} -i ${var.jumphost_inventory_file_path}
  depends_on = [
    aws_iam_instance_profile.my_instance_profile, var.eks_dependant_resource
  ]
}

resource "aws_iam_instance_profile" "my_instance_profile" {
  name = "my-ec2-instance-profile"

  role = var.role_name
  # aws_iam_role.my_role.name

}
