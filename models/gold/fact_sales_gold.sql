{{ config(materialized='table') }}

with fact as (
    select
        -- surrogate key
        {{ dbt_utils.generate_surrogate_key(['o.order_id']) }} as order_key,

        -- foreign key to dim_customers
        {{ dbt_utils.generate_surrogate_key(['o.customer_id']) }} as customer_key,

        -- order info
        o.order_id,
        o.order_date,
        o.amount,
        o._status,

        -- customer info
        c.first_name || ' ' || c.last_name as customer_name,
        c.email,

        -- business logic
        case
            when o.amount > 200 then 'High Value'
            when o.amount > 100 then 'Medium Value'
            else 'Low Value'
        end as order_category

    from {{ ref('silver_orders') }} o
    left join {{ ref('silver_customers') }} c
        on o.customer_id = c.customer_id
)

select * from fact
