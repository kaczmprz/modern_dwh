resource "aws_iam_policy" "snowflake_access" {
  name        = "snowflake_access"
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

resource "aws_iam_role" "mysnowflakerole" {
  name                = var.aws_iam_snowflakerole_name
  assume_role_policy  = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "",
            "Effect": "Allow",
            "Principal": {
                "AWS": var.snowflake_integration_storage_aws_iam_user_arn
            },
            "Action": "sts:AssumeRole",
            "Condition": {
                "StringEquals": {
                    "sts:ExternalId": var.snowflake_integration_storage_aws_external_id
                }
            }
        }
    ]
})
  managed_policy_arns = [aws_iam_policy.snowflake_access.arn]
}