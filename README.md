# Description

This project is proof of concept how you can use Snowflake, Terraform, Prefect and AWS S3 bucket together to create your own data warehouse. 


![architecture drawio](https://user-images.githubusercontent.com/111633053/200112366-d756d4d8-9954-4358-9970-1472bf122ce9.png)


## Prerequisities

1. Create account in AWS https://aws.amazon.com/
2. Create account in Snowflake https://signup.snowflake.com/
3. Configure connection with AWS CLI https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-quickstart.html
4. Crete technical user for Terraform in Snowflake. 
  4.1. Go to ~/.ssh catalog and create private key and copy public key
  ```
  cd ~/.ssh
  openssl rsa -in snowflake_tf_snow_key.p8 -pubout -out snowflake_tf_snow_key.pub
  clip < ~/.ssh/snowflake_tf_snow_key.pub
  ```
  4.2. Go to Snowflake and create user and paste public key
  ```
  USE ROLE SECURITYADMIN;
  CREATE USER "tf-snow" 
  RSA_PUBLIC_KEY='<<paste here RSA_PUBLIC_KEY>>' 
  DEFAULT_ROLE=PUBLIC 
  MUST_CHANGE_PASSWORD=FALSE;
  GRANT ROLE SYSADMIN TO USER "tf-snow";
  GRANT ROLE SECURITYADMIN TO USER "tf-snow";

  ```
