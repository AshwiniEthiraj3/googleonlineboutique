output "vpc_id" {
  description = "value of vpc id"
  value = aws_vpc.myvpc.id
}

output "cidr_privatesubnet" {
  description = "value of private subnet ids"
  value = aws_subnet.private_subnet[*].id
}


output "cidr_publicsubnet" {
  description = "value of private subnet ids"
  value = aws_subnet.public_subnet[*].id
}

output "availability_zone" {
  description = "value"
  value = var.availability_zone
}
