Terraform - AWS
Configure Webserver and Database on AWS with autoscaling behind a Load Balancer

Description:
The terraform script will create two EC2 instances and an RDS instance. The EC2 instances are assigned a public IP. An ELB is created and initialized with the EC2 instances. An autoscaling group will monitor the healthcheck of ELB and create a minimum of two EC2 instances and a maximum of five.
Nginx is installed and configured with php and mysql on all EC2 instances. A php file ibuiltthis.php is created on all instances. RDS is initialized with a database called "mydb" and a table - "teams" is populated with values.

Usage:
1. In the root directory, add the terraform.pem private key for the EC2 instances.
2. Enter the access key and secret key for AWS account in the variables.tf file in the root directory.
3. Enter the key-name in variables.tf to create the EC2 instances.
4. Run by running the below command:
	terraform apply
5. Access the following URL to confirm:
	http://{load_balancer_dns/ec2_dns}/ibuiltthis.php