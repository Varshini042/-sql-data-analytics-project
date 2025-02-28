/*
===============================================================================
Measures Exploration (Key Metrics)
===============================================================================
Purpose:
    - To calculate aggregated metrics (e.g., totals, averages) for quick insights.
    - To identify overall trends or spot anomalies.
===============================================================================
*/
--Find the total sales
SELECT SUM([sales_amount]) total_sales
FROM [gold].[fact_sales]

--total items sold
SELECT SUM([quantity]) total_quantity
FROM [gold].[fact_sales]

--avg seliing price
SELECT AVG([price]) avg_price
FROM [gold].[fact_sales]

--total number of orders
SELECT COUNT([order_number]) total_orders
FROM [gold].[fact_sales]

SELECT COUNT (DISTINCT([order_number])) total_orders
FROM [gold].[fact_sales]

--total number of products
SELECT COUNT([product_key]) total_products
FROM [gold].[dim_products]

SELECT COUNT (DISTINCT([product_key])) total_products
FROM [gold].[dim_products]

--total number of customers
SELECT COUNT([customer_key]) total_customers
FROM [gold].[dim_customers]

SELECT COUNT (DISTINCT([customer_key])) total_products
FROM [gold].[dim_customers]

--total number of customers who placed orders
SELECT COUNT(DISTINCT([customer_key])) total_customers
FROM [gold].[fact_sales]

--measures
--Generate a report to shsow all metrics

SELECT 'Total Sales' as measure_name, SUM([sales_amount]) AS measure_value 
FROM [gold].[fact_sales]
UNION ALL
SELECT 'Total Quantity' , SUM([quantity]) FROM [gold].[fact_sales]
UNION ALL
SELECT 'Average Price' , AVG([price])  FROM [gold].[fact_sales]
UNION ALL
SELECT 'Average Price' , AVG([price])  FROM [gold].[fact_sales]
UNION ALL
SELECT 'Total Orders' , COUNT (DISTINCT([order_number])) FROM [gold].[fact_sales]
UNION ALL
SELECT 'Total Products',COUNT (DISTINCT([product_key])) FROM [gold].[dim_products]
UNION ALL
SELECT 'Total Customers', COUNT (DISTINCT([customer_key])) FROM [gold].[dim_customers]
