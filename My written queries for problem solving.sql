create database walmart;
use walmart ;
create table sales( 
 invoice_id VARCHAR(30) NOT NULL PRIMARY KEY,
 Branch	VARCHAR(5),
 City VARCHAR(30),
 Customer_type VARCHAR(30) NOT NULL,
 Gender VARCHAR(10)NOT NULL,
 Product_line VARCHAR(100) NOT NULL,
 Unit_price DECIMAL(10,2) NOT NULL,
 Quantity INT NOT NULL,
 VAT FLOAT(6,4) NOT NULL,
 Total DECIMAL(12,4) NOT NULL,
 Date DATETIME NOT NULL,
 Time TIME NOT NULL,
 Payment_method VARCHAR(15) NOT NULL,
 cogs DECIMAL(10,2) NOT NULL,
 gross_margin_pct FLOAT(11,9),
 gross_income DECIMAL(12,4) NOT NULL,
 Rating FLOAT(2,1) );
 
 SELECT * FROM SALES ;
 
 -- ------------------------------------------------------------------------------------------
 -- ------------------------- Feature Engineering --------------------------------------------
 
 -- Time_of_day --------------------
 
 SELECT time from sales ;
 
  SELECT time,
  (CASE 
       WHEN `TIME` BETWEEN "00:00:00" AND "12:00:00" THEN "Morning"
       WHEN `TIME` BETWEEN "12:01:00" AND "16:00:00" THEN "Afternoon"
       ELSE "Evening"
       END
  )from sales ;
 
 ALTER TABLE SALES ADD COLUMN time_of_day VARCHAR(20) ;
 
 SELECT * FROM SALES ;
 
 UPDATE SALES
 SET time_of_day = ( CASE 
       WHEN `TIME` BETWEEN "00:00:00" AND "12:00:00" THEN "Morning"
       WHEN `TIME` BETWEEN "12:01:00" AND "16:00:00" THEN "Afternoon"
       ELSE "Evening"
       END
 );
 SELECT * FROM SALES ;  
 
 -- day name ------------------------
 
 SELECT 
       DATE,
       DAYNAME(date)
       FROM SALES;
       
ALTER TABLE SALES ADD COLUMN Day_name VARCHAR(20);

UPDATE sales
SET Day_name = DAYNAME(date) ;

-- Month_name -----------------------

SELECT 
     date,
     MONTHNAME(date)
FROM sales ;

ALTER TABLE sales ADD COLUMN month_name VARCHAR(10) ;

UPDATE sales
SET month_name = MONTHNAME(date);

-- -------------------------------------------------------------------------------------------------------

-- ------------------------------------------------------------------------------------------------------------------
-- ------------------------------------Generic Questions ----------------------------------------------------------------------

-- 1. How many unique cities does the data have?

SELECT 
      DISTINCT city
FROM sales ;

-- 2. In which city is each branch?

SELECT 
      DISTINCT branch
FROM sales ;

SELECT 
     DISTINCT city,
     branch
FROM sales ;

-- ------------------------------------------------------------------------------------------------------------------
-- -----------------------------------------Product Questions ------------------------------------------------------------------

-- 1. How many unique product lines does the data have?

SELECT
      COUNT(DISTINCT product_line) 
FROM sales ;

-- 2. What is the most common payment method? 

SELECT
	  Payment_method,
	 COUNT(Payment_method) AS cnt
FROM sales
GROUP BY Payment_method
ORDER BY cnt DESC ;

-- 3. What is the most selling product line?

SELECT 
      product_line,
      COUNT(product_line) AS av
FROM sales 
GROUP BY product_line
ORDER BY av DESC;

-- 4. What is the total revenue by month? 

SELECT
      month_name AS month,
      SUM(total) AS total_revenue
FROM sales
GROUP BY month_name
ORDER BY total_revenue DESC;

-- 5. What month had the largest COGS?

SELECT
      month_name AS Months,
      SUM(cogs) AS total_cogs
FROM sales
GROUP BY month_name
ORDER BY total_cogs;

-- 6. What product line had the largest revenue?

SELECT 
      product_line,
      SUM(total) AS total_revenue
FROM sales
GROUP BY product_line
ORDER BY total_revenue DESC;

-- 7. What is the city with the largest revenue?

SELECT 
      city,
      SUM(total) AS total_revenue
