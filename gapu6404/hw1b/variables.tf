variable "aws_region" {
  description = "AWS region to launch Instance in"
  default = "us-west-2a"
}
variable "instance_user" {
  description = "Login for instance"
  default = "admin"
}
variable "instance_type" {
  description = "AWS Machine Type"
  default = "t2.micro"
}
variable "ssh_keyfile" {
  description = ""
  default = "/home/gpunwat5/Downloads/punwatkar.pem"
}
variable "ssh_key_name" {
  default = "punwatkar"
}
variable "public_cidr" {
  default = "10.0.1.0/24"
}
variable "private_cidr" {
  default = "10.0.16.0/20"
}
variable "vpc_cidr" {
  default = "10.0.0.0/16"
}
variable "availability_zone" {
  default = "us-west-2a"
}
variable "ami_id" {
  default = "ami-79873901"
}
variable "db_server_private_ip" {
  default = "10.0.16.100"
}
