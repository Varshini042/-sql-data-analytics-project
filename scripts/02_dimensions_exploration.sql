/*
===============================================================================
Dimensions Exploration
===============================================================================
Purpose:
    - To explore the structure of dimension tables.
===============================================================================
*/
--Explore Dimensions
-- Explore countries of customers
SELECT DISTINCT [country] FROM [gold].[dim_customers]

-- Explore categories of products
SELECT DISTINCT [category],[subcategory],[product_name] 
FROM [gold].[dim_products]
order by 1,2,3
