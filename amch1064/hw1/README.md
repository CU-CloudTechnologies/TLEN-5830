# Lab on building a simple web app in AWS using Terraform

These set of terraform scripts will deploy a web server and a database server.
1. The WebServer is publicly accessible via the internet.
2. The DataBase server is only accessible on private network connected to the web server

Pointing your browser to ELB/lab1.php will connect you to one of the WebServer where the php script will query the DB and display the output on the screen.

## Use of Packer

We will use packer tool to create custom AMI from the base Amazon Linux Image.
Packer will create two AMI images:
1. Apache web server image
2. Nginx web server image

These AMIs are used to replace current web server with a new server.
For example, If we are currently running two **Apache servers**, we can replace them with **Nginx Servers.** 
Creating AMI is important for seamless as AWS launch configuration will first spin up new instances and then start draining connections from the old servers that need to be deleted.

## Terraform Components

### variables.tf

Our variables file contain all the pre-defined varilables for the infrastructure. It contains the public/private subnets and the availability zone for our instances. 

We do not store AWS Access Keys in the variables file but use environment variables to get this information.

```
export AWS_ACCESS_KEY_ID="xxxxxx"
export AWS_SECRET_ACCESS_KEY="xxxx"
```

### main.tf


# Instructions on how to run

### Export AWS Keys to ENV variables:
```
export AWS_ACCESS_KEY_ID=xxxxxx
export AWS_SECRET_ACCESS_KEY=xxxx
```
### Packer to create AMI:

#### Create Apache AMI **(takes couple of minutes):**
```
packer validate packer/aws/web-apache-server.json
packer build packer/aws/web-apache-server.json
```

**export the AMI ID noted in above step**
```
export AMI_APACHE="xxxxxx"
```

#### Create Nginx AMI **(takes couple of minutes):**
```
packer validate packer/aws/web-nginx-server.json
packer build packer/aws/web-nginx-server.json 
```
**export the AMI ID returned**  

![Alt text](TLEN-5830/amch1064/hw1/documentation/packer_ami_id.png)

```
export AMI_NGINX="xxxxxx"
```

### Use Terraform to deploy the servers (web + db):
**export the key name used to ssh to the server**
```
export KEY_NAME="xxxxxx"
```

```
terraform init

terraform plan \
-var "aws_access_key=${AWS_ACCESS_KEY_ID}" \
-var "aws_secret_key=${AWS_SECRET_ACCESS_KEY}" \
-var "ami=${AMI_APACHE}" \
-var "key_name=${KEY_NAME}"
```
```
terraform apply \
-var "aws_access_key=${AWS_ACCESS_KEY_ID}" \
-var "aws_secret_key=${AWS_SECRET_ACCESS_KEY}" \
-var "ami=${AMI_APACHE}" \
-var "key_name=${KEY_NAME}"
```
*Note the ELB_dns_name returned*  
**Access the php page (takes couple of minutes):**  
    http://ELB_dns_name/lab1.php

## Replace all Apache Servers with Nginx
**export the key name used to ssh to the server**
```
export KEY_NAME="xxxxxx"
```

```
terraform plan \
-var "aws_access_key=${AWS_ACCESS_KEY_ID}" \
-var "aws_secret_key=${AWS_SECRET_ACCESS_KEY}" \
-var "ami=${AMI_NGINX}" \
-var "key_name=${KEY_NAME}"
```
```
terraform apply \
-var "aws_access_key=${AWS_ACCESS_KEY_ID}" \
-var "aws_secret_key=${AWS_SECRET_ACCESS_KEY}" \
-var "ami=${AMI_NGINX}" \
-var "key_name=${KEY_NAME}"
```
*Note the ELB_dns_name returned*  
**Access the php page with (takes couple of minutes):**  
    http://ELB_dns_name/lab1.php
