USE my_datasets;

-- DATA EXPLORATION
SELECT * FROM zepto;
DESCRIBE zepto;
-- null values
SELECT * FROM zepto
WHERE name IS NULL
OR
category IS NULL
OR
mrp IS NULL
OR
discountPercent IS NULL
OR
discountedSellingPrice IS NULL
OR
weightInGms IS NULL
OR
availableQuantity IS NULL
OR
outOfStock IS NULL
OR
quantity IS NULL;

-- products in stock vs out of stock
SELECT outOfStock, COUNT(*) AS  TOTAL
FROM zepto
GROUP BY outOfStock;

-- product names present multiple times
SELECT name, COUNT(*) AS "Number of times present"
FROM zepto
GROUP BY name
HAVING count(*) > 1
ORDER BY count(*) DESC; 


SET SQL_SAFE_UPDATES = 0;

-- DATA CLEANING
DELETE FROM zepto
WHERE mrp = 0;

UPDATE zepto
SET mrp = mrp / 100.0,
discountedSellingPrice = discountedSellingPrice / 100.0;

ALTER TABLE zepto
RENAME COLUMN ï»¿Category TO category;

-- KPI ANALYSIS
-- Q1 Found top 10 best-value products based on discount percentage
SELECT DISTINCT name,mrp,discountPercent
FROM zepto
ORDER BY discountPercent DESC
LIMIT 10;

-- Q2 Identified high-MRP products that are currently out of stock
SELECT DISTINCT name,mrp,outOfStock
FROM zepto
WHERE OutOfStock = 'TRUE'
ORDER BY mrp DESC
LIMIT 10;

-- Q3 Estimated potential revenue for each product category
SELECT Category,SUM(discountedSellingPrice * availableQuantity) Total_Amount
FROM zepto
GROUP BY Category 
ORDER BY Total_Amount DESC;

-- Q4 Filtered expensive products (MRP > ₹500) with minimal discount of 10%
SELECT name,mrp,discountPercent
FROM zepto
WHERE mrp > 500 AND discountPercent < 10
ORDER BY mrp DESC,discountPercent ASC;

-- Q5 Ranked top 5 categories offering highest average discounts
SELECT category,AVG(discountPercent) AS avg_discount
FROM zepto
GROUP BY category
ORDER BY avg_discount DESC
LIMIT 5;
 
-- -- Q6. Find the price per gram for products above 100g and sort by best value.
SELECT  name,discountedSellingPrice,weightInGms,ROUND(weightInGms/discountedSellingPrice) as price_per_gram 
FROM zepto
WHERE weightInGms > 100
ORDER BY price_per_gram DESC;

-- Q7.Group the products into categories like Low, Medium, Bulk.
WITH cte as (
SELECT name,weightInGms,
CASE 
    WHEN weightInGms < 1000 THEN 'LOW'
    WHEN weightInGms BETWEEN 1000 AND 3000 THEN 'MEDIUM'
    WHEN weightInGms > 3000 THEN 'BULK'
    END
    AS categories
FROM zepto)
SELECT categories,COUNT(*) AS COUNT
FROM cte
GROUP BY categories
ORDER BY COUNT DESC; -- COUNTING THE EACH DISTINCT CATEGORIES

-- Q8.What is the Total Inventory Weight Per Category 
SELECT category,SUM(weightInGms * availableQuantity) AS Total_Inventory
FROM zepto
GROUP BY category
ORDER BY Total_Inventory DESC
;



