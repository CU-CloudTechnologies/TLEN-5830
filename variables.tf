variable "aws_region" {
  description = "AWS region in which the instance is launched"
  default = "us-west-2"
}
variable "ssh_keyfile" {
  description = ""
  default = "~/.ssh/shikha.pem"
}  
variable "vpc_cidr" {
  default = "172.28.0.0/16"
}
variable "public_cidr" {
  default = "172.28.1.0/24"
}
variable "private_cidr" {
  default = "172.28.2.0/24"
}
variable "ami_id" {
  default = "ami-f173cc91"
}
variable "instance_type" {
  description = "AWS Machine Type"
  default = "t2.micro"
}
variable "ssh_key_name" {
  default = "shikha"
}

