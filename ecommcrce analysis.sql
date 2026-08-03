
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

-- Q9. Sales by State --
SELECT orders.State, SUM(order_details.sales) AS Total_sales
FROM orders
INNER JOIN order_details
ON orders.order_id = order_details.order_id
GROUP BY orders.State
ORDER BY Total_sales DESC;

-- Q10. Sales by City --
SELECT orders.city, SUM(order_details.sales) AS Total_sales
FROM orders
INNER JOIN order_details
ON orders.order_id = order_details.order_id
GROUP BY orders.city
ORDER BY Total_sales DESC;

-- Q11. Top 10 Customers by Sales --
SELECT orders.Customer_name, SUM(order_details.sales) AS Total_sales
FROM orders
INNER JOIN order_details
ON orders.order_id = order_details.order_id
GROUP BY orders.Customer_Name
ORDER BY Total_sales DESC
LIMIT 10;

-- Q12. Top 10 Customers by Profit --
SELECT orders.Customer_name, SUM(order_details.profit) AS Total_profit
FROM orders
INNER JOIN order_details
ON orders.order_id = order_details.order_id
GROUP BY orders.Customer_name
ORDER BY Total_profit DESC
LIMIT 10;

-- Q13. Categories with Sales Greater Than 50000 --
SELECT Category, SUM(sales) AS Total_sales
FROM order_details
GROUP BY Category
HAVING SUM(sales) > 50000
ORDER BY Total_sales DESC;

-- Q14. Customers with Profit Greater Than 1000 --
SELECT orders.Customer_name, SUM(order_details.profit) AS Total_profit
FROM orders
INNER JOIN order_details
ON orders.order_id = order_details.order_id
GROUP BY orders.Customer_name
HAVING Total_profit > 1000
ORDER BY Total_profit DESC;

-- Q15. Sales Category using CASE --
SELECT Order_id, sales,
CASE WHEN sales >= 1000 THEN 'High sales'
WHEN sales >= 500 THEN 'Medium sales'
ELSE 'Low sales'
END AS Sales_category
FROM order_details;

-- Q16. Profit Status using CASE --
SELECT Order_id, profit,
CASE WHEN profit > 0 THEN 'Profit'
WHEN Profit < 0 THEN 'Loss'
ELSE 'Break Even'
END AS Profit_status
FROM order_details;

-- Q17. Sales by Order Date --
SELECT orders.order_date, SUM(order_details.sales) AS Total_sales
FROM orders
INNER JOIN order_details
ON orders.order_id = order_details.order_id
GROUP BY orders.order_date
ORDER BY orders.order_date;

-- Q18. Orders by State --
SELECT State, COUNT(*) AS Total_orders
FROM orders
GROUP BY State
ORDER BY Total_orders DESC;

-- Q19. Orders by City --
SELECT City, COUNT(*) AS Total_orders
FROM orders
GROUP BY City
ORDER BY Total_orders DESC;

-- Q20. Average Sales by Category --
SELECT Category, AVG(Sales), AS Average_sales
FROM order_details
GROUP BY Category
ORDER BY Average_sales DESC;

-- Q21. Customer with the Highest Sales --
SELECT orders.customer_name, SUM(order_details.sales) AS Total_sales
FROM orders
INNER JOIN order_details
ON orders.order_id = order_details.order_id
GROUP BY orders.customer_name
ORDER BY Total_sales DESC
LIMIT 1;

-- Q22. Sub-Categories with Sales Above Average --
SELECT Sub_Category, SUM(sales) AS Total_sales
FROM order_details
GROUP BY Sub_category
HAVING SUM(sales) >
(
SELECT AVG(Sales) FROM order_details
);

-- Q23. Categories with Profit Below Average --
SELECT Category, SUM(profit) AS Total_profit
FROM order_details
GROUP BY Category
HAVING SUM(profit) <
(
SELECT AVG(profit) FROM order_details
);

-- Q24. Top 5 Customers by Sales --
WITH Top_customers AS
(
SELECT orders.customer_name, SUM(order_details.sales) AS Total_sales,
RANK() OVER(ORDER BY SUM(order_details.sales) DESC) AS Rank_num
FROM orders
INNER JOIN order_details
ON orders.order_id = order_details.order_id
GROUP BY orders.customer_name
)
SELECT * FROM Top_customers
WHERE Rank_num <= 5;

-- Q25. State-wise Sales --
SELECT orders.state, SUM(order_details.sales) AS Total_sales
FROM orders
INNER JOIN order_details
ON orders.order_id = order_details.order_id
GROUP BY orders.state
ORDER BY Total_sales DESC;

-- Q26. Rank Customers by Sales --
SELECT orders.customer_name, SUM(order_details.sales) AS Total_sales,
RANK() OVER(ORDER BY SUM(order_details.sales) DESC) AS Sales_rank
FROM orders
INNER JOIN order_details
ON orders.order_id = order_details.order_id
GROUP BY orders.customer_name;

-- Q27. Dense Rank Customers by Profit --
SELECT orders.customer_name, SUM(order_details.profit) AS Total_profit,
DENSE_RANK() OVER(ORDER BY SUM(order_details.profit) DESC) AS Profit_rank
FROM orders
INNER JOIN order_details
ON orders.order_id = order_details.order_id
GROUP BY orders.Customer_name;

-- Q28. Row Number by Sales --
SELECT orders.Customer_name, SUM(order_details.sales) AS Total_sales,
ROW_NUMBER() OVER(ORDER BY SUM(order_details.sales) DESC) AS Row_num
FROM orders
INNER JOIN order_details
ON orders.order_id = order_details.order_id
GROUP BY orders.Customer_name;

-- Q29. Rank Categories by  Sales --
SELECT Category, SUM(Sales) AS Total_sales,
RANK() OVER(ORDER BY SUM(Sales) DESC) AS Rank_num
FROM order_details
GROUP BY Category;

-- Q30. Dense Rank Categories by Profit --
SELECT Category, SUM(Profit) AS Total_profit,
DENSE_RANK() OVER(ORDER BY SUM(Profit) DESC) AS Rank_num
FROM order_details
GROUP BY Category;
