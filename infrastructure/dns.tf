resource "aws_route53_zone" "main" {
  name = "rolodex.tech"
}

resource "aws_route53_zone" "dev" {
  name = "dev.rolodex.tech"

  tags = {
    Environment = "dev"
  }
}

resource "aws_route53_record" "dev" {
  zone_id = aws_route53_zone.main.zone_id
  name    = "dev.rolodex.tech"
  type    = "A"

  alias {
    name                   = aws_lb.this.dns_name
    zone_id                = aws_lb.this.zone_id
    evaluate_target_health = true
  }

}