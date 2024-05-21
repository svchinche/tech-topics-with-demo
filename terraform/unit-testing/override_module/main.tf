variable "bucket_prefix" {
  type = string
  default = "test"
}

module "s3_module" {
  source = "./s3"
    bucket_prefix = var.bucket_prefix
}