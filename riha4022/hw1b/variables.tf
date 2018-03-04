##################################################################################
# VARIABLES
##################################################################################

variable "ami_id" {
	default = "ami-1ee65166"
}

variable "instance_type" {
	default = "t2.micro"
}


variable "aws_access_key" {}
variable "aws_secret_key" {}
variable "private_key_path" {}
variable "key_pair"{
	default = "KEYS"
}

variable "db_instance_password" {
	default = "jesal1993"
}	

variable "count_aws_instance" {
  description = "Enter number of web servers you want to add/destroy"
}	



