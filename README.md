# Retail Sales Analysis SQL Project

## Project Overview

**Project Title**: Retail Sales Analysis  
**Level**: Beginner  
**Database**: `p1_retail_db`

This project is designed to demonstrate SQL skills and techniques typically used by data analysts to explore, clean, and analyze retail sales data. The project involves setting up a retail sales database, performing exploratory data analysis (EDA), and answering specific business questions through SQL queries. This project is ideal for those who are starting their journey in data analysis and want to build a solid foundation in SQL.

## Objectives

1. **Set up a retail sales database**: Create and populate a retail sales database with the provided sales data.
2. **Data Cleaning**: Identify and remove any records with missing or null values.
3. **Exploratory Data Analysis (EDA)**: Perform basic exploratory data analysis to understand the dataset.
4. **Business Analysis**: Use SQL to answer specific business questions and derive insights from the sales data.

## Project Structure

### 1. Database Setup

- **Database Creation**: The project starts by creating a database named `p1_retail_db`.
- **Table Creation**: A table named `retail_sales` is created to store the sales data. The table structure includes columns for transaction ID, sale date, sale time, customer ID, gender, age, product category, quantity sold, price per unit, cost of goods sold (COGS), and total sale amount.

```sql
USE sql_pro_01;
DROP TABLE IF EXISTS retail_sales;
CREATE TABLE retail_sales
	(
     transactions_id INT PRIMARY KEY,
     sale_date DATE,
     sale_time TIME,
     customer_id INT,
     gender VARCHAR(10),
     age INT,
     category VARCHAR(15),
     quantity INT,
     price_per_unit FLOAT,
     cogs FLOAT,
     total_sale FLOAT
	);
```

### 2. Data Exploration & Cleaning

- **Record Count**: Determine the total number of records in the dataset.
- **Customer Count**: Find out how many unique customers are in the dataset.
- **Category Count**: Identify all unique product categories in the dataset.
- **Null Value Check**: Check for any null values in the dataset and delete records with missing data.

```sql
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
```

-- Data Exploration--
```sql
USE sql_pro_01;
```
-- How many sales where there--
```sql
SELECT COUNT(*) FROM retail_sales;
```
-- Ans: 1987 --

-- How many customers where there?--
```sql
SELECT COUNT(distinct(customer_id)) FROM retail_sales;
```
-- Ans: 155 --

-- How many categories are there? --
```sql
SELECT distinct(category) FROM retail_sales;
```
-- Ans: Beauty, Clothing & Electronics --

### 3. Data Analysis & Findings

The following SQL queries were developed to answer specific business questions:

1. **Write a SQL query to retrieve all columns for sales made on '2022-11-05**:
```sql
SELECT * FROM retail_sales
WHERE sale_date = "2022-11-05";
```
-- Ans: it is showing 11 rows of data --

2. **Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022**:
```sql
SELECT * FROM retail_sales
WHERE category = "Clothing"
AND sale_date BETWEEN "2022-11-01" AND "2022-11-30"
AND quantity >= 4;
```
-- Ans: 17 rows returned --

3. **Write a SQL query to calculate the total sales (total_sale) for each category.**:
```sql
SELECT category, SUM(total_sale) as total_sales FROM retail_sales
group by category;
```
-- Ans: Beauty	286790 , Clothing	309995, Electronics	311445 --

4. **Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.**:
```sql
SELECT AVG(age) FROM retail_sales
WHERE category = "Beauty";
```
-- Ans: Avg Age = 40.4157 --

5. **Write a SQL query to find all transactions where the total_sale is greater than 1000.**:
```sql
SELECT * FROM retail_sales
WHERE total_sale > 1000
```
-- Ans: 306 rows returned --

6. **Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.**:
```sql
SELECT gender, category, COUNT(transactions_id)
FROM retail_sales
GROUP BY gender, category;
```
-- Ans. Male	Beauty	    281
--      Female	Clothing	347
--      Male	Electronics	343
--      Male	Clothing	351
--      Female	Beauty	    330
--      Female	Electronics	335

7. **Write a SQL query to calculate the average sale for each month. Find out best selling month in each year**:
```sql
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
```

8. **Write a SQL query to find the top 5 customers based on the highest total sales **:
```sql
SELECT customer_id, SUM(total_sale) as total_sales
FROM retail_sales
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5
```
-- Answer
-- 3	38440
-- 1	30750
-- 5	30405
-- 2	25295
-- 4	23580

9. **Write a SQL query to find the number of unique customers who purchased items from each category.**:
```sql
SELECT 
    category,    
    COUNT(DISTINCT customer_id) as cnt_unique_cs
FROM retail_sales
GROUP BY category
```
-- Answer
-- Beauty	    141
-- Clothing	    149
-- Electronics	144

10. **Write a SQL query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17)**:
```sql
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
```

## Findings

- **Customer Demographics**:   The dataset includes customers from various age groups, with sales distributed across different categories such as Clothing and Beauty.
- **High-Value Transactions**: Several transactions had a total sale amount greater than 1000, indicating premium purchases.
- **Sales Trends**:            Monthly analysis shows variations in sales, helping identify peak seasons.
- **Customer Insights**:       The analysis identifies the top-spending customers and the most popular product categories.

## Reports

- **Sales Summary**:     A detailed report summarizing total sales, customer demographics, and category performance.
- **Trend Analysis**:    Insights into sales trends across different months and shifts.
- **Customer Insights**: Reports on top customers and unique customer counts per category.

## Conclusion

This project serves as a comprehensive introduction to SQL for data analysts, covering database setup, data cleaning, exploratory data analysis, and business-driven SQL queries. The findings from this project can help drive business decisions by understanding sales patterns, customer behavior, and product performance.
