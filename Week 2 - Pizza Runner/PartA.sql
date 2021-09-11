/* Q1: How many pizzas were ordered? */

SELECT COUNT(*) AS total_pizza_orders FROM new_cust_orders;

/* Q2: How many unique customer orders were made? */

SELECT COUNT(DISTINCT(order_id)) AS unique_cust_orders FROM new_cust_orders;

/* Q3: How many successful orders were delivered by each runner? */
SELECT runner_id, COUNT(*) AS successful_orders 
FROM new_runner_orders 
WHERE duration!= 0
GROUP BY runner_id;

/* Q4: How many of each type of pizza was delivered? */
SELECT p.pizza_name, COUNT(c.pizza_id) AS delivered_pizzas
FROM new_cust_orders AS c 
JOIN new_runner_orders AS r
ON c.order_id = r.order_id
JOIN pizza_names AS p 
ON c.pizza_id = p.pizza_id
WHERE r.duration != 0
GROUP BY p.pizza_name;

/* Q5: How many Vegetarian and Meatlovers were ordered by each customer? */
SELECT c.customer_id, p.pizza_name, COUNT(p.pizza_name) AS order_count 
FROM new_cust_orders AS c 
JOIN pizza_names AS p 
ON c.pizza_id = p.pizza_id
GROUP BY c.customer_id, p.pizza_name
ORDER BY c.customer_id; 

/* Q6: What was the maximum number of pizzas delivered in a single order */

WITH max_order_cte AS (

SELECT c.order_id, COUNT(c.pizza_id) AS number_of_orders 
FROM new_cust_orders AS c JOIN 
new_runner_orders AS r 
ON c.order_id = r.order_id
GROUP BY c.order_id

)

SELECT MAX(number_of_orders) AS max_pizza FROM max_order_cte;

/* Q7: For each customer, how many delivered pizzas had at least 1 change and how many had no changes? */ 

SELECT c.customer_id,
SUM(CASE 
        WHEN c.exclusions != ' ' OR c.extras != ' ' THEN 1  
        ELSE 0
        END) AS atleast_one_change,
SUM(CASE 
        WHEN c.exclusions = ' ' AND c.extras = ' ' THEN 1
        ELSE 0
        END) AS no_changes 
FROM new_cust_orders AS c JOIN 
new_runner_orders AS r ON 
c.order_id = r.order_id 
WHERE r.duration != 0
GROUP BY c.customer_id 

/* Q8: How many pizzas were delivered that had both exclusions and extras */

SELECT c.customer_id,  
SUM(CASE 
        WHEN c.exclusions IS NOT NULL AND c.extras  IS NOT NULL THEN 1 
        ELSE 0 
        END) AS pizza_with_changes
FROM new_cust_orders AS c JOIN 
new_runner_orders AS r ON 
c.order_id = r.order_id 
WHERE r.duration != 0 AND c.exclusions != ' ' AND c.extras != ' '
GROUP BY c.customer_id 

/* Q9: What was the total volume of pizzas ordered for each hour of the day? */

SELECT DATEPART(HOUR, order_time) AS hour_of_day, 
COUNT(order_id) AS pizzas_ordered 
FROM new_cust_orders
GROUP BY DATEPART(HOUR, order_time)

/* Q10: What was the volume of orders for each day of the week? */

SELECT DATENAME(WEEKDAY, order_time) AS day_of_week,
COUNT(order_id) AS volume_of_pizzas
FROM new_cust_orders
GROUP BY DATENAME(WEEKDAY, order_time);