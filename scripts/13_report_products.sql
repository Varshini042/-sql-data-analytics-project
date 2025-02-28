/*
===============================================================================
Product Report
===============================================================================
Purpose:
    - This report consolidates key product metrics and behaviors.

Highlights:
    1. Gathers essential fields such as product name, category, subcategory, and cost.
    2. Segments products by revenue to identify High-Performers, Mid-Range, or Low-Performers.
    3. Aggregates product-level metrics:
       - total orders
       - total sales
       - total quantity sold
       - total customers (unique)
       - lifespan (in months)
    4. Calculates valuable KPIs:
       - recency (months since last sale)
       - average order revenue (AOR)
       - average monthly revenue
===============================================================================
*/

CREATE VIEW gold.report_products
AS

WITH base_query AS
(
	SELECT
	s.[order_number],
	s.[customer_key],
	s.[order_date],
	s.[sales_amount],
	s.[quantity],
	P.[product_key],
	P.[product_name],
	P.[category],
	P.[subcategory],
	P.[cost]
	FROM [gold].[fact_sales] s
	LEFT JOIN [gold].[dim_products] p
	ON s.[product_key] = p.[product_key]
	WHERE [order_date] IS NOT NULL
),
products_aggregation as
(
	SELECT 
	[product_key],
	[product_name],
	[category],
	[subcategory],
	[cost],
	COUNT(DISTINCT([order_number])) total_orders,
	SUM([sales_amount]) as total_sales,
	SUM([quantity]) as total_quantity,
	COUNT(DISTINCT([customer_key])) total_customers,
	MIN([order_date]) first_order,
	MAX([order_date]) last_order_date,
	DATEDIFF(MONTH,MIN([order_date]) ,MAX([order_date]))  lifespan,
	ROUND(AVG(CAST(sales_amount AS FLOAT) / NULLIF(quantity, 0)),1) AS avg_selling_price
	FROM base_query
	GROUP BY
			[product_key],
			[product_name],
			[category],
			[subcategory],
			[cost]
)
SELECT
[product_key],
[product_name],
[category],
[subcategory],
[cost],
CASE
		WHEN total_sales > 50000 THEN 'High-Performer'
		WHEN total_sales >= 10000 THEN 'Mid-Range'
		ELSE 'Low-Performer'
	END AS product_segmentation,
total_orders,
total_sales,
total_quantity,
total_customers,
last_order_date,
DATEDIFF(MONTH,last_order_date,GETDATE()) recency,
lifespan,
avg_selling_price,
--order values sales/orders
CASE 
	WHEN total_orders = 0 THEN 0 
	ELSE total_sales/ total_orders END AS avg_order_value,
--avg monthly rvenue sales/months
CASE 
	WHEN lifespan = 0 THEN  total_sales
	ELSE total_sales/ lifespan END AS avg_monthly_revenue
FROM products_aggregation

