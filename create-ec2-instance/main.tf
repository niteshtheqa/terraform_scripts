provider "aws" {
  region = "ap-south-1"
}
resource "aws_instance" "ubuntu" {
  ami           = "ami-03f4878755434977f"
  instance_type = "t2.micro"
  key_name      = "aws-login"
  subnet_id     = "subnet-06c867bcca503534a"
  tags = {
    Name = "Ubuntu-01"
  }

}