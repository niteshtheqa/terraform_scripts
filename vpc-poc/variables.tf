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

