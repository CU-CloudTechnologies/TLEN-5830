# Lab on building a simple web app in AWS using Terraform

These set of terraform scripts will deploy a web server and a database server.
1. The WebServer is publicly accessible via the internet.
2. The DataBase server is only accessible on private network connected to the web server

Pointing your browser to ELB/lab1.php will connect you to one of the WebServer where the php script will query the DB and display the output on the screen.

## Terraform Components

### variables.tf

Our variables file contain all the pre-defined varilables for the infrastructure. It contains the public/private subnets and the availability zone for our instances. 

We do not store AWS Access Keys in the variables file but use environment variables to get this information.

```
export AWS_ACCESS_KEY_ID="xxxxxx"
export AWS_SECRET_ACCESS_KEY="xxxx"
```

### main.tf


## Instructions on how to run

### Export AWS Keys to ENV variables:
    export AWS_ACCESS_KEY_ID=xxxxxx
    export AWS_SECRET_ACCESS_KEY=xxxx

### User Packer to create AMI:

    Create Apache AMI **(takes couple of minutes):**
```
    packer validate packer/aws/web-apache-server.json
    packer build packer/aws/web-apache-server.json
```

    Create Nginx AMI ***(takes couple of minutes):***
```
    packer validate packer/aws/web-nginx-server.json
    packer build packer/aws/web-nginx-server.json 
```
**Note the AMI ID returned**

### User terraform to deploy the servers (web + db):
```
    export AMI="xxxxxx"
    terraform init
    terraform plan \
    -var "aws_access_key=${AWS_ACCESS_KEY_ID}" \
    -var "aws_secret_key=${AWS_SECRET_ACCESS_KEY}" \
    -var "ami=${AMI}" \
    -var "key_name=xxxxxx"
```
```
    terraform apply \
    -var "aws_access_key=${AWS_ACCESS_KEY_ID}" \
    -var "aws_secret_key=${AWS_SECRET_ACCESS_KEY}" \
    -var "ami=${AMI}" \
    -var "key_name=xxxxxx"
```
**Note the ELB_dns_name returned**

**Access the php page with (takes couple of minutes):**
        http://ELB_dns_name/lab1.php

### To deploy Nginx inplace of Apache or vice versa:
**Export the new AMI ID noted from step 2 to ENV variable:**
```
    export AMI="xxxxxx"
    terraform plan \
    -var "aws_access_key=${AWS_ACCESS_KEY_ID}" \
    -var "aws_secret_key=${AWS_SECRET_ACCESS_KEY}" \
    -var "ami=${AMI}" \
    -var "key_name=xxxxxx"

```
```
    terraform apply \
    -var "aws_access_key=${AWS_ACCESS_KEY_ID}" \
    -var "aws_secret_key=${AWS_SECRET_ACCESS_KEY}" \
    -var "ami=${AMI}" \
    -var "key_name=xxxxxx"
```
**Note the ELB_dns_name returned**

**Access the php page with (takes couple of minutes):**  
        http://ELB_dns_name/lab1.php
