resource "aws_s3_bucket" "staging_bucket" {
  bucket = "${var.bucket_name}"
  tags = {
    Name = "stage"
    Environment = "dev"
  }
}

resource "aws_s3_bucket_acl" "staging_bucket_acl" {
  bucket = aws_s3_bucket.staging_bucket.id
  acl    = "private"
}