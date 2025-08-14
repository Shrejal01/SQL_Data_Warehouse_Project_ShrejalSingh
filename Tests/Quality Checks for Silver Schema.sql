SELECT cst_id, count(*) from Silver.crm_cust_info group by cst_id having count(*) >1 or cst_id IS NULL;
select * from Silver.crm_cust_info where cst_id = 29466;
select *, ROW_NUMBER() over (partition by cst_id order by cst_create_date) as flag_last from Silver.crm_cust_info;


-- REMOVING DUPLICATES
select * from 
(select *, ROW_NUMBER() over (partition by cst_id order by cst_create_date) as flag_last 
from Silver.crm_cust_info) as t 
where flag_last = 1;

-- REMOVING EXTRA SPACES FROM THE STRINGS
select cst_firstname from Silver.crm_cust_info where cst_firstname != trim(cst_firstname);
-- REMOVING EXTRA SPACES FROM THE STRINGS
select cst_lastname from Silver.crm_cust_info where cst_lastname != trim(cst_lastname);

-- REMOVING EXTRA SPACES FROM THE STRINGS
select cst_gndr from Silver.crm_cust_info where cst_gndr != trim(cst_gndr);

-- REMOVING EXTRA SPACES FROM THE STRINGS
select cst_marital_status from Silver.crm_cust_info where cst_marital_status != trim(cst_marital_status);

select * from Silver.crm_cust_info;

-- Data Standardization and Consistency
select distinct cst_gndr from Silver.crm_cust_info;