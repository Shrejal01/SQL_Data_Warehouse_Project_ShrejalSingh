use Data_Warehouse;
go
EXECUTE Bronze.load_bronze;
go
create or alter procedure Bronze.load_bronze AS
BEGIN
	DECLARE @start_time DATETIME, @end_time DATETIME, @batch_start_time DATETIME, @batch_end_time DATETIME;
	BEGIN TRY 
		PRINT '=================================================================================';
		PRINT 'Loading the Bronze Layer';
		PRINT '=================================================================================';

		SET @batch_start_time = GETDATE();
		PRINT '---------------------------------------------------------------------------------';
		PRINT 'Loading the Bronze.crm_cust_info table';
		PRINT '---------------------------------------------------------------------------------';
		SET @start_time = GETDATE();
		PRINT '>> Truncate the Bronze.crm_cust_info table';
		truncate table Bronze.crm_cust_info;

		PRINT '>> Bulk insert the data in the Bronze.crm_cust_info table';
		bulk insert Bronze.crm_cust_info
		from 'C:\Users\NitroV\Downloads\sql-data-warehouse-project\datasets\source_crm\cust_info.csv'
		with (
		firstrow = 2,
		fieldterminator = ',', 
		tablock
		);
		SET @end_time = GETDATE();
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(millisecond, @start_time, @end_time) as NVARCHAR) + ' ms';
		select count(*) from Bronze.crm_cust_info;


		PRINT '---------------------------------------------------------------------------------';
		PRINT 'Loading the Bronze.crm_prd_info table';
		PRINT '---------------------------------------------------------------------------------';

		SET @start_time = GETDATE();
		PRINT '>> Truncate the Bronze.crm_prd_info table';
		truncate table Bronze.crm_prd_info;

		PRINT '>> Bulk insert the data in the Bronze.crm_prd_info table';
		bulk insert Bronze.crm_prd_info
		from 'C:\Users\NitroV\Downloads\sql-data-warehouse-project\datasets\source_crm\prd_info.csv'
		with (
		firstrow = 2,
		fieldterminator = ',', 
		tablock
		);
		SET @end_time = GETDATE();
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(millisecond, @start_time, @end_time) as NVARCHAR) + ' ms';
		select count(*) from Bronze.crm_prd_info;

		PRINT '---------------------------------------------------------------------------------';
		PRINT 'Loading the Bronze.crm_sales_details';
		PRINT '---------------------------------------------------------------------------------';

		SET @start_time = GETDATE();
		PRINT '>> Truncate the Bronze.crm_sales_details';
		truncate table Bronze.crm_sales_details;

		PRINT '>> Bulk insert the data in the Bronze.crm_sales_details';
		bulk insert Bronze.crm_sales_details
		from 'C:\Users\NitroV\Downloads\sql-data-warehouse-project\datasets\source_crm\sales_details.csv'
		with (
		firstrow = 2,
		fieldterminator = ',', 
		tablock
		);
		SET @end_time = GETDATE();
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(millisecond, @start_time, @end_time) as NVARCHAR) + ' ms';
		select count(*) from Bronze.crm_sales_details;

		PRINT '---------------------------------------------------------------------------------';
		PRINT 'Loading the Bronze.erp_cust_az12';
		PRINT '---------------------------------------------------------------------------------';

		SET @start_time = GETDATE();
		PRINT '>> Truncate the Bronze.erp_cust_az12';
		truncate table Bronze.erp_cust_az12;

		PRINT '>> Bulk insert the data in the Bronze.erp_cust_az12';
		bulk insert Bronze.erp_cust_az12
		from 'C:\Users\NitroV\Downloads\sql-data-warehouse-project\datasets\source_erp\CUST_AZ12.csv'
		with (
		firstrow = 2,
		fieldterminator = ',', 
		tablock
		);
		SET @end_time = GETDATE();
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(millisecond, @start_time, @end_time) as NVARCHAR) + ' ms';
		select count(*) from Bronze.erp_cust_az12;


		PRINT '---------------------------------------------------------------------------------';
		PRINT 'Loading the Bronze.erp_loc_a101';
		PRINT '---------------------------------------------------------------------------------';

		SET @start_time = GETDATE();
		PRINT '>> Truncate the Bronze.erp_loc_a101';
		truncate table Bronze.erp_loc_a101;

		PRINT '>> Bulk insert the data in the Bronze.erp_loc_a101';
		bulk insert Bronze.erp_loc_a101
		from 'C:\Users\NitroV\Downloads\sql-data-warehouse-project\datasets\source_erp\LOC_A101.csv'
		with (
		firstrow = 2,
		fieldterminator = ',', 
		tablock
		);
		SET @end_time = GETDATE();
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(millisecond, @start_time, @end_time) as NVARCHAR) + ' ms';
		select count(*) from Bronze.erp_loc_a101;

		PRINT '---------------------------------------------------------------------------------';
		PRINT 'Loading the Bronze.erp_px_cat_g1v2';
		PRINT '---------------------------------------------------------------------------------';

		SET @start_time = GETDATE();
		PRINT '>> Truncate the Bronze.erp_px_cat_g1v2';
		truncate table Bronze.erp_px_cat_g1v2;

		PRINT '>> Bulk insert the data in the Bronze.erp_px_cat_g1v2';
		bulk insert Bronze.erp_px_cat_g1v2
		from 'C:\Users\NitroV\Downloads\sql-data-warehouse-project\datasets\source_erp\PX_CAT_G1V2.csv'
		with (
		firstrow = 2,
		fieldterminator = ',', 
		tablock
		);
		SET @end_time = GETDATE();
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(millisecond, @start_time, @end_time) as NVARCHAR) + ' ms';
		select count(*) from Bronze.erp_px_cat_g1v2;

		SET @batch_end_time = GETDATE();
		PRINT '>> Total time taken to load the entire Bronze layer: ' + CAST(DATEDIFF(millisecond, @batch_start_time, @batch_end_time) as NVARCHAR) +' ms';
	END TRY
	BEGIN CATCH
		PRINT '================================================================='
		PRINT 'ERROR OCCURED DURING LOADING BRONZE LAYER'
		PRINT 'Error Message' + ERROR_MESSAGE();
		PRINT 'Error Message' + CAST(ERROR_NUMBER() AS NVARCHAR);
		PRINT 'Error Message' + CAST(ERROR_STATE() AS NVARCHAR);
	END CATCH
END;
