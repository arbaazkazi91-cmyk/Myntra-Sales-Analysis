CREATE database Myntra_Sales_Analysis;

USE Myntra_Sales_Analysis;

ALTER TABLE myntra_sales_analysis.myntra_dataset_byscraping
RENAME myntra_Sales;

DESC myntra_Sales;

ALTER TABLE myntra_Sales
MODIFY brand_name VARCHAR(255),
MODIFY pants_description VARCHAR(255),
MODIFY MRP FLOAT,
MODIFY discount_percent FLOAT,
MODIFY ratings FLOAT;

 
--- Top Brands by Product View ---
CREATE VIEW Top_Brand_by_Product_View AS
SELECT 
    brand_name, 
    COUNT(pants_description) AS product_count
FROM 
    myntra_Sales
GROUP BY 
    brand_name
ORDER BY
    product_count DESC;
    
SELECT * FROM Top_Brand_by_Product_View LIMIT 10;


--- Price Range Distribution ---
CREATE VIEW Price_Range_Distribution_View AS
SELECT 
    brand_name,
    CASE
        WHEN price < 1000 THEN '<1000'
        WHEN price BETWEEN 1000 AND 1999 THEN '1000-1999'
        WHEN price BETWEEN 2000 AND 2999 THEN '2000-2999'
        ELSE '3000+'
    END AS price_range,
    COUNT(*) AS product_count
FROM 
    myntra_Sales
GROUP BY 
    brand_name, 
    price_range
ORDER BY 
    brand_name, 
    product_count DESC;
    
SELECT * FROM Price_Range_Distribution_View LIMIT 10;


--- Discount % Distribution ---
CREATE VIEW Discount_Distribution_View AS
SELECT 
    CASE
        WHEN discount_percent < 0.20 THEN '0-20%'
        WHEN discount_percent < 0.40 THEN '20-40%'
        WHEN discount_percent < 0.60 THEN '40-60%'
        WHEN discount_percent < 0.80 THEN '60-80%'
        ELSE '80%+'
    END AS discount_range,
    COUNT(*) AS product_count
FROM 
    myntra_sales
GROUP BY 
    discount_range
ORDER BY 
    discount_range DESC;

SELECT * FROM Discount_Distribution_View LIMIT 10;


--- Average Price per Brand ---
CREATE VIEW Average_price_brand_view AS
SELECT
	brand_name,
    AVG(price) AS Avg_price,
    COUNT(pants_description) AS product_count
FROM 
    myntra_Sales
GROUP BY 
    brand_name
ORDER BY
    product_count DESC;
    
SELECT* FROM Average_price_brand_view LIMIT 10;


--- Average Discount per Brand ---
CREATE VIEW Average_discount_percent_view AS
SELECT
	brand_name,
	ROUND(AVG(discount_percent), 2) AS Avg_discount,
    COUNT(pants_description) AS product_count
FROM 
    myntra_Sales
GROUP BY 
    brand_name
ORDER BY
    product_count DESC;
    
SELECT* FROM Average_discount_percent_view LIMIT 10;


--- Best Selling Brands based on MRP ---
CREATE VIEW Best_selling_brand_view AS
SELECT brand_name,
       ROUND(AVG(MRP),0) AS avg_mrp,
       COUNT(*) AS product_count
FROM myntra_Sales
GROUP BY brand_name
ORDER BY avg_mrp DESC;

SELECT* FROM Best_selling_brand_view LIMIT 10;


--- Rating Distribution by Brand ---
CREATE VIEW rating_distribution_view AS
SELECT
	brand_name,
    CASE 
    WHEN ratings < 1 THEN '0-1'
    WHEN ratings < 2 THEN '1-2'
    WHEN ratings < 3 THEN '2-3'
    WHEN ratings < 4 THEN '3-4'
    ELSE '4+'
   END AS rating_range,
    COUNT(*) AS product_count
FROM 
    myntra_sales
GROUP BY 
    brand_name,
    rating_range
ORDER BY 
    rating_range DESC;
    
SELECT* FROM rating_distribution_view LIMIT 10;


--- Premium Brand View ---
CREATE VIEW premium_brand AS
SELECT brand_name,
       ROUND(AVG(price),0) AS avg_price
FROM myntra_Sales
GROUP BY brand_name
HAVING AVG(price) > (
    SELECT AVG(price) FROM myntra_Sales
)
ORDER BY avg_price DESC LIMIT 1;

SELECT* FROM premium_brand;


--- Budget Brand View ---
CREATE VIEW budget_brand AS
SELECT brand_name,
       ROUND(AVG(price),0) AS avg_price
FROM myntra_Sales
GROUP BY brand_name
HAVING AVG(price) < (
    SELECT AVG(price) FROM myntra_Sales
)
ORDER BY avg_price ASC LIMIT 1;

SELECT* FROM budget_brand;


--- Top Brand by MRP View ---
CREATE VIEW brand_mrp AS
SELECT 
    brand_name,
    SUM(MRP) AS total_mrp_value
FROM myntra_Sales
GROUP BY brand_name
ORDER BY total_mrp_value DESC;

SELECT* FROM  brand_mrp LIMIT 1;

--- Rating Histogram based on No. of Ratings ---
CREATE VIEW rating_histogram AS
SELECT
    CASE
        WHEN number_of_ratings < 100 THEN '0–100'
        WHEN number_of_ratings < 250 THEN '100-250'
        WHEN number_of_ratings < 500 THEN '250–500'
        WHEN number_of_ratings < 750 THEN '500–750'
        WHEN number_of_ratings < 1000 THEN '750–1000'
        ELSE '1000+'
    END AS rating_segment,
    COUNT(*) AS product_count
FROM myntra_Sales
WHERE number_of_ratings IS NOT NULL
GROUP BY rating_segment
ORDER BY MIN(number_of_ratings);

SELECT* FROM rating_histogram;


--- TOP 10 MOST RATED PRODUCT  ---
CREATE VIEW most_rated_products_view AS
SELECT
	brand_name,
    pants_description,
    number_of_ratings AS most_rated_product
FROM myntra_Sales
ORDER BY number_of_ratings DESC
LIMIT 10;

SELECT* FROM most_rated_products_view;


--- TOP 10 MOST DISCOUNTED PRODUCT ---
CREATE VIEW most_discounted_products_view AS
SELECT
	brand_name,
    pants_description,
    discount_percent AS most_discounted_product
FROM myntra_Sales
ORDER BY discount_percent DESC
LIMIT 10;

SELECT* FROM most_discounted_products_view;


--- Top 10 Product based on Average MRP ---
CREATE VIEW top_products_by_MRP_view AS
SELECT
	brand_name,
    pants_description,
    ROUND(AVG(MRP),0) AS top_product_by_mrp
FROM myntra_Sales
GROUP BY brand_name, pants_description
ORDER BY top_product_by_mrp DESC
LIMIT 10;

SELECT* FROM top_products_by_MRP_view;


--- MOST EXPENSIVE PRODUCT VIEW ---
CREATE VIEW most_expensive_product_view AS
SELECT 
    brand_name,
    pants_description,
    MRP AS most_expensive_product
FROM myntra_Sales
ORDER BY MRP DESC
LIMIT 1;
    
SELECT* FROM most_expensive_product_view;


--- LEAST EXPENSIVE PRODUCT VIEW ---
CREATE VIEW least_expensive_product_view AS
SELECT 
    brand_name,
    pants_description,
    MRP AS most_expensive_product
FROM myntra_Sales
ORDER BY MRP ASC
LIMIT 1;
    
SELECT* FROM least_expensive_product_view;

