select cst_id, count(*) from (
select 
	ci.cst_id, 
	ci.cst_key, 
	ci.cst_firstname, 
	ci.cst_lastname,
	ci.cst_marital_status,
	ci.cst_gndr,
	ci.cst_create_date,
	ca.bdate,
	ca.gen,
	cl.cntry
from Silver.crm_cust_info as ci
left join Silver.erp_cust_az12 as ca
on ci.cst_key = ca.cid
left join Silver.erp_loc_a101 as cl 
on ci.cst_key = cl.cid
) as t group by cst_id having count(*)>1;


select 
	ci.cst_gndr,
	ca.gen, 
	case when ci.cst_gndr != 'n/a' then ci.cst_gndr --CRM IS THE MASTER TABLE
	else coalesce(ca.gen, 'n/a')
	end as new_gender
from Silver.crm_cust_info as ci
left join Silver.erp_cust_az12 as ca
on ci.cst_key = ca.cid
left join Silver.erp_loc_a101 as cl 
on ci.cst_key = cl.cid where ci.cst_gndr != ca.gen;
