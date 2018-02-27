
variable "cidr" {
    default = "172.28.0.0/16"
}

variable "Public_subnet" {
  default = "172.28.0.0/24"
}

variable "Private_subnet" {
  default = "172.28.3.0/24"
}

variable "DnsZoneName" {
  default = "ip-172-28-3-50.us-west-2.compute.internal"
}

