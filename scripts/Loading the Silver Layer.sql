
EXEC Silver.load_silver;
GO

create or alter procedure Silver.load_silver as 
begin 
	DECLARE @start_time DATETIME, @end_time DATETIME, @batch_start_time DATETIME, @batch_end_time DATETIME;
	BEGIN TRY 
		PRINT '=================================================================================';
		PRINT 'Loading the Silver Layer';
		PRINT '=================================================================================';
		SET @batch_start_time = GETDATE();
		PRINT '---------------------------------------------------------------------------------';
		PRINT 'Loading the CRM Tables';
		PRINT '---------------------------------------------------------------------------------';

		SET @start_time = GETDATE();
		PRINT '>> Truncating the Silver.crm_cust_info table'
		TRUNCATE TABLE Silver.crm_cust_info;
		PRINT '>> Inserting the data in the Silver.crm_cust_info table'
		insert into Silver.crm_cust_info(
		cst_id, cst_key, cst_firstname, cst_lastname, cst_marital_status, cst_gndr, cst_create_date)
		select cst_id, 
		cst_key, 
		trim(cst_firstname) as cst_firstname, 
		trim(cst_lastname) as cst_lastname, 
		case when upper(trim(cst_gndr)) = 'M' THEN 'Married'
			when upper(trim(cst_gndr)) = 'F' THEN 'Single'
			ELSE 'n/a'
		END cst_marital_status, 
		case when upper(trim(cst_gndr)) = 'M' THEN 'Male'
			when upper(trim(cst_gndr)) = 'F' THEN 'Female'
			ELSE 'n/a'
		END cst_gndr,
		cst_create_date from 
		(select *, ROW_NUMBER() over (partition by cst_id order by cst_create_date) as flag_last 
		from Bronze.crm_cust_info where cst_id is not null) as t 
		where flag_last = 1;
		SET @end_time = GETDATE();
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(millisecond, @start_time, @end_time) as NVARCHAR) + ' ms';
		select count(*) from Silver.crm_cust_info;





		SET @start_time = GETDATE();
		PRINT '>> Truncating the Silver.crm_prd_info table'
		truncate table Silver.crm_prd_info;
		PRINT '>> Inserting the data into Silver.crm_prd_info table'
		insert into Silver.crm_prd_info(
		prd_id,cat_id, prd_key, prd_nm, prd_cost, prd_line, prd_start_dt, prd_end_dt)
		select 
		prd_id,
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
		cast(prd_start_dt as DATE) as prd_start_dt, 
		DATEADD(DAY, -1, 
			LEAD(prd_start_dt) OVER (PARTITION BY prd_key ORDER BY prd_start_dt)
		) AS prd_end_dt
		from Bronze.crm_prd_info;
		SET @end_time = GETDATE();
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(millisecond, @start_time, @end_time) as NVARCHAR) + ' ms';
		select count(*) from Silver.crm_prd_info;



		SET @start_time = GETDATE();
		PRINT '>> Truncating the Silver.crm_sales_details table'
		TRUNCATE TABLE Silver.crm_sales_details;
		PRINT '>> Inserting the data into Silver.crm_sales_details table'
		insert into Silver.crm_sales_details
			(sls_ord_num, 
			sls_prd_key, 
			sls_cust_id, 
			sls_order_dt, 
			sls_ship_dt, 
			sls_due_dt, 
			sls_sales, 
			sls_quantity, 
			sls_price)
		select 
		sls_ord_num,
		sls_prd_key, 
		sls_cust_id,
		case 
			when sls_order_dt <=0 or len(sls_order_dt) !=8 then cast(null as DATE)
			else CAST(CAST(sls_order_dt as NVARCHAR) AS DATE)
		END AS sls_order_dt, 

		case 
			when sls_ship_dt <=0 or len(sls_ship_dt) !=8 then cast(null as DATE)
			else CAST(CAST(sls_ship_dt as NVARCHAR) AS DATE)
		END AS sls_ship_dt,

		case 
			when sls_due_dt <=0 or len(sls_due_dt) !=8 then cast(null as DATE)
			else CAST(CAST(sls_due_dt as NVARCHAR) AS DATE)
		END AS sls_due_dt,
 
		case 
			when sls_sales is null or sls_sales<=0 or sls_sales != sls_quantity * abs(sls_price)
			then sls_quantity * abs(sls_price)
			else sls_sales 
		end as sls_sales, 

		sls_quantity, 

		case 
			when sls_price is null or sls_price <=0 
			then sls_sales / nullif(sls_quantity, 0) 
			else sls_price 
		end as sls_price
		from Bronze.crm_sales_details;
		SET @end_time = GETDATE();
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(millisecond, @start_time, @end_time) as NVARCHAR) + ' ms';
		select count(*) from Silver.crm_sales_details;



		PRINT '---------------------------------------------------------------------------------';
		PRINT 'Loading the ERP Tables';
		PRINT '---------------------------------------------------------------------------------';
		SET @start_time = GETDATE();
		PRINT '>> Truncating the Silver.erp_cust_az12 table'
		TRUNCATE TABLE Silver.erp_cust_az12;
		PRINT '>> Inserting the data into Silver.erp_cust_az12 table'
		insert into Silver.erp_cust_az12(cid, bdate, gen)
		select 
		case 
			when cid like 'NAS%' 
			then substring(cid, 4, len(cid)) 
			else cid 
		end as cid, 
		case 
			when bdate > GETDATE() 
			then null
			else bdate 
		end as bdate,
		case 
			when upper(trim(gen)) in ('F', 'FEMALE') then 'Female'
			when upper(trim(gen)) in ('M', 'MALE') then 'Male'
			else 'n/a'
		end as gen 
		from Bronze.erp_cust_az12;
		SET @end_time = GETDATE();
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(millisecond, @start_time, @end_time) as NVARCHAR) + ' ms';
		select count(*) from Silver.erp_cust_az12;



		SET @start_time = GETDATE();
		PRINT '>> Truncating the Silver.erp_loc_a101 table'
		TRUNCATE TABLE Silver.erp_loc_a101;
		PRINT '>> Inserting the data into Silver.erp_loc_a101 table'
		insert into Silver.erp_loc_a101(cid, cntry)
		select 
		replace(cid, '-', '') as cid,
		case 
			when trim(cntry) = 'DE' then 'Germany'
			when trim(cntry) in ('US', 'USA') then 'United States'
			when trim(cntry) = '' or cntry is null then 'n/a'
			else trim(cntry) 
		end as cntry 
		from Bronze.erp_loc_a101;
		SET @end_time = GETDATE();
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(millisecond, @start_time, @end_time) as NVARCHAR) + ' ms';
		select count(*) from Silver.erp_loc_a101;



		SET @start_time = GETDATE();
		PRINT '>> Truncating the Silver.erp_px_cat_g1v2 table'
		TRUNCATE TABLE Silver.erp_px_cat_g1v2;
		PRINT '>> Inserting the data into Silver.erp_px_cat_g1v2 table'
		insert into Silver.erp_px_cat_g1v2(id, cat, subcat, maintenance)
		select 
		id, 
		cat, 
		subcat, 
		maintenance
		from Bronze.erp_px_cat_g1v2;
		SET @end_time = GETDATE();
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(millisecond, @start_time, @end_time) as NVARCHAR) + ' ms';
		select count(*) from Silver.erp_px_cat_g1v2;
		SET @batch_end_time = GETDATE();
		PRINT '>> Total time taken to load the entire Bronze layer: ' + CAST(DATEDIFF(millisecond, @batch_start_time, @batch_end_time) as NVARCHAR) +' ms';
	END TRY
	BEGIN CATCH
		PRINT '================================================================='
		PRINT 'ERROR OCCURED DURING LOADING SILVER LAYER'
		PRINT 'Error Message' + ERROR_MESSAGE();
		PRINT 'Error Message' + CAST(ERROR_NUMBER() AS NVARCHAR);
		PRINT 'Error Message' + CAST(ERROR_STATE() AS NVARCHAR);
	END CATCH
END;













