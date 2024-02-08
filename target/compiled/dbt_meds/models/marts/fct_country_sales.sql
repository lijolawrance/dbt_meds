    with source as (
    SELECT
        country
        ,api_sold_product as product_name
        ,sum(quantity_sold) as total_sold
        ,round(avg(unit_price), 2) as average_price
        ,min(sold_product_created_at) as first_sale
        ,max(sold_product_created_at) as most_recent_sale
    FROM PUBLIC.RAW_DATA.SALES_DATA
    WHERE EXTRACT(YEAR FROM sold_product_created_at) = EXTRACT(YEAR FROM current_date) - 1
    GROUP BY country, api_sold_product
    HAVING COUNT(*) > 3
    ORDER BY COUNTRY, api_sold_product
)
SELECT 
    country,
    product_name,
    total_sold,
    average_price,
    first_sale,
    most_recent_sale
FROM source 