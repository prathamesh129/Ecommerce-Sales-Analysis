-- E-commerce Sales Analysis using SQL --

USE ecommerce_analysis;

-- Q1. Total Sales --
SELECT SUM(sales) AS Total_sales
FROM order_details;

-- Q2. Total Profit --
SELECT SUM(Profit) AS Total_profit
FROM order_details;

-- Q3. Total Quantity Sold --
SELECT SUM(Quantity) AS Total_quantity
FROM order_details;

-- Q4. Total Orders --
SELECT COUNT(DISTINCT Order_ID) AS Total_orders
FROM orders;

-- Q5. Total Customers --
SELECT COUNT(DISTINCT Customer_name) AS Total_customers
FROM orders;

-- Q6. Sales by Category --
SELECT Category, SUM(sales) AS Total_sales
FROM order_details
GROUP BY Category
ORDER BY Total_sales DESC;

-- Q7. Profit by Category --
SELECT Category, SUM(Profit) AS Total_profit
FROM order_details
GROUP BY Category
ORDER BY Total_profit DESC;

-- Q8. Quantity Sold by Category --
SELECT Category, SUM(Quantity) AS Total_quantity
FROM order_details
GROUP BY Category
ORDER BY Total_quantity DESC;

-- Q9. Average Sales by Category --
SELECT Category, AVG(Sales) AS Average_sales
FROM order_details
GROUP BY Category
ORDER BY Average_sales DESC;

-- Q10. Sales by State --
SELECT o.State, SUM(od.sales) AS Total_sales
FROM orders o
INNER JOIN order_details od
ON o.order_id = od.order_id
GROUP BY o.State
ORDER BY Total_sales DESC;

-- Q11. Sales by City --
SELECT o.city, SUM(od.sales) AS Total_sales
FROM orders o
INNER JOIN order_details od
ON o.order_id = od.order_id
GROUP BY o.city
ORDER BY Total_sales DESC;

-- Q12. Orders by State --
SELECT State, COUNT(*) AS Total_orders
FROM orders
GROUP BY State
ORDER BY Total_orders DESC;

-- Q13. Orders by City --
SELECT City, COUNT(*) AS Total_orders
FROM orders
GROUP BY City
ORDER BY Total_orders DESC;

-- Q14. Top 10 Customers by Sales --
SELECT o.Customer_name, SUM(od.sales) AS Total_sales
FROM orders o
INNER JOIN order_details od
ON o.order_id = od.order_id
GROUP BY o.Customer_Name
ORDER BY Total_sales DESC
LIMIT 10;

-- Q15. Top 10 Customers by Profit --
SELECT o.Customer_name, SUM(od.profit) AS Total_profit
FROM orders o
INNER JOIN order_details od
ON o.order_id = od.order_id
GROUP BY o.Customer_name
ORDER BY Total_profit DESC
LIMIT 10;

-- Q16. Customers with Profit Greater Than 1000 --
SELECT o.Customer_name, SUM(od.profit) AS Total_profit
FROM orders o
INNER JOIN order_details od
ON o.order_id = od.order_id
GROUP BY o.Customer_name
HAVING Total_profit > 1000
ORDER BY Total_profit DESC;

-- Q17. Rank customers based on their total sales --
SELECT o.Customer_name, SUM(od.Sales) AS Total_sales,
RANK() OVER (ORDER BY SUM(od.Sales) DESC) AS Rank_num
FROM orders o
INNER JOIN order_details od
ON o.Order_id = od.Order_id
GROUP BY o.Customer_name;

-- Q18. Find the top 3 customers by sales within each category.
WITH Customer_sales AS
(
SELECT od.category, o.customer_name, SUM(od.sales) AS Total_sales,
RANK() OVER(PARTITION BY od.category ORDER BY SUM(od.sales) DESC) AS Rank_num
FROM orders o
INNER JOIN order_details od
ON o.order_id = od.Order_id
GROUP BY od.Category, o.Customer_name
)
SELECT * FROM Customer_sales
WHERE Rank_num <= 3;

-- Q19. Profit Status using CASE --
SELECT Order_id, profit,
CASE WHEN profit > 0 THEN 'Profit'
WHEN Profit < 0 THEN 'Loss'
ELSE 'Break Even'
END AS Profit_status
FROM order_details;

