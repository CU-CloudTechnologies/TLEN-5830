variable "aws_region" {
  description = "AWS region to launch Instance in"
  default = "us-east-1a"
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
  default = "~/.ssh/griffith-ec2.pem"
}
variable "ssh_key_name" {
  default = "griffith-ec2"
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
  default = "us-east-1a"
}
variable "ami_id" {
  default = "ami-628ad918"
}
variable "db_server_private_ip" {
  default = "10.0.16.100"
}
