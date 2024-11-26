resource "aws_vpc" "vpc-test" {
    cidr_block = "10.0.0.0/16"
    tags = {
        name = "BrunoEzopsTestVPC"
    }
}

resource "aws_subnet" "public_subnet-test"{
    vpc_id = aws_vpc.vpc-test.id
    cidr_block = "10.0.1.0/24"
    map_public_ip_on_launch = true
}

resource "aws_subnet" "private_subnet-test" {
    vpc_id = aws_vpc.vpc-test.id
    cidr_block = "10.0.2.0/24"
}

resource "aws_subnet" "subnet_b" {
  vpc_id                  = aws_vpc.vpc-test.id
  cidr_block              = "10.0.3.0/24"
  availability_zone       = "us-east-1b"
  map_public_ip_on_launch = true
}

resource "aws_subnet" "subnet_a" {
  vpc_id                  = aws_vpc.vpc-test.id
  cidr_block              = "10.0.4.0/24"
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true
}

resource "aws_internet_gateway" "igw-test" {
    vpc_id = aws_vpc.vpc-test.id
}

resource "aws_route_table" "public_route_table-test" {
    vpc_id = aws_vpc.vpc-test.id
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.igw-test.id
    }
}

resource "aws_route_table_association" "BrunoPublicRouteTableAssociation" {
    subnet_id = aws_subnet.public_subnet-test.id
    route_table_id = aws_route_table.public_route_table-test.id
}