/*
===============================================================================
Database Exploration
===============================================================================
Purpose:
    - To explore the structure of the database, including the list of tables and their schemas.
    - To inspect the columns and metadata for specific tables.
===============================================================================
*/

-- EXPLORE TABLES
SELECT * FROM INFORMATION_SCHEMA.TABLES

--EXPLORE COLUMNS
SELECT * FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'dim_customers'
