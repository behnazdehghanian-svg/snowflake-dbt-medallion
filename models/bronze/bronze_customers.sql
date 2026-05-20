{{ 
    config(
        materialized='incremental',
        unique_key='customer_id'
    ) 
}}

-- Version 1: Local/raw table
with source_data as (
    select *
    from {{ source('raw', 'customers') }}
)

-- Version 2: From GCS (commented out)
-- with source_data as (
--     select *
--     from external_stage_customers  -- assume stage on GCS
-- )

, deduplicated as (
    select *
    from (
        select *,
               row_number() over (
                   partition by customer_id
                   order by updated_at desc
               ) as rn
        from source_data
    )
    where rn = 1
)

select
    *,
    current_timestamp() as _loaded_at
    --current_localtimestamp() as _loaded_at
from deduplicated

{% if is_incremental() %}
where updated_at > (select max(updated_at) from {{ this }})
{% endif %}
