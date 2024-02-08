{{
    config(
        tags = ["meds"],
    )
}}

with sales_data as (
    select * from {{ source('raw','sales_data') }}
),
filtered_data as (
    select 
        country,
        city 
    from sales_data
    extract(year from sold_product_created_at) = extract(year from current_date) - 1
    group by 1,2
    having count(facility_id) >=3
    order by 1
)
select 
    sales_data.country,
    sales_data.api_sold_product as product_name,
    sum(quantity_sold) as total_sold,
    avg(unit_price) as average_price,
    min(sold_product_created_at) as first_sale,
    max(sold_product_created_at) as last_sale
from sales_data 
inner join filtered_data
on filtered_data.country=sales_data.country
and filtered_data.city=sales_data.city
group by 1,2
order by 1,2