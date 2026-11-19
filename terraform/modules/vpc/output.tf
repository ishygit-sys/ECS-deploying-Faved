# to allow other modules to reference the VPC 
output "vpc_id" {
  value = aws_vpc.main.id

}
# To allow other modules to reference the subnets
output "subnet_ids" {
  value = [aws_subnet.main.id, aws_subnet.second.id]

}
