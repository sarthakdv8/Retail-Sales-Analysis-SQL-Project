SELECT *
FROM retail_sale;

-- Data Cleaning

ALTER TABLE retail_sale
RENAME COLUMN `ï»¿transactions_id` TO `transcations_id`;
WITH duplicates AS(
SELECT *,
ROW_NUMBER() OVER(PARTITION BY transcations_id, sale_date, sale_time, customer_id, gender, age, category, quantiy, price_per_unit, cogs, total_sale) as row_num
FROM retail_sale
)
SELECT * FROM duplicates
WHERE row_num>1;
				-- No Duplicates 
                
-- Standardizing The data

ALTER TABLE retail_sale
RENAME COLUMN `quantiy` TO `quantity`,
MODIFY COLUMN `sale_date` DATE,
MODIFY COLUMN `sale_time` TIME;

-- NULL VALUES

SELECT * FROM retail_sale
WHERE 
    sale_date IS NULL OR sale_time IS NULL OR customer_id IS NULL OR 
    gender IS NULL OR age IS NULL OR category IS NULL OR 
    quantity IS NULL OR price_per_unit IS NULL OR cogs IS NULL;
    
-- Write a SQL query to retrieve all columns for sales made on '2022-11-05

SELECT * FROM retail_sale
WHERE sale_date = '2022-11-05';

-- Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022:

SELECT * FROM retail_sale
WHERE category = 'Clothing' and quantity >= '4' and sale_date BETWEEN '2022-11-01' AND '2022-11-30';

-- Write a SQL query to calculate the total sales (total_sale) for each category.

SELECT category,SUM(total_sale) 
FROM retail_sale
GROUP BY 1;

-- Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.:

SELECT category,AVG(age)
FROM retail_sale
GROUP BY category
HAVING category='Beauty';

-- Write a SQL query to find all transactions where the total_sale is greater than 1000

SELECT * FROM retail_sale
WHERE total_sale>1000;
    
-- Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.:

SELECT gender,count(*) FROM retail_sale
GROUP BY gender;

-- Write a SQL query to calculate the average sale for each month. Find out best selling month in each year:

WITH months AS(
SELECT 
	date_format(sale_date,'%m')as each_months,
    date_format(sale_date,'%Y')as each_year,
    AVG(total_sale) as avg_sale,
    RANK() OVER(PARTITION BY date_format(sale_date,'%Y') ORDER BY AVG(total_sale) DESC) as ranks
        FROM retail_sale
GROUP BY 1,2
ORDER BY 4
)
SELECT * FROM months
WHERE ranks=1;

-- **Write a SQL query to find the top 5 customers based on the highest total sales **:

SELECT customer_id,sum(total_sale) AS total_sales FROM retail_sale
GROUP BY 1 
ORDER BY 2 DESC LIMIT 5 ;

-- Write a SQL query to find the number of unique customers who purchased items from each category.:

SELECT category,count(DISTINCT customer_id) as cs_unique FROM retail_sale
GROUP BY 1;




