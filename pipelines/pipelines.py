from prefect import task, flow
from prefect.filesystems import S3
from prefect_snowflake.database import SnowflakeConnector, SnowflakeCredentials
from prefect_snowflake.database import snowflake_query, snowflake_multiquery
from datetime import datetime

s3_block = S3.load("s3-retail")
snowflake_connector = SnowflakeConnector.load("snowflake-connector-retail")

now = datetime.now()
year, month, day = now.year, now.month, now.day

def etl_load_stage(table: str, columns: list, stage: str, path: str, params: dict):
    columns_ = ", ".join(columns)
    stage_columns = ["replace($" + str(i+1) + ",'\"','')" for i in range(len(columns))]
    stage_columns_ = ", ".join(stage_columns)

    truncate_stage_table = f"truncate stage.{table}"

    load_stage_table = f"insert into stage.{table} ({columns_}, filename, load_ts) select {stage_columns_}, metadata$filename, current_timestamp" \
                       f" from @{stage}/{path}/%(year)s/%(month)s/%(day)s"

    result_truncate = snowflake_query(
        query = truncate_stage_table,
        snowflake_connector = snowflake_connector
    )

    result_load = snowflake_query(
        query = load_stage_table,
        snowflake_connector = snowflake_connector,
        params=params
    )
    return result_load, result_truncate


def etl_load_prod(table: str):
    load_prod_table = f"call stage.load_dim_{table}()"
    result = snowflake_query(
        query = load_prod_table,
        snowflake_connector = snowflake_connector
    )
    return result

@flow
def etl_load_dim_customer_flow():
    params = {"day": day,
              "month": month,
              "year": year}
    etl_load_stage('customer', ['name', 'birth_date', 'town', 'email'], 'mdw_staging', 'customers', params)
    etl_load_prod('customer')

@flow
def etl_load_dim_product_flow():
    params = {"day": day,
              "month": month,
              "year": year}
    etl_load_stage('product', ['ean', 'category', 'net_price'], 'mdw_staging', 'products', params)
    etl_load_prod('product')

@flow
def etl_load_dim_shop_flow():
    params = {"day": day,
              "month": month,
              "year": year}
    etl_load_stage('shops', ['id', 'city'], 'mdw_staging', 'shops', params)
    etl_load_prod('shops')


etl_load_dim_customer_flow()
etl_load_dim_product_flow()
etl_load_dim_shop_flow()