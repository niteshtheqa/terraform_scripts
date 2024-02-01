# Define an output variable
output "instance_ip" {
  value = aws_instance.ubuntu.public_ip
}

output "instance_private_ip" {
  value = aws_instance.ubuntu.private_ip
}

output "security_group" {
  value = aws_instance.ubuntu.security_groups

}


output "public_dns" {
    value = aws_instance.ubuntu.private_dns
  
}