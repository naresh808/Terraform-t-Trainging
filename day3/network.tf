#create vpc in us-east-1
resource "aws_vpc" "vpc_master" {
 cidr_block = "10.0.0.0/16"
 tags = {
   Nmae = "${terraform.workspace}-vpc"
 }
}


# Get all availble AZ's in vpc for master region

data "aws_availability_zones" "azs" {
 state = "available"
}

#create subnet #1 in us-eat-1

resource "aws_subnet" "subnet" {
 availability_zone = element(data.aws_availability_zones.azs.names, 0)
 vpc_id            = aws_vpc.vpc_master.id
 cidr_block        = "10.0.1.0/24"

 tags = {
    Nmae = "$(terarform.workspace)-subnet"
 }
}

#create SG for allowing TCP/22 from anywhere
resource "aws_security_group" "sg" {
 name                 = "${terraform.workspace}-sg"
 description          =  "Allow TCP/22"
 vpc_id               = aws_vpc.vpc_master.id
 ingress {
   description = "Allow 22 from anywhere from our public ip"
   from_port    = 22
   to_port      = 22
   protocol     = "tcp"
   cidr_blocks  = ["0.0.0.0/0"]
}
egress {
 from_port    = 0
 to_port      = 0
 protocol     = "-1"
 cidr_blocks = ["0.0.0.0/0"]
}
 tags = {
  Name = "$(terraform.workspace)-securitygroup"
 }
}
