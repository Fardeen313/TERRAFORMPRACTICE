provider "aws" {
  region  = "us-east-1"
  profile = "android"
}
data "aws_subnet" "name" {
  filter {
    name   = "tag:Name"
    values = [var.subnet_name]
  }
}

resource "aws_instance" "inst-1" {
  instance_type               = var.instance_type
  subnet_id = data.aws_subnet.name.id
  associate_public_ip_address = "false"
  key_name  = var.key_name
  ami       = var.image
  count     = 1
  user_data = file("${path.module}/setup.sh")
  tags = {
    key_name = var.instance_tag
  }
}

resource "aws_subnet" "pub" {
  vpc_id = var.vpc_id
  cidr_block = var.pub_sub_cidr
  availability_zone = "us-east-1a"
  tags = {
    Name = var.pub_sub_tag
  }

}

# TG

resource "aws_lb_target_group" "easy_tg" {
  name     = "easymart-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = "vpc-0557efa3763965b59"
  depends_on = [ aws_instance.inst-1 ]

  health_check {
    enabled             = true
    interval            = 30
    path                = "/fardeen/path1/*"
    protocol            = "HTTP"
    timeout             = 5
    healthy_threshold   = 3
    unhealthy_threshold = 3
    matcher             = "200-299"
  }

  tags = {
    Name = "easymart-target-group"
  }
}
# TG Instance Attachment

resource "aws_lb_target_group_attachment" "easy_attach" {
  target_group_arn = aws_lb_target_group.easy_tg.arn
  target_id        = aws_instance.inst-1[0].id
  port             = 80
}

# ALB

resource "aws_lb" "easy_alb" {
  name               = "easymart-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = ["sg-058e19d19ba9b60a6"]
  subnets            = [aws_subnet.pub.id, "subnet-072a8ef6037d9b8f9"]

  tags = {
    Name = "easymart-alb"
  }
  depends_on = [ aws_lb_target_group_attachment.easy_attach ]
}

resource "aws_lb_listener" "easy_listener" {
  load_balancer_arn = aws_lb.easy_alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.easy_tg.arn
  }
}