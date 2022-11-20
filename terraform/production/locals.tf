locals {
    aws_storage_aws_role_arn = "arn:aws:iam::${var.aws_accountid}:role/${var.aws_iam_snowflakerole_name}"
}