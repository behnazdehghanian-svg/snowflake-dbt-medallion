{{ 
    config(
        materialized='incremental',
        unique_key='order_id'
    ) 
}}

-- Version 1: Local/raw table
with source_data as (
    select *
    from {{ source('raw', 'orders') }}
)



, deduplicated as (
    select *
    from (
        select *,
               row_number() over (
                   partition by order_id 
                   order by updated_at desc
               ) as rn
        from source_data
        where order_id is not null
    )
    where rn = 1
)

select
    * exclude (_loaded_at),
    current_timestamp() as _loaded_at
from deduplicated

{% if is_incremental() %}
where updated_at > (select max(updated_at) from {{ this }})
{% endif %}


