Building a simple web application with a Database in AWS using Terraform
The project aims at deploying the following:
Web server
Database server

The variables variables.tf file contains information about the following
The region that AWS will use
Instance size (t2.micro)
CIDR Blocks for the public and private IP ranges
Image Type (default is Debian)
Availibility zone
SSH Instances for the user
Use the AWS credentials and region as an environment variable

export AWS_ACCESS_KEY_ID="xxxxxxxxxxxxxxxxxxxxx" 
export AWS_SECRET_ACCESS_KEY="xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx" 
export AWS_DEFAULT_REGION="us-east-1"

The functions of network.tf is as follows
Creates a VPC and our public/private subnets here
Reference them when building our instances.

dbserver.tf and webserver.tf
Both these server.tf files describe how we can create security groups and ensure the instances created has parameters associated to it such as IP address, which protocolas are allowed, availability zone, instance type etc.

Running it
Make sure you have exported the environment variables

Modify the variables.tf file according to your own requirement

Run the following commands inside the folder where you store all the scripts:

terraform init 
terraform plan 
terraform apply

Access the Terraform output
Obtain the public DNS name of the Web Server Instance from the Terraform output (or your EC2 Console) and point your browser to: /cloudtech.php
Pointing your browser to the /cloudtech.php of the Web Server, should result in a query to the mysql DB and a display of the query result in your browser.

I have also added a info.php file and if you run https://webserver_IP_Address/info.php
It will show the php page indicating that the php is working fine.

I have changed the extension of loadbalance file to .txt 
The extension can be changed to .tf which will create a load balancer. 
