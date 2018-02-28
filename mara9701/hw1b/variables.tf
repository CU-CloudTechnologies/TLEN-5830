#File containing various variables used in the code

#Region to spin the instance
variable "region" {
  default = "us-west-1"
}

/*
#Can Insert the aws access key and secret key or provide the path of credentials file: Not recommended!!
variable "aws_access_key" {
  default = "AKIAJ2MW7764T6QHC3ZA"
  description = "the user aws access key"
}

variable "aws_secret_key" {
  default = "nLTaWHj5c5nWULEPhvDJUjFpXVXrhoeLFwdRgoeX"
  description = "the user aws secret key"
}
*/

variable "count" {
	default = "2"
	description = "Number of webservers to spawn"
}

#VPC subnet
variable "vpc-cidr" {
    default = "10.0.0.0/16"
  description = "the vpc cdir"
}

#Subnet Reserved for Public
variable "Subnet-Public_cidr" {
  default = "10.0.1.0/24"
  description = "the cidr of the public subnet"
}

#Subnet Reserved for Private: Providing two CIDR: high availability for the database deployment
variable "Subnet-Private_cidr1" {
  default = "10.0.16.0/24"
  description = "the cidr of the first private subnet"
}

variable "Subnet-Private_cidr2" {
  default = "10.0.17.0/24"
  description = "the cidr of the second private subnet"
}

#The AMI type to deploy
variable "ami" {
  description = "Ubuntu"
  default  =  "ami-07585467"
}

variable "instance_type" {
  description = "AWS Machine Type"
  default = "t2.micro"
}

#Needs to point to the path of the public key
variable "key_path" {
  description = "SSH Public Key path"
  default = "D:\\Madhavi\\Spring2018\\CloudTechnologies\\Assignment_Revised\\vpc_keypair"
}


#Different availability zones to achieve High availability for the database
variable "az_1" {
  default     = "us-west-1c"
  description = "AZ1: US West (N. California) Region"
}

variable "az_2" {
  default     = "us-west-1b"
  description = "Az2: US West (Oregon) Region"
}


#Hard code the private IP of the Database Server
variable "db_server_private_ip" {
  default = "10.0.16.100"
}
