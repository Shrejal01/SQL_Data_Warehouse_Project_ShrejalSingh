select prd_id, count(*) from Silver.crm_prd_info group by prd_id having count(*) >1 or prd_id is null;
select * from Silver.crm_prd_info;

-- Unwanted spaces 
select prd_nm from Silver.crm_prd_info where prd_nm != trim(prd_nm) or prd_nm is null;

-- Nulls or negative numbers 
select prd_cost from Silver.crm_prd_info where prd_cost<0 or prd_cost is null;

-- Standardization and Data Consistency
select DISTINCT prd_line from Silver.crm_prd_info;

-- Check if the dates are valid 
select * from Silver.crm_prd_info where prd_start_dt> prd_end_dt;

select 
prd_id, 
prd_key,
replace(substring(prd_key, 1, 5) , '-', '_') as cat_id,
substring(prd_key, 7, len(prd_key)) as prd_key,
prd_nm, 
coalesce(prd_cost,0) as prd_cost, 
/* CASE WHEN UPPER(TRIM(prd_line)) = 'M' then 'Mountain'
	when UPPER(TRIM(prd_line)) = 'R' then 'Road'
	when UPPER(TRIM(prd_line)) = 'S' then 'Other Sales'
	when UPPER(TRIM(prd_line)) = 'T' then 'Touring'
ELSE 'n/a'
END prd_line*/
CASE UPPER(TRIM(prd_line))
	when 'M' then 'Mountain'
	when 'R' then 'Road'
	when 'S' then 'Other Sales'
	when 'T' then 'Touring'
	ELSE 'n/a' 
end prd_line, 
prd_start_dt, 
prd_end_dt 
from Silver.crm_prd_info where prd_start_dt> prd_end_dt;
