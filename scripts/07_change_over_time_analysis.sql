/*
===============================================================================
Change Over Time Analysis
===============================================================================
Purpose:
    - To track trends, growth, and changes in key metrics over time.
    - For time-series analysis and identifying seasonality.
    - To measure growth or decline over specific periods.

SQL Functions Used:
    - Date Functions: DATEPART(), DATETRUNC(), FORMAT()
    - Aggregate Functions: SUM(), COUNT(), AVG()
===============================================================================
*/
---------------------------------------------------------------------
--Change- Over - Time Analysis
---------------------------------------------------------------------
--Measure by date dimesion

--Sales perfomance over time
SELECT [order_date],
SUM([sales_amount]) total_sales
FROM [gold].[fact_sales]
WHERE [order_date] IS NOT NULL 
GROUP BY [order_date]
ORDER BY 1

SELECT YEAR([order_date]) order_year,
SUM([sales_amount]) total_sales,
COUNT(DISTINCT([customer_key])) as total_customers,
SUM([quantity]) total_quantity
FROM [gold].[fact_sales]
WHERE [order_date] IS NOT NULL 
GROUP BY YEAR([order_date])
ORDER BY YEAR([order_date])

SELECT YEAR([order_date]) order_year,
MONTH([order_date]) month,
SUM([sales_amount]) total_sales,
COUNT(DISTINCT([customer_key])) as total_customers,
SUM([quantity]) total_quantity
FROM [gold].[fact_sales]
WHERE [order_date] IS NOT NULL 
GROUP BY YEAR([order_date]),MONTH([order_date])
ORDER BY YEAR([order_date]),MONTH([order_date])

--SELECT 
--DATETRUNC(month,[order_date]) order_date,
--SUM([sales_amount]) total_sales,
--COUNT(DISTINCT([customer_key])) as total_customers,
--SUM([quantity]) total_quantity
--FROM [gold].[fact_sales]
--WHERE [order_date] IS NOT NULL 
--GROUP BY DATETRUNC(month,[order_date])
--ORDER BY DATETRUNC(month,[order_date])

SELECT 
FORMAT([order_date],'yyyy-MMM') order_date,
SUM([sales_amount]) total_sales,
COUNT(DISTINCT([customer_key])) as total_customers,
SUM([quantity]) total_quantity
FROM [gold].[fact_sales]
WHERE [order_date] IS NOT NULL 
GROUP BY FORMAT([order_date],'yyyy-MMM')
ORDER BY FORMAT([order_date],'yyyy-MMM')
