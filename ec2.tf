provider "aws" {
    region = "us-east-1"
    access_key = var.access_key
    secret_key = var.secret_key
}

resource "aws_instance" "ec2-DockerCompose" {
    ami = var.ami
    instance_type = var.instance_type
    key_name = var.key_name
    vpc_security_group_ids = [aws_security_group.security_group-test.id]
    subnet_id = aws_subnet.public_subnet-test.id
}

resource "aws_instance" "ec2-Kubernetes" {
    ami = var.ami
    instance_type = var.instance_type
    key_name = var.key_name
   vpc_security_group_ids = [aws_security_group.security_group-test.id]
   subnet_id = aws_subnet.public_subnet-test.id
   tags = {
        Name = "Kubernetes"
    }
}

resource "aws_security_group" "security_group-test" {     
    name =  "security_group_test" 
    vpc_id = aws_vpc.vpc-test.id
    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]

    }
    ingress {
        from_port = 80
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