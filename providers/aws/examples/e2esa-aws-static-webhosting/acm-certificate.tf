#------------------------------------------------------------------------------
# ACM Certificate
#------------------------------------------------------------------------------
# Find a certificate issued by (not imported into) ACM
data "aws_acm_certificate" "amazon_issued" {
  domain      = var.domain_name
  types       = ["AMAZON_ISSUED"]
  most_recent = true
}