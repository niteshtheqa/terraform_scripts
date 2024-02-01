variable "ami_id" {
  type        = string
  description = "EC2 machine type id"
  default     = "ami-03f4878755434977f"
}

variable "instance_type" {
  type        = string
  description = "EC2 instance type"
  default     = "t2.micro"

}


variable "key_name" {
  type        = string
  description = "ssh key"
  default     = "aws_login"

}

variable "subnet_Id" {
  description = "EC2 Subnet Id"
  default = "subnet-06c867bcca503534a"

}

variable "tags" {
  type = map(string)
  default = {
    Name        = "Ubuntu-01"
    Environment = "Production"
    Owner       = "Nitesh Wayafalkar"
  }

}
