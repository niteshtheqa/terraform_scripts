

# Create VPC
resource "aws_vpc" "aws_vpc_example" {

  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "aws-vpc-example"
  }

}

# Create public subnet avaialbility zone first

resource "aws_subnet" "public_subnet_example-1a" {
  vpc_id                  = aws_vpc.aws_vpc_example.id
  availability_zone       = "ap-south-1a"
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true

  tags = {
    Name = "public-subnet-example-1a"
  }

}

# Create Private subnet in 1a

resource "aws_subnet" "private_subnet_example-1a" {
  vpc_id            = aws_vpc.aws_vpc_example.id
  availability_zone = "ap-south-1a"
  cidr_block        = "10.0.2.0/24"

  tags = {
    Name = "private-subnet-example-1a"
  }

}

# Create public subnet avaialbility zone second
resource "aws_subnet" "public_subnet_example-1b" {
  vpc_id                  = aws_vpc.aws_vpc_example.id
  availability_zone       = "ap-south-1b"
  cidr_block              = "10.0.3.0/24"
  map_public_ip_on_launch = true

  tags = {
    Name = "public-subnet-example-1b"
  }

}

# Create Private subnet in 1b

resource "aws_subnet" "private_subnet_example-1b" {
  vpc_id            = aws_vpc.aws_vpc_example.id
  availability_zone = "ap-south-1b"
  cidr_block        = "10.0.4.0/24"

  tags = {
    Name = "private-subnet-example-1b"
  }

}


# Create Internet Gateway

resource "aws_internet_gateway" "igw_example" {
  vpc_id = aws_vpc.aws_vpc_example.id
  tags = {
    Name = "igw_example"
  }

}

# Attache Gateway to VPC
resource "aws_internet_gateway_attachment" "igw_attachement" {
  vpc_id              = aws_vpc.aws_vpc_example.id
  internet_gateway_id = aws_internet_gateway.igw_example.id
}


# Create a Route Table for Public Subnet
resource "aws_route_table" "rt_example" {
  vpc_id = aws_vpc.aws_vpc_example.id
  route  {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw_example.id
  }


  tags = {
    Name = "public-route-table"
  }
}
