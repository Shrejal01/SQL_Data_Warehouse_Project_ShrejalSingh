/* 
Script Purpose: 
  The script is used to create a new database "Data_Warehouse" after checking if it already exists. If the database exists, then it is dropping the database and recreating it. 
  The script also creates 3 schemas: Bronze, Silver, & Gold. 

Warning: 
  Running this script will drop the entire Data_Warehouse database if it exists. Proceed with this script if you want to delete the database permanently. Be cautious and ensure there are proper backups before running this script. 
*/

USE master;
GO

-- DROP AND RECREATE THE DATABASE 
IF EXISTS (SELECT 1 FROM sys.databases WHERE name = "Data_Warehouse")
BEGIN
    ALTER DATABASE Data_Warehouse SET SINGLE_USER WITH ROLLBACK IMMEDIATE; 
    DROP DATABASE Data_Warehouse;
END; 
GO

-- Creating the "Data_Warehouse" database 
CREATE DATABASE Data_Warehouse; 
GO

USE Data_Warehouse;
GO

--CREATE SCHEMA
CREATE SCHEMA Bronze; 
GO 
CREATE SCHEMA Silver; 
GO 
CREATE SCHEMA Gold; 


