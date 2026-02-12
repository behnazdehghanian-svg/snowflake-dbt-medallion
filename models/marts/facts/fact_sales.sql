{{ config(materialized='table') }}

-- Version 1: from Silver
with fact as (
    select
        o.order_id,
        o.customer_id,
        o.order_date,
        o.amount,
        c.first_name || ' ' || c.last_name as customer_name
    from {{ ref('silver_orders') }} o
    left join {{ ref('silver_customers') }} c
        on o.customer_id = c.customer_id
)

-- Version 2: from GCS / staging (commented)
-- with fact as (
--     select
--         o.order_id,
--         o.customer_id,
--         o.order_date,
--         o.amount,
--         c.first_name || ' ' || c.last_name as customer_name
--     from external_stage_orders o
--     left join external_stage_customers c
--         on o.customer_id = c.customer_id
-- )

select * from fact
