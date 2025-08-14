-- =============================================================================
-- Create Dimension: gold.dim_customers
-- =============================================================================
IF OBJECT_ID('gold.dim_customers', 'V') IS NOT NULL
    DROP VIEW gold.dim_customers;
GO

create view gold.dim_customers as 
select 
	row_number() over (order by cst_id) as customer_key,
	ci.cst_id as customer_id, 
	ci.cst_key as customer_number, 
	ci.cst_firstname as first_name, 
	ci.cst_lastname as last_name,
	cl.cntry as country,
	case when ci.cst_gndr != 'n/a' then ci.cst_gndr --CRM IS THE MASTER TABLE
	else coalesce(ca.gen, 'n/a')
	end as gender,
	ci.cst_marital_status as marital_status,
	ca.bdate as birth_date,
	ci.cst_create_date as create_date
from Silver.crm_cust_info as ci
left join Silver.erp_cust_az12 as ca
on ci.cst_key = ca.cid
left join Silver.erp_loc_a101 as cl 
on ci.cst_key = cl.cid;
GO

-- =============================================================================
-- Create Dimension: gold.dim_products
-- =============================================================================
IF OBJECT_ID('gold.dim_products', 'V') IS NOT NULL
    DROP VIEW gold.dim_products;
GO
create view gold.dim_products as 
select 
row_number() over (order by pr.prd_start_dt, pr.prd_key) as product_key,
pr.prd_id as product_id,  
pr.prd_key as product_number, 
pr.prd_nm as product_name,
pr.cat_id as category_id,
px.cat as category,
px.subcat as subcategory,
px.maintenance,
pr.prd_cost as cost, 
pr.prd_line as product_line, 
pr.prd_start_dt as start_date
from Silver.crm_prd_info as pr
left join Silver.erp_px_cat_g1v2 as px
on pr.cat_id = px.id
where prd_end_dt is null;
go

-- =============================================================================
-- Create Fact Table: gold.fact_sales
-- =============================================================================
IF OBJECT_ID('gold.fact_sales', 'V') IS NOT NULL
    DROP VIEW gold.fact_sales;
GO
create view gold.fact_sales as
select 
	sl.sls_ord_num as order_number, 
	cu.customer_key,
	pr.product_key, 
	sl.sls_order_dt as order_date, 
	sl.sls_ship_dt as shipping_date, 
	sl.sls_due_dt as due_date, 
	sl.sls_sales as sales_amount, 
	sl.sls_quantity as quantity, 
	sl.sls_price as price
from Silver.crm_sales_details as sl
left join gold.dim_customers as cu
on sls_cust_id = cu.customer_id
left join gold.dim_products as pr
on sls_prd_key = pr.product_number;

-- Dimension Keys: order_number, customer_key, product_key
-- Date Keys: order_date, shipping_date, due_date 
-- Measure Keys: sales_amount, quantity, price
