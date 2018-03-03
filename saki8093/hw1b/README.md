s project involves automating the deployment of a php web server and a MySQL database server on AWS using terraform. 

This includes 7 files.

The "cloudtech.php" file contains the php web server code that connects to the database, retrives information, and then displays it.

The "dbserver.tf" file contains security groups information about the database instance, as well as information related to ami,availability zone etc. 

The "webserver.tf" file contains security groups information about the webserver instance, as well as information related to ami,availability zonetc.

The "dbserver.tpl" is a setup file which is used to configure the database server upon launch. It installs mysql-server, configures it, creates aa table, and then starts the sevice.

The "webserver.tpl" is a setup file which is used to configure the web server upon launch. It installs the apache server, php server, apache2-utils, and then has the web server connect to the databaser server.

THe "network.tf" defines the vpc, the internet gateway, the public (front end) subnet(where the web server is placed) , and the private (backend)where the private server is placed.

The "variables.tf" defines all the variables that are used across the automation script.

The access key id, the access secret access key, and the default region are set up as enviormental variables. 

To initiate the build, execute the following commands in the directory where the terraform files are present.
	"terraform init"
	"terraform plan"
	"terraform apply"

Note: we hardcode the private IP address of the database server to 172.28.3.100 because we need a known IP address to connect to the database from the web server.


From more information contact saki8093@colorado.edu

