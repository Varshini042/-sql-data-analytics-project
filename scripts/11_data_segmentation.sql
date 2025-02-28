/*
===============================================================================
Data Segmentation Analysis
===============================================================================
Purpose:
    - To group data into meaningful categories for targeted insights.
    - For customer segmentation, product categorization, or regional analysis.

SQL Functions Used:
    - CASE: Defines custom segmentation logic.
    - GROUP BY: Groups data into segments.
===============================================================================
*/
--------------------------------------------------------------------------
-- DATA segmentation 
-------------------------------------------------------------------------
--measure by measure
--case when statements

--- segment products into cost ranges and count how many fall in each

SELECT cost_range, COUNT([product_key]) total_products
FROM(
	SELECT 
	[product_key],
	[product_name],
	[cost],
	CASE 
	WHEN [cost] < 100 THEN 'Below 100'
	WHEN [cost] BETWEEN 100 AND 500 THEN '100-500'
	WHEN [cost] BETWEEN 500 AND 1000 THEN '500-1000'
	ELSE 'Above 1000' END AS cost_range
	FROM [gold].[dim_products])T
GROUP BY cost_range
ORDER BY total_products DESC

/* Group customers in to 3 segments based on spedding
-VIP: at least 12 months of history and spending more that 5000
Regular:at least 12 months of history and spending 5000 or less
New : life span lest than 12
and toatal number of customers */
WITH customer_sales as
(
	SELECT c.[customer_key],
	SUM(s.[sales_amount])  total_sales,
	MIN(s.[order_date]) first_order,
	MAX(s.[order_date]) last_order,
	DATEDIFF(MONTH,MIN(s.[order_date]) ,MAX(s.[order_date]))  lifespan
	FROM [gold].[fact_sales] s
	LEFT JOIN [gold].[dim_customers] c
	ON s.[customer_key] = c.[customer_key]
	GROUP BY  c.[customer_key]
),
customer_segmentation as
(
	SELECT 
	[customer_key],
	total_sales,
	lifespan,
	CASE 
	WHEN total_sales > 5000 AND  lifespan >= 12 THEN 'VIP'
	WHEN total_sales <= 5000 AND  lifespan >= 12 THEN 'Regular'
	ELSE 'New' END AS customer_segmentation
	FROM customer_sales
	)

SELECT customer_segmentation,
COUNT([customer_key]) total_cutomers
FROM customer_segmentation
GROUP BY customer_segmentation




