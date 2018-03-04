# Terraform - AWS
## Configure Webserver and Database on AWS with autoscaling behind a Load Balancer

### Description:
The terraform script will create two EC2 instances and an RDS instance. The EC2 instances are assigned a public IP. An ELB is created and initialized with the EC2 instances. An autoscaling group will monitor the healthcheck of ELB and create a minimum of two EC2 instances and a maximum of five.
Nginx is installed and configured with php and mysql on all EC2 instances. A php file ibuiltthis.php is created on all instances. RDS is initialized with a database called "mydb" and a table - "teams" is populated with values.

### Pre-Requisites:
1. Edit the variables.tf file in the root folder, and enter the path to the private key (.pem extension) of the SSH private key used to connect to the AWS instances
```
variable "ssh-key-file" {
  default = "xxxxx"
}
```
2. Enter the key name to be used to create the EC2 instances
```
variable "key-name" {
  default = "xxxxx"
}
```
3. Export environment variables
```
export AWS_ACCESS_KEY_ID="xxxxxxxxxxxxxxxxxxxxx"
export AWS_SECRET_ACCESS_KEY="xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
export AWS_DEFAULT_REGION="us-east-1"
```

### Usage:
1. Run below commands to run the terraform script
```
terrform init
terraform plan
terraform apply
```
2. Access the following URL to confirm:
```
http://{load_balancer_dns/ec2_dns}/ibuiltthis.php
```

### Modules:
1. Autoscaling
Create a launch configuration to be used by autoscaling group to spin up new EC2 instances by doing a healthcheck on ELB
2. Security Groups
Create appropriate security groups for webservers and database
3. ELB - Load Balancer
Create a load balancer to hash requests to available EC2 instances
4. Instances - Webservers & Database
Create 2 EC2 instances (Webserver) and a database. Webservers run nginx to display webpages to end users. `default` and `index.php` are used to instantiate these webservers
5. Network
Create and configure public and private subnets, network acls, and route tables