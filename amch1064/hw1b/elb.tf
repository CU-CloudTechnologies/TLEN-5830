##### AWS SLB #####
resource "aws_elb" "web" {
  name = "cloud-tech-lab1-elb"
  subnets         = ["${aws_subnet.lab1-public.id}"]
  security_groups = ["${aws_security_group.web-dmz.id}"]
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
    target              = "TCP:80"
    interval            = 30
  }

  cross_zone_load_balancing = true
  idle_timeout = 60
  connection_draining = true
  connection_draining_timeout = 120
}