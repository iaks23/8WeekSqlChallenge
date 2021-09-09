/*Data Cleaning & Transformation- Method 1 */
SELECT * into new_cust_orders FROM customer_orders;
UPDATE new_cust_orders SET exclusions = ' ' WHERE exclusions IS NULL OR exclusions = 'null'
UPDATE new_cust_orders SET extras = ' ' WHERE extras IS NULL OR extras = 'null'
SELECT * FROM new_cust_orders;



/* Data Cleaning & Transformation- Method 2 */
SELECT * from runner_orders;
SELECT order_id, runner_id,
    CASE 
        WHEN pickup_time LIKE 'null' THEN ' '
        ELSE pickup_time
        END AS pickup_time,
    CASE 
        WHEN distance LIKE 'null' THEN ' '
        WHEN distance LIKE '%km' THEN TRIM('km' from distance)
        ELSE distance
        END AS distance,
    CASE 
        WHEN duration LIKE 'null' THEN ' '
        WHEN duration LIKE '%minutes' THEN TRIM('minutes' from duration)
        WHEN duration LIKE '%minute' THEN TRIM('minute' from duration)
        WHEN duration LIKE '%mins' THEN TRIM('mins' from duration)
        ELSE duration
        END AS duration,
    CASE 
        WHEN cancellation IS NULL THEN ' '
        WHEN cancellation like 'null' THEN ' '
        ELSE cancellation
        END AS cancellation
INTO new_runner_orders
FROM runner_orders
SELECT * FROM new_runner_orders;

/*Altering Table Columns*/

/*You must also alter PICKUP_TIME as DATETIME, I was not able to create the table with the previous data type so I am not including the code here */

ALTER table new_runner_orders 
ALTER COLUMN duration INT;

ALTER table new_runner_orders 
ALTER COLUMN distance FLOAT;



/* Changing Data Type of TEXT to VARCHAR */

ALTER table pizza_names 
ALTER COLUMN pizza_name VARCHAR(30);