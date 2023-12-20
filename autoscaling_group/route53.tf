
resource "aws_route53_record" "blog" {
  zone_id = data.aws_route53_zone.domain.id
  name    = var.domain_name
  type    = "A"

  alias {
    name                   = aws_lb.wordpress-alb.dns_name
    zone_id                = aws_lb.wordpress-alb.zone_id
    evaluate_target_health = true
  }
}

# request for certificate
resource "aws_acm_certificate" "cert" {
  domain_name       = var.domain_name
  validation_method = "DNS"

  tags = {
    Name = "SSL Certificate"
  }

  lifecycle {
    create_before_destroy = true
  }
}

# DNS validation
resource "aws_route53_record" "cert_validation" {
  for_each = {
    for dvo in aws_acm_certificate.cert.domain_validation_options : dvo.domain_name => {
      name  = dvo.resource_record_name
      value = dvo.resource_record_value
      type  = dvo.resource_record_type
    }
  }

  name    = each.value.name
  type    = each.value.type
  records = [each.value.value]
  ttl     = 60
  zone_id = data.aws_route53_zone.domain.id
}


# Certificate validation resource
resource "aws_acm_certificate_validation" "cert" {
  certificate_arn         = aws_acm_certificate.cert.arn
  validation_record_fqdns = [for record in aws_route53_record.cert_validation : record.fqdn]
}