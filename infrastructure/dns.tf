# resource "aws_route53_zone" "main" {
#   name = "api.rolodex.tech"

#   tags = {
#     project = local.project_name
#   }
# }

# resource "aws_route53_zone" "dev" {
#   name = "dev.api.rolodex.tech"

#   tags = {
#     Environment = "dev"
#     project     = local.project_name
#   }
# }

# resource "aws_route53_zone" "devweb" {
#   name = "dev.rolodex.tech"

#   tags = {
#     Environment = "dev"
#     project     = local.project_name
#   }
# }

# resource "aws_route53_record" "dev" {
#   zone_id = aws_route53_zone.main.zone_id
#   name    = "dev.api.rolodex.tech"
#   type    = "A"

#   alias {
#     name                   = aws_lb.this.dns_name
#     zone_id                = aws_lb.this.zone_id
#     evaluate_target_health = true
#   }
# }

# resource "aws_route53_record" "devweb" {
#   zone_id = aws_route53_zone.devweb.zone_id
#   name    = "dev.rolodex.tech"
#   type    = "A"
#   ttl = "30"

#   records = [var.static_site_dns_name]

# }