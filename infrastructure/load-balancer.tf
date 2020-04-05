resource "aws_s3_bucket" "lb_logs" {
  bucket = "${local.application_name}-alb-logs"

  tags = {
    environment = var.environment
    project     = local.project_name
  }
}

resource "aws_s3_bucket_policy" "lb_logs_policy" {
  bucket = aws_s3_bucket.lb_logs.id

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "AWS": "arn:aws:iam::985666609251:root"
      },
      "Action": "s3:PutObject",
      "Resource": "arn:aws:s3:::${aws_s3_bucket.lb_logs.bucket}/${local.application_name}-alb/*"
    }
  ]
}
POLICY
}

resource "aws_lb" "this" {
  name               = "${local.application_name}-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.this.id]
  subnets            = [aws_subnet.this.id, aws_subnet.this-2.id, aws_subnet.this-3.id]

  access_logs {
    bucket  = aws_s3_bucket.lb_logs.id
    prefix  = "${local.application_name}-alb"
    enabled = true
  }

  tags = {
    environment = var.environment
    project     = local.project_name
  }
}

resource "aws_lb_target_group" "this" {
  name        = "${local.application_name}-alb-tg"
  port        = 80
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = aws_vpc.this.id
}

resource "aws_lb_listener" "this" {
  load_balancer_arn = aws_lb.this.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.this.arn
  }
}