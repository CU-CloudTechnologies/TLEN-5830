/* This block defines the configuration for webserver instances that are brought up by the autoscaling group. */

resource "aws_launch_configuration" "webserver" {
  image_id = "${var.ami_id}"
  instance_type = "t2.micro"
  security_groups = ["${aws_security_group.webserver.id}"]
  user_data = "${data.template_file.web_setup.rendered}"
  
  lifecycle {
    create_before_destroy = true
  }
}

/* This block defines the policy for creation of webservers through an autoscaling group. We have defined min and max values for the number of machines in the group and assigned a load balancer. */

resource "aws_autoscaling_group" "webserver" {
  launch_configuration = "${aws_launch_configuration.webserver.id}"
  availability_zones = ["${data.aws_availability_zones.all.names}"]
  load_balancers = ["${aws_elb.balancer.name}"]
  health_check_type = "ELB"

  min_size = 2
  max_size = 3

  tag {
    key = "Name"
    value = "webserver"
    propagate_at_launch = true
  }
}


/* This block defines the template file to set up the instances on execution. */

data "template_file" "web_setup"{
  template = "${file("webserver.tpl")}"
}

data "aws_availability_zones" "all" {}

/* This block defines the configuration for the webserver load-balancer.  It defines a health check policy and places
instances across all AZs within the region. */

resource "aws_elb" "balancer" {
  name = "webserver-load-balancer"
  security_groups = ["${aws_security_group.elb.id}"]
  availability_zones = ["${data.aws_availability_zones.all.names}"]


  health_check {
    healthy_threshold = 2
    unhealthy_threshold = 2
    timeout = 3
    interval = 30
    target = "HTTP:${var.server_port}/"
  }

  listener {
    lb_port = 80
    lb_protocol = "http"
    instance_port = "${var.server_port}"
    instance_protocol = "http"
  }
}

/* ELB security group policy. Allow traffic to/from anywhere towards
ELB. */

resource "aws_security_group" "elb" {
  name = "terraform-example-elb"

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

/* More restrictive security group policy for the webservers behind the ELB. Only allow traffic from the non-default listening port of the webserver in. */

resource "aws_security_group" "webserver" {
  name = "ws-security"

  ingress {
    from_port = "${var.server_port}"
    to_port = "${var.server_port}"
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  lifecycle {
    create_before_destroy = true
  }
}