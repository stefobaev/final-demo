resource "aws_alb" "alb" {
  name               = "${var.app}-${var.env}-alb"
  load_balancer_type = "application"
  subnets            = aws_subnet.public_subnet.*.id
  security_groups    = [aws_security_group.alb.id]

  tags = {
    Name = "${var.app}_${var.env}_alb"
  }
}

resource "aws_alb_listener" "http" {
  load_balancer_arn = aws_alb.alb.id
  port              = var.app_port
  protocol          = "HTTP"

  default_action {
    target_group_arn = aws_alb_target_group.web_server.id
    type             = "forward"
  }
}

resource "aws_security_group" "alb" {
  name   = "${var.app}-${var.env}-sg_alb"
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "${var.app}_${var.env}_sg_alb"
  }

  ingress {
    protocol    = "tcp"
    from_port   = var.app_port
    to_port     = var.app_port
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_alb_target_group" "web_server" {
  name        = "${var.app}-${var.env}-tg"
  port        = var.app_target_port
  protocol    = "HTTP"
  vpc_id      = aws_vpc.vpc.id
  target_type = "ip"

  tags = {
    Name = "${var.app}_${var.env}_tg"
  }

  health_check {
    healthy_threshold   = "3"
    interval            = "30"
    protocol            = "HTTP"
    matcher             = "200"
    timeout             = "3"
    path                = var.health_check_path
    unhealthy_threshold = "2"
  }
}
