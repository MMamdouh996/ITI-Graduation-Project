module "network" {
  source               = "./Network"
  vpc_cidr             = "10.1.0.0/16"
  vpc_name             = "mamdouh-GP-VPC"
  enable_dns_hostnames = true
  enable_dns_support   = true
  #   ---------------
  route_table_in_cidr     = "0.0.0.0/0"
  nat-subnet-id           = module.public-subnet-1.subnet-id
  nat-dependant-subnet-id = module.public-subnet-1
}

module "public-subnet-1" {
  source                            = "./Subnets"
  vpc-id                            = module.network.vpc-id
  subnet_cidr                       = "10.1.0.0/24"
  subnet_AZ                         = "us-east-1a"
  route_table_id                    = module.network.igw-route-table-id
  route_table_association_dependant = [module.network.igw-route-table-id]
  auto_assign_public_ip_state       = true
  tags = {
    Name                               = "public-subnet-1"
    "kubernetes.io/cluster/gp-cluster" = "shared"
    "kubernetes.io/role/elb"           = 1
  }
}
module "public-subnet-2" {
  source                            = "./Subnets"
  vpc-id                            = module.network.vpc-id
  subnet_cidr                       = "10.1.1.0/24"
  subnet_AZ                         = "us-east-1b"
  route_table_id                    = module.network.igw-route-table-id
  route_table_association_dependant = [module.network.igw-route-table-id]
  auto_assign_public_ip_state       = true
  tags = {
    Name                               = "public-subnet-2"
    "kubernetes.io/cluster/gp-cluster" = "shared"
    "kubernetes.io/role/elb"           = 1
  }
}

module "private-nat-subnet-1" {
  source                            = "./Subnets"
  vpc-id                            = module.network.vpc-id
  subnet_cidr                       = "10.1.2.0/24"
  subnet_AZ                         = "us-east-1a"
  route_table_id                    = module.network.nat-route-table-id
  route_table_association_dependant = [module.network.nat-route-table-id]
  auto_assign_public_ip_state       = false
  tags = {
    Name                               = "private-nat-subnet-1"
    "kubernetes.io/cluster/gp-cluster" = "shared"
    "kubernetes.io/role/internal-elb"  = 1
  }
}

module "private-nat-subnet-2" {
  source                            = "./Subnets"
  vpc-id                            = module.network.vpc-id
  subnet_cidr                       = "10.1.3.0/24"
  subnet_AZ                         = "us-east-1b"
  route_table_id                    = module.network.nat-route-table-id
  route_table_association_dependant = [module.network.nat-route-table-id]
  auto_assign_public_ip_state       = false
  tags = {
    Name                               = "private-nat-subnet-2"
    "kubernetes.io/cluster/gp-cluster" = "shared"
    "kubernetes.io/role/internal-elb"  = 1
  }
}
module "EKS" {
  source              = "./EKS"
  Cluster_Name        = "gp-cluster"
  eks_role_arn        = module.EKS_IAM_Role.role_arn
  cluster_subnets     = [module.private-nat-subnet-1.subnet-id, module.private-nat-subnet-2.subnet-id, ] # module.public-subnet-1.subnet-id, module.public-subnet-2.subnet-id,
  cluster_k8s_version = "1.24"
  cluster_dependant   = [module.EKS_IAM_Role]
  cluster_SG          = module.EKS_SG.SG_id

  endpoint_private_access = true
  endpoint_public_access  = false

  node_group_name = "Node-Group-1"
  NG_role_arn     = module.NG_IAM_Role.role_arn
  NG_subnets_ids  = [module.private-nat-subnet-1.subnet-id, module.private-nat-subnet-2.subnet-id]
  NG_dependant    = [module.NG_IAM_Role]


}
module "EKS_SG" {
  source  = "./SecuirtGroup"
  SG_name = "EKS-SG"
  vpc_id  = module.network.vpc-id

  in_port            = ["80", "22", "443"]
  in_protocol        = "tcp"
  ipv4_in_cidr_block = ["0.0.0.0/0"]

  eg_port            = "0"
  eg_protocol        = "-1"
  ipv4_eg_cidr_block = ["0.0.0.0/0"]
}
module "EKS_IAM_Role" {
  source        = "./IAM"
  iam_role_name = "EKS-Role"
  using_service = "eks"
  policies_arns = [
    "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy",
    "arn:aws:iam::aws:policy/AmazonEKSVPCResourceController",
  ]
}

module "NG_IAM_Role" {
  source        = "./IAM"
  iam_role_name = "NG_Role"
  using_service = "ec2"
  policies_arns = [
    "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly",
    "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy",
    "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy",
  ]
}

module "EC2" {
  source        = "./EC2"
  ec2_ami       = "ami-0dfcb1ef8550277af"
  ec2_type      = "t2.small"
  SG_id         = [module.Secuirty_Group.SG_id]
  ec2_subnet    = module.public-subnet-1.subnet-id
  pub_ip_state  = true
  key_pair      = "mamdouh-final-key"
  instance_name = "Jumphost-for-control-plane"
  role_name     = module.EC2_IAM_Role.role_name
}
module "EC2_IAM_Role" {
  source        = "./IAM"
  iam_role_name = "EC2-Connect-EKS"
  using_service = "ec2"
  policies_arns = [
    "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly",
    "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy",
    "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy",
  ]
}
module "Secuirty_Group" {
  source  = "./SecuirtGroup"
  SG_name = "ssh-http-SG"
  vpc_id  = module.network.vpc-id

  in_port            = ["80", "22", "443"]
  in_protocol        = "tcp"
  ipv4_in_cidr_block = ["0.0.0.0/0"]

  eg_port            = "0"
  eg_protocol        = "-1"
  ipv4_eg_cidr_block = ["0.0.0.0/0"]
}
