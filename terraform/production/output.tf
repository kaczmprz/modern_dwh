output "aws_storage_aws_role_arn" {
  description = "AWS mysnowflakerole arn"
  value = "${module.iam.aws_storage_aws_role_arn}"
  sensitive = true
}

output "snowflake_integration_storage_aws_iam_user_arn" {
  value = "${module.snowflake.snowflake_integration_storage_aws_iam_user_arn}"
  sensitive = true
}

output "snowflake_integration_storage_aws_external_id" {
  value = "${module.snowflake.snowflake_integration_storage_aws_external_id}"
  sensitive = true
}

output "snowflake_pipe_notification_channel" {
  value = "${module.snowflake.snowflake_pipe_notification_channel}"
  sensitive = true
}