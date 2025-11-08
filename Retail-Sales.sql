use retail_sql;

CREATE TABLE Retail_Sales
     (
      transactions_id INT PRIMARY KEY,
      sale_date DATE,
      Sale_time TIME,
      customer_id INT,
      gender VARCHAR(5),
      age INT,
      category VARCHAR(15),
      quantity INT,
      price_per_unit FLOAT,
      cogs FLOAT,
      total_sale FLOAT
	);     
    
-- Data Exploration & Cleaning

-- How to find Null values

SELECT * FROM
    retail_sales
WHERE
    transactions_id IS NULL
        OR sale_date IS NULL
        OR sale_time IS NULL
        OR customer_id IS NULL
        OR gender IS NULL
        OR age IS NULL
        OR category IS NULL
        OR quantity IS NULL
        OR price_per_unit IS NULL
        OR cogs IS NULL
        OR total_sale IS NULL
;

-- how to delete Null values

DELETE FROM retail_sales 
WHERE
    transactions_id IS NULL
    OR sale_date IS NULL
    OR sale_time IS NULL
    OR customer_id IS NULL
    OR gender IS NULL
    OR age IS NULL
    OR category IS NULL
    OR quantity IS NULL
    OR price_per_unit IS NULL
    OR cogs IS NULL
    OR total_sale IS NULL
; 

-- How many sales we have?

SELECT 
    COUNT(*)
FROM
    retail_sales;

-- How many customer we have?

SELECT 
    COUNT(DISTINCT customer_id) AS Customer
FROM
    retail_sales;

-- How many category we have?

SELECT 
    COUNT(DISTINCT category) AS Category
FROM
    retail_sales;

--  What type of Category?

SELECT DISTINCT
    category AS Category
FROM
    retail_sales;
    
    -- Write a SQL query to retrieve all columns for sales made on '2022-11-05

SELECT * FROM
    retail_sales
WHERE
    sale_date = '2022-11-05';
    
-- Write a SQL query to retrieve all transactions 
-- where the category is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022

SELECT *
FROM retail_sales
WHERE category = 'Clothing'
  AND DATE_FORMAT(sale_date, '%Y-%m') = '2022-11'
  AND quantity <= 4;

-- Write a SQL query to calculate the total sales (total_sale) for each category.

SELECT 
    category, SUM(total_sale) AS Total_Sale
FROM
    retail_sales
GROUP BY 1;

-- Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.

SELECT 
    ROUND(AVG(age), 0) AS Avg_Age
FROM
    retail_sales
WHERE
    category = 'Beauty';
    
-- Write a SQL query to find all transactions where the total_sale is greater than 1000.

SELECT * FROM
    retail_sales
WHERE
    total_sale >= 1000;
    
-- Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.

SELECT 
    category, gender, COUNT(*) AS Total_Trans
FROM
    retail_sales
GROUP BY category , gender
ORDER BY 1;

-- Write a SQL query to calculate the average sale for each month. Find out best selling month in each year

SELECT 
    Year, Month, Avg_sale
FROM
(
	SELECT
		YEAR(sale_date) AS year,
		MONTH(sale_date) AS month,
		AVG(total_sale) AS avg_sale,
		RANK() OVER (PARTITION BY YEAR(sale_date) ORDER BY AVG(total_sale) DESC) AS Ranks
	FROM retail_sales
	GROUP BY year, month
) AS t1
WHERE Ranks= 1;

-- Write a SQL query to find the top 5 customers based on the highest total sales

SELECT 
    customer_id, SUM(total_sale) AS Net_Sale
FROM
    retail_sales
GROUP BY customer_id
ORDER BY Net_sale DESC
LIMIT 5;

-- Write a SQL query to find the number of unique customers who purchased items from each category.

SELECT 
    category, COUNT(DISTINCT customer_id) AS unique_customers
FROM
    retail_sales
GROUP BY category;

-- Write a SQL query to create each shift and number of orders (Example Morning <12,Afternoon Between 12 & 17, Evening >17)

SELECT 
    Shift, COUNT(*) AS Total_Orders
FROM
    (SELECT *,
            CASE
                WHEN HOUR(sale_time) < 12 THEN 'Morning'
                WHEN HOUR(sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
                ELSE 'Evening'
            END AS shift
    FROM
        retail_sales) AS t1
GROUP BY Shift;