-- ============================================================
-- Project  : RetailIQ — E-commerce Sales Analysis
-- Author   : Basil
-- Tool     : MySQL 8.0
-- Dataset  : retail_orders (2000 rows, 2022–2024)
-- Concepts : SELECT, GROUP BY, CASE, JOIN, Subquery,
--            Window Functions, CTE, ROLLUP, Date Functions
-- ============================================================
CREATE DATABASE retailiq;
USE retailiq;
CREATE TABLE retail_orders (
    order_id        VARCHAR(20),
    order_date      DATE,
    ship_date       DATE,
    customer_id     VARCHAR(20),
    customer_name   VARCHAR(100),
    segment         VARCHAR(50),
    region          VARCHAR(50),
    city            VARCHAR(50),
    product_id      VARCHAR(20),
    category        VARCHAR(50),
    sub_category    VARCHAR(50),
    product_name    VARCHAR(100),
    quantity        INT,
    unit_price      DECIMAL(10,2),
    discount        DECIMAL(5,2),
    sales           DECIMAL(10,2),
    profit          DECIMAL(10,2),
    ship_mode       VARCHAR(50),
    payment_method  VARCHAR(50),
    returned        VARCHAR(5)
);
select count(*) from retail_orders;


-- Query 1: Top 10 orders by sales
-- Shows the highest value transactions across all regions
select order_id,
customer_name,
region,
category,
sales 
from retail_orders 
order by sales 
desc limit 10;


-- Query 2: Sales & Profit by Region
-- Compares total revenue, profit and margin efficiency per region
select 
region,
round(sum(sales),2) AS total_sales,
round(sum(profit),2) AS total_profit,
round(avg(profit/sales*100),2) AS avg_profit_pct 
from retail_orders 
group by region 
order by sum(profit) desc;

-- Query 3: Order Value Segmentation using CASE
-- Classifies each order into High, Mid, or Low value tier based on sales amount
-- Business use: Identify premium orders for targeted marketing
select order_id,customer_name,sales,
CASE
	when sales > 5000 then 'High Value'
    when sales between 2000 AND 5000 then 'Mid Value'
    when sales < 2000 then 'Low Value'
End As order_segment
from retail_orders
order by sales desc;



CREATE TABLE customers (
    customer_id     VARCHAR(20),
    customer_name   VARCHAR(100),
    age             INT,
    loyalty_tier    VARCHAR(20)
);


INSERT INTO customers VALUES
('CUST0001', 'Customer_1',  28, 'Gold'),
('CUST0002', 'Customer_2',  35, 'Silver'),
('CUST0003', 'Customer_3',  42, 'Platinum'),
('CUST0004', 'Customer_4',  25, 'Bronze'),
('CUST0005', 'Customer_5',  31, 'Gold'),
('CUST0006', 'Customer_6',  29, 'Silver'),
('CUST0007', 'Customer_7',  38, 'Platinum'),
('CUST0008', 'Customer_8',  45, 'Bronze'),
('CUST0009', 'Customer_9',  27, 'Gold'),
('CUST0010', 'Customer_10', 33, 'Silver');


-- Query 4: Customer Order Analysis using JOIN
-- Combines order data with customer demographics (age, loyalty tier)
-- Business use: Understand which customer segments drive highest sales

select r.order_id,c.customer_name,r.region,r.sales,c.age,c.loyalty_tier
from retail_orders r
inner join customers c
on r.customer_id = c.customer_id
order by sales desc
limit 15;


-- Query 5: Above Average Sales Orders using Subquery
-- Finds all orders where sales exceed the overall average
-- Business use: Identify high performing orders for further analysis

select order_id,customer_name,region,sales
from retail_orders
where sales > (select avg(sales) from retail_orders)
order by sales desc;

-- Query 6: Running Total of Sales by Region using Window Function
-- Calculates cumulative sales within each region ordered by date
-- Business use: Track how sales build up over time per region

select order_id,region,order_date,sales,
sum(sales) over (partition by region order by order_date) as running_total
from retail_orders
order by region,order_date;


-- Query 7: Top Category per Region using CTE
-- First calculates sales by region & category, then ranks them
-- Business use: Identify which product category leads in each region

with category_sales as (
select region,category,round(sum(sales),2) as total_sales,
rank() over (partition by region order by sum(sales) desc) as rnk
from retail_orders
group by region,category
)

select region,category,total_sales
from category_sales
where rnk = 1
order by total_sales desc;


-- Query 8: High Performing Regions using HAVING
-- Filters regions where total sales exceed ₹14,00,000
-- Business use: Identify regions that meet minimum revenue threshold

select region,round(sum(sales),2) as total_sales
from retail_orders
group by region
having total_sales > 1400000;


-- Query 9: Monthly Sales Trend using Date Functions
-- Extracts month and year from order_date to show sales over time
-- Business use: Identify peak and low performing months across years

select year(order_date) as order_year,month(order_date) as order_month,round(sum(sales),2) as total_sales
from retail_orders
group by year(order_date),month(order_date)
order by year(order_date),month(order_date);


-- Query 10: Sales Distribution by Order Value Segment
-- Groups orders into High, Mid, Low value tiers and calculates total sales per tier
-- Business use: Understand which order segment drives the most revenue

select order_segment,count(order_id) as total_orders,ROUND(SUM(sales), 2) AS total_sales
from (
	select order_id,sales,
    case
		when sales > 5000 then 'High'
		when sales between 2000 and 5000 then 'Mid'
		when sales < 2000 then 'Low'
	end as order_segment
    from retail_orders
) as segmented
group by order_segment
order by total_sales desc;


-- Query 11: Top 3 Orders per Region using ROW_NUMBER
-- Assigns a row number to each order within its region ranked by sales
-- Business use: Identify the best performing orders in each region

with orders_per_region as (
select order_id,region,customer_name,sales,
row_number() over(partition by region order by sales desc) as row_num
from retail_orders
)

select region,order_id,customer_name,sales
from orders_per_region
where row_num <= 3;
		


-- Query 12: Each Order's Percentage Contribution to Total Sales
-- Calculates what % of total revenue each order represents
-- Business use: Identify orders that contribute disproportionately to revenue

select order_id,customer_name,region,sales,
round(sales/ (select sum(sales) from retail_orders) * 100,2) as pct_of_total
from retail_orders
order by pct_of_total desc;

-- Adding test customer with no orders to demonstrate LEFT JOIN
INSERT INTO customers VALUES
('CUST0301', 'Customer_301', 40, 'Bronze');


-- Query 13: All Customers including those with No Orders using LEFT JOIN
-- Returns all customers from customers table even if they have no matching orders
-- Business use: Identify inactive customers who have never placed an order

select c.customer_id,c.customer_name,c.loyalty_tier,ROUND(SUM(r.sales),2) as total_sales
from customers c
left join retail_orders r
on c.customer_id = r.customer_id
group by c.customer_id,c.customer_name,c.loyalty_tier
order by total_sales desc;


-- Query 14: Sales Breakdown by Category and Sub-Category
-- Groups data by both category and sub_category to show granular revenue
-- Business use: Identify which sub-categories drive sales within each category

select category,sub_category, round(sum(sales),2) as total_sales,round(sum(profit),2) as total_profit
from retail_orders
group by category,sub_category
order by category,total_sales desc;


-- Query 15: Month over Month Sales Change using LAG
-- Compares each month's sales to the previous month
-- Business use: Track sales growth or decline trends over time

with monthly_sales as (
select month(order_date) as order_month,year(order_date) as order_year, round(sum(sales),2) as total_sales
from retail_orders
group by month(order_date),year(order_date)
order by year(order_date),month(order_date)
)

select *,
lag (total_sales,1) over (order by order_year,order_month) as prev_month_sales,
round(total_sales - lag(total_sales,1) over (order by order_year,order_month),2) as mom_change
from monthly_sales;



-- Query 16: Discount Impact on Profit using CASE + GROUP BY
-- Groups orders by discount tier and compares average profit
-- Business use: Understand whether discounts are hurting profitability

with discount_impact as (
	select profit,sales,discount,
    case
		when discount = 0 then 'No Discount'
        when discount between 0.01 and 0.10 then 'Low'
        when discount between 0.11 and 0.20 then 'Medium'
        when discount > 0.20 then 'High'
	end as discount_tier
    from retail_orders)
    
select discount_tier,round(avg(profit),2) as avg_profit,round(avg(sales),2) as avg_sales
from discount_impact
group by discount_tier;


-- Query 17: Above Average Profit Categories using Nested Subquery
-- Finds categories where average profit exceeds the overall average profit
-- Business use: Identify which categories are most profitable compared to baseline

select category,round(avg(profit),2) as avg_profit
from retail_orders
group by category
having avg(profit) > ( select avg(profit) from retail_orders)
order by avg_profit desc;


-- Query 18: Customer Lifetime Value Analysis using GROUP BY aggregation
-- Calculates total spend, total orders, average order value per customer
-- Business use: Identify highest value customers for retention and loyalty programs

select customer_id,customer_name,count(order_id) as total_orders,
round(sum(sales),2) as total_sales,round(avg(sales),2) as avg_order_value,
round(sum(profit),2) as total_profit
from retail_orders
group by customer_id,customer_name
order by total_sales desc;


-- Query 19: Sales Subtotals by Region and Category using ROLLUP
-- Generates subtotals for each region and a grand total at the end
-- Business use: Executive summary view of sales hierarchy in one query

select region,category,round(sum(sales),2) as total_sales
from retail_orders
group by region,category with rollup;


-- Query 20: Regional Profitability Scorecard
-- Combines sales, profit, margin, order count, return rate and discount impact
-- Business use: Complete performance snapshot per region for executive reporting

select region,count(order_id) as total_orders,round(sum(sales),2) as total_sales,
round(sum(profit),2) as total_profit,round(avg(profit/sales*100),2) as avg_margin,
round(avg(discount)*100,2) as discount_perc,
round(sum(case when returned = 'Yes' then 1 else 0 end) / count(order_id) * 100,2) as return_rate
from retail_orders
group by region
order by total_profit desc;




