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

/*
resource "aws_s3_bucket_policy" "allow_access_from_snowflake" {
  bucket = aws_s3_bucket.staging_bucket.id
  policy = <<POLICY
  {
    "Version": "2012-10-17",
    "Statement": [
      {
        "Effect": "Allow",
        "Principal": "*",
        "Action": [
          "s3:GetObject",
          "s3:GetObjectVersion"
        ],
        "Resource": [
          "${aws_s3_bucket.staging_bucket.arn}",
          "${aws_s3_bucket.staging_bucket.arn}/*"
          ]
      },
      {
        "Effect": "Allow",
        "Principal": "*",
        "Action": [
          "s3:ListBucket",
          "s3:GetBucketLocation"
        ],
        "Resource": [
          "${aws_s3_bucket.staging_bucket.arn}",
          "${aws_s3_bucket.staging_bucket.arn}/*"
          ]
      }
    ]
  }
  POLICY
}
*/

/*
resource "aws_sqs_queue" "queue" {
  name                      = "s3-event-notification-queue"
  delay_seconds             = 10
  max_message_size          = 2048
  message_retention_seconds = 60
  receive_wait_time_seconds = 10
}
*/
/*
resource "aws_s3_bucket_notification" "staging_bucket_notification" {
  bucket = aws_s3_bucket.staging_bucket.id

  queue {
    queue_arn     = aws_sqs_queue.queue.arn
    events        = ["s3:ObjectCreated:*"]
    filter_prefix = "orders/"
    filter_suffix = ".json"
  }
}
*/