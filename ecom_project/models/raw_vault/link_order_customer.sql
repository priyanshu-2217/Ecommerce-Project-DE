{{
    config(
        materialized='incremental',
        unique_key='hk_order_customer_l'
    )
}}

WITH source AS (

    SELECT DISTINCT
        hk_order_customer_l,
        hk_order_h,
        hk_customer_h,
        order_id,
        customer_id,
        load_dts,
        record_source
    FROM {{ ref('stg_orders_hashed') }}
    WHERE order_id IS NOT NULL
      AND customer_id IS NOT NULL

)

SELECT *
FROM source

{% if is_incremental() %}
WHERE hk_order_customer_l NOT IN (
    SELECT hk_order_customer_l
    FROM {{ this }}
)
{% endif %}