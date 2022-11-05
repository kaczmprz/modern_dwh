resource "snowflake_procedure" "LOAD_DIM_CUSTOMER" {
  provider            = snowflake.sysadmin
  name                = "LOAD_DIM_CUSTOMER"
  database            = snowflake_database.database["RETAIL"].name
  schema              = snowflake_schema.schema["STAGE"].name
  language            = "JAVASCRIPT"
  comment             = "Procedure for loading data to DIM_CUSTOMER table"
  return_type         = "VARCHAR"
  execute_as          = "CALLER"
  return_behavior     = "IMMUTABLE"
  null_input_behavior = "RETURNS NULL ON NULL INPUT"
  statement           = <<EOT
    var sql_get_timestamp = "SELECT TO_VARCHAR(CURRENT_TIMESTAMP::TIMESTAMP_NTZ)";
    var stmt_sql_get_timestamp = snowflake.createStatement({sqlText: sql_get_timestamp});
    var result_timestamp = stmt_sql_get_timestamp.execute();
    result_timestamp.next();
    var vtimestamp = result_timestamp.getColumnValue(1);

    var sql_create_tmp_table = `CREATE OR REPLACE TEMP TABLE STAGE.TMP_DIM_CUSTOMER
    AS
    SELECT
        BIRTH_DATE,
        EMAIL,
        IS_VALID,
        MODIFICATION_TS,
        NAME,
        TOWN,
        VALID_FROM,
        VALID_TO,
        HASH
    FROM PROD.DIM_CUSTOMER LIMIT 0;`;

    var stmt_sql_create_tmp_table = snowflake.createStatement({sqlText: sql_create_tmp_table});

    var sql_insert_into_tmp_table = `INSERT INTO STAGE.TMP_DIM_CUSTOMER
    (
    BIRTH_DATE,
    EMAIL,
    IS_VALID,
    MODIFICATION_TS,
    NAME,
    TOWN,
    VALID_FROM,
    VALID_TO,
    HASH
    )
    SELECT
    BIRTH_DATE,
    EMAIL,
    TRUE,
    '` + vtimestamp + `' MODIFICATION_TS,
    NAME,
    TOWN,
    '` + vtimestamp + `' VALID_FROM,
    '9999-12-31' VALID_TO,
    HASH(BIRTH_DATE, NAME, TOWN)
    FROM STAGE.CUSTOMER
    QUALIFY ROW_NUMBER() OVER(PARTITION BY EMAIL ORDER BY TO_TIMESTAMP_NTZ(SPLIT_PART(SPLIT_PART(SPLIT_PART(FILENAME, '/', 5), '_',2),'.',1),'YYYYMMDDHHMISS') DESC)=1
    ;`;

    var stmt_sql_insert_into_tmp_table = snowflake.createStatement({sqlText: sql_insert_into_tmp_table});

    var sql_insert1_into_table = `INSERT INTO PROD.DIM_CUSTOMER
    (
    PK,
    BIRTH_DATE,
    EMAIL,
    IS_VALID,
    MODIFICATION_TS,
    NAME,
    TOWN,
    VALID_FROM,
    VALID_TO,
    HASH
    )
    SELECT
        PROD."seq_customer".nextval,
        S.BIRTH_DATE,
        S.EMAIL,
        S.IS_VALID,
        S.MODIFICATION_TS,
        S.NAME,
        S.TOWN,
        S.VALID_FROM,
        S.VALID_TO,
        S.HASH
    FROM STAGE.TMP_DIM_CUSTOMER S
    LEFT JOIN PROD.DIM_CUSTOMER P
        ON P.EMAIL=S.EMAIL
    WHERE P.EMAIL IS NULL
    ;`;
    var sql_insert2_into_table = `INSERT INTO PROD.DIM_CUSTOMER
    (
    PK,
    BIRTH_DATE,
    EMAIL,
    IS_VALID,
    MODIFICATION_TS,
    NAME,
    TOWN,
    VALID_FROM,
    VALID_TO,
    HASH
    )
    SELECT
        PROD."seq_customer".nextval,
        S.BIRTH_DATE,
        S.EMAIL,
        S.IS_VALID,
        S.MODIFICATION_TS,
        S.NAME,
        S.TOWN,
        S.VALID_FROM,
        S.VALID_TO,
        S.HASH
    FROM STAGE.TMP_DIM_CUSTOMER S
    INNER JOIN PROD.DIM_CUSTOMER P
        ON P.EMAIL=S.EMAIL
        AND P.IS_VALID=TRUE
    WHERE P.HASH<>S.HASH
    ;`;
    var sql_update_table = `UPDATE PROD.DIM_CUSTOMER P
      SET P.IS_VALID = FALSE,
        P.MODIFICATION_TS = S.MODIFICATION_TS,
        P.VALID_TO = TIMESTAMPADD(SECOND, -1, S.MODIFICATION_TS)
      FROM STAGE.TMP_DIM_CUSTOMER AS S
      WHERE P.EMAIL=S.EMAIL
        AND P.IS_VALID=TRUE
        AND P.HASH<>S.HASH
    ;`;
    var stmt_sql_insert1_into_table = snowflake.createStatement({sqlText: sql_insert1_into_table});
    var stmt_sql_insert2_into_table = snowflake.createStatement({sqlText: sql_insert2_into_table});
    var stmt_sql_update_table = snowflake.createStatement({sqlText: sql_update_table});
    stmt_sql_create_tmp_table.execute();
    stmt_sql_insert_into_tmp_table.execute();
    stmt_sql_insert1_into_table.execute();
    stmt_sql_insert2_into_table.execute();
    stmt_sql_update_table.execute();
    return '1'
EOT
}

