# create vpc for proof of concept

resource "aws_vpc" "vpc-poc" {
    cidr_block = "192.168.0.0/16"
    enable_dns_hostnames = true
    enable_dns_support = true

    tags = {
      Name ="vpc-proof-of-concept"
    }

  
}

# create public subnet for existing vpc

resource "aws_subnet" "poc-subnet-public" {
    vpc_id = aws_vpc.vpc-poc.id
    cidr_block = "192.168.1.0/24"
    availability_zone = "ap-south-1a"
    map_public_ip_on_launch = true

    tags = {
      Name = "poc-subnet-public"
    }
  
}



# Create public routing table
resource "aws_route_table" "poc-route-table-public" {
    vpc_id = aws_vpc.vpc-poc.id

    tags = {
      name ="poc-route-table-public"
    }
  
}

#create route table association with subnet
resource "aws_route_table_association" "route_table_ass" {
  route_table_id = aws_route_table.poc-route-table-public.id
  subnet_id = aws_subnet.poc-subnet-public.id
}


# create internet gateway
resource "aws_internet_gateway" "poc-igw" {
    vpc_id = aws_vpc.vpc-poc.id
    tags = {
    Name = "poc-igw"
  }
  
}

# Create WS Route to map subnet to internet gateway

resource "aws_route" "poc-route-mapping" {
    route_table_id = aws_route_table.poc-route-table-public.id
    gateway_id = aws_internet_gateway.poc-igw.id
    destination_cidr_block = "0.0.0.0/0"
  
}



#create ec2 instance in public subnet

resource "aws_instance" "public-instance" {
    ami = var.ami_id
    instance_type = var.instance_type
    key_name = "ssh_key"

    subnet_id = aws_subnet.poc-subnet-public.id
    security_groups = [ aws_security_group.poc-security-group.id ]

    tags = {
    Name = "poc-public-instance"
  }
}

# create security group for vpc

resource "aws_security_group" "poc-security-group" {
    vpc_id = aws_vpc.vpc-poc.id
    name = "Allow ssh from desktop"
    tags = {
      Name ="Allow ssh from Desktop"
    }
    ingress {        
        to_port = "22"
        from_port = "22"
        protocol = "tcp"
        #self = true
        cidr_blocks = ["0.0.0.0/0"]
        
    }

    egress {
        from_port = 0
        to_port   = 0
        protocol  = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
    
}

# resource "aws_vpc_security_group_ingress_rule" "poc-ingerss" {
#   security_group_id = aws_security_group.poc-security-group.id
#   cidr_ipv4 = aws_vpc.vpc-poc.cidr_block
#   ip_protocol = "tcp"
#   to_port = "22"
#   from_port = "22"
  
# }

# resource "aws_vpc_security_group_egress_rule" "poc-egerss" {
#   security_group_id = aws_security_group.poc-security-group.id
#   cidr_ipv4         = "0.0.0.0/0"
#   ip_protocol       = "-1" # semantically equivalent to all ports
# }