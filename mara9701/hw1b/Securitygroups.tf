/*
Security Groups 
*/

#Webserver
resource "aws_security_group" "Webserver" {
  name = "Webserver"
  description = "Allow HTTP, HTTPS, SSH, ICMP connections from any IP, Block the rest"
  tags {
        Name = "Webserver"
  }
  
  vpc_id = "${aws_vpc.main.id}"

  #Incoming Rules
  #HTTP
  ingress {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
  }
  
  #HTTPS
  ingress {
    from_port = 443
    to_port = 443
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  #ICMP
  ingress {
        from_port = 0
        to_port = 0
        protocol = "icmp"
        cidr_blocks = ["0.0.0.0/0"]
    }
  
  #SSH 
  ingress {
    from_port   = "22"
    to_port     = "22"
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  #Allow all traffic to anywhere
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


#Database Rules
resource "aws_security_group" "Database" {
  name = "Database"
  description = "Allow only mysql and SSH connections from the public subnet"
  tags {
        Name = "Database"
  }
  description = "Allow traffic from only public subnet"
  vpc_id = "${aws_vpc.main.id}"
 
/* 
  ingress {
	#Allow connections only from the public subnet, SSH
      from_port = 3306 #MySQL
      to_port = 3306
      protocol = "TCP"
	  cidr_blocks = ["${var.Subnet-Public_cidr}"]
  }
  ingress {
      from_port   = "22"
      to_port     = "22"
      protocol    = "TCP"
      cidr_blocks = ["${var.Subnet-Public_cidr}"]
  }
  
  ingress {
      from_port   = -1
      to_port     = -1
      protocol    = 0
      cidr_blocks = ["${var.Subnet-Public_cidr}"]
  } 
 */
 
  #Allow all traffic from public subnet
   ingress {
      from_port = 0
      to_port = 0
      protocol = -1
	  cidr_blocks = ["${var.Subnet-Public_cidr}"]
  }
  
     ingress {
      from_port = 0
      to_port = 0
      protocol = -1
	  cidr_blocks = ["${var.Subnet-Private_cidr1}"]
  }
  
   
  #Allow all Traffic
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
	cidr_blocks = ["0.0.0.0/0"]
  }
}


#Load Balancer Rules
resource "aws_security_group" "lb" {
  name = "LoadBalancer"
  vpc_id = "${aws_vpc.main.id}"
  description = "Allow HTTP connections from everywhere"
  tags {
        Name = "Load Balancer"
  }
  
  vpc_id = "${aws_vpc.main.id}"
 
  ingress {
	from_port = 0
    to_port = 80
    protocol = "tcp"
	cidr_blocks = ["0.0.0.0/0"]
  }
  
  egress {
	from_port = 0
    to_port = 0
    protocol = "-1"
	cidr_blocks = ["0.0.0.0/0"]
  
  
  }
}
