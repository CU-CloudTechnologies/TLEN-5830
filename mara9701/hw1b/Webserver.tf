#Deploy an apache web server

#Webserver Setup File
data "template_file" "web_setup"{
  template = "${file("websetup.tpl")}"
}


resource "aws_instance" "ws"{
	ami = "${var.ami}"
	instance_type = "t2.micro"
	key_name = "${aws_key_pair.default.id}"
	subnet_id = "${aws_subnet.public_subnet.id}"
	vpc_security_group_ids = ["${aws_security_group.Webserver.id}"]
	associate_public_ip_address = true
	#availability_zone = "${var.az_2}"
	
	#Setup the webserver using the file
	user_data = "${data.template_file.web_setup.rendered}"
		
	#Dynamically configure multiple web servers
	count = "${var.count}"
	
	connection {
		key_file = "${var.key_path}"
	}
	
	tags {
    Name = "webserver"
	}
}


#Load Balancer
 resource "aws_elb" "web_lb" {
   name            		= "WebLB"	
   security_groups 	= ["${aws_security_group.lb.id}"]
   #availability_zones = ["us-west-1b", "us-west-1c"]
   subnets              =  ["${aws_subnet.public_subnet.id}"]
   instances 		    = ["${aws_instance.ws.*.id}"]
 
   listener {
     instance_port     = 8000
     instance_protocol = "http"
     lb_port           = 80
     lb_protocol       = "http"
   }
     
   health_check {
     healthy_threshold   = 2
     unhealthy_threshold = 10
     interval            = 5
     target              = "HTTP:8000/"
     timeout             = 3
 }
    
   tags {
    Name = "Web Server Load Balancer"
   }
 }



