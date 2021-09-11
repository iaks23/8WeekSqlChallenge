# 8-Week SQL Challenge

# CASE STUDY #2 - PIZZA RUNNER 🍕

![picturelogo](https://github.com/iaks23/8WeekSqlChallenge/blob/main/img/W2.png)

## TABLE OF CONTENTS 📖
* [Who's Running? 🏃🏻‍♀️](#who's-running)
* [Problem Statement 🔨](#problem-statement)
* [Datasets 💻](#datasets)
* [Data Cleaning 🧹](#cleaning)
* [Case Study Solutions 🔑](#case-study-solutions)
* [Bonus Questions 💃🏻](#bonus-questions)




## Who's Running? 🏃🏻‍♀️ <a name="who's-running"></a>

Danny's back at it with yet another million dollar idea but this time it's with a worldwide favorite dish, the pizza.

Danny was scrolling through his Instagram feed when something really caught his eye - “80s Retro Styling and Pizza Is The Future!”

Danny was sold on the idea, but he knew that pizza alone was not going to help him get seed funding to expand his new Pizza Empire - so he had one more genius idea to combine with it - he was going to Uberize it - and so Pizza Runner was launched!

Danny started by recruiting “runners” to deliver fresh pizza from Pizza Runner Headquarters (otherwise known as Danny’s house) and also maxed out his credit card to pay freelance developers to build a mobile app to accept orders from customers.


## Problem Statement 🔨 <a name="problem-statement"></a>

Danny's aware of how essential data collection will be to his business, which is why he has prepared for us an entity relationship diagram of his database design but requires further assistance to clean his data and apply some basic calculations so he can better direct his runners and optimise Pizza Runner’s operations.

Danny has shared with you 6 interconnected datasets for this case study:

---------------

* <code> customer_orders </code>
* <code> runner_orders </code>
* <code> runners </code>
* <code> pizza_names </code>
* <code> pizza_toppings </code>
* <code> pizza_recipes </code>

---------------

## Datasets 💻 <a name="datasets"></a>

Below is the entity relationship diagram of the datasets available with Danny.

![ER](https://github.com/iaks23/8WeekSqlChallenge/blob/main/img/ER.png)

For more information regarding the tables, their descriptions, and schema make sure to take a look [here](https://8weeksqlchallenge.com/case-study-2/)

## Data Cleaning 🧹 <a name="cleaning"></a>

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

✅ Pros: Simple command, only knowledge of DML is required. Works in cases where one uniform value has to be set for all columns. 


🛑 Cons: Cannot be utilized for varying conditions of values in the same table. Multiple updates would be rwquired for that, not very optimized. 

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
✅ Pros: Multiple cleaning issues tackled in one consise query. 

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

## Case Study Solutions 🔑 <a name="case-study-solutions"></a>

<details> 
    <summary>
        PART A:
    </summary>
    
### Q1: How many pizzas were ordered?
    
Level: 1️⃣
    
 ```sql
   SELECT COUNT(*) AS total_pizza_orders FROM new_cust_orders;
 ```
 
|total_pizza_orders|
|---|
|14|
    
### Q2: How many unique customer orders were made?

LEVEL: 1️⃣
    
```sql
  SELECT COUNT(DISTINCT(order_id)) AS unique_cust_orders FROM new_cust_orders;
```
    
|unique_cust_orders|
|---|
|10|
    
    
### Q3: How many successful orders were delivered by each runner? 
    
LEVEL: 1️⃣

    
```sql
    
SELECT runner_id, COUNT(*) AS successful_orders 
FROM new_runner_orders 
WHERE duration!= 0
GROUP BY runner_id;
    
```
  
    
</details> 

-------

<details> 
    <summary>
        PART B:
    </summary>
    
</details> 


