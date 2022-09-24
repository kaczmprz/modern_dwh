resource "aws_s3_bucket" "staging" {
    bucket = "${var.bucket_name}"
    acl = "${var.acl_value}"
}