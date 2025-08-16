module "cached_bucket" {
  source = "git::https://github.com/afneville/cached-bucket-tf.git?ref=v1"

  providers = {
    aws.n-virginia = aws.n-virginia
  }

  bucket_name = var.bucket_name
  subdomain   = var.subdomain
  domain      = var.domain
}
