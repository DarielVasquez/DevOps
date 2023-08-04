resource "aws_lb" "LoadBalancer" {
  name               = "LoadBalancer"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.SecurityGroup.id]
  subnets            = [aws_subnet.PublicSubnet1.id, aws_subnet.PublicSubnet2.id]
  tags = {
    Name = "LoadBalancer"
  }
}

resource "aws_lb_target_group" "TargetGroup1" {
  name        = "TargetGroup1"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = aws_vpc.ChallengeVPC.id
  tags = {
    Name = "TargetGroup1"
  }
}

resource "aws_lb_target_group" "TargetGroup2" {
  name        = "TargetGroup2"
  port        = 5000
  protocol    = "HTTP"
  vpc_id      = aws_vpc.ChallengeVPC.id
  tags = {
    Name = "TargetGroup2"
  }
}

resource "aws_lb_listener" "Listener1" {
  load_balancer_arn = aws_lb.LoadBalancer.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.TargetGroup1.arn
  }
}

resource "aws_lb_listener" "Listener2" {
  load_balancer_arn = aws_lb.LoadBalancer.arn
  port              = 5000
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.TargetGroup2.arn
  }
}