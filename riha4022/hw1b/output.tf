#Prints the output of the configured public dns of nginx webserver
 output "aws_instance_public_dns" {
    value = ["${aws_instance.nginx.*.public_dns}"]
 }

#Prints the output of the configured dns of dbserver
 output "aws_DB_instance_public_dns" {
    value = "${aws_db_instance.default.address}"
 }

#Prints the output of the configured public dns of the load balancer. This DNS will be used for load balancing between the different webservers
 output "aws_elb_public_dns" {
    value = "${aws_elb.default.dns_name}"
 }
 
