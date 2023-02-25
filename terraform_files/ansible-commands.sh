ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook  ../Ansible/worker-node-config.yaml -i ../Ansible/workernode-inventory.ini
ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook  ../Ansible/control-machine-playbook.yaml -i ../Ansible/jumphost.ini
