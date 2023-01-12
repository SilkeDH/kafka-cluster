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
