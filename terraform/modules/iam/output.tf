output "aws_storage_aws_role_arn" {
  description = "AWS mysnowflakerole arn"
  value = aws_iam_role.mysnowflakerole.arn
  #sensitive = true
}