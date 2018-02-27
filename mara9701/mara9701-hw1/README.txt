_____________________________________________________________________________________________________________________________________________
Building a WebServer and a MYSQL database on AWS using TERRAFORM
_____________________________________________________________________________________________________________________________________________

This project includes a set of Terraform scripts to automate the deployment of an application. The various features of the application include:

1. A front end web server
2. A backend private database deployed using AWS Relational Database Service that is accessed using the Frontend webserver. 
3. Implements scalability in terms of WebServer Deployment
4. Load Balancing between the Servers
5. Also includes a script to convert to an nginx webserver from an apache webserver.

_____________________________________________________________________________________________________________________________________________
The various scripts included in the application are as follows:
_____________________________________________________________________________________________________________________________________________

1. Variables: Includes all the variables used throughout the program. Some of the variables include VPC CIDR, Private CIDR, Public CIDR, AMI version,
   Availability zones, count to scale the number of servers, etc.

NOTE: Do NOT put AWS Access Keys in the variables file. Instead set them as environment variables.

For example, run a script with the following entries or you can add it in the .bashrc file 

export AWS_ACCESS_KEY_ID="xxxxxxxxxxxxxxxxxxxxx"
export AWS_SECRET_ACCESS_KEY="xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
export AWS_DEFAULT_REGION="us-east-1"

2. Subnets: Defines one public subnet and 2 private subnet for the rds to achieve high availability

3. Networks: Create a VPC and associate the private and public subnets with the VPC. Also populate the routing table with a default gateway

4. Security Groups: Defines the ACL rules for the webserver, database server and for the load balancer.

5. Webserver: Deploy an apache webserver. Make the necessary configurations to query from a database. It is deployed using the websetup.tpl script.

6. Database: Deploy a mysql database server. Only queries from the webserver are allowed. The database is deployed using the dbsetup.tpl script.

_____________________________________________________________________________________________________________________________________________
Init Scripts:
_____________________________________________________________________________________________________________________________________________
CloudInit scripts are used to initialize the Database server and the Webserver. There are two files:
1. dbsetup.tpl: Used to setup and configure the database server
2. websetup.tpl: Used to setup and configure the webserver

_____________________________________________________________________________________________________________________________________________
How to Use the Scripts:
_____________________________________________________________________________________________________________________________________________
terraform init
terraform plan -out=terraform.plan
terraform apply "terraform.plan"
_____________________________________________________________________________________________________________________________________________



