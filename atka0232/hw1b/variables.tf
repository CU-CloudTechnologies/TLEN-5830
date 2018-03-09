variable "aws_region" {
  default = "us-west-2"
}

variable "ami_sql" {
  default = "ami-f2d3638a"
}

variable "ami_web" {
  default = "ami-1ee65166"
}

variable "instance_type" {
  default = "t2.micro"
}

variable "ssh_key_name" {
  default = "CloudTech"
}

variable "cidr" {
    default = "172.28.0.0/16"
}

variable "Public_subnet" {
  default = "172.28.0.0/24"
}

variable "Private_subnet" {
  default = "172.28.3.0/24"
}


