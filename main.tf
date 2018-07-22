provider "aws" {
  region = "us-east-1"
}

resource "aws_vpc" "myvpc" {
  cidr_block = "10.0.0.0/16"
  enable_dns_hostnames = true
}

resource "aws_subnet" "mysub" {
  vpc_id = "${aws_vpc.myvpc.id}"
  cidr_block = "10.0.1.0/24"
  
}

resource "aws_internet_gateway" "myigw" {
  vpc_id = "${aws_vpc.myvpc.id}"
  
}

resource "aws_route_table" "myroutetable" {
  vpc_id = "${aws_vpc.myvpc.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.myigw.id}"
  }
}

resource "aws_route_table_association" "myroutetableassoc" {
  subnet_id = "${aws_subnet.mysub.id}"
  route_table_id = "${aws_route_table.myroutetable.id}"
}

resource "aws_security_group" "mysg" {
  name = "mysecuritygroup"
  description = "Allow incoming HTTP connections & SSH access"

  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 443
    to_port = 443
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = -1
    to_port = -1
    protocol = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks =  ["0.0.0.0/0"]
  }
  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }

  vpc_id="${aws_vpc.myvpc.id}"

}

resource "aws_key_pair" "default" {
  key_name = "fashioncloud"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCpbiMxhdlKU97bfr6T8FhHbhyf96aM/2AN862rgrkP1Yemu1bxfYUWFQyw+zAQNVHOywswLoP6a76TQ5mPKlNdDWJT99ZEFIeolHzTCBJNl6t9Gq33aqfii2/a2ClE//cTfxD/pFphZoZ9/4RsQdbmN8jfqyxQ//+YU2TLOcT3dBDNBvzq5tZROMes/HlSpacEODpaGWgZ1l/cH69txrrpHs0bnei1SdmzD4tlvTZ0r5g5P+UnarGjERe5eJpzRyQMwhmq71TFbz2tGTuVl2VTqfwUeTkUUeC1uf5myiVN+EriHZmu85bwXUMK5I5xJ/fAIFvtg86zA+7mJA6UFyvL"
}


resource "aws_instance" "myapp" {
   ami  = "ami-cfe4b2b0"
   instance_type = "t2.micro"
   key_name = "${aws_key_pair.default.id}"
   subnet_id = "${aws_subnet.mysub.id}"
   vpc_security_group_ids = ["${aws_security_group.mysg.id}"]
   associate_public_ip_address = true
   source_dest_check = false
   user_data = "${file("userdata.sh")}"

  tags {
    Name = "webserver"
  }
}







