# Creating VPC 
resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
}

# Creating first subnet
resource "aws_subnet" "main" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = var.az_a

  tags = {
    Name = var.az_a
  }
}

# Creating second subnet
resource "aws_subnet" "second" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = var.az_b

  tags = {
    Name = var.az_b
  }
}

# Creating internet gateway and attaching to VPC
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "main"
  }
}

# Creating route table and directing subnet traffic to IGW
resource "aws_route_table" "route_table" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }
}

# linking both subnets to the route table
resource "aws_route_table_association" "eu-west-2a" {
  route_table_id = aws_route_table.route_table.id
  subnet_id      = aws_subnet.main.id
}

resource "aws_route_table_association" "eu-west-2b" {
  route_table_id = aws_route_table.route_table.id
  subnet_id      = aws_subnet.second.id
}


