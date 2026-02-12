{{ config(materialized='table') }}

-- Version 1: from local Bronze
with cleaned as (
    select
        customer_id,
        upper(first_name) as first_name,
        upper(last_name) as last_name,
        email,
        _loaded_at
    from {{ ref('bronze_customers') }}
)

-- Version 2: from GCS / staging (commented)
-- with cleaned as (
--     select
--         customer_id,
--         upper(first_name) as first_name,
--         upper(last_name) as last_name,
--         email,
--         _loaded_at
--     from external_stage_customers
-- )

select * from cleaned
