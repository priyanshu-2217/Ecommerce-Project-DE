WITH source AS (

    SELECT *
    FROM {{ ref('stg_orders') }}

)

SELECT
    order_id,
    customer_id,
    order_timestamp,
    order_date,
    order_amount,
    order_status,
    payment_method,
    source_file_name,
    loaded_at,

    {{ dbt_utils.generate_surrogate_key(['order_id']) }} AS hk_order_h,

    {{ dbt_utils.generate_surrogate_key(['customer_id']) }} AS hk_customer_h,

    {{ dbt_utils.generate_surrogate_key(['order_id', 'customer_id']) }} AS hk_order_customer_l,

    {{ dbt_utils.generate_surrogate_key([
        'order_amount',
        'order_status',
        'order_timestamp'
    ]) }} AS hd_order_details,

    loaded_at AS load_dts,
    source_file_name AS record_source

FROM source
WHERE order_id IS NOT NULL