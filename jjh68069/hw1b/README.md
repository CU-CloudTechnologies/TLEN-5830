# Two Tier Terraform Web Application

## Running the code
You will need the following environment variables set.
```bash
export AWS_ACCESS_KEY_ID="AK******************"
export AWS_SECRET_ACCESS_KEY="NAAWdG+Rpu************************"
export AWS_DEFAULT_REGION="us-east-1"
```
With terraform downloaded, run these commands from inside the directory where all the .tf files live:
``` bash
terraform init
terraform plan
terraform apply
terraform destroy
```
The destroy command tears down all the infrastructure you just built so that you don't get charged for anything!

## Tips

I had trouble running terraform with AWS credentials in a .aws file, so I have been using the following work-around.

To read in your AWS credentials prior to running this project:

Write AWS credentials into a text file. Make sure to apply protections as you would to any
ssh file (chmod 660):
```bash
vim creds.txt
```
Enter your AWS credentials in the following format (replace your credentials for the spaceholders):
```bash
[default]
aws_access_key_id AK******************
aws_secret_access_key = NAAWdG+Rpu************************
```
Write a script to read in the credentials called setup.sh:
```bash
#!/bin/bash

KEY_ID="$(cat creds | awk 'FNR == 2 {print $2}')"
SECRET="$(cat creds | awk 'FNR == 3 {print $3}')"

export AWS_ACCESS_KEY_ID="$KEY_ID"
export AWS_SECRET_ACCESS_KEY="$SECRET"
export AWS_DEFAULT_REGION="us-east-1"
```
Run the script (use source so that the exported environment variables apply to your current shell instead of a child shell):
```bash
chmod u+x setup.sh
source setup.sh
```


