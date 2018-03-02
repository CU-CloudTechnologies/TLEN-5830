# Example of building a simple web application in AWS using Terraform

This set of Terraform scripts deploys a simple 2 instance web application
deployment.  The goal is to have an automated deployment of a simple
application that includes:
1. A web front end publicly accessible
2. A relational DB backend accessed by the frontend app via private IP

Pointing your browser to the <public DNS address>/cloudtech.php of the
Web Server, should result in a query to the mysql DB and a display of
the query result in your browser.

## Variables
Our vars.tf file has almost everything we need here.  The defaults include
things like CIDR Blocks for the public and private IP ranges, as well as
the image type (default is Debian) and instance size (t2.micro).

The variables also allow you to easily modify things like AZ's, keyfiles etc.

NOTE:  We do NOT put our AWS Access Keys in the vars file!!  Instead we have
the following set as environment variables to ensure we don't inadvertently 
upload our valuable keys to github :)

For example, it's sometimes handy to put a few things in your .bashrc (or
.zshrc) file:

```bash
export AWS_ACCESS_KEY_ID="xxxxxxxxxxxxxxxxxxxxx"
export AWS_SECRET_ACCESS_KEY="xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
export AWS_DEFAULT_REGION="us-east-1"
```

## Cloud Init
This example uses Cloud Init to do things like install/initialize our Data
Base, and Apache server.  We have a dbsetup.tpl file for the database 
install and config, and a websetup.tpl file for the web sever setup and
config.  NOTE that we use these Cloud Init files because they run at boot
up, and they include root access.

One downside here that can/should be improved upon; we don't have a good
way of reading in the private IP address of the database server from our
cloud-init file.  So we're hard-coding that to match the entry in our vars
file.  Ideally we'd add some logic to this to make the init routine 
dynamically set this variable, but for now; note that if you change the 
default db_server_private_ip setting, you'll need to change the webserver.tf
file as well.

### network.tf
As you would guess this contains our Network settings.  We create a VPC
and our public/private subnets here and reference them when building our
Instances.

### dbserver.tf
And of course our tf file for deploying a DataBase server.
We keep access fairly restricted to the DataBase server and
ideally want to have it accessible ONLY via private IP address.

### webserver.tf
Finally our web server; very similar to the database server in
it's setup, but we want to make sure we set our security group
here to be a bit more permissive.

### Running it
Make sure you set your env variables for your AWS Access Keys (mentioned
above), modify the vars file to update the ssh keys at a minimum and 
run:

```bash
terraform init
terraform plan -out=terraform.plan
terraform apply "terraform.plan"
```

After this, obtain the public DNS name of the Web Server Instance from
the Terraform output (or your EC2 Console) and point your browser to:
  <web-server-dns-name>/cloudtech.php

