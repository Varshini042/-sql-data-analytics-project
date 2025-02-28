/*
===============================================================================
Customer Report
===============================================================================
Purpose:
    - This report consolidates key customer metrics and behaviors

Highlights:
    1. Gathers essential fields such as names, ages, and transaction details.
	2. Segments customers into categories (VIP, Regular, New) and age groups.
    3. Aggregates customer-level metrics:
	   - total orders
	   - total sales
	   - total quantity purchased
	   - total products
	   - lifespan (in months)
    4. Calculates valuable KPIs:
	    - recency (months since last order)
		- average order value
		- average monthly spend
===============================================================================
*/
CREATE VIEW gold.report_customers AS

WITH base_query as 
(
SELECT
s.[order_number],
s.[product_key],
s.[order_date],
s.[sales_amount],
s.[quantity],
c.[customer_key],
c.[customer_number],
CONCAT (c.[first_name], ' ',c.[last_name]) customer_name,
DATEDIFF(YEAR,c.[birthdate],GETDATE()) age
FROM [gold].[fact_sales] s
LEFT JOIN [gold].[dim_customers] c
ON s.[customer_key] = c.[customer_key]
WHERE s.[order_date] IS NOT NULL
),
customer_aggregation as
(
SELECT
[customer_key],
[customer_number],
customer_name,
age,
COUNT(DISTINCT([order_number])) total_orders,
SUM([sales_amount]) as total_sales,
SUM([quantity]) as total_quantity,
COUNT(DISTINCT([product_key])) total_products,
MIN([order_date]) first_order,
MAX([order_date]) last_order_date,
DATEDIFF(MONTH,MIN([order_date]) ,MAX([order_date]))  lifespan
FROM base_query
GROUP BY
	[customer_key],
	[customer_number],
	customer_name,
	age
)

SELECT 
[customer_key],
[customer_number],
customer_name,
age,
CASE 
	WHEN age < 20 THEN 'Under 20'
	WHEN age BETWEEN 20 AND 29 THEN '20-29'
	WHEN age BETWEEN 30 AND 39 THEN '30-49'
	WHEN age BETWEEN 40 AND 49 THEN '40-49'
	ELSE '50 and above' END AS age_group,
CASE 
	WHEN total_sales > 5000 AND  lifespan >= 12 THEN 'VIP'
	WHEN total_sales <= 5000 AND  lifespan >= 12 THEN 'Regular'
	ELSE 'New' END AS customer_segmentation,
last_order_date,
DATEDIFF(MONTH,last_order_date,GETDATE()) recency,
total_orders,
total_sales,
total_quantity,
total_products,
lifespan,
--order values sales/orders
CASE 
	WHEN total_orders = 0 THEN 0 
	ELSE total_sales/ total_orders END AS avg_order_value,
--avg monthly spend sales/months
CASE 
	WHEN lifespan = 0 THEN  total_sales
	ELSE total_sales/ lifespan END AS avg_monthly_spend
FROM customer_aggregation

---
select* from [gold].[report_customers]
