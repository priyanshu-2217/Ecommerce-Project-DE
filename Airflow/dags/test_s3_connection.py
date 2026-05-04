from datetime import datetime
from airflow import DAG
from airflow.operators.python import PythonOperator
from airflow.providers.amazon.aws.hooks.s3 import S3Hook


def test_s3_connection():
    hook = S3Hook(aws_conn_id="s3_default")

    # Just try listing buckets (no file needed)
    response = hook.get_conn().list_buckets()

    print("✅ S3 connection successful")
    print("Buckets:", response.get("Buckets", []))


with DAG(
    dag_id="test_s3_connection",
    start_date=datetime(2025, 1, 1),
    schedule=None,
    catchup=False,
    tags=["test", "s3"],
) as dag:

    test_task = PythonOperator(
        task_id="test_s3",
        python_callable=test_s3_connection,
    )