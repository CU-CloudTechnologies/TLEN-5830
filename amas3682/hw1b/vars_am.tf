variable "aws_region" {
  description = "AWS region"
  default = "us-west-2"
}

variable "ami" {
  description = "linux image"
  default = "ami-f2d3638a"
}

variable "instance_type" {
  description = "AWS Machine Type"
  default = "t2.micro"
}

variable "vpc_ips" {
    default = "172.17.0.0/16"
}
variable "public_cidr" {
  default = "172.17.0.0/24"
}
variable "private_cidr" {
  default = "172.17.4.0/24"
}

variable "availability_zone" {
  default = "us-west-2b"
}

variable "db_server_private_ip" {
  default = "172.17.4.200"
}

variable "ssh_key_name" {
  default = "cloudlab1"
}

