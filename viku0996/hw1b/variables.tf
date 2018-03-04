#Enter the key name in AWS used to connect to AWS instances
variable "key-name" {
  default = ""
}

#Path to Private key file with .pem extension
variable "ssh-key-file" {
  default = ""
}

#Enter the AWS region (Availability Zones) for the instances. If modified, change the aws_region_subnet parameter as well
variable "aws_region" {
  description = "AWS region to launch servers."
  default     = "us-west-2"
}

#Enter the AWS region for the subnets.
variable "aws_region_subnet" {
  description = "AWS region for subnets."
  default     = "us-west-2a"
}

#Enter the AMI ID of the image to be used for the EC2 instances
variable "aws_ami" {
  description = "Ubuntu 16.04 AMI"
  default = "ami-1ee65166"
}

#Select the instance class
variable "instance-type" {
  default = "t2.micro"
}

#Select the RDS instance class
variable "db-instance-class" {
  default = "db.t2.micro"
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