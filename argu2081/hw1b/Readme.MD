How to Run:
cd /hw1b/source_info
ssh-keygen -t rsa -C "login_key" -f ./login_key
----> Enter a passphrase
export AWS_ACCESS_KEY_ID="myaccesskey"
export AWS_SECRET_ACCESS_KEY="mysecretkey"
terraform init
terraform get
terraform plan
terraform apply

'''
OUTPUT = dns name of the load balancer.
Use the browser to go to the webservers. This should show the default page of the apache server. Change the url to
<dns_name>/cloudtech.php

If this does not load instantaneously please allow some time between 1 to 3 mins for the ec2 instances to come up.
'''

Finally: Terraform destroy

Note:
Default values of the webserver and the database are located under /modules/web/variables.tf
