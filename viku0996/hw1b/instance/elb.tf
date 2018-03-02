data "aws_availability_zones" "available" {}

#Create a load balancer and link to the autoscaling group
resource "aws_elb" "web" {
  name = "load-balancers"
  subnets         = ["${var.public-subnet}", "${var.private-subnet}"]
  security_groups = ["${var.security-group-webserver}"]
  instances       = ["${aws_instance.webserver.*.id}"]
  cross_zone_load_balancing   = true
  idle_timeout                = 400
  connection_draining         = true
  connection_draining_timeout = 400
#  instances       = "${aws_instances.instances.ids}"
#  availability_zones = ["${data.aws_availability_zones.available.names}"]
  tags {
    name = "elb"
  }
  listener {
    instance_port     = 80
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }
  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    target              = "HTTP:80/"
    interval            = 30
  }
}


output "elb" {
  value = "${aws_elb.web.name}"
}