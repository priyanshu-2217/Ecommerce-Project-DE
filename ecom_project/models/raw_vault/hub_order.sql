{{
    config(
        materialized='incremental',
        unique_key='hk_order_h'
    )
}}

WITH source AS (

    SELECT DISTINCT
        hk_order_h,
        order_id,
        load_dts,
        record_source
    FROM {{ ref('stg_orders_hashed') }}
    WHERE order_id IS NOT NULL

)

SELECT *
FROM source

{% if is_incremental() %}
WHERE hk_order_h NOT IN (
    SELECT hk_order_h
    FROM {{ this }}
)
{% endif %}