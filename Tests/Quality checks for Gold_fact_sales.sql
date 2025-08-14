select * from gold.dim_customers;
select * from gold.dim_products;

-- Check if all the dimensions table can successfully join the fact table or not

select * from gold.fact_sales as fg
left join gold.dim_customers as cg 
on cg.customer_key = fg.customer_key
where cg.customer_key is null;

select * from gold.fact_sales as fg
left join gold.dim_products as pg 
on pg.product_key = fg.product_key
where pg.product_key is null;