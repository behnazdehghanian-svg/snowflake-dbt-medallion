{{ config(materialized='table') }}

-- Version 1: from Silver
with dim as (
    select
        customer_id,
        first_name || ' ' || last_name as full_name,
        email,
        _loaded_at
    from {{ ref('silver_customers') }}
)

-- Version 2: from GCS / staging (commented)
-- with dim as (
--     select
--         customer_id,
--         first_name || ' ' || last_name as full_name,
--         email,
--         _loaded_at
--     from external_stage_customers
-- )

select * from dim
