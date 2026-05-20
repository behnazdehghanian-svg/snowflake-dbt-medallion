{{ config(materialized='table') }}

with cleaned as (
    select
        customer_id,
        upper(first_name) as first_name,
        upper(last_name) as last_name,
        email,
        _loaded_at
    from {{ ref('bronze_customers') }}
)


select * from cleaned