resource "snowflake_procedure" "LOAD_DIM_PRODUCT" {
  provider            = snowflake.sysadmin
  name                = "LOAD_DIM_PRODUCT"
  database            = snowflake_database.database["RETAIL"].name
  schema              = snowflake_schema.schema["STAGE"].name
  language            = "JAVASCRIPT"
  comment             = "Procedure for loading data to DIM_PRODUCT table"
  return_type         = "VARCHAR"
  execute_as          = "CALLER"
  return_behavior     = "IMMUTABLE"
  null_input_behavior = "RETURNS NULL ON NULL INPUT"
  statement           = <<EOT
    var sql_get_timestamp = "SELECT TO_VARCHAR(CURRENT_TIMESTAMP::TIMESTAMP_NTZ)";
    var stmt_sql_get_timestamp = snowflake.createStatement({sqlText: sql_get_timestamp});
    var result_timestamp = stmt_sql_get_timestamp.execute();
    result_timestamp.next();
    var vtimestamp = result_timestamp.getColumnValue(1);

    var sql_create_tmp_table = `CREATE OR REPLACE TEMP TABLE STAGE.TMP_DIM_PRODUCT
    AS
    SELECT
      CATEGORY,
      EAN,
      HASH,
      IS_VALID,
      MODIFICATION_TS,
      NET_PRICE,
      VALID_FROM,
      VALID_TO
    FROM PROD.DIM_PRODUCT LIMIT 0;`;

    var stmt_sql_create_tmp_table = snowflake.createStatement({sqlText: sql_create_tmp_table});

    var sql_insert_into_tmp_table = `INSERT INTO STAGE.TMP_DIM_PRODUCT
    (
    CATEGORY,
    EAN,
    HASH,
    IS_VALID,
    MODIFICATION_TS,
    NET_PRICE,
    VALID_FROM,
    VALID_TO
    )
    SELECT
    CATEGORY,
    EAN,
    HASH(CATEGORY, NET_PRICE),
    TRUE,
    '` + vtimestamp + `' MODIFICATION_TS,
    NET_PRICE,
    '` + vtimestamp + `' VALID_FROM,
    '9999-12-31' VALID_TO
    FROM STAGE.PRODUCT
    QUALIFY ROW_NUMBER() OVER(PARTITION BY EAN ORDER BY TO_TIMESTAMP_NTZ(SPLIT_PART(SPLIT_PART(SPLIT_PART(FILENAME, '/', 5), '_',2),'.',1),'YYYYMMDDHHMISS') DESC)=1
    ;`;

    var stmt_sql_insert_into_tmp_table = snowflake.createStatement({sqlText: sql_insert_into_tmp_table});

    var sql_insert1_into_table = `INSERT INTO PROD.DIM_PRODUCT
    (
    PK,
    CATEGORY,
    EAN,
    HASH,
    IS_VALID,
    MODIFICATION_TS,
    NET_PRICE,
    VALID_FROM,
    VALID_TO
    )
    SELECT
        PROD."seq_product".nextval,
        S.CATEGORY,
        S.EAN,
        S.HASH,
        S.IS_VALID,
        S.MODIFICATION_TS,
        S.NET_PRICE,
        S.VALID_FROM,
        S.VALID_TO
    FROM STAGE.TMP_DIM_PRODUCT S
    LEFT JOIN PROD.DIM_PRODUCT P
        ON P.EAN=S.EAN
    WHERE P.EAN IS NULL
    ;`;
    var sql_insert2_into_table = `INSERT INTO PROD.DIM_PRODUCT
    (
    PK,
    CATEGORY,
    EAN,
    HASH,
    IS_VALID,
    MODIFICATION_TS,
    NET_PRICE,
    VALID_FROM,
    VALID_TO
    )
    SELECT
        PROD."seq_product".nextval,
        S.CATEGORY,
        S.EAN,
        S.HASH,
        S.IS_VALID,
        S.MODIFICATION_TS,
        S.NET_PRICE,
        S.VALID_FROM,
        S.VALID_TO
    FROM STAGE.TMP_DIM_PRODUCT S
    INNER JOIN PROD.DIM_PRODUCT P
        ON P.EAN=S.EAN
        AND P.IS_VALID=TRUE
    WHERE P.HASH<>S.HASH
    ;`;
    var sql_update_table = `UPDATE PROD.DIM_PRODUCT P
      SET P.IS_VALID = FALSE,
        P.MODIFICATION_TS = S.MODIFICATION_TS,
        P.VALID_TO = TIMESTAMPADD(SECOND, -1, S.MODIFICATION_TS)
      FROM STAGE.TMP_DIM_PRODUCT AS S
      WHERE P.EAN=S.EAN
        AND P.IS_VALID=TRUE
        AND P.HASH<>S.HASH
    ;`;
    var stmt_sql_insert1_into_table = snowflake.createStatement({sqlText: sql_insert1_into_table});
    var stmt_sql_insert2_into_table = snowflake.createStatement({sqlText: sql_insert2_into_table});
    var stmt_sql_update_table = snowflake.createStatement({sqlText: sql_update_table});
    stmt_sql_create_tmp_table.execute();
    stmt_sql_insert_into_tmp_table.execute();
    stmt_sql_insert1_into_table.execute();
    stmt_sql_insert2_into_table.execute();
    stmt_sql_update_table.execute();
    return '1'
EOT
}

