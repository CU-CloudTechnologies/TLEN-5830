variable "aws_access_key" {
  description = "Desired name of AWS key pair"
  default = ""
}

variable "aws_secret_key" {
  description = "Desired name of AWS key pair"
  default = ""
}

variable "key-name" {
  default = ""
}

variable "aws_region" {
  description = "AWS region to launch servers."
  default     = "us-west-2"
}

variable "aws_region_subnet" {
  description = "AWS region for subnets."
  default     = "us-west-2a"
}

variable "aws_ami" {
  description = "Ubuntu 16.04 AMI"
  default = "ami-1ee65166"
}

variable "vpc-cidr" {
  default = "172.16.0.0/16"
}

variable "public-network" {
  default = "172.16.1.0/24"
  description = "Public Network"
}

variable "internal-network" {
  default = "172.16.2.0/24"
  description = "Internal Network"
}