from prefect import task, flow
from prefect.filesystems import S3
from prefect_snowflake.database import SnowflakeConnector, SnowflakeCredentials
from prefect_snowflake.database import snowflake_query, snowflake_multiquery

s3_block = S3.load("s3-retail")
snowflake_connector = SnowflakeConnector.load("snowflake-connector-retail")


@flow
def snowflake_multiquery_flow():
    result = snowflake_multiquery(
        ["SELECT * FROM shops WHERE id=%(id)s LIMIT 8;", "SELECT 1,2"],
        snowflake_connector,
        params={"id": 1},
        as_transaction=True
    )
    return result

snowflake_multiquery_flow()