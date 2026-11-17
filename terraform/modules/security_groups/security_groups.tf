

resource "aws_security_group" "alb" {
  name        = "alb"
  description = "allow inbound traffic on port 80/443 and send traffic to service"
  vpc_id      = var.vpc_id

  tags = {
    Name = "alb"
  }
}

resource "aws_security_group" "ecs_task" {
  name        = "ecs_task"
  description = "receive traffic from alb and outbound to internet"
  vpc_id      = var.vpc_id

  tags = {
    Name = "ecs_task"
  }
}


resource "aws_vpc_security_group_ingress_rule" "ingress_alb" {
  security_group_id = aws_security_group.alb.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 443
  ip_protocol       = "tcp"
  to_port           = 443
}

resource "aws_vpc_security_group_ingress_rule" "allow_port_80" {
  security_group_id = aws_security_group.alb.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 80
  ip_protocol       = "tcp"
  to_port           = 80
}

resource "aws_vpc_security_group_egress_rule" "send_service" {
  security_group_id            = aws_security_group.alb.id
  referenced_security_group_id = aws_security_group.ecs_task.id
  from_port                    = 8080
  ip_protocol                  = "tcp"
  to_port                      = 8080
}



resource "aws_vpc_security_group_ingress_rule" "ingress_task" {
  security_group_id            = aws_security_group.ecs_task.id
  referenced_security_group_id = aws_security_group.alb.id
  from_port                    = 8080
  ip_protocol                  = "tcp"
  to_port                      = 8080
}

resource "aws_vpc_security_group_egress_rule" "to_internet" {
  security_group_id = aws_security_group.ecs_task.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"


}

















































