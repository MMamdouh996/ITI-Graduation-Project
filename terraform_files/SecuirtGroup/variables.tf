variable "SG_name" {

}
variable "vpc_id" {

}

variable "in_port" {
  default = "0"
}
variable "in_protocol" {
  default = "-1"
}
variable "ipv4_in_cidr_block" {
  default = ["0.0.0.0/0"]
}
# variable "ipv6_in_cidr_block" {

# }

variable "eg_port" {
  default = "0"
}
variable "eg_protocol" {

}
variable "ipv4_eg_cidr_block" {
  default = ["0.0.0.0/0"]
}
# variable "ipv6_eg_cidr_block" {

# }
