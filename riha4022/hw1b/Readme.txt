Description:

1. Automates the creation of a two tier topology consisting of webservers and a database server in the backend.
2. Dynamic creation of webservers on applying the terraform script.
3. Public facing load balancer which scales the addtion of webservers in the network.



USAGE:

1. Add the secret key and the access key in the file terraform.tfvars.
2. Download the private key and add the relative/absolute path of the downloaded key in the file terraform.tfvars
3. terraform plan -var-file=terraform.tfvars
4. terraform apply -var-file=terraform.tfvars
	
		a. Enter the number of webserver you want in the network
		b. Type 'yes' for terraform to apply the script
		c. At the end of application of the script, terraform will print out the public dns name of the webservers along with the load balancer
		d. Copy paste the link in the browser of choice and add /myhomepage.php to the end. 
		
5. Name of the page => <PUBLIC_DNS_OF_LOAD_BALANCER>/myhomepage.php 