output "db01_address" {
  value = "${aws_db_instance.dbsrv-01.address}"
}

output "ELB_dns_name" {
  value = "${aws_elb.web.dns_name}"
}