resource "aws_s3_bucket" "content_bucket" {
  bucket        = var.bucket_name
  force_destroy = true
}

resource "aws_s3_bucket_public_access_block" "content_bucket_public_access_block" {
  bucket                  = aws_s3_bucket.content_bucket.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_policy" "content_bucket_policy" {
  bucket = aws_s3_bucket.content_bucket.id
  policy = data.aws_iam_policy_document.content_bucket_policy_document.json
}

resource "aws_cloudfront_origin_access_control" "cloudfront_s3_oac" {
  name                              = "${aws_s3_bucket.content_bucket.bucket}-oac"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}

data "aws_iam_policy_document" "content_bucket_policy_document" {
  statement {
    actions   = ["s3:GetObject"]
    resources = ["${aws_s3_bucket.content_bucket.arn}/*"]
    principals {
      type        = "Service"
      identifiers = ["cloudfront.amazonaws.com"]
    }
    condition {
      test     = "StringEquals"
      variable = "AWS:SourceArn"
      values   = [aws_cloudfront_distribution.cdn.arn]
    }
  }
}

resource "aws_cloudfront_distribution" "cdn" {
  enabled             = true
  default_root_object = "index.html"
  aliases             = [var.subdomain]
  custom_error_response {
    error_code         = 404
    response_code      = 404
    response_page_path = "/error.html"
  }
  custom_error_response {
    error_code         = 403
    response_code      = 403
    response_page_path = "/error.html"
  }
  default_cache_behavior {
    allowed_methods        = ["GET", "HEAD"]
    cached_methods         = ["GET", "HEAD"]
    target_origin_id       = aws_s3_bucket.content_bucket.bucket
    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }
  }
  viewer_certificate {
    acm_certificate_arn      = aws_acm_certificate.acm_certificate.arn
    ssl_support_method       = "sni-only"
    minimum_protocol_version = "TLSv1"
  }
  origin {
    domain_name              = aws_s3_bucket.content_bucket.bucket_regional_domain_name
    origin_access_control_id = aws_cloudfront_origin_access_control.cloudfront_s3_oac.id
    origin_id                = aws_s3_bucket.content_bucket.bucket
  }
  restrictions {
    geo_restriction {
      restriction_type = "none"
      locations        = []
    }
  }
}

data "aws_route53_zone" "hosted_zone" {
  provider = aws.n-virginia
  name     = var.domain
}

resource "aws_acm_certificate" "acm_certificate" {
  provider          = aws.n-virginia
  domain_name       = var.subdomain
  validation_method = "DNS"
}

resource "aws_route53_record" "domain_validation_options" {
  provider = aws.n-virginia
  for_each = {
    for dvo in aws_acm_certificate.acm_certificate.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = data.aws_route53_zone.hosted_zone.zone_id
}

resource "aws_acm_certificate_validation" "example" {
  provider                = aws.n-virginia
  certificate_arn         = aws_acm_certificate.acm_certificate.arn
  validation_record_fqdns = [for record in aws_route53_record.domain_validation_options : record.fqdn]
}

resource "aws_route53_record" "cloudfront_domain" {
  provider = aws.n-virginia
  zone_id  = data.aws_route53_zone.hosted_zone.zone_id
  name     = var.subdomain
  type     = "A"
  alias {
    name                   = aws_cloudfront_distribution.cdn.domain_name
    zone_id                = aws_cloudfront_distribution.cdn.hosted_zone_id
    evaluate_target_health = false
  }
}

output "distribution_id" {
  value = aws_cloudfront_distribution.cdn.id
}
