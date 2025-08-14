# SQL_Data_Warehouse_Project_ShrejalSingh
This is a Data Engineering project. I have built a Data Warehouse using SQL Server. This includes ETL processes, data modeling, and analytics. 
Modern Data Warehouse for Sales Analytics

## Project Objective:
- This project aims to build a modern data warehouse using SQL Server to consolidate and integrate sales data from ERP and CRM systems. The purpose is to deliver a unified and clean data model that supports analytical reporting and informed decision-making on customer behavior, product performance, and sales trends.

## Architecture Overview:
- The solution follows a Bronze → Silver → Gold architecture:
- **Bronze Layer:** Raw ingestion of ERP and CRM data as-is.
- **Silver Layer:** Cleaned and conformed version of source data.
- **Gold Layer:** Business-aligned dimensional model for reporting and insights.

## Data Sources:
- **ERP System:** Provides product and sales-related data.
- **CRM System:** Provides customer-related data.
- Both sources are available in CSV format and ingested into SQL Server.

## Analytics & Reporting Focus:
- SQL-based analysis has been built to explore:
- **Customer Behavior** - segmentation, repeat purchases, activity.
- **Product Performance** - sales by product, top-sellers, and trends.
- **Sales Trends** - monthly/quarterly growth, regional breakdowns, etc.

## Data Quality & Integration:
- Before loading data into the reporting layer, the following transformations are applied:
- Null and duplicate handling
- Standardization of data formats
- Entity resolution for customer and product overlaps
- Creation of surrogate keys and technical metadata

## Naming Conventions:
- To ensure consistency and clarity, the following naming standards are used:

## Table Naming:
**Layer	Pattern	Example:**
- Bronze	<source>_<entity>	crm_customer_info, erp_product_data
- Silver	<source>_<entity>	erp_sales_invoice, crm_contact_list
- Gold	<category>_<entity>	dim_customers, fact_sales, agg_monthly_sales

## Column Naming:
- **Surrogate Keys:** <table>_key → customer_key, product_key
- **Technical Columns:** dwh_<column_name> → dwh_load_date, dwh_batch_id

## Stored Procedures:
- load_bronze, load_silver, load_gold - to standardize data loading processes.
- Data Model (Gold Layer)
The Gold Layer is designed for analytical queries with star-schema design patterns:

## Dimension Tables:
- dim_customers
- dim_products

## Fact Tables:
- fact_sales
- Each table includes well-documented metadata and is optimized for reporting.

## Tech Stack:
- Database: SQL Server
- Data Loading: Stored Procedures
- Scripting Language: T-SQL

## Source Files: CSV (ERP and CRM)

## Documentation: Markdown, Entity Relationship Diagrams (ERD)

## Stakeholder Value:
- **Business Analysts-** Self-service access to cleansed, unified data.
- **Executives-** Reliable KPIs for strategic decisions.
- **Data Scientists-** Ready-to-use datasets for advanced modeling.
- Sample queries for analytics
- Business definitions of key metrics
