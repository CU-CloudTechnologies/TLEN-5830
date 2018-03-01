# Configure the AWS Provider
provider "aws" {
  access_key = "${var.aws_access_key}"
  secret_key = "${var.aws_secret_key}"
  region     = "${var.aws_region}"
}

module "network" {
  source = "./network"
  vpc-cidr = "${var.vpc-cidr}"
  private-subnet-cidr = "${var.internal-network}"
  public-subnet-cidr = "${var.public-network}"
}

module "security-group" {
  source = "./security-group"
  vpc = "${module.network.vpc}"
}

module "instance" {
  source = "./instance"
  ami = "${var.aws_ami}"
  key-name = "${var.key-name}"
  security-group-webserver = "${module.security-group.security-group-webserver}"
  security-group-database = "${module.security-group.security-group-database}"
  db-private-subnet = "${module.network.db-private-subnet}"
  private-subnet = "${module.network.private-subnet}"
  public-subnet = "${module.network.public-subnet}"
}

module "autoscaling" {
  source = "./autoscaling"
  ami = "${var.aws_ami}"
  key-name = "${var.key-name}"
  security-group-webserver = "${module.security-group.security-group-webserver}"  
  dbname = "${module.instance.dbname}"
  elb = "${module.instance.elb}"
  public-subnet = "${module.network.public-subnet}"
}

output "public_ip_dns" {
#  value = "${module.instance.public_ip} : ${module.instance.public_dns}"
  value = "${concat(module.instance.public_ip, module.instance.public_dns)}"
}

output "elb" {
  value = "${module.instance.elb}"
}