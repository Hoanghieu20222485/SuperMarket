CREATE DATABASE SuperMarket

SELECT * 
FROM SuperMarket

-- Bai 1:
-- A
SELECT COUNT(*) AS 'Total Order'
FROM SuperMarket

-- B
SELECT 
    Branch
    , ROUND(SUM(cogs), 2) AS 'Sum Sales'
FROM SuperMarket
GROUP BY 
    Branch

-- Bai 2:
-- A
SELECT 
    Product_line
    , ROUND(SUM(cogs), 2) AS 'Sum Sales'
    , COUNT(Invoice_ID) AS 'Total Order'
FROM SuperMarket
GROUP BY 
    Product_line

--B
SELECT 
    Product_line
    , Customer_type
    , ROUND(SUM(cogs), 2) AS 'Sum Sales'
    , COUNT(Invoice_ID) AS 'Total Order'
FROM SuperMarket
GROUP BY 
    Product_line
    , Customer_type

-- Bai 3:
-- A
WITH Top_month AS (
    SELECT TOP 1
        MONTH(Date) AS Month
        , ROUND(SUM(cogs), 2) AS 'Total_cogs'
    FROM SuperMarket
    GROUP BY 
        MONTH(Date)
    ORDER BY 
        SUM(cogs) DESC
)
, Hour_order AS (
    SELECT 
        DATEPART(HOUR, Time) AS Hour
        , COUNT(*) AS 'Total_order'
    FROM SuperMarket
    WHERE 
        MONTH(Date) = (SELECT MONTH(Date) FROM Top_month)
    GROUP BY 
        DATEPART(HOUR, Time)
)
, Avg_order AS (
    SELECT 
        ROUND(AVG(CAST(Total_order AS FLOAT)), 2) AS Aov_order
    FROM Hour_order
)
SELECT 
    Hour
    ,Total_order
FROM Hour_order, Avg_order
WHERE
    Total_order > Aov_order
ORDER BY
    Total_order DESC

-- B
WITH revanue AS (
    SELECT 
        Product_line
        , Customer_type
        , COUNT(Invoice_ID) AS Total_order
        , ROUND(SUM(cogs), 2) AS sum_sales
    FROM SuperMarket
    GROUP BY 
        Product_line
        , Customer_type
)
SELECT 
    r1.Product_line
    , r1.Customer_type AS c1
    , r2.Customer_type AS c2
    , r1.Total_order AS t1
    , r2.Total_order AS t2
    , r1.sum_sales AS s1
    , r2.sum_sales AS s2
FROM revanue r1
JOIN revanue r2
    ON r1.Product_line = r2.Product_line
    AND r1.Customer_type <> r2.Customer_type
WHERE 
    r1.Total_order < r2.Total_order
    AND r1.sum_sales > r2.sum_sales

-- Bai 4:
WITH MonthlyStats AS (
    SELECT 
        MONTH(Date) AS month
        , ROUND(SUM(cogs), 2) AS SumSales
        , COUNT(Invoice_ID) AS TotalOrder
    FROM SuperMarket
    GROUP BY 
        MONTH(Date)
)   
SELECT 
    Month,
    SumSales,
    TotalOrder,
    LAG(SumSales) OVER (ORDER BY Month) AS Total_Sales_Before,
    LAG(TotalOrder) OVER (ORDER BY Month) AS Total_Order_Before
FROM MonthlyStats
ORDER BY Month;