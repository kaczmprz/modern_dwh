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

resource "aws_iam_policy" "snowflake_access2" {
  name        = "snowflake_access2"
  path        = "/"
  description = "Access for Snowflake"
  policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "s3:GetObject",
                "s3:GetObjectVersion"
            ],
            "Resource": "arn:aws:s3:::${var.bucket_name}/*"
        },
        {
            "Effect": "Allow",
            "Action": [
                "s3:ListBucket",
                "s3:GetBucketLocation"
            ],
            "Resource": "arn:aws:s3:::${var.bucket_name}",
            "Condition": {
                "StringLike": {
                    "s3:prefix": [
                        "*"
                    ]
                }
            }
        }
    ]
  })
}

resource "aws_iam_role" "mysnowflakerole2" {
  name                = "mysnowflakerole2"
  assume_role_policy  = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "",
            "Effect": "Allow",
            "Principal": {
                "AWS": "arn:aws:iam::230814635691:user/jlo20000-s"
            },
            "Action": "sts:AssumeRole",
            "Condition": {
                "StringEquals": {
                    "sts:ExternalId": "AT21246_SFCRole=2_WwmlUrbHjl2UvQYlvlE2+sq0rzI="
                }
            }
        }
    ]
})
  managed_policy_arns = [aws_iam_policy.snowflake_access2.arn]
}



resource "aws_s3_bucket_notification" "orders2" {
  bucket = aws_s3_bucket.staging_bucket.id

  queue {
    queue_arn     = "arn:aws:sqs:eu-central-1:230814635691:sf-snowpipe-AIDATLPM722V2ACBR7BQX-iRwsYJrDLQDAw_SJn31G_A"
    events        = ["s3:ObjectCreated:*"]
    filter_prefix = "orders/"
    filter_suffix = ".json"
  }
}
