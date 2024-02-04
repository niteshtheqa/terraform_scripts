variable "cidr_blocks" {
    type = string
    default = "192.168.0.0/16"
  }

  variable "az-1a" {
    type = string
    default = "ap-south-1a"
    
  }

  variable "az-1b" {
    type = string
    default = "ap-south-1b"
    
  }

  variable "region" {
    type = string
    default = "ap-south-1"
    
  }

variable "region_name"{    
    type = string
    default="ap-south-1"
    description = "default description"
}

variable "ami_id" {

 default = "ami-03f4878755434977f"
 type = string
 description = "This is defualt AMI Id" 
  
}

variable "instance_type" {
    type = string
    default = "t2.micro"
      
}

variable "nat_ami_id" {
    type = string
    default = "ami-09ecffe3d016b5e97"
    description = "This is AMI ID of NAT Server"
  
}