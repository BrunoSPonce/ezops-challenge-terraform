resource "aws_lb_target_group" "target_group-test" {
    name = "target-group-test"
    port = 80
    protocol = "HTTP"
    vpc_id = aws_vpc.vpc-test.id
    health_check {
      interval = 10
      path = "/"
      protocol = "HTTP"
      timeout = 5
      healthy_threshold = 5
      unhealthy_threshold = 2
    }
}

resource "aws_lb" "load-balancer-test" {
  name = "load-balancer-test"
  internal = false
  ip_address_type = "ipv4"
  load_balancer_type = "application"
  security_groups = [aws_security_group.security_group-test.id]
  subnets = [aws_subnet.subnet_a.id, aws_subnet.subnet_b.id]
  tags = {
    Name = "load-balancer-test"
  }
}

resource "aws_lb_listener" "load-balancer-listener-test" {
  load_balancer_arn = aws_lb.load-balancer-test.arn
  port = 80
  protocol = "HTTP"
  default_action {
    type = "forward"
    target_group_arn = aws_lb_target_group.target_group-test.arn
  }
}

resource "aws_lb_target_group_attachment" "ec2_attachment-test" {
  target_group_arn = aws_lb_target_group.target_group-test.id
  target_id = aws_instance.ec2-DockerCompose.id
}