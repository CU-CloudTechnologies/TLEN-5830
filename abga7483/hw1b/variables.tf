variable "aws_region" {
  description = "AWS region to launch Instance in"
  default = "us-east-2a"
}
variable "instance_user" {
  description = "Login for instance"
  default = "admin"
}
variable "availability_zone" {
  default = "us-east-2a"
}
variable "ami_id" {
  default = "ami-965e6bf3"
}
variable "instance_type" {
  description = "AWS Machine Type"
  default = "t2.micro"
}
variable "ssh_key_name" {
  default = "/home/abhishek/.ssh/id_rsa.pub"
}
variable "vpc_cidr" {
  default = "172.16.0.0/16"
}

variable "public_cidr" {
  default = "172.16.0.0/24"
}
variable "private_cidr" {
  default = "172.16.1.0/24"
}
variable "db_server_private_ip" {
  default = "172.16.1.100"
}
variable "server_port" {
  default = "80"
}