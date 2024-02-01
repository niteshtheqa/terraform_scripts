resource "aws_instance" "ubuntu" {

  ami           = var.ami_id
  instance_type = var.instance_type
  subnet_id     = var.subnet_Id
  key_name      = var.key_name
  tags          = var.tags


}
