# RetailIQ — E-commerce SQL Analysis

![MySQL](https://img.shields.io/badge/Tool-MySQL-blue)
![Status](https://img.shields.io/badge/Status-Completed-green)
![Queries](https://img.shields.io/badge/Queries-20-orange)

## Project Overview
RetailIQ is an end-to-end SQL analysis project built on a synthetic 
but realistic e-commerce retail dataset containing 2000 orders across 
2022–2024. The project simulates the work of a real data analyst — 
starting from raw transactional data and progressively uncovering 
business insights around regional performance, category profitability, 
customer behavior, discount strategy and sales trends. 20 SQL queries 
were written covering beginner to advanced concepts including JOINs, 
Subqueries, Window Functions, CTEs and ROLLUP — structured to answer 
specific business questions that a retail company's management team 
would actually ask.

## Dataset
| Field | Details |
|---|---|
| Source | Synthetic retail orders dataset |
| Rows | 2000 |
| Columns | 20 |
| Period | 2022 — 2024 |
| Domain | E-commerce / Retail |

## Tool Used
- MySQL 8.0 / MySQL Workbench

## Business Questions Answered
1.  Which are the top 10 highest value orders across all regions?
2.  Which region generates the highest total sales and profit?
3.  How can orders be segmented into High, Mid and Low value tiers?
4.  Which customer loyalty tier drives the highest sales?
5.  Which orders perform above the overall average sales?
6.  How do cumulative sales build up over time within each region?
7.  Which product category leads in sales within each region?
8.  Which regions meet the minimum revenue threshold of ₹14,00,000?
9.  What is the monthly sales trend across 2022, 2023 and 2024?
10. How much total revenue and how many orders come from each value segment?
11. What are the top 3 highest sales orders in each region?
12. What percentage of total revenue does each individual order contribute?
13. Which customers have never placed an order?
14. Which sub-categories drive the most sales within each category?
15. How does sales performance change month over month?
16. Do higher discounts lead to lower profit?
17. Which product categories perform above the overall average profit?
18. Who are the top customers by lifetime sales value and order count?
19. What are the regional and category-level sales subtotals?
20. What does the complete profitability scorecard look like per region?

## Key Findings
- **West** region had highest total sales (₹17.3L) but **North** 
  was most margin efficient at 23.1%
- **Books** led in sales by category but had the lowest 
  profit margin at 22.2%
- Higher discounts consistently resulted in lower average 
  profit — No Discount orders averaged ₹924 profit vs 
  ₹664 for High Discount orders
- **December** is the peak sales month every year — 
  festive season effect
- **Central** region had the lowest return rate at 18.4% — 
  most reliable region
- Top 28.8% of orders (High Value) contributed 60.9% 
  of total revenue — Pareto principle confirmed

## SQL Concepts Used
| Concept | Query |
|---|---|
| SELECT, ORDER BY, LIMIT | Q1 |
| GROUP BY, Aggregates, Aliases | Q2 |
| CASE Statement | Q3, Q10, Q16 |
| INNER JOIN | Q4 |
| Subquery in WHERE | Q5 |
| Window Function — SUM OVER | Q6 |
| CTE + RANK | Q7 |
| HAVING | Q8 |
| Date Functions | Q9 |
| Subquery in SELECT | Q12 |
| LEFT JOIN | Q13 |
| Multiple GROUP BY | Q14 |
| LAG Window Function | Q15 |
| Nested Subquery + HAVING | Q17 |
| Customer Aggregation | Q18 |
| ROLLUP | Q19 |
| Complex Scorecard Query | Q20 |



## How to Run
1. Clone this repository
2. Open MySQL Workbench and connect to local server
3. Import `data/retail_orders.csv` using Table Data Import Wizard
4. Open `sql/analysis.sql`
5. Run queries individually using `Ctrl + Shift + Enter`

## Author
**Basil** — Aspiring Data Analyst  
📍 Kochi, Kerala  
🔗 [LinkedIn](www.linkedin.com/in/basil-paul94) | [GitHub](https://github.com/basil940)
