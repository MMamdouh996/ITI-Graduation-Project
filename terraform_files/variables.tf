variable "cluster-name" {
  default = "gp-cluster"
}
variable "pub_subnets_cidr" {
  default = {
    "10.1.0.0/24" = "us-east-1a"
    "10.1.1.0/24" = "us-east-1b"
  }
}
