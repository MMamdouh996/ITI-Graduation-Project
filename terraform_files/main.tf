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
  subnet_name                       = "public-subnet-1"
  route_table_id                    = module.network.igw-route-table-id
  route_table_association_dependant = [module.network.igw-route-table-id]
  auto_assign_public_ip_state       = true
}
module "public-subnet-2" {
  source                            = "./Subnets"
  vpc-id                            = module.network.vpc-id
  subnet_cidr                       = "10.1.1.0/24"
  subnet_AZ                         = "us-east-1b"
  subnet_name                       = "public-subnet-2"
  route_table_id                    = module.network.igw-route-table-id
  route_table_association_dependant = [module.network.igw-route-table-id]
  auto_assign_public_ip_state       = true
}

module "private-nat-subnet-1" {
  source                            = "./Subnets"
  vpc-id                            = module.network.vpc-id
  subnet_cidr                       = "10.1.2.0/24"
  subnet_AZ                         = "us-east-1a"
  subnet_name                       = "private-nat-subnet-1"
  route_table_id                    = module.network.nat-route-table-id
  route_table_association_dependant = [module.network.nat-route-table-id]
  auto_assign_public_ip_state       = true
}

module "private-nat-subnet-2" {
  source                            = "./Subnets"
  vpc-id                            = module.network.vpc-id
  subnet_cidr                       = "10.1.3.0/24"
  subnet_AZ                         = "us-east-1b"
  subnet_name                       = "private-nat-subnet-2"
  route_table_id                    = module.network.nat-route-table-id
  route_table_association_dependant = [module.network.nat-route-table-id]
  auto_assign_public_ip_state       = true
}
module "EKS" {
  source              = "./EKS"
  Cluster_Name        = "gp-cluser"
  eks_role_arn        = module.EKS_IAM_Role.role_arn
  cluster_subnets     = [module.private-nat-subnet-1.subnet-id, module.private-nat-subnet-2.subnet-id] # module.public-subnet-1.subnet-id, module.public-subnet-2.subnet-id, 
  cluster_k8s_version = "1.24"
  cluster_dependant   = [module.EKS_IAM_Role]

  node_group_name = "Node-Group-1"
  NG_role_arn     = module.NG_IAM_Role.role_arn
  NG_subnets_ids  = [module.private-nat-subnet-1.subnet-id, module.private-nat-subnet-2.subnet-id]
  NG_dependant    = [module.NG_IAM_Role]


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
  ec2_ami       = "ami-06878d265978313ca"
  ec2_type      = "t2.small"
  SG_id         = [module.Secuirty_Group.SG_id]
  ec2_subnet    = module.public-subnet-1.subnet-id
  pub_ip_state  = true
  key_pair      = "../mamdouh-final-key"
  instance_name = "Jumphost-for-control-plane"
}

module "Secuirty_Group" {
  source  = "./SecuirtGroup"
  SG_name = "First-SG"
  vpc_id  = module.network.vpc-id

  ingress_description = "allow-HTTP-From-Anywhere"
  in_port             = 80
  in_protocol         = "tcp"
  in_cidr_block       = ["0.0.0.0/0"]

  ssh_description = "allow-SSH-From-Anywhere"
  ssh_port        = 22
  ssh_protocol    = "tcp"

  egress_description = "allow-all-outbound"
  eg_port            = "0"
  eg_protocol        = "-1"
  eg_cidr_block      = ["0.0.0.0/0"]
}
