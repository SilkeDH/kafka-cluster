terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.2.0"
}

provider "aws" {
  region  = var.region
}

// 7 Instances following cp-ansible 
resource "aws_instance" "rest" {
    count = 1
    ami = var.ami
    instance_type = var.instance
    key_name = var.key_name
    vpc_security_group_ids = ["${aws_security_group.kafka_sg.id}"] 
    subnet_id = aws_subnet.my_subnet.id
    associate_public_ip_address = true
    source_dest_check = false
    tags = {
        Name = "kafka-rest-${format("%02d", count.index+1)}"
    }
}

resource "aws_instance" "connect" {
    count = 1
    ami = var.ami
    instance_type = var.instance
    key_name = var.key_name
    vpc_security_group_ids = ["${aws_security_group.kafka_sg.id}"] 
    subnet_id = aws_subnet.my_subnet.id
    associate_public_ip_address = true
    source_dest_check = false
    tags = {
        Name = "kafka-connect-${format("%02d", count.index+1)}"
    }
}

resource "aws_instance" "ksql" {
    count = 1
    ami = var.ami
    instance_type = var.instance
    key_name = var.key_name
    vpc_security_group_ids = ["${aws_security_group.kafka_sg.id}"] 
    subnet_id = aws_subnet.my_subnet.id
    associate_public_ip_address = true
    source_dest_check = false
    tags = {
        Name = "kafka-ksql-${format("%02d", count.index+1)}"
    }
}
resource "aws_instance" "control_center" {
    count = 1
    ami = var.ami
    instance_type = var.instance
    key_name = var.key_name
    vpc_security_group_ids = ["${aws_security_group.kafka_sg.id}"] 
    subnet_id = aws_subnet.my_subnet.id
    associate_public_ip_address = true
    source_dest_check = false
    tags = {
        Name = "kafka-control-center-${format("%02d", count.index+1)}"
    }
}

resource "aws_instance" "schema" {
    count = 1
    ami = var.ami
    instance_type = var.instance
    key_name = var.key_name
    vpc_security_group_ids = ["${aws_security_group.kafka_sg.id}"] 
    subnet_id = aws_subnet.my_subnet.id
    associate_public_ip_address = true
    source_dest_check = false
    tags = {
        Name = "kafka-schema-${format("%02d", count.index+1)}"
    }
}

resource "aws_instance" "broker" {
    count = 1
    ami = var.ami
    instance_type = var.instance
    key_name = var.key_name
    vpc_security_group_ids = ["${aws_security_group.kafka_sg.id}"] 
    subnet_id = aws_subnet.my_subnet.id
    associate_public_ip_address = true
    source_dest_check = false
    tags = {
        Name = "kafka-broker-${format("%02d", count.index+1)}"
    }
}

resource "aws_instance" "zookeeper" {
    count = 1
    ami = var.ami
    instance_type = var.instance
    key_name = var.key_name
    vpc_security_group_ids = ["${aws_security_group.kafka_sg.id}"] 
    subnet_id = aws_subnet.my_subnet.id
    associate_public_ip_address = true
    source_dest_check = false
    tags = {
        Name = "kafka-zookeeper-${format("%02d", count.index+1)}"
    }
}

resource "aws_vpc" "my_vpc" {
  cidr_block = "10.0.0.0/16"
  enable_dns_hostnames = true
  tags = {
    Name = "kafka-vpc"
  }
}

resource "aws_subnet" "my_subnet" {
  vpc_id            = aws_vpc.my_vpc.id
  cidr_block        = "10.0.0.0/24"
  map_public_ip_on_launch = true
  tags = {
    Name = "kafka-subnet"
  }
}

resource "aws_internet_gateway" "default" {
    vpc_id = aws_vpc.my_vpc.id
    tags = {
        Name = "kafka_gw"
    }
}


resource "aws_route" "default" {
  route_table_id         = aws_vpc.my_vpc.main_route_table_id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.default.id
}

resource "aws_route_table" "default" {
    vpc_id = aws_vpc.my_vpc.id

    route {
       cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.default.id
    }

    tags = {
        Name = "Kafka Public Subnet"
    }
}

resource "aws_route_table_association" "default" {
    subnet_id = aws_subnet.my_subnet.id
    route_table_id = aws_route_table.default.id
}

resource "aws_security_group" "kafka_sg" {
    name = "vpc_kafka_sg"
    description = "Accept incoming connections."

    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
        description = "SSH"
    }
    ingress {
        from_port = 8083
        to_port = 8083
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
        description = "Kafka Connect REST API" 
    }
    ingress {
        from_port = 8088
        to_port = 8088
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
        description = "KSQL Server REST API" 
    }
    ingress {
        from_port = 8082
        to_port = 8082
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
        description = "REST Proxy" 
    }
    ingress {
        from_port = 8081
        to_port = 8081
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
        description = "Schema Registry REST API" 
    }
    ingress {
        from_port = 1099
        to_port = 1099
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
        description = "JMX" 
    }
    ingress {
        from_port = 2181
        to_port = 2181
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
        description = "ZooKeeper" 
    }
    ingress {
        from_port = 2888
        to_port = 2888
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
        description = "ZooKeeper" 
    }
    ingress {
        from_port = 3888
        to_port = 3888
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
        description = "ZooKeeper" 
    }
    ingress {
        from_port = 9092
        to_port = 9092
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
        description = "Kafka Brokers"
    }
    ingress {
        from_port = 9021
        to_port = 9021
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
        description = "Control Center"
    }
    ingress {
        from_port = -1
        to_port = -1
        protocol = "icmp"
        cidr_blocks = ["0.0.0.0/0"] 
    }
    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    vpc_id = aws_vpc.my_vpc.id

    tags = {
        Name = "kafka_cluster_sg"
    }
}