/*
===============================================================================
Ranking Analysis
===============================================================================
Purpose:
    - To rank items (e.g., products, customers) based on performance or other metrics.
    - To identify top performers or laggards.

SQL Functions Used:
    - Window Ranking Functions: RANK(), DENSE_RANK(), ROW_NUMBER(), TOP
    - Clauses: GROUP BY, ORDER BY
===============================================================================
*/
--Ranking Analysis
--Rank(dimension) by measure

--top 5 products generating highest revenue
 SELECT TOP(5) p.[product_name], 
SUM(s.[sales_amount]) as total_revenue
FROM [gold].[fact_sales] s
LEFT JOIN [gold].[dim_products] p
ON s.[product_key] = p.[product_key]
GROUP BY p.[product_name]
order by total_revenue desc

SELECT *
FROM(
	SELECT p.[product_name], 
	SUM(s.[sales_amount]) as total_revenue,
	ROW_NUMBER() OVER ( ORDER BY SUM(s.[sales_amount]) DESC) as rank_product
	FROM [gold].[fact_sales] s
	LEFT JOIN [gold].[dim_products] p
	ON s.[product_key] = p.[product_key]
	GROUP BY p.[product_name] ) T
WHERE rank_product <= 5


--top 5 products worst perfoming products 

 SELECT TOP(5) p.[product_name], 
SUM(s.[sales_amount]) as total_revenue
FROM [gold].[fact_sales] s
LEFT JOIN [gold].[dim_products] p
ON s.[product_key] = p.[product_key]
GROUP BY p.[product_name]
order by total_revenue asc

--Top 10 customers generating highest revenue
SELECT Top (10) c.[customer_key],
c.[first_name],
c.[last_name],
SUM(s.[sales_amount]) as total_revenue
FROM [gold].[fact_sales] s
LEFT JOIN [gold].[dim_customers] c
ON s.[customer_key] = c.[customer_key]
GROUP BY c.[customer_key],c.[first_name],c.[last_name]
order by total_revenue desc

--top 3 lowest orders placed customers

SELECT Top (3) c.[customer_key],
c.[first_name],
c.[last_name],
COUNT(DISTINCT([order_number])) as total_orders
FROM [gold].[fact_sales] s
LEFT JOIN [gold].[dim_customers] c
ON s.[customer_key] = c.[customer_key]
GROUP BY c.[customer_key],c.[first_name],c.[last_name]
order by total_orders 

