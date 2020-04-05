variable "region" {}
variable "aws_account_id" {}
variable "environment" {}
variable "task_definition_container_image" {}
variable "task_definition_execution_role_arn" {}
variable "static_site_dns_name" {}
variable "ssl_cert_arn" {}

locals {
  project_name     = "rolodex"
  application_name = "rolodex-${var.environment}"
  launch_type      = "FARGATE"
}

provider "aws" {
  profile = local.project_name
  region  = var.region
}