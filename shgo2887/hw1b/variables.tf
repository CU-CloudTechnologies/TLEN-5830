variable "aws_region" {
  description = "AWS region to launch Instance in"
  default = "us-east-1a"
}
variable "instance_user" {
  description = "Login for instance"
  default = "ubuntu"
}
variable "instance_type" {
  description = "AWS Machine Type"
  default = "t2.micro"
}

variable "ssh_keyfile" {
	default="/home/chetan/Feb252018.pem"
}

variable "ssh_key_name"{
	default = "Feb252018"
}

variable "public_cidr" {
  default = "10.1.1.0/24"
}
variable "private_cidr" {
  default = "10.1.3.0/24"
}
variable "vpc_cidr" {
  default = "10.1.0.0/16"
}
variable "availability_zone" {
  default = "us-east-1a"
}
variable "ami_id" {
  default = "ami-26ebbc5c"
}
variable "ami_id1" {
  default = "ami-66506c1c"
}
variable "db_server_private_ip" {
  default = "10.1.3.100"
}

variable "server_port" {
  default = "80"
}
