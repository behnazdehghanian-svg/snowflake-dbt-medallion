{{ config(materialized='table') }}

with customer_spending as (
    -- calculate total spending per customer
    select
        customer_id,
        sum(amount) as total_spent,
        count(order_id) as total_orders
    from {{ ref('silver_orders') }}
    group by customer_id
),

dim as (
    select
        -- surrogate key
        {{ dbt_utils.generate_surrogate_key(['c.customer_id']) }} as customer_key,

        -- customer info
        c.customer_id,
        c.first_name || ' ' || c.last_name as full_name,
        c.email,

        -- spending metrics
        s.total_spent,
        s.total_orders,

        -- business categorization
        case
            when s.total_spent > 500 then 'VIP'
            when s.total_spent > 200 then 'Regular'
            else 'New'
        end as customer_segment,

        c._loaded_at

    from {{ ref('silver_customers') }} c
    left join customer_spending s
        on c.customer_id = s.customer_id
)

select * from dim