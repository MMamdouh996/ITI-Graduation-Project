output "eks" {
  value = aws_eks_node_group.EKS
}
output "node-ip" {
  value = data.aws_instances.my_worker_nodes.private_ips[0]

}
