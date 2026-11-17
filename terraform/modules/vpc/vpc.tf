
resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_subnet" "main" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = var.az_a

  tags = {
    Name = var.az_a
  }
}

resource "aws_subnet" "second" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = var.az_b

  tags = {
    Name = var.az_b
  }
}


resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "main"
  }
}


resource "aws_route_table" "route_table" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }
}


resource "aws_route_table_association" "eu-west-2a" {
  route_table_id = aws_route_table.route_table.id
  subnet_id      = aws_subnet.main.id
}

resource "aws_route_table_association" "eu-west-2b" {
  route_table_id = aws_route_table.route_table.id
  subnet_id      = aws_subnet.second.id
}


