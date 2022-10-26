CREATE OR REPLACE PROCEDURE STAGE.LOAD_DIM_CUSTOMER()
RETURNS VARCHAR
LANGUAGE JAVASCRIPT
AS
$$
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
    WHERE LOAD_TS > (SELECT NVL(MAX(MODIFICATION_TS),'1900-01-01') FROM PROD.DIM_CUSTOMER)
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
    LEFT JOIN RETAIL.PROD.DIM_CUSTOMER P
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
    INNER JOIN RETAIL.PROD.DIM_CUSTOMER P
        ON P.EMAIL=S.EMAIL
        AND P.IS_VALID=TRUE
    WHERE P.HASH<>S.HASH
    ;`;

    var sql_update_table = `UPDATE RETAIL.PROD.DIM_CUSTOMER P
      SET P.IS_VALID = FALSE,
        P.MODIFICATION_TS = S.MODIFICATION_TS,
        P.VALID_TO = '9999-12-31'
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
    stmt_sql_insert1_into_table.execute();
    stmt_sql_update_table.execute();

    return '1'

$$ ;