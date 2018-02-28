This script is used to orchestrate a network consisting of Webserver(s) and a Database server in an AWS environment. The webserver(s) has a public IP for intenet connectivity and the sql server accesses the internet via a nat gateway. The number of webservers can be manipulated via the count variable in the webservers.tf file. As soon as the servers are online, they will sleep for 2 minutes until all the services are up and running. 

Explanation of various modules:

network.tf - This file is used to orchestrate the Amazon Virtual Private Circuit(VPC), internet gateway, ACLs, the private and the public subnets, route-tables, elastic IP for NAT, NAT gateways and route-table associations between subnets and route tables. 

variables.tf - This file is used to describe all variables required for the orchestration of the environment. These are mainly the CIDRs for the public and the private subnets and the default DNS zonename of the database server used for connections with the webserver(s).

webserver.tf and sqlserver.tf - These files are used to orchestrate the webserver(s) and the sqlserver. They describe the security groups, instance types, subnets etc.

webserver.tpl and sqlserver.tpl - These files are shell scripts that will run on the servers once they are alive. They are mainly used to install the services, manipulate their configurations and start the services.

IMPORTANT: How to run?

Ensure that the all important access keys for your account are added to your environment before running these scripts. 

export AWS_ACCESS_KEY_ID="xxxxxxxxxxxxxxxxxxxxx"
export AWS_SECRET_ACCESS_KEY="xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
export AWS_DEFAULT_REGION="us-west-2"

Add the provider as AWS and the region in one of the files. Post that, run the following commands to initialize terraform, create a plan from these files and apply them to your environment.

terraform init
terraform plan -out=terraform.plan
terraform apply "terraform.plan"

If everything goes smoothly, you will see the servers running in your AWS account. After waiting for a couple of minutes for the services to start running, retrieve the public IP of the webserver(s) and enter it into the browser. You will see a default webpage saying "You have reached Atharva's webserver. Create here to retrieve value from DB." If you create on the link, you will see the retreived value from the Database saying "Hello Cloud Technologies"
