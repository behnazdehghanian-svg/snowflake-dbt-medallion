{{ config(materialized='table') }}

-- Version 1: from local Bronze
with cleaned as (
    select
        order_id,
        customer_id,
        cast(order_date as date) as order_date,
        cast(amount as decimal(10,2)) as amount,
        _status,
        _loaded_at
    from {{ ref('bronze_orders') }}
    where _status in ('completed', 'shipped', 'cancelled')
)

-- Version 2: from GCS / staging (GCP version)
-- with cleaned as (
--     select
--         order_id,
--         customer_id,
--         cast(order_date as date) as order_date,
--         cast(amount as decimal(10,2)) as amount,
--         _status,
--         _loaded_at
--     from external_stage_orders
--     where status in ('completed', 'shipped','cancelled')
-- )

select * from cleaned
