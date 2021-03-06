# 8-Week SQL Challenge

# CASE STUDY #2 - PIZZA RUNNER π

![picturelogo](https://github.com/iaks23/8WeekSqlChallenge/blob/main/img/W2.png)

## TABLE OF CONTENTS π
* [Who's Running? ππ»ββοΈ](#who's-running)
* [Problem Statement π¨](#problem-statement)
* [Datasets π»](#datasets)
* [Data Cleaning π§Ή](#cleaning)
* [Case Study Solutions π](#case-study-solutions)
* [Bonus Questions ππ»](#bonus-questions)




## Who's Running? ππ»ββοΈ <a name="who's-running"></a>

Danny's back at it with yet another million dollar idea but this time it's with a worldwide favorite dish, the pizza.

Danny was scrolling through his Instagram feed when something really caught his eye - β80s Retro Styling and Pizza Is The Future!β

Danny was sold on the idea, but he knew that pizza alone was not going to help him get seed funding to expand his new Pizza Empire - so he had one more genius idea to combine with it - he was going to Uberize it - and so Pizza Runner was launched!

Danny started by recruiting βrunnersβ to deliver fresh pizza from Pizza Runner Headquarters (otherwise known as Dannyβs house) and also maxed out his credit card to pay freelance developers to build a mobile app to accept orders from customers.


## Problem Statement π¨ <a name="problem-statement"></a>

Danny's aware of how essential data collection will be to his business, which is why he has prepared for us an entity relationship diagram of his database design but requires further assistance to clean his data and apply some basic calculations so he can better direct his runners and optimise Pizza Runnerβs operations.

Danny has shared with you 6 interconnected datasets for this case study:

---------------

* <code> customer_orders </code>
* <code> runner_orders </code>
* <code> runners </code>
* <code> pizza_names </code>
* <code> pizza_toppings </code>
* <code> pizza_recipes </code>

---------------

## Datasets π» <a name="datasets"></a>

Below is the entity relationship diagram of the datasets available with Danny.

![ER](https://github.com/iaks23/8WeekSqlChallenge/blob/main/img/ER.png)

For more information regarding the tables, their descriptions, and schema make sure to take a look [here](https://8weeksqlchallenge.com/case-study-2/)

## Data Cleaning π§Ή <a name="cleaning"></a>

Upon first glance, it is evident that we cannot dive headfirst into solving the queries without doing a little bit of grunt work. This calls for a bit of data cleaning on the <code>customer_orders</code> table and the <code>runner_orders</code> table to transform the null values, unwanted suffixes, and even alter column types to mmatch the SQL environment I am working with. 

I have tried tackling this in two ways...

### Method 1: DML Commands 

When presented with a table containing NULL/null values, you can always update the entries of the table to be uniform. I have implemented the same for <code> customer_orders </code> table, by cloning it into a new table called <code> new_cust_orders </code>

```sql
SELECT * into new_cust_orders FROM customer_orders;
UPDATE new_cust_orders SET exclusions = ' ' WHERE exclusions IS NULL OR exclusions = 'null'
UPDATE new_cust_orders SET extras = ' ' WHERE extras IS NULL OR extras = 'null'
SELECT * FROM new_cust_orders;
```

β Pros: Simple command, only knowledge of DML is required. Works in cases where one uniform value has to be set for all columns. 


π Cons: Cannot be utilized for varying conditions of values in the same table. Multiple updates would be rwquired for that, not very optimized. 

### Method 2: CASE 

An immediate go-to solution for when you have to clean up multiple values in multiple columns. I have implemented this on the <code> runner_orders </code> table, by cloning it into a new table called <code> new_runner_orders </code>

```sql
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
```
β Pros: Multiple cleaning issues tackled in one consise query. 

### Column Altering

In order to make sure that certain columns are compatible with MS SQL environment so that data manipulations can be performed, they need to be altered. This is purely dependent on the type of SQL environment you are using.

```sql
ALTER table new_runner_orders 
ALTER COLUMN duration INT;

ALTER table new_runner_orders 
ALTER COLUMN distance FLOAT;

You must also alter <code> PICKUP_TIME </code> as DATETIME, I was not able to create the table with the previous data type so I am not including the code here.

/* Changing Data Type of TEXT to VARCHAR */

ALTER table pizza_names 
ALTER COLUMN pizza_name VARCHAR(30);

```
-------

## Case Study Solutions π <a name="case-study-solutions"></a>

<details> 
    <summary>
        PART A:
    </summary>
    
### Q1: How many pizzas were ordered?
    
Level: 1οΈβ£
    
 ```sql
   SELECT COUNT(*) AS total_pizza_orders FROM new_cust_orders;
 ```
 
|total_pizza_orders|
|---|
|14|
    
### Q2: How many unique customer orders were made?

LEVEL: 1οΈβ£
    
```sql
  SELECT COUNT(DISTINCT(order_id)) AS unique_cust_orders FROM new_cust_orders;
```
    
|unique_cust_orders|
|---|
|10|
    
    
### Q3: How many successful orders were delivered by each runner? 
    
LEVEL: 1οΈβ£

    
```sql
    
SELECT runner_id, COUNT(*) AS successful_orders 
FROM new_runner_orders 
WHERE duration!= 0
GROUP BY runner_id;
    
```

|runner_id|successful_orders|
|---|---|
|1| 4|
|2| 3|
|3| 1|
    
Looks like runner 1 has been having quite a busy time successfully getting the pizzas! Make sure to tip him extra!
    
    
### Q4: How many of each type of pizza was delivered?
    
LEVEL: :two:

    
```sql
    
SELECT p.pizza_name, COUNT(c.pizza_id) AS delivered_pizzas
FROM new_cust_orders AS c 
JOIN new_runner_orders AS r
ON c.order_id = r.order_id
JOIN pizza_names AS p 
ON c.pizza_id = p.pizza_id
WHERE r.duration != 0
GROUP BY p.pizza_name;
    
```

|pizza_name|delivered_pizzas|
|---|---|
|Meatlovers| 9|
|Vegetarian| 3|

    
The meatlovers pizza seems to be quite hit! 
    
### Q5: How many Vegetarian and Meatlovers were ordered by each customer?
    
LEVEL: :two:

    
```sql
    
SELECT c.customer_id, p.pizza_name, COUNT(p.pizza_name) AS order_count 
FROM new_cust_orders AS c 
JOIN pizza_names AS p 
ON c.pizza_id = p.pizza_id
GROUP BY c.customer_id, p.pizza_name
ORDER BY c.customer_id; 
    
```

|customer_id|pizza_name|order_count|
|---|---|---|
|101|Meatlovers| 2|
|101|Vegetarian| 1|
|102|Meatlovers| 2|
|102|Vegetarian| 1|
|103|Meatlovers| 3|
|103|Vegetarian| 1|
|104|Meatlovers| 3|
|105|Vegetarian| 1|
    
Looks like all customers have given both the pizzas a try, but still prefer to reorder the Meatlovers a lot more! Maybe we can figure out the topping options in the vegatrian to push the sales up!
    
### Q6: What was the maximum number of pizzas delivered in a single order?
    
LEVEL: :two:

    
```sql
    
WITH max_order_cte AS (

SELECT c.order_id, COUNT(c.pizza_id) AS number_of_orders 
FROM new_cust_orders AS c JOIN 
new_runner_orders AS r 
ON c.order_id = r.order_id
GROUP BY c.order_id

)

SELECT MAX(number_of_orders) AS max_pizza FROM max_order_cte;
    
```
|max_order_cte|
|---|
|3|

Three pizzas in a single order, that mustve been quite the party!
    
### Q7: For each customer, how many delivered pizzas had at least 1 change and how many had no changes?
    
LEVEL: :three:

    
```sql
    
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
    
```

|customer_id|atleast_one_change|no_changes|
|---|---|---|
|101|0| 2|
|102|0| 3|
|103|3| 0|
|104|2| 1|
|105|1| 0|

Looks like cutomer 101, and 102 love Danny's pizzas as they are but 103 & 105 can't seem to have it without a few modifications. 
 
### Q8: How many pizzas were delivered that had both exclusions and extras?
    
LEVEL: :three:

    
```sql
    
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
```
|customer_id|pizza_with_changes|
|---|
|104|1|

Looks like customer 104 is really picky about their toppings!
    
### Q9: What was the total volume of pizzas ordered for each hour of the day? 
    
LEVEL: :two:

    
```sql
    
SELECT DATEPART(HOUR, order_time) AS hour_of_day, 
COUNT(order_id) AS pizzas_ordered 
FROM new_cust_orders
GROUP BY DATEPART(HOUR, order_time)
    
```

|hour_of_day|pizzas_ordered|
|---|---|
|11| 1|
|13| 3|
|18| 3|
|19| 1|
|21| 3|
|23| 3|

Looks like the busiest time for pizza runners was 1 P.M. , 6 P.M., 9 P.M. and 11 P.M. Might be time to roll out peak hour delivery rates to up the sales numbers!

> Tip: You can perform this and the next question with the help of EXTRACT function if you're using MySQL.
    
### Q10: What was the volume of orders for each day of the week?
    
LEVEL: :two:

    
```sql
    
SELECT DATENAME(WEEKDAY, order_time) AS day_of_week,
COUNT(order_id) AS volume_of_pizzas
FROM new_cust_orders
GROUP BY DATENAME(WEEKDAY, order_time);
    
```

|hour_of_day|pizzas_ordered|
|---|---|
|Friday| 1|
|Saturday| 5|
|Thursday| 3|
|Wednesday| 5|

It's no surprise that Saturday seems to top the list for most sales cause there's no weekend without pizza! An interesting number here is that the highest sales also happen to be on Wednsday? Maybe pizza helps fight midweek blues? 
    
</details> 

-------

<details> 
    <summary>
        PART B:
    </summary>
    
</details> 


