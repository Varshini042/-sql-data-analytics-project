/*
===============================================================================
Part-to-Whole Analysis
===============================================================================
Purpose:
    - To compare performance or metrics across dimensions or time periods.
    - To evaluate differences between categories.
    - Useful for A/B testing or regional comparisons.

SQL Functions Used:
    - SUM(), AVG(): Aggregates values for comparison.
    - Window Functions: SUM() OVER() for total calculations.
===============================================================================
*/
------------------------------------------------------------------
-- Proportional analysis Part yo whole Analysis
------------------------------------------------------------------
--measurs/total measur  * 100 by dimention

--Which categories contri bute to most to overall sales

WITH category_sales as (
SELECT
p.[category],
SUM(s.[sales_amount]) total_sales
FROM [gold].[fact_sales] s
LEFT JOIN [gold].[dim_products] p
ON s.[product_key] = p.[product_key]
GROUP BY p.[category])

SELECT [category],
total_sales,
SUM(total_sales) OVER () overall_sales,
CONCAT (ROUND((CAST(total_sales AS FLOAT)/SUM(total_sales) OVER ())*100 ,2),'%') as percent_sales
FROM category_sales
ORDER BY total_sales DESC
