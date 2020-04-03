variable "region" {}
variable "environment" {}
variable "task_definition_container_image" {}
variable "task_definition_execution_role_arn" {}

provider "aws" {
  profile = "default"
  region  = var.region
}

locals {
  project_name     = "rolodex"
  application_name = "rolodex-${var.environment}"
  launch_type      = "FARGATE"
}

// ============== VPC ==================
resource "aws_vpc" "this" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name    = "${local.application_name}-vpc"
    project = local.project_name
  }
}

resource "aws_subnet" "this" {
  vpc_id                  = aws_vpc.this.id
  cidr_block              = "10.0.0.0/24"
  map_public_ip_on_launch = "false"
  availability_zone       = "ca-central-1a"

  tags = {
    Name    = "${local.application_name}-subnet"
    project = local.project_name
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
    project = local.project_name
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

// ============== CLOUDWATCH ===========

resource "aws_cloudwatch_log_group" "this" {
  name = "/ecs/${local.application_name}"

  tags = {
    environment = var.environment
    project = local.project_name 
  }

}

// ============== ECS ==================
resource "aws_ecs_cluster" "this" {
  name = local.application_name

  tags = {
    project = local.project_name
  }
}

module "rolodex_definition" {
  source          = "git::https://github.com/cloudposse/terraform-aws-ecs-container-definition.git?ref=tags/0.23.0"
  container_name  = local.project_name
  container_image = var.task_definition_container_image

  log_configuration = {
    logDriver = "awslogs"
    options = {
      awslogs-group         = "/ecs/${local.application_name}"
      awslogs-region        = var.region
      awslogs-stream-prefix = local.application_name
    }

    secretOptions = []

  }
}

resource "aws_ecs_task_definition" "this" {
  family                   = "${local.application_name}-task"
  requires_compatibilities = [local.launch_type]
  execution_role_arn       = var.task_definition_execution_role_arn

  cpu          = "256"
  memory       = "512"
  network_mode = "awsvpc"

  container_definitions = module.rolodex_definition.json

  tags = {
    project = local.project_name
  }
}

resource "aws_ecs_service" "this" {
  name        = "${local.application_name}-service"
  cluster     = aws_ecs_cluster.this.id
  launch_type = local.launch_type

  deployment_maximum_percent         = 200
  deployment_minimum_healthy_percent = 0
  desired_count                      = 1
  task_definition                    = "${aws_ecs_task_definition.this.family}:${aws_ecs_task_definition.this.revision}"

  network_configuration {
    assign_public_ip = true
    security_groups  = [aws_security_group.this.id]
    subnets          = [aws_subnet.this.id]
  }

  tags = {
    project = local.project_name
  }

}
