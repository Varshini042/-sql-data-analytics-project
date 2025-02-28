/*
===============================================================================
Performance Analysis (Year-over-Year, Month-over-Month)
===============================================================================
Purpose:
    - To measure the performance of products, customers, or regions over time.
    - For benchmarking and identifying high-performing entities.
    - To track yearly trends and growth.

SQL Functions Used:
    - LAG(): Accesses data from previous rows.
    - AVG() OVER(): Computes average values within partitions.
    - CASE: Defines conditional logic for trend analysis.
===============================================================================
*/
------------------------------------------------------------------
--Perfomance Analysis
------------------------------------------------------------------
-- compare current with target value
--current measure - target measure

/*Analyse yearly perfomance of products by comparing each
product sales to both saverage sales and previous year sales*/

WITH yearly_product_sale as
(
SELECT
YEAR(s.[order_date]) as order_year,
p.[product_name] as product_name,
SUM(s.[sales_amount]) as current_sales
FROM [gold].[fact_sales] s
LEFT JOIN [gold].[dim_products] p
ON s.[product_key] = p.[product_key]
WHERE [order_date] IS NOT NULL
GROUP BY YEAR(s.[order_date]),p.[product_name] )
SELECT 
order_year,
product_name,
current_sales,
AVG(current_sales) OVER (PARTITION BY product_name) AS avg_sales,
current_sales - AVG(current_sales) OVER (PARTITION BY product_name) AS diff_avg,
CASE 
	WHEN current_sales - AVG(current_sales) OVER (PARTITION BY product_name) > 0 THEN 'Above Average'
	WHEN current_sales - AVG(current_sales) OVER (PARTITION BY product_name) < 0 THEN 'Below Average'
	ELSE 'Average' END AS avg_change,
LAG(current_sales) OVER (PARTITION BY product_name ORDER BY order_year ) as previous_year_sales,
current_sales - LAG(current_sales) OVER (PARTITION BY product_name ORDER BY order_year ) as diff_previous_year,
CASE 
	WHEN current_sales - LAG(current_sales) OVER (PARTITION BY product_name ORDER BY order_year ) > 0 THEN 'Increase'
	WHEN current_sales - LAG(current_sales) OVER (PARTITION BY product_name ORDER BY order_year ) < 0 THEN 'Decrease'
	ELSE 'No change' END AS py_change
FROM  yearly_product_sale
order by product_name
