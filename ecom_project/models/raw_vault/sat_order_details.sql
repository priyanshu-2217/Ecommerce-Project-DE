{{
    config(
        materialized='incremental',
        unique_key=['hk_order_h', 'load_dts']
    )
}}

WITH source AS (

    SELECT
        hk_order_h,
        order_amount,
        order_status,
        payment_method,
        order_timestamp,
        order_date,
        hd_order_details,
        load_dts,
        record_source
    FROM {{ ref('stg_orders_hashed') }}
    WHERE hk_order_h IS NOT NULL

),

latest AS (

    {% if is_incremental() %}

    SELECT
        hk_order_h,
        hd_order_details
    FROM {{ this }}
    QUALIFY ROW_NUMBER() OVER (
        PARTITION BY hk_order_h
        ORDER BY load_dts DESC
    ) = 1

    {% else %}

    SELECT
        NULL AS hk_order_h,
        NULL AS hd_order_details
    WHERE 1 = 0

    {% endif %}

)

SELECT s.*
FROM source s
LEFT JOIN latest l
    ON s.hk_order_h = l.hk_order_h
WHERE l.hd_order_details IS NULL
   OR s.hd_order_details <> l.hd_order_details