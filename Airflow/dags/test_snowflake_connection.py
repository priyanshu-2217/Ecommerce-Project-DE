from datetime import datetime
from airflow import DAG
from airflow.providers.common.sql.operators.sql import SQLExecuteQueryOperator


with DAG(
    dag_id="test_snowflake_connection",
    start_date=datetime(2025, 1, 1),
    schedule=None,
    catchup=False,
    tags=["test", "snowflake"],
) as dag:

    test_task = SQLExecuteQueryOperator(
        task_id="test_snowflake",
        conn_id="snowflake_default",
        sql="""
        SELECT 
            CURRENT_VERSION() AS version,
            CURRENT_USER() AS user,
            CURRENT_ROLE() AS role,
            CURRENT_WAREHOUSE() AS warehouse;
        """,
    )