resource "snowflake_procedure" "LOAD_DIM_SHOPS" {
  provider            = snowflake.sysadmin
  name                = "LOAD_DIM_SHOPS"
  database            = snowflake_database.database["RETAIL"].name
  schema              = snowflake_schema.schema["STAGE"].name
  language            = "JAVASCRIPT"
  comment             = "Procedure for loading data to DIM_SHOPS table"
  return_type         = "VARCHAR"
  execute_as          = "CALLER"
  return_behavior     = "IMMUTABLE"
  null_input_behavior = "RETURNS NULL ON NULL INPUT"
  statement           = <<EOT
    var sql_get_timestamp = "SELECT TO_VARCHAR(CURRENT_TIMESTAMP::TIMESTAMP_NTZ)";
    var stmt_sql_get_timestamp = snowflake.createStatement({sqlText: sql_get_timestamp});
    var result_timestamp = stmt_sql_get_timestamp.execute();
    result_timestamp.next();
    var vtimestamp = result_timestamp.getColumnValue(1);

    var sql_create_tmp_table = `CREATE OR REPLACE TEMP TABLE STAGE.TMP_DIM_SHOPS
    AS
    SELECT
      CITY,
      HASH,
      ID,
      IS_VALID,
      MODIFICATION_TS,
      VALID_FROM,
      VALID_TO
    FROM PROD.DIM_SHOPS LIMIT 0;`;

    var stmt_sql_create_tmp_table = snowflake.createStatement({sqlText: sql_create_tmp_table});

    var sql_insert_into_tmp_table = `INSERT INTO STAGE.TMP_DIM_SHOPS
    (
      CITY,
      HASH,
      ID,
      IS_VALID,
      MODIFICATION_TS,
      VALID_FROM,
      VALID_TO
    )
    SELECT
    CITY,
    HASH(CITY),
    ID,
    TRUE,
    '` + vtimestamp + `' MODIFICATION_TS,
    '` + vtimestamp + `' VALID_FROM,
    '9999-12-31' VALID_TO
    FROM STAGE.SHOPS
    QUALIFY ROW_NUMBER() OVER(PARTITION BY ID ORDER BY TO_TIMESTAMP_NTZ(SPLIT_PART(SPLIT_PART(SPLIT_PART(FILENAME, '/', 5), '_',2),'.',1),'YYYYMMDDHHMISS') DESC)=1
    ;`;

    var stmt_sql_insert_into_tmp_table = snowflake.createStatement({sqlText: sql_insert_into_tmp_table});

    var sql_insert1_into_table = `INSERT INTO PROD.DIM_SHOPS
    (
      PK,
      CITY,
      HASH,
      ID,
      IS_VALID,
      MODIFICATION_TS,
      VALID_FROM,
      VALID_TO
    )
    SELECT
        PROD."seq_shops".nextval,
        S.CITY,
        S.HASH,
        S.ID,
        S.IS_VALID,
        S.MODIFICATION_TS,
        S.VALID_FROM,
        S.VALID_TO
    FROM STAGE.TMP_DIM_SHOPS S
    LEFT JOIN PROD.DIM_SHOPS P
        ON P.ID=S.ID
    WHERE P.ID IS NULL
    ;`;
    var sql_insert2_into_table = `INSERT INTO PROD.DIM_SHOPS
    (
      PK,
      CITY,
      HASH,
      ID,
      IS_VALID,
      MODIFICATION_TS,
      VALID_FROM,
      VALID_TO
    )
    SELECT
        PROD."seq_shops".nextval,
        S.CITY,
        S.HASH,
        S.ID,
        S.IS_VALID,
        S.MODIFICATION_TS,
        S.VALID_FROM,
        S.VALID_TO
    FROM STAGE.TMP_DIM_SHOPS S
    INNER JOIN PROD.DIM_SHOPS P
        ON P.ID=S.ID
        AND P.IS_VALID=TRUE
    WHERE P.HASH<>S.HASH
    ;`;
    var sql_update_table = `UPDATE PROD.DIM_SHOPS P
      SET P.IS_VALID = FALSE,
        P.MODIFICATION_TS = S.MODIFICATION_TS,
        P.VALID_TO = TIMESTAMPADD(SECOND, -1, S.MODIFICATION_TS)
      FROM STAGE.TMP_DIM_SHOPS AS S
      WHERE P.ID=S.ID
        AND P.IS_VALID=TRUE
        AND P.HASH<>S.HASH
    ;`;
    var stmt_sql_insert1_into_table = snowflake.createStatement({sqlText: sql_insert1_into_table});
    var stmt_sql_insert2_into_table = snowflake.createStatement({sqlText: sql_insert2_into_table});
    var stmt_sql_update_table = snowflake.createStatement({sqlText: sql_update_table});
    stmt_sql_create_tmp_table.execute();
    stmt_sql_insert_into_tmp_table.execute();
    stmt_sql_insert1_into_table.execute();
    stmt_sql_insert2_into_table.execute();
    stmt_sql_update_table.execute();
    return '1'
EOT
}