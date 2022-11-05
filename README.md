# Description

This project is proof of concept how you can use Snowflake, Terraform, Prefect and AWS S3 bucket together to create your own data warehouse. 


![architecture drawio](https://user-images.githubusercontent.com/111633053/200112366-d756d4d8-9954-4358-9970-1472bf122ce9.png)


## Prerequisities

1. Create account in AWS https://aws.amazon.com/
2. Create account in Snowflake https://signup.snowflake.com/
3. Configure connection with AWS CLI https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-quickstart.html
4. Create technical user for Terraform in Snowflake. 
    * Go to ~/.ssh catalog and create private key and copy public key
    ```
    cd ~/.ssh
    openssl rsa -in snowflake_tf_snow_key.p8 -pubout -out snowflake_tf_snow_key.pub
    clip < ~/.ssh/snowflake_tf_snow_key.pub
    ```
    * Go to Snowflake and create user and paste public key
    ```
    USE ROLE SECURITYADMIN;
    CREATE USER "tf-snow" 
    RSA_PUBLIC_KEY='<<paste here RSA_PUBLIC_KEY>>' 
    DEFAULT_ROLE=PUBLIC 
    MUST_CHANGE_PASSWORD=FALSE;
    GRANT ROLE SYSADMIN TO USER "tf-snow";
    GRANT ROLE SECURITYADMIN TO USER "tf-snow";
    ```
5. Download Terraform https://www.terraform.io/downloads
6. Export enviromental variables
    * Linux
    ```
    $ export SNOWFLAKE_USER="tf-snow"
    $ export SNOWFLAKE_PRIVATE_KEY_PATH="~/.ssh/snowflake_tf_snow_key.p8"
    $ export SNOWFLAKE_ACCOUNT="<<YOUR_ACCOUNT_LOCATOR>>"
    $ export SNOWFLAKE_REGION="<<YOUR_REGION_HERE>>"
    ```
    * Windows
    ```
    SET SNOWFLAKE_USER=tf-snow
    SET SNOWFLAKE_PRIVATE_KEY_PATH=C:\Users\<<YOUR_USER>>\.ssh\snowflake_tf_snow_key.p8
    SET SNOWFLAKE_ACCOUNT="<<YOUR_ACCOUNT_LOCATOR>>"
    SET SNOWFLAKE_REGION="<<YOUR_REGION_HERE>>"
    ```
7. Create virtualenv and clone this repository
    ```
    python -m venv myenv
    cd myenv
    git clone https://github.com/kaczmprz/modern_dwh.git
    ```
8. Activate virtualenv and install packages from requirements.txt
    ```
    pip install -r requirements.txt
    ```
9. Add variable.tf files 
10. Init terraform project in modern_dwh/terraform/production/ path and
    ```
    terraform init
    ```
11. Run terraform plan & apply commands
    ```
    terraform plan
    terraform apply
    ```
