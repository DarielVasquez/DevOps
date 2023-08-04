resource "aws_launch_template" "ASGTemplate" {
  image_id        = "ami-0f34c5ae932e6f0e4"
  instance_type   = "t2.micro"
  key_name = aws_key_pair.Keypair.key_name
  vpc_security_group_ids = [ aws_security_group.SecurityGroup.id ]
}

resource "aws_autoscaling_group" "ASG" {
  name                 = "ASG"
  launch_template {
    id      = aws_launch_template.ASGTemplate.id
    version = aws_launch_template.ASGTemplate.latest_version
  }
  min_size             = 2
  max_size             = 4
  desired_capacity     = 2
  health_check_type    = "EC2"
  vpc_zone_identifier  = [aws_subnet.PublicSubnet1.id, aws_subnet.PublicSubnet2.id]

  tag {
    key                 = "Name"
    value               = "ASG"
    propagate_at_launch = true
  }
}