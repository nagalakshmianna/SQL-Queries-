--SQL Retail Sales Analysis - P1
drop table retail_sale;

create table retail_sale(
transactions_id int primary key,
sale_date DATE,
sale_time TIME,
customer_id int,
gender varchar(15),
age int,
category varchar(15), 
quantiy int,
price_per_unit FLOAT,
cogs FLOAT,
total_sale FLOAT
);

select * from retail_sale
LIMIT 10
select
    COUNT(*)
FROM retail_sale

select * from retail_sale
WHERE transactions_id is null

select * from retail_sale
WHERE sale_date is null

select * from retail_sale
WHERE sale_time is null

select * from retail_sale
WHERE
   transactions_id is null
   OR
   sale_date is null
   OR
   sale_time is null
   OR
   gender is null
   OR
   age is null
   OR
   category is null
   OR
   quantiy is null
   OR
   price_per_unit is null
   OR
   cogs is null
   OR
   total_sale is null
   
   
delete from retail_sale  
WHERE
   transactions_id is null
   OR
   sale_date is null
   OR
   sale_time is null
   OR
   gender is null
   OR
   age is null
   OR
   category is null
   OR
   quantiy is null
   OR
   price_per_unit is null
   OR
   cogs is null
   OR
   total_sale is null
   
----DATA EXPLORATION--
select COUNT(*) as total_sale from retail_sale

select COUNT(DISTINCT customer_id) as total_sale from retail_sale
select DISTINCT category as total_sale from retail_sale

---DATA ANALYSIS--

--1.write a sql query to retrive all columns for sales made on '2022-11-05'
select *
from retail_sale
where sale_date = '2022-11-05'

--2.write a sql query to retrive all transactions where the category is 'clothing' and the quantiy sold is more then 10 in the month of Nov-2022
select *
from retail_sale
where 
    category = 'Clothing'
     AND
	 TO_CHAR(sale_date, 'YYYY-MM') = '2022-11'
	 AND
	 quantiy >= 4

--3.write the sql query to calculate the total saleas(total_sale) for each category
select 
     category,
	 SUM(total_sale) as net_sale,
	 COUNT(*) as total_order
from retail_sale
group by 1

--4.write the sql query to find the average age of customers who purchased items from the 'Beuty' category
select 
     ROUND(AVG(age), 2) as avg_age
from retail_sale
where category = 'Beauty'

--5.write a sql query to find all transactions where the total_sale is greater than 1000
select * from retail_sale 
where total_sale > 1000

--6.write the sql query to find the total number of transactions (transaction_id) made by each gender in each category
select
     category,
	 gender,
	 COUNT(*) as total_transactions
from retail_sale
group by
     category,
	 gender
order by 1

--7.write the sql query to calculate the average sale for each month. find out the best selling month in each year
select 
     year,
	 month,
	 avg_sale
from
(
    select
    EXTRACT(YEAR FROM sale_date) as year,
	 EXTRACT(MONTH FROM sale_date) as MONTH,
	 SUM(total_sale) as avg_sale,
	 RANK() OVER(PARTITION BY EXTRACT(YEAR FROM sale_date) ORDER BY AVG(total_sale) DESC) as rank
from retail_sale
group by 1, 2
) as t1
where rank = 1

--8.write the sql query to find out the top 5 customers based on the highest total sales
select 
     customer_id,
	 SUM(total_sale) as total_sales
from retail_sale
group by 1
order by 2 DESC
LIMIT 5

--9.write the sql query to find the number of unique customers who purchased items for each category.
select
     category,
     COUNT( DISTINCT customer_id) as cnt_unique_cs
from retail_sale
group by category

--10. write the sql query to create each shift and number of orders(EX: morninh <= 12, Afternoon between 12 & 17, evening >17)
WITH hourly_sale
AS
(
select *,
      CASE
	     WHEN EXTRACT(HOUR FROM sale_time) < 12 THEN 'Morning'
		 WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
		 ELSE 'Evening'
		END as shift
from retail_sale
)
select 
      shift,
	  COUNT(*) as total_orders
from hourly_sale
group by shift

--End of Project--






















	 







	







