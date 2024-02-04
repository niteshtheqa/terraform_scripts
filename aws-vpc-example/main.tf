

# Create VPC
resource "aws_vpc" "aws-vpc-example" {

  cidr_block           = var.cidr_blocks
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "aws-vpc-example"
  }

}

# Create public subnet avaialbility zone first

resource "aws_subnet" "public-subnet-example-1a" {
  vpc_id                  = aws_vpc.aws-vpc-example.id
  availability_zone       = var.az-1a
  cidr_block              = "192.168.1.0/24"
  map_public_ip_on_launch = true


  tags = {
    Name = "public-subnet-example-1a"
  }

}



# Create public subnet avaialbility zone second
resource "aws_subnet" "public-subnet-example-1b" {
  vpc_id                  = aws_vpc.aws-vpc-example.id
  availability_zone       = var.az-1b
  cidr_block              = "192.168.3.0/24"
  map_public_ip_on_launch = true

  tags = {
    Name = "public-subnet-example-1b"
  }

}



resource "aws_internet_gateway" "example-igw" {
  vpc_id = aws_vpc.aws-vpc-example.id
  tags = {
    Name = "vpc-example-internet-gateway"
  }
  
}

resource "aws_route_table" "public-route-tb-example" {
  vpc_id = aws_vpc.aws-vpc-example.id
  route  {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.example-igw.id
  }
  
}

resource "aws_route" "exmaple-public-route-mapping" {
 gateway_id = aws_internet_gateway.example-igw.id
 route_table_id = aws_route_table.public-route-tb-example.id
 destination_cidr_block = "0.0.0.0/0"
}


#create route table association with subnet
resource "aws_route_table_association" "route_table_ass01" {
  route_table_id = aws_route_table.public-route-tb-example.id
  subnet_id = aws_subnet.public-subnet-example-1a.id  
  
}

#create route table association with subnet
resource "aws_route_table_association" "route_table_ass02" {
  route_table_id = aws_route_table.public-route-tb-example.id
  subnet_id = aws_subnet.public-subnet-example-1b.id
  
}


resource "aws_route_table" "private-route-table" {
  vpc_id = aws_vpc.aws-vpc-example.id
  
}

#Create Private subnet in 1a

resource "aws_subnet" "private-subnet-example-1a" {
  vpc_id            = aws_vpc.aws-vpc-example.id
  availability_zone = var.az-1a
  cidr_block        = "192.168.2.0/24"

  tags = {
    Name = "private-subnet-example-1a"
  }

}

# Create private subnet avaialbility zone second
resource "aws_subnet" "private-subnet-example-1b" {
  vpc_id                  = aws_vpc.aws-vpc-example.id
  availability_zone       = var.az-1b
  cidr_block              = "192.168.4.0/24"

  tags = {
    Name = "private-subnet-example-1b"
  }

}


#create route table association with private subnet
resource "aws_route_table_association" "private-route_table_ass01" {
  route_table_id = aws_route_table.private-route-table.id
  subnet_id = aws_subnet.private-subnet-example-1a.id
  
}

#create route table association with private subnet
resource "aws_route_table_association" "private-route_table_ass02" {
  route_table_id = aws_route_table.private-route-table.id
  subnet_id = aws_subnet.private-subnet-example-1b.id
  
}

# Create Security Group
resource "aws_security_group" "example-sg" {
  vpc_id = aws_vpc.aws-vpc-example.id
  description = "ssh from desktop client"

  ingress {
    protocol = "tcp"
    to_port = 22
    from_port = 22
    cidr_blocks = [ "0.0.0.0/0" ]
  }

  egress{
    protocol = "-1"
    to_port = 0
    from_port = 0
    cidr_blocks = ["0.0.0.0/0"]
    
  }

  tags = {
    Name ="Security group for VPC example"
  }
  
}
#Create Ec2 Instance in public subnet

resource "aws_instance" "public-instance-example" {
  ami = var.ami_id
  instance_type = var.instance_type
  key_name = "ssh_key"
  security_groups =  [ aws_security_group.example-sg.id ]
  subnet_id = aws_subnet.public-subnet-example-1a.id
  tags = {
    Name = "public-instance-example"
  }
  
}

# Launch Private instance in private subnet

resource "aws_instance" "private-instance-example" {
  ami = var.ami_id
  instance_type = var.instance_type
  key_name = "ssh_key"
  security_groups =  [ aws_security_group.example-sg.id ]
  subnet_id = aws_subnet.private-subnet-example-1a.id
  tags = {
    Name = "private-instance-example"
  }
  associate_public_ip_address = false
}


#Create a bstian server to ssh into private server

resource "aws_instance" "bastian-server" {
  ami = var.ami_id
  instance_type = var.instance_type
  key_name = "ssh_key"
  security_groups =  [ aws_security_group.example-sg.id ]
  subnet_id = aws_subnet.public-subnet-example-1a.id
  tags = {
    Name = "bastian-server"
  }
  associate_public_ip_address = true
  
}


#Create a NAT Server to ssh into private server

resource "aws_instance" "nat-server" {
  
  ami = var.nat_ami_id
  instance_type = var.instance_type
  key_name = "ssh_key"
  security_groups =  [ aws_security_group.example-sg.id ]
  subnet_id = aws_subnet.public-subnet-example-1a.id
  tags = {
    Name = "NAT-server"
  }
  source_dest_check = false
  associate_public_ip_address = true

  
}

resource "aws_route" "private-rt-mapping" {
  route_table_id = aws_route_table.private-route-table.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id = aws_instance.nat-server.id
  
}

# Create Security Group
resource "aws_security_group" "example-sg-nat" {
  vpc_id = aws_vpc.aws-vpc-example.id
  description = "nat instance access"

  ingress {
    protocol = "-1"
    to_port = 0
    from_port = 0
    cidr_blocks = [ "0.0.0.0/0" ]
  }

  egress{
    protocol = "-1"
    to_port = 0
    from_port = 0
    cidr_blocks = ["0.0.0.0/0"]
    
  }

  tags = {
    Name ="Security group for NAT Instance"
  }
  
}