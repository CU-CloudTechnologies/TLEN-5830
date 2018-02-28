Example of building a simple web application in AWS using Terraform
The goal is to have an automated deployment of a simple application that includes:

Web server
Database server
RDS (Please note that this is currently not created in AWS)
Load Balancing (Files created)
Pointing your browser to the /cloudtech.php of the Web Server, should result in a query to the mysql DB and a display of the query result in your browser.

Variables
Includes the following:

AWS Region
CIDR Blocks for the public and private IP ranges
Image Type (default is Debian)
Instance size (t2.micro)
Availibility zone
SSH Instances for the user
Use the AWS credentials as a environment variable

export AWS_ACCESS_KEY_ID="xxxxxxxxxxxxxxxxxxxxx" export AWS_SECRET_ACCESS_KEY="xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx" export AWS_DEFAULT_REGION="us-west-2a"

network.tf
Creates a VPC and our public/private subnets here
Reference them when building our instances.
dbserver.tf and webserver.tf
Both these server.tf files describe how we can create security groups and generate the commands required

Running it
Make sure you have exported the environment variables

Modify the variables.tf file according to your own requirement

Run the following commands inside the folder where you store all the scripts:

terraform init terraform plan terraform apply

Access the Terraform output
Obtain the public DNS name of the Web Server Instance from the Terraform output (or your EC2 Console) and point your browser to: /cloudtech.php