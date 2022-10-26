from prefect import task, flow
from prefect.filesystems import S3
from prefect_snowflake.database import SnowflakeConnector, SnowflakeCredentials
from prefect_snowflake.database import snowflake_query, snowflake_multiquery

s3_block = S3.load("s3-retail")
snowflake_connector = SnowflakeConnector.load("snowflake-connector-retail")

@flow
def etl_load_dim(table: str, columns: list, natural_key: str, stage: str, path: str):
    columns_ = ", ".join(columns)
    stage_columns = ["replace($" + str(i+1) + ",'\"','')" for i in range(len(columns))]
    stage_columns_ = ", ".join(stage_columns)

    load_stage_table = f"insert into stage.{table} ({columns_}, filename, load_ts) select {stage_columns_}, metadata$filename, current_timestamp" \
                       f" from @{stage}/{path}/%(year)s/%(month)s/%(day)s"

    load_prod_table = f"merge into prod.dim_{table} p using stage.{table} s on p.{natural_key}=s.{natural_key} " \
                      f"when not matched then insert (pk, {columns_}, is_valid, valid_from, valid_to, modification_ts) " \
                      f"values (prod.\"seq_{table}\".nextval, {columns_}, true, current_timestamp, '9999-12-31', current_timestamp)" \
                      f"when matched then "
    result = snowflake_multiquery(
        [load_stage_table],
        snowflake_connector,
        params={"day": 26,
                "month": 10,
                "year": 2022},
        as_transaction=True
    )
    return result



@flow
def etl_load_dim_customer_flow():
    etl_load_dim('customer', ['name', 'birth_date', 'town', 'email'], 'email', 'mdw_staging', 'customers')

def etl_load_dim_product_flow():
    etl_load_dim('product', ['ean', 'category', 'net_price'], 'ean', 'mdw_staging', 'products')

def etl_load_dim_shop_flow():
    etl_load_dim('shops', ['id', 'city'], 'id', 'mdw_staging', 'shops')


etl_load_dim_customer_flow()
etl_load_dim_product_flow()
etl_load_dim_shop_flow()