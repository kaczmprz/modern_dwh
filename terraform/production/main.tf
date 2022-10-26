provider "aws" {
    access_key = "${var.aws_access_key}"
    secret_key = "${var.aws_secret_key}"
    region = "${var.region}"
}

module "s3" {
    source = "../modules/s3"
}

module "snowflake" {
    source = "../modules/snowflake"
}