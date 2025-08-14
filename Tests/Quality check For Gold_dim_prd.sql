select * from Silver.erp_px_cat_g1v2;
select * from Silver.crm_prd_info;

select prd_key, count(*) from(
select 
pr.prd_id, 
pr.cat_id, 
pr.prd_key, 
pr.prd_nm, 
pr.prd_cost, 
pr.prd_line, 
pr.prd_start_dt,
px.cat, 
px.subcat, 
px.maintenance 
from Silver.crm_prd_info as pr
left join Silver.erp_px_cat_g1v2 as px
on pr.cat_id = px.id
where prd_end_dt is null) as t group by prd_key having count(*)>1;
