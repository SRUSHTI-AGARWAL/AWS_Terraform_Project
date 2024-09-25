#instances in public subnets 1 and 2
resource "aws_instance" "demo_ec21" {
  ami = var.ami
  instance_type = var.type
  subnet_id = var.demo_subnet1
  vpc_security_group_ids = var.vpc_security_group
}

resource "aws_instance" "demo_ec22" {
  ami = var.ami
  instance_type = var.type
  subnet_id = var.demo_subnet2
  vpc_security_group_ids = var.vpc_security_group
}

#---
# instance placed in private subnet
resource "aws_instance" "demo_ec23" {
  ami = var.ami
  instance_type = var.type
  subnet_id = var.demo_subnet_private

}
#---

#application Load Balancer to direct the traffic to subnets
resource "aws_lb" "demo_lb" {
  name               = "demo-lb-subnets"
  internal           = false
  load_balancer_type = "application"
  security_groups    = var.vpc_security_group
  subnets            = [var.demo_subnet1, var.demo_subnet2, var.demo_subnet_private]

  enable_deletion_protection = false

}

resource "aws_lb_target_group" "demo_tg" {
  name        = "demo-lb-tg"
  port        = 80
  protocol    = "HTTP"
  target_type = "instance"
  vpc_id      = var.vpc
# defining what paths it needs to check ,so if instances are not healthy 
# traffic will not be routed to it.
  health_check {
 path = "/"
#checks are being made at home path as instances are running on home path. 
}
}

#Register instances to target groups
resource "aws_lb_target_group_attachment" "demo_tg_ins1"{
target_group_arn= aws_lb_target_group.demo_tg.arn
target_id = aws_instance.demo_ec21.id
port = "80"

}

resource "aws_lb_target_group_attachment" "demo_tg_ins2"{
target_group_arn= aws_lb_target_group.demo_tg.arn
target_id = aws_instance.demo_ec22.id
port = "80"

}


#Adding the LB listener 
resource "aws_lb_listener" "demo_lb_listen" {
load_balancer_arn = aws_lb.demo_lb.arn
protocol = "HTTP"
port= "80"

default_action{

type = "forward"
target_group_arn = aws_lb_target_group.demo_tg.arn
}
}


