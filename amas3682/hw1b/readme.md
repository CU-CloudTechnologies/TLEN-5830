These Terraform scripts deploy one db server and (multiple) web servers based on the count variable in webserver_am.tf script. These scripts aid in automated deployment on ec2 instances. We have chosen the provider as AWS.

The execution of these will result in a web fornt end which can be accessed via a public ip and it can be directed to the page /cloudtech.php from the browser. The web server fetches the value from db server (mysql database) and displays it in the web browser.

vars_am.tf file
-------------------

It consists of variables which can be accessed globally. Once defined here we do not need to change them elsewhere. The variables are:

aws_region (aws region where you want to launch the instance)
ami (amazon machine image)
instance_type (the machine type)
vpc_ips (the cidr block for virtual private cloud)
public_cidr (cidr block for public ips)
private_cidr (cidr block for private ips)
availability_zone (the available zone in the aws region)
db_server_private_ip (we need to fix this ip in the private subnet)
ssh_key_name

We will not put access and secret keys and the aws_region in vars file. 

export AWS_ACCESS_KEY_ID="xxxxxxxxxxxxxxxxxxxxx"
export AWS_SECRET_ACCESS_KEY="xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
export AWS_DEFAULT_REGION="us-west-2"

network_am.tf file
--------------------

This file sets up the network settings. We create a VPC and public/private subnets and reference them here.

We need to attach an internet gateway to the VPC and define network ACLs. There are 2 routing tables defined one for public access and other for private. To install the mysql services on the database instance we require internet access. We use the NAT gateway which depends on the internet gateway. We deploy a public subnet and associate an elastic ip to it.

dbserver_am.tf file
---------------------

This deploys the ec2 instance and installs db server on it. It can be accessed via a private ip. The security group has restrictions set. Uses a sleep time of 120 sec.

webserver_am.tf file
----------------------

This deploys the ec2 instance and installs web server on it. The security group is less restrictive. Uses a sleep time of 150 sec.

How to run the scripts
-------------------------
Make sure to add the provider as aws and mention the access and secret keys, and aws region then run using following commands:

terraform init
terraform plan -out=terraform.plan
terraform apply "terraform.plan"

Once your instance is running (for web server), obtain its public IP and point it to /cloudtech.php
The page will come up in 60-90 seconds.


