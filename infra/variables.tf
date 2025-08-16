variable "bucket_name" {
  description = "The name of the S3 bucket for content."
  type        = string
}

variable "subdomain" {
  description = "The subdomain for the CloudFront distribution (e.g., www.example.com)."
  type        = string
}

variable "domain" {
  description = "The root domain for Route53 (e.g., example.com)."
  type        = string
}
