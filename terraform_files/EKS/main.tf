resource "aws_eks_cluster" "EKS-" {
  name     = var.Cluster_Name
  role_arn = var.eks_role_arn
  version  = var.cluster_k8s_version

  #When you create a cluster, you specify a VPC and at least two subnets that are in different Availability Zones. 

  vpc_config {
    subnet_ids              = var.cluster_subnets
    endpoint_private_access = true
    endpoint_public_access  = false
  }

  depends_on = [var.cluster_dependant]
}

#-------------------------------------------Node Group ---------------------------------------------------#

resource "aws_eks_node_group" "EKS-" {
  cluster_name    = aws_eks_cluster.EKS-.name
  node_group_name = var.node_group_name
  node_role_arn   = var.NG_role_arn
  subnet_ids      = var.NG_subnets_ids

  scaling_config {
    desired_size = 2
    max_size     = 4
    min_size     = 1
  }

  update_config {
    max_unavailable = 1
  }
  lifecycle {
    replace_triggered_by = [
      # Replace `aws_appautoscaling_target` each time this instance of
      # the `aws_ecs_service` is replaced.
      aws_eks_cluster.EKS-.id
    ]
  }
  # Ensure that IAM Role permissions are created before and deleted after EKS Node Group handling.
  # Otherwise, EKS will not be able to properly delete EC2 Instances and Elastic Network Interfaces.
  # depends_on = [aws_eks_cluster.EKS-]
  depends_on = [var.NG_dependant]

}
#amiType
# capacityType =ON_DEMAND
# diskSize = 20 
# instanceTypes = t2 micro
