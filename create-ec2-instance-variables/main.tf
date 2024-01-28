#Provider name
variable "ami_id" {
  description = "EC2 AMI ID"
  type        = string
  default = "ami-03f4878755434977f"

}


variable "instance_type" {
  description = "EC2 Instance Type"
  type        = string
  default     = "t2.micro"

}

variable "subnet_id" {
  description = "Subnet Id"
  type        = string
  default = "subnet-06c867bcca503534a"
}

variable "key_name" {
  description = "Key Name"
  type        = string
  default     = "aws-login"

}

# Define a variable for tags
variable "tags" {
  type    = map(string)
  default = {
    Name        = "Ubuntu-01"
    Environment = "Production"
    Owner       = "Nitesh Wayafalkar"
  }
}

resource "aws_instance" "Ubuntu" {
  ami           = var.ami_id
  instance_type = var.instance_type
  key_name      = var.key_name
  subnet_id     = var.subnet_id
  tags = var.tags

}