FROM sales
GROUP BY city
ORDER BY total_revenue DESC;

-- 8. What product line had the largest VAT?

SELECT 
      product_line,
      AVG(VAT) as avg_VAT
FROM sales
GROUP BY Product_line
ORDER BY avg_VAT DESC ;

-- 9. Fetch each product line and add a column to those product line showing "Good", "Bad". Good if its greater than average sales

SELECT 
    Product_line,
    SUM(Total) AS total_sales,
    CASE 
        WHEN SUM(Total) > (SELECT AVG(Total_sales) FROM (SELECT SUM(Total) AS Total_sales FROM sales GROUP BY Product_line) AS avg_sales)
        THEN 'Good'
        ELSE 'Bad'
    END AS sales_performance
FROM 
    sales
GROUP BY 
    Product_line;


-- 10. Which branch sold more products than average product sold?

SELECT
      branch,
      SUM(quantity) AS qty
FROM sales
GROUP BY branch
HAVING SUM(quantity) > (SELECT AVG(quantity) FROM sales);

-- 11. What is the most common product line by gender?

SELECT 
      gender,
      product_line,
      COUNT(gender) AS total_cnt
FROM sales
GROUP BY gender, Product_line
ORDER BY total_cnt DESC;

-- 12. What is the average rating of each product line?

SELECT 
      ROUND(AVG(rating),2) AS avg_R,
      product_line
FROM sales
GROUP BY product_line
ORDER BY avg_R DESC ;

-- ---------------------------------------------------------------------------------------------------------------
-- ------------------------------------ Sales Questions ----------------------------------------------------------

-- 1. Number of sales made in each time of the day per weekday?

SELECT
      time_of_day,
      COUNT(*) AS total_sales
FROM sales
GROUP BY time_of_day
ORDER BY total_sales DESC ;

-- 2. Which of the customer types brings the most revenue?

SELECT
      customer_type,
      SUM(total) AS total_rev
FROM sales
GROUP BY customer_type
ORDER BY total_rev DESC;

-- 3. Which city has the largest tax percent/ VAT (Value Added Tax)?

SELECT
      city,
      AVG(VAT) AS VAT
FROM sales
GROUP BY city
ORDER BY VAT DESC;

-- 4. Which customer type pays the most in VAT?

SELECT
      customer_type,
      AVG(VAT) AS VAT
FROM sales
GROUP BY Customer_type
ORDER BY VAT DESC;


-- ---------------------------------------------------------------------------------------
-- --------------------------- Customer Questions ----------------------------------------

-- 1. How many unique customer types does the data have?

SELECT 
     DISTINCT customer_type
FROM sales ;

-- 2. How many unique payment methods does the data have?

SELECT 
      DISTINCT payment_method
FROM sales ;

-- 3. What is the most common customer type?

SELECT
     MAX(customer_type)
FROM sales;

-- 4. Which customer type buys the most?

SELECT 
      customer_type,
      COUNT(Quantity) AS customer
FROM sales
GROUP BY customer_type ;

-- 5. What is the gender of most of the customers?

SELECT
     gender,
     COUNT(gender) AS gnd
FROM sales
GROUP BY gender ;

-- 6. What is the gender distribution per branch?
      
SELECT
 gender,
     COUNT(*) AS male
FROM sales
WHERE branch = 'A'
GROUP BY gender
ORDER BY male ;

-- 7. Which time of the day do customers give most ratings?

SELECT 
     time_of_day,
     AVG(rating) AS avg_rt
FROM sales
GROUP BY time_of_day
ORDER BY avg_rt  desc;

-- 8. Which time of the day do customers give most ratings per branch?

SELECT 
     time_of_day,
     AVG(rating) AS avg_rt
FROM sales
WHERE branch = 'B'
GROUP BY time_of_day
ORDER BY avg_rt  desc;

-- 9. Which day fo the week has the best avg ratings?

SELECT 
	 day_name,
     AVG(rating) AS avg_rt
FROM sales
GROUP BY day_name
ORDER BY avg_rt DESC;

-- 10.Which day of the week has the best average ratings per branch?

SELECT 
	 day_name,
     AVG(rating) AS avg_rt
FROM sales
WHERE branch = 'A'
GROUP BY day_name
ORDER BY avg_rt DESC;
