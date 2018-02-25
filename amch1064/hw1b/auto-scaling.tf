resource "aws_launch_configuration" "webcluster" {
  image_id= "${var.ami}"
  name_prefix = "websrv-"
  instance_type = "t2.micro"
  security_groups = ["${aws_security_group.web-dmz.id}"]
  key_name = "${var.key_name}"
  associate_public_ip_address = true
  user_data = "${data.template_file.user_data_shell.rendered}"

  lifecycle {
    create_before_destroy = true
    }
}

data "template_file" "user_data_shell" {
  template = "${file("files/user_data.tpl")}"
  vars {
    s3_bucket = "${aws_s3_bucket.lab1-cloud-tech.bucket_domain_name}",
    db_server = "${aws_db_instance.dbsrv-01.address}",
    db_table_file = "/tmp/table.sql"
  }
}

data "aws_availability_zones" "allzones" {}

resource "aws_autoscaling_group" "scalegroup" {

    name = "${aws_launch_configuration.webcluster.name}"

    max_size = "3"
    min_size = "2"
    wait_for_elb_capacity = 2
    desired_capacity = 2

    health_check_grace_period = 300
    health_check_type = "ELB"
    vpc_zone_identifier = ["${aws_subnet.lab1-public.id}"]
    load_balancers= ["${aws_elb.web.id}"]
    enabled_metrics = ["GroupMinSize", "GroupMaxSize", "GroupDesiredCapacity", "GroupInServiceInstances", "GroupTotalInstances"]
    force_delete = true
    launch_configuration = "${aws_launch_configuration.webcluster.name}"
    lifecycle { create_before_destroy = true }
    tag {
        key = "Name"
        value = "Web Server Instance"
        propagate_at_launch = true
    }
}

resource "aws_autoscaling_policy" "autopolicy" {
name = "terraform-autoplicy"
scaling_adjustment = 1
adjustment_type = "ChangeInCapacity"
cooldown = 300
autoscaling_group_name = "${aws_autoscaling_group.scalegroup.name}"
}

resource "aws_cloudwatch_metric_alarm" "cpualarm" {
alarm_name = "terraform-alarm"
comparison_operator = "GreaterThanOrEqualToThreshold"
evaluation_periods = "2"
metric_name = "CPUUtilization"
namespace = "AWS/EC2"
period = "120"
statistic = "Average"
threshold = "60"

dimensions {
AutoScalingGroupName = "${aws_autoscaling_group.scalegroup.name}"
}

alarm_description = "This metric monitor EC2 instance cpu utilization"
alarm_actions = ["${aws_autoscaling_policy.autopolicy.arn}"]
}

#
resource "aws_autoscaling_policy" "autopolicy-down" {
name = "terraform-autoplicy-down"
scaling_adjustment = -1
adjustment_type = "ChangeInCapacity"
cooldown = 300
autoscaling_group_name = "${aws_autoscaling_group.scalegroup.name}"
}

resource "aws_cloudwatch_metric_alarm" "cpualarm-down" {
alarm_name = "terraform-alarm-down"
comparison_operator = "LessThanOrEqualToThreshold"
evaluation_periods = "2"
metric_name = "CPUUtilization"
namespace = "AWS/EC2"
period = "120"
statistic = "Average"
threshold = "10"

dimensions {
AutoScalingGroupName = "${aws_autoscaling_group.scalegroup.name}"
}

alarm_description = "This metric monitor EC2 instance cpu utilization"
alarm_actions = ["${aws_autoscaling_policy.autopolicy-down.arn}"]
}
