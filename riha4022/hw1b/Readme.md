# Using Terraform to deploy AWS resources
## Learning a basic 2-tier architecture of  public webservers behinf a load balancer and a private db server.

### Description:

1. Automates the creation of a two tier topology consisting of webservers and a database server in the backend.
2. Dynamic creation of webservers on applying the terraform script.
3. Public facing load balancer which scales the addtion of webservers in the network.


### Pre-requisites
1. Edit the variables.tf file to enter the default value of the name of the KEY pair you have configured on your AWS accout
```
variable "key_pair"{
	default = "xxxx"
}
```

2. Add the secret key and the access key in the file terraform.tfvars or you can export the enviroment variables
```
export aws_access_key="xxxxxxxxxxxxxxxxxxxxx"
export aws_secret_key="xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
```
###### Or change the terraform.tfvars

```
aws_access_key = "xxxxx"
aws_secret_key = "xxxxx"
```

3. Also configure the path to the file where the private key is stored (.pem extension) in the terraform.tfvars. It can be an absoulte or relative path.
```
private_key_path = "xxxx"
```
### USAGE:
Run the following commands after doing the pre-requisites.
```
terraform init
terraform plan -var-file=terraform.tfvars
terraform apply -var-file=terraform.tfvars
```

* Enter the number of webserver you want in the network when prompted
* Type 'yes' for terraform to apply the script
* At the end of application of the script, terraform will print out the public dns name of the webservers along with the load balancer
* Copy paste the link in the browser of choice and add /myhomepage.php to the end. 

### How to Access the webpage
Type the following in the URL:
```
<PUBLIC_DNS_OF_LOAD_BALANCER>/myhomepage.php 
```
It generally takes around 10 seconds for the load balancer to be fully functional with this script. Till that time you can access the individual webservers directly. 

```
<PUBLIC_DNS_OF_WEBSERVER>/myhomepage.php
```
