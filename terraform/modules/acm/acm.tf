# Requests a new SSL/TLS certificate from AWS ACM.
resource "aws_acm_certificate" "cert" {
  domain_name       = var.domain
  validation_method = "DNS"


}

