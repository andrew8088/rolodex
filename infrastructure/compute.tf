// ============== CLOUDWATCH ===========

resource "aws_cloudwatch_log_group" "this" {
  name = "/ecs/${local.application_name}"

  tags = {
    environment = var.environment
    project     = local.project_name
  }

}

// ============== ECS ==================
resource "aws_ecs_cluster" "this" {
  name = local.application_name

  tags = {
    environment = var.environment
    project     = local.project_name
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
    environment = var.environment
    project     = local.project_name
  }
}

resource "aws_ecs_service" "this" {
  name        = "${local.application_name}-service"
  cluster     = aws_ecs_cluster.this.id
  launch_type = local.launch_type
  depends_on  = [aws_lb_listener.this]

  deployment_maximum_percent         = 200
  deployment_minimum_healthy_percent = 0
  desired_count                      = 1
  task_definition                    = "${aws_ecs_task_definition.this.family}:${aws_ecs_task_definition.this.revision}"

  network_configuration {
    assign_public_ip = true
    security_groups  = [aws_security_group.this.id]
    subnets          = [aws_subnet.this.id, aws_subnet.this-2.id]
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.this.arn
    container_name   = local.project_name
    container_port   = 80
  }

  tags = {
    environment = var.environment
    project     = local.project_name
  }
}