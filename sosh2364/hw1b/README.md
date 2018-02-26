# Example of building a simple web application in AWS using Terraform

The goal is to have an automated deployment of a simple application that includes:
1. Web server
2. Database server

Pointing your browser to the <public DNS address>/cloudtech.php of the
Web Server, should result in a query to the mysql DB and a display of
the query result in your browser.

## Variables
Includes the following:

1. AWS Region
2. CIDR Blocks for the public and private IP ranges
3. Image Type (default is Debian)
4. Instance size (t2.micro)
5. Availibility zone
6. SSH Instances for the user

Use the AWS credentials as a environment variable

export AWS_ACCESS_KEY_ID="xxxxxxxxxxxxxxxxxxxxx"
export AWS_SECRET_ACCESS_KEY="xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
export AWS_DEFAULT_REGION="us-east-1"

### network.tf
1. Creates a VPC and our public/private subnets here
2. Reference them when building our instances.

### dbserver.tf and webserver.tf
Both these server.tf files describe how we can create security groups and generate the commands required

### Running it
1. Make sure you have exported the environment variables
2. Modify the variables.tf file according to your own requirement
3. Run the following commands inside the folder where you store all the scripts:

	terraform init
	terraform plan 
	terraform apply

### Access the Terraform output
Obtain the public DNS name of the Web Server Instance from
the Terraform output (or your EC2 Console) and point your browser to:
  <web-server-dns-name>/cloudtech.php

