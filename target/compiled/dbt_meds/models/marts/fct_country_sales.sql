

with sales_data as (
    select * from public.raw_data.sales_data
),
filtered_data as (
    select 
        country,
        api_sold_product 
    from sales_data
    where extract(year from sold_product_created_at) = extract(year from current_date) - 1
    group by 1,2
    having count(*) >3
    order by 1
),
final as (
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
    and filtered_data.api_sold_product=sales_data.api_sold_product
    group by 1,2
    order by 1,2
)
select 
    country,
    product_name,
    total_sold,
    average_price,
    first_sale,
    last_sale
from final