output "snowflake_svc_public_key" {
    value = tls_private_key.svc_key.public_key_pem
    sensitive = true
}
output "snowflake_svc_private_key" {
    value = tls_private_key.svc_key.private_key_pem
    sensitive = true
}

output "snowflake_integration_storage_aws_iam_user_arn" {
    value = snowflake_storage_integration.s3.storage_aws_iam_user_arn
    sensitive = true
}

output "snowflake_integration_storage_aws_external_id" {
    value = snowflake_storage_integration.s3.storage_aws_external_id
    sensitive = true
}

output "snowflake_pipe_notification_channel" {
    value = snowflake_pipe.pipe_orders.notification_channel
    sensitive = true
}