-- Q20. Sales by Order Date --
SELECT o.order_date, SUM(od.sales) AS Total_sales
FROM orders o
INNER JOIN order_details od
ON o.order_id = od.order_id
GROUP BY o.order_date
ORDER BY o.order_date;

-- Q21. Total sales generated in each year? --
SELECT YEAR(o.Order_date) AS Order_year, SUM(od.Sales) AS Total_sales
FROM orders o
INNER JOIN order_details od
ON o.Order_id = od.Order_id
GROUP BY YEAR(o.Order_date)
ORDER BY Order_year;

-- Q22. Total sales generated in each year and month? --
SELECT YEAR(o.Order_date) AS Order_year, MONTH(o.Order_date) AS Order_month, SUM(od.Sales) AS Total_sales
FROM orders o
INNER JOIN order_details od
ON o.Order_id = od.Order_id
GROUP BY YEAR(o.Order_date), MONTH(o.Order_date)
ORDER BY Order_year, Order_month;

-- Q23. Which month generated the highest sales? --
WITH Monthly_sales AS
(
SELECT YEAR(o.Order_date) AS Order_year, MONTH(o.Order_date) AS Order_month, SUM(od.Sales) AS Total_sales
FROM orders o
INNER JOIN order_details od
ON o.Order_id = od.Order_id
GROUP BY YEAR(o.Order_date), MONTH(o.Order_date)
)
SELECT Order_year, Order_month, Total_sales
FROM Monthly_sales
ORDER BY Total_sales DESC
LIMIT 1;

-- Q24. What is the month-over-month change in sales?--
WITH Monthly_sales AS
(
SELECT YEAR(o.Order_date) AS Order_year, MONTH(o.Order_date) AS Order_month, SUM(od.Sales) AS Total_sales
FROM orders o
INNER JOIN order_details od
ON o.Order_id = od.Order_id
GROUP BY YEAR(o.Order_date), MONTH(o.Order_date)
)
SELECT Order_year, Order_month, Total_sales,
LAG(Total_sales) OVER (ORDER BY Order_year, Order_month) AS Previous_Monthsales,
Total_Sales - LAG(Total_Sales) OVER (ORDER BY Order_year, Order_month) AS Sales_difference
FROM monthly_sales
ORDER BY Order_year, Order_month;

-- Q25. Calculate the running total of sales by order.--
WITH Order_sales AS
(
SELECT Order_id, SUM(Sales) AS Total_sales
FROM order_details
GROUP BY Order_ID
)
SELECT Order_id, Total_sales, 
SUM(Total_sales) OVER (ORDER BY Order_id) AS Running_total
FROM Order_sales
ORDER BY Order_id;

-- Q26. Find the difference between each order's sales and the previous order's sales.
WITH Order_sales AS
(
SELECT Order_id, SUM(Sales) AS Total_sales
FROM order_details
GROUP BY Order_id
)
SELECT Order_id, Total_sales,
LAG(Total_sales) OVER (ORDER BY Order_id) AS Previous_order_sales,
Total_sales - LAG(Total_sales) OVER (ORDER BY Order_id) AS Sales_difference
FROM Order_sales
ORDER BY Order_id;

-- Q27. What are the total sales and total target by category?
WITH Category_sales AS
(
SELECT Category, SUM(Sales) AS Total_sales
FROM order_details
GROUP BY Category
),
Category_target AS
(
SELECT Category, SUM(Target) AS Total_target
FROM sales_target
GROUP BY Category
)
SELECT cs.Category, cs.Total_sales, ct.Total_target, cs.Total_sales - ct.Total_target AS Difference
FROM Category_sales cs
INNER JOIN Category_target ct
ON cs.Category = ct.Category
ORDER BY Difference DESC;

-- Q28. Which categories exceeded their total sales target?
WITH Category_sales AS
(
SELECT Category, SUM(Sales) AS Total_sales
FROM order_details
GROUP BY Category
),
Category_target AS
(
SELECT Category, SUM(Target) AS Total_target
FROM sales_target
GROUP BY Category
)
SELECT cs.Category, cs.Total_Sales, ct.Total_Target, cs.Total_Sales - ct.Total_Target AS Difference
FROM category_sales cs
INNER JOIN category_target ct
ON cs.Category = ct.Category
WHERE cs.Total_Sales > ct.Total_Target
ORDER BY Difference DESC;
