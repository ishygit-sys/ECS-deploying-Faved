
# creating security group to attatch to ALB
resource "aws_security_group" "alb" {
  name        = "alb"
  description = "allow inbound traffic on port 80/443 and send traffic to service"
  vpc_id      = var.vpc_id

  tags = {
    Name = "alb"
  }
}

# Creating security group to attach to ECS service 
resource "aws_security_group" "ecs_task" {
  name        = "ecs_task"
  description = "receive traffic from alb and outbound to internet"
  vpc_id      = var.vpc_id

  tags = {
    Name = "ecs_task"
  }
}

# Inbound rules for the ALB security group 
resource "aws_vpc_security_group_ingress_rule" "ingress_alb" {
  security_group_id = aws_security_group.alb.id
  cidr_ipv4         = "0.0.0.0/0" # Allowing all traffic from the internet on port 443
  from_port         = 443
  ip_protocol       = "tcp"
  to_port           = 443
}

# Inbound rules for the ALB security group 
resource "aws_vpc_security_group_ingress_rule" "allow_port_80" {
  security_group_id = aws_security_group.alb.id
  cidr_ipv4         = "0.0.0.0/0" # Allowing all traffic from the internet on port 80
  from_port         = 80
  ip_protocol       = "tcp"
  to_port           = 80
}

# Outbound rules for the ALB security group  
resource "aws_vpc_security_group_egress_rule" "send_service" {
  security_group_id            = aws_security_group.alb.id
  referenced_security_group_id = aws_security_group.ecs_task.id # sending the traffic to the ECS security group
  from_port                    = 8080
  ip_protocol                  = "tcp"
  to_port                      = 8080
}


# Inbound rules for the Ecs security group 
resource "aws_vpc_security_group_ingress_rule" "ingress_task" {
  security_group_id            = aws_security_group.ecs_task.id
  referenced_security_group_id = aws_security_group.alb.id # Receiving traffic from ALB security group
  from_port                    = 8080
  ip_protocol                  = "tcp"
  to_port                      = 8080
}

# Outbound rules for the Ecs security group 
resource "aws_vpc_security_group_egress_rule" "to_internet" {
  security_group_id = aws_security_group.ecs_task.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # allows all outbound internet traffic from ECS 


}

















































