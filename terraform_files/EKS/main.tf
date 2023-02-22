resource "aws_eks_cluster" "EKS-" {
  name     = var.Cluster_Name
  role_arn = var.eks_role_arn
  version  = var.cluster_k8s_version

  #When you create a cluster, you specify a VPC and at least two subnets that are in different Availability Zones. 

  vpc_config {
    subnet_ids              = var.cluster_subnets
    endpoint_private_access = var.endpoint_private_access
    endpoint_public_access  = var.endpoint_public_access
    security_group_ids      = [var.cluster_SG]
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
  # Type of Amazon Machine Image (AMI) associated with the EKS Node Group.
  # Valid values: AL2_x86_64, AL2_x86_64_GPU, AL2_ARM_64
  ami_type = "AL2_x86_64"

  # Type of capacity associated with the EKS Node Group. 
  # Valid values: ON_DEMAND, SPOT
  capacity_type = "ON_DEMAND"

  # Disk size in GiB for worker nodes
  disk_size = 30

  # Force version update if existing pods are unable to be drained due to a pod disruption budget issue.
  force_update_version = false

  # List of instance types associated with the EKS Node Group
  instance_types = ["t3.medium"]

  labels = {
    role = "nodes-general"
  }

  # Kubernetes version
  version = var.cluster_k8s_version

  remote_access {
    ec2_ssh_key = "mamdouh-final-key"

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
