provider "aws" {
    access_key = "${var.aws_access_key}"
    secret_key = "${var.aws_secret_key}"
    region = "${var.region}"
}

module "iam" {
    source = "../modules/iam"
    snowflake_integration_storage_aws_iam_user_arn = module.snowflake.snowflake_integration_storage_aws_iam_user_arn
    snowflake_integration_storage_aws_external_id = module.snowflake.snowflake_integration_storage_aws_external_id
    bucket_name = var.bucket_name
    depends_on = [module.s3.aws_s3_bucket]
}

module "s3" {
    source = "../modules/s3"
    snowflake_pipe_notification_channel = module.snowflake.snowflake_pipe_notification_channel
    bucket_name = var.bucket_name
    depends_on = [module.snowflake.snowflake_pipe]
}

module "snowflake" {
    source = "../modules/snowflake"
    bucket_name = var.bucket_name
    region = var.region
    aws_access_key = var.aws_access_key
    aws_secret_key = var.aws_secret_key
    aws_storage_aws_role_arn = var.aws_storage_aws_role_arn
}