# Configure the AWS Provider using environment variables
provider aws {}

#Configure the network - create public and private subnet, vpc, network acls, gateway, and route tables
module "network" {
  source = "./network"
  vpc-cidr = "${var.vpc-cidr}"
  private-subnet-cidr = "${var.internal-network}"
  public-subnet-cidr = "${var.public-network}"
}

#Configure securirty groups for webservers and database
module "security-group" {
  source = "./security-group"
  vpc = "${module.network.vpc}"
}

#Configure EC2 instances behind a load balancer with autoscaling
module "instance" {
  source = "./instance"
  ami = "${var.aws_ami}"
  instance-type = "${var.instance-type}"
  db-instance-class = "${var.db-instance-class}"
  key-name = "${var.key-name}"
  ssh-key-file = "${var.ssh-key-file}"
  security-group-webserver = "${module.security-group.security-group-webserver}"
  security-group-database = "${module.security-group.security-group-database}"
  db-private-subnet = "${module.network.db-private-subnet}"
  private-subnet = "${module.network.private-subnet}"
  public-subnet = "${module.network.public-subnet}"
}

#Configure autoscaling for EC2 instances
module "autoscaling" {
  source = "./autoscaling"
  ami = "${var.aws_ami}"
  instance-type = "${var.instance-type}"
  key-name = "${var.key-name}"
  security-group-webserver = "${module.security-group.security-group-webserver}"  
  dbname = "${module.instance.dbname}"
  elb = "${module.instance.elb}"
  public-subnet = "${module.network.public-subnet}"
}

#Print public ips and urls for each of the created EC2 instances
output "public_ip_dns" {
#  value = "${module.instance.public_ip} : ${module.instance.public_dns}"
  value = "${concat(module.instance.public_ip, module.instance.public_dns)}"
}

#Print public urls for load balancer which will hash the request to any one of the available EC2 instance
output "elb" {
  value = "${module.instance.elb}"
}