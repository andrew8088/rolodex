resource "aws_vpc" "this" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name        = "${local.application_name}-vpc"
    environment = var.environment
    project     = local.project_name
  }
}

resource "aws_subnet" "this" {
  vpc_id                  = aws_vpc.this.id
  cidr_block              = "10.0.0.0/24"
  map_public_ip_on_launch = "false"
  availability_zone       = "ca-central-1a"

  tags = {
    Name        = "${local.application_name}-subnet-1"
    environment = var.environment
    project     = local.project_name
  }
}

resource "aws_subnet" "this-2" {
  vpc_id                  = aws_vpc.this.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = "false"
  availability_zone       = "ca-central-1b"

  tags = {
    Name        = "${local.application_name}-subnet-2"
    environment = var.environment
    project     = local.project_name
  }
}

resource "aws_subnet" "this-3" {
  vpc_id                  = aws_vpc.this.id
  cidr_block              = "10.0.2.0/24"
  map_public_ip_on_launch = "false"
  availability_zone       = "ca-central-1d"

  tags = {
    Name        = "${local.application_name}-subnet-3"
    environment = var.environment
    project     = local.project_name
  }
}

resource "aws_security_group" "this" {
  name        = "${local.application_name}-sg"
  description = "${local.project_name} ${var.environment}"
  vpc_id      = aws_vpc.this.id

  ingress {
    description      = "public internet access"
    from_port        = 80
    to_port          = 80
    protocol         = "TCP"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    environment = var.environment
    project     = local.project_name
  }
}

resource "aws_security_group_rule" "this" {
  security_group_id = aws_security_group.this.id
  type              = "ingress"
  cidr_blocks       = ["0.0.0.0/0"]
  description       = "public internet access"
  from_port         = 80
  ipv6_cidr_blocks  = []
  prefix_list_ids   = []
  protocol          = "tcp"
  self              = false
  to_port           = 80
}

resource "aws_security_group_rule" "this-1" {
  security_group_id = aws_security_group.this.id
  type              = "ingress"
  cidr_blocks       = []
  description       = "public internet access"
  from_port         = 80
  ipv6_cidr_blocks  = ["::/0", ]
  prefix_list_ids   = []
  protocol          = "tcp"
  self              = false
  to_port           = 80
}

resource "aws_security_group_rule" "this-2" {
  security_group_id = aws_security_group.this.id
  type              = "egress"
  cidr_blocks       = ["0.0.0.0/0"]
  from_port         = 0
  ipv6_cidr_blocks  = []
  prefix_list_ids   = []
  protocol          = "-1"
  self              = false
  to_port           = 0
}