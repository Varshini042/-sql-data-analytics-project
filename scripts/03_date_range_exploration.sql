/*
===============================================================================
Date Range Exploration 
===============================================================================
Purpose:
    - To determine the temporal boundaries of key data points.
    - To understand the range of historical data.
===============================================================================
*/
--Explore Date
--boudaries of date earilest and latest (min & max)
--understand timespan using earliest nd latest

--first and last order date and timespan
SELECT MIN([order_date]) AS first_order_date ,
MAX([order_date]) AS last_order_date,
DATEDIFF(YEAR,MIN([order_date]),MAX([order_date])) AS order_range_years,
DATEDIFF(MONTH,MIN([order_date]),MAX([order_date])) AS order_range_month
FROM [gold].[fact_sales]

--youngest and oldest customers
SELECT MIN([birthdate]) AS oldest_birthdate ,
DATEDIFF(YEAR, MIN([birthdate]),GETDATE()) as oldest_age,
MAX([birthdate]) AS youngest_birthdate,
DATEDIFF(YEAR, MAX([birthdate]),GETDATE()) as youngest_age
FROM [gold].[dim_customers]
