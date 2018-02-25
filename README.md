# Simple infrastructure in AWS using Terraform

This script deploys a simple architecture on AWS which consists of a webserver and a database server. The script intends to perform automated deployment of this simple architecture where in the webserver is the publicly accessible front-end and the DB server is accessible by the webserver via a private subnet. 
Once the infrastructure is created, the user should be able to access the DB server using the public IP of the webserver instance. When the user tries to access <publicIP>/cloudtech.php, the webserver should quesry the DB server and display the desired output.

## Variables.tf

This file consists of all the variables that the script may need to access to run successfully. Ex: Region, AMI, public and private subnets, etc.
The variable file does not contain the access key and the secret key for the AWS account. 
In order for it to run successfully, the user would need to use environment variables instead. Please edit your .bashrc/.zshrc files and export the keys.
Please refer to the below example:
```bash
export AWS_ACCESS_KEY_ID="xxxxxxxxxxxxxxxxxxxxx"
export AWS_SECRET_ACCESS_KEY="xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
export AWS_DEFAULT_REGION="us-east-1"
```

## Other files

Below is the overview of each of the modules used.


### network.tf
The provider aws is setup by taking input environment variables which is the access and secret keys and the default region used in AWS.
This file contains all of the network configurations. It creates a VPC with an internet gateway attached to it. It also has an ANY-ANY ACL which has no access restrictions. 

We then create 2 routing tables, one each for a private and public subnets. In order to access the internet to install services on the servers, the script creates a NAT gateway which uses a public subnet and assigns an Elastic IP to the same. 

It also sets up DNS to resolve the private IP of the DB server to its server name, which in turn is used by the webserver to establish a PHP connection to.This is not really required. The script would have worked without it too by just referencing the private IP in the PHP script directly.

### Security.tf

There are 2 security groups, webserver and database, which have both inbound and outbound rules that can allow and limit type of traffic depending on user requirements. 
Right now, all traffic is allowed for troubleshooting purposes, but was initially limited to MYSQL port, HTTP traffic and SSH only. 

### dbinstance.tf

creates the AWS instance which takes the variables for AMI and instance type from variables.tf.
The script uses HEREDOC to install and start MYSQL services on the instance. 
It also creates a user account with a username and password and assigns all privileges to it. 
It also creates a simple database which can now be queried by the webserver. 

### webinstance.tf

creates the AWS instance which takes the variables for AMI and instance type from variables.tf.
The script uses HEREDOC to install and start Apache and PHP services on the instance. 
It also creates a PHP script named cloudtech.php which queries the database created in the previous instance.

###How to run it:
THe user first needs to set the environment variable for AWS keys as mentioned above and the pem file for SSH access if needed. 
Below are the most basic form of commands to run the scripts:

```bash
terraform init
terraform plan 
terraform apply 
```
Once this is done, the user can take the public IP from the AWS instance and try to access <publicIP>/cloudtech.php in the browser.
