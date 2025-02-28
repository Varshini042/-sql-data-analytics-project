/*
===============================================================================
Cumulative Analysis
===============================================================================
Purpose:
    - To calculate running totals or moving averages for key metrics.
    - To track performance over time cumulatively.
    - Useful for growth analysis or identifying long-term trends.

SQL Functions Used:
    - Window Functions: SUM() OVER(), AVG() OVER()
===============================================================================
*/
-----------------------------------------------------------------------
--Cumulative Analysis
-----------------------------------------------------------------------
--growth over time (running total)
--cumulative measure by date dimesion\

---totalsales for each month and running total over time

SELECT
order_date,
total_sales,
SUM(total_sales) OVER (PARTITION BY YEAR(order_date)  ORDER BY order_date)  AS running_total_sales,
AVG(avg_price) OVER (PARTITION BY YEAR(order_date)   ORDER BY order_date)  AS moving_average
FROM(
	SELECT
	MIN([order_date]) AS order_date,
	SUM([sales_amount]) total_sales,
	AVG([price]) as avg_price
	FROM  [gold].[fact_sales]
	WHERE [order_date] IS NOT NULL
	GROUP BY YEAR([order_date]), MONTH([order_date])
	 ) T

---totalsales for each month and running total over time year

SELECT
order_date,
total_sales,
SUM(total_sales) OVER ( ORDER BY order_date)  AS running_total_sales,
AVG(avg_price) OVER (   ORDER BY order_date)  AS moving_average
FROM(
	SELECT
	MIN([order_date]) AS order_date,
	SUM([sales_amount]) total_sales,
	AVG([price]) as avg_price
	FROM  [gold].[fact_sales]
	WHERE [order_date] IS NOT NULL
	GROUP BY YEAR([order_date])
	 ) T
