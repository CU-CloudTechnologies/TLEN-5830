variable "region" {
  default = "us-east-2"
}
variable "ami" {
  default = "ami-965e6bf3"
}
variable "inst_type" {
  description = "Instance type t2.micro"
  default = "t2.micro"
}

variable "user" {
	default="admin"
}

variable "ssh_keyfile" {
  default = "/home/sampykishan/Desktop/AWSkeys/Terraform_2.pem"
}


variable "aws_access_key" {
  default = "AKIAJHMMAAKXYWPSZBSA"
  description = "the user aws access key"
}
variable "aws_secret_key" {
  default = "bttBWw4fSJ+xKfKPhFpGmNgUkqzfIoY/eiah2qGE"
  description = "the user aws secret key"
}

variable "vpc-cidr" {
    default = "172.28.0.0/16"
  description = "the vpc cdir"
}
variable "public-cidr" {
  default = "172.28.0.0/24"
  description = "the cidr of the subnet"
}

variable "avail_zone" {
  default = "us-east-2a"
}
variable "private-cidr" {
  default = "172.28.3.0/24"
  description = "the cidr of the subnet"
}
variable "ssh_key_name" {
  default = "Terraform_2"
  description = "the ssh key to use in the EC2 machines"
}

variable "dbserver_private_ip" {
  default = "172.28.3.100"
}

