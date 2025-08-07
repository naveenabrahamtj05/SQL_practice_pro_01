SELECT * FROM sql_pro_01.retail_sales;

SELECT COUNT(*) FROM sql_pro_01.retail_sales;

SELECT * FROM sql_pro_01.retail_sales
WHERE
     transactions_id is NULL
     OR
     sale_date is NULL
     OR
     sale_time is NULL
     OR
     customer_id is NULL
     OR
     gender is NULL
     OR
     age is NULL
     OR
     category is NULL
     OR
     quantity is NULL
     OR
     price_per_unit is NULL
     OR
     cogs is NULL
     OR
     total_sale is NULL;
     
-- Data Exploration--
USE sql_pro_01;

-- How many sales where there--
SELECT COUNT(*) FROM retail_sales;
-- Ans: 1987 --

-- How many customers where there?--
SELECT COUNT(distinct(customer_id)) FROM retail_sales;
-- Ans: 155 --

-- How many categories are there? --
SELECT distinct(category) FROM retail_sales;
-- Ans: Beauty, Clothing & Electronics --

-- Data Analysis & Business Key problems --
-- Data Analysis & Business Key Problems & Answers --

-- My Analysis & Findings --
-- Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05'
-- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 10 in the month of Nov-2022
-- Q.3 Write a SQL query to calculate the total sales (total_sale) for each category.
-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.
-- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.
-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.
-- Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year
-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales
-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.
-- Q.10 Write a SQL query to create each shift and number of orders (Example Morning <=12, Afternoon Between 12 & 17, Evening >17)

-- Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05'?
SELECT * FROM retail_sales
WHERE sale_date = "2022-11-05";
-- Ans: it is showing 11 rows of data --

-- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022? --
SELECT * FROM retail_sales
WHERE category = "Clothing"
AND sale_date BETWEEN "2022-11-01" AND "2022-11-30"
AND quantity >= 4;
-- Ans: 17 rows returned

-- Q.3 Write a SQL query to calculate the total sales (total_sale) for each category? --
SELECT category, SUM(total_sale) as total_sales FROM retail_sales
group by category;
-- Ans: Beauty	286790 , Clothing	309995, Electronics	311445

-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category? --
SELECT AVG(age) FROM retail_sales
WHERE category = "Beauty";
-- Ans: Avg Age = 40.4157

-- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000? --
SELECT * FROM retail_sales
WHERE total_sale > 1000;
-- Ans: 306 rows returned --

-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.
SELECT gender, category, COUNT(transactions_id)
FROM retail_sales
GROUP BY gender, category;
-- Ans. Male	Beauty	    281
--      Female	Clothing	347
--      Male	Electronics	343
--      Male	Clothing	351
--      Female	Beauty	    330
--      Female	Electronics	335
-- Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year

-- 1. Average sale per month
SELECT 
     YEAR(sale_date) AS year,
     MONTH(sale_date) AS month,
     AVG(total_sale) AS avg_total_sales
FROM retail_sales
-- GROUP BY 1, 2
-- ORDER BY 1, 3 DESC
GROUP BY YEAR(sale_date), MONTH(sale_date);

-- 2. Best-selling month in each year (based on total sales)
SELECT
     year, month, total_monthly_sales
FROM (
SELECT
	 YEAR(sale_date) AS y,
     MONTH(sale_date) AS m,
     SUM(total_sale) AS total_monthly_sales,
     RANK() OVER (PARTITION BY y ORDER BY total_monthly_sales DESC) AS rnk
FROM retail_sales
GROUP BY y,m
) as ranked
WHERE rnk = 1;


-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales
SELECT customer_id, SUM(total_sale) as total_sales
FROM retail_sales
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5
-- Answer
-- 3	38440
-- 1	30750
-- 5	30405
-- 2	25295
-- 4	23580


-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.
SELECT 
	category,COUNT(DISTINCT(customer_id)) as unq_customer
FROM retail_sales
GROUP BY category
-- Answer
-- Beauty	    141
-- Clothing	    149
-- Electronics	144




-- Q.10 Write a SQL query to create each shift and number of orders (Example Morning <=12, Afternoon Between 12 & 17, Evening >17)
WITH hourly_sales
AS
(
SELECT *,
	CASE
		WHEN HOUR(sale_time) < 12 THEN 'Morning'
        WHEN HOUR(sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
        ELSE 'Evening'
	END as shift
FROM retail_sales
)
SELECT 
	shift,
    COUNT(*) AS total_sales
    FROM hourly_sales
    GROUP BY  shift 
    
-- End of project 1