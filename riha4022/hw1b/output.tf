output "aws_instance_public_dns" {
    value = ["${aws_instance.nginx.*.public_dns}"]
 }

 output "aws_DB_instance_public_dns" {
    value = "${aws_db_instance.default.address}"
 }
 
 output "aws_elb_public_dns" {
    value = "${aws_elb.default.dns_name}"
 }
 
