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


resource "aws_s3_bucket_notification" "orders" {
  bucket = aws_s3_bucket.staging_bucket.id

  queue {
    queue_arn     = var.snowflake_pipe_notification_channel
    events        = ["s3:ObjectCreated:*"]
    filter_prefix = "orders/"
    filter_suffix = ".json"
  }
}
