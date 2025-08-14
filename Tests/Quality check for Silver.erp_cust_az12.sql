select * from Bronze.erp_cust_az12;

select cid from Bronze.erp_cust_az12 where cid not in (select cst_key from Silver.crm_cust_info);


select cid, case when cid like 'NAS%' then substring (cid, 4, len(cid)) else cid end as cid from Bronze.erp_cust_az12 
where cid not in (select DISTINCT cst_key from Silver.crm_cust_info);

select cst_key from Silver.crm_cust_info;
select * from Bronze.erp_cust_az12;


select case when cid like 'NAS%' then substring (cid, 4, len(cid)) else cid end as cid from Bronze.erp_cust_az12
where case when cid like 'NAS%' then substring (cid, 4, len(cid)) else cid end
not in (select distinct cst_key as cst_key from Silver.crm_cust_info);

SELECT DISTINCT gen from Bronze.erp_cust_az12;