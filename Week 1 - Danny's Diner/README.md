# 8-Week SQL Challenge #

# CASE STUDY #1 - DANNY'S DINER 👩🏻‍🍳
![picturelogo](https://github.com/iaks23/8WeekSqlChallenge/blob/main/img/W1.png)

### TABLE OF CONTENTS 📖
* [What's Cooking? 🍜](#what's-cooking)
* [Problem Statement 🔨](#problem-statement)
* [Datasets 💻](#datasets)
* [Case Study Solutions 🔑](#case-study-solutions)
* [Bonus Questions 💃🏻](#bonus-questions)



## What's Cooking? 🍜 <a name="what's-cooking"></a>

Danny seriously loves Japanese food so in the beginning of 2021, he decides to embark upon a risky venture and opens up a cute little restaurant that sells his 3 favourite foods: sushi, curry and ramen.

Danny’s Diner is in need of your assistance to help the restaurant stay afloat - the restaurant has captured some very basic data from their few months of operation but have no idea how to use their data to help them run the business.


## Problem Statement 🔨 <a name="problem-statement"></a>

Danny wants you to use the data to answer a few simple questions about his customers, especially about their visiting patterns, how much money they’ve spent and also which menu items are their favourite.

Danny would then use this data to provide his customers with a more personalized loyalty program which he plans on expanding.

Danny has shared with you 3 key datasets for this case study:

---------------

* <code> sales </code>
* <code> menu </code>
* <code> members </code>

---------------

  
# Datasets 💻 <a name="datasets"></a>
 
All datasets exist within the <code> dannys_diner </code> database schema - be sure to include this reference within your SQL scripts as you start exploring the data and answering the case study questions. 
You can find that in my profile under <code> schema.sql </code> file!

Danny's shared 3 key tables for us to work with:
  
  * #### <code> Sales </code>


The <code> sales </code> table captures all <code> customer_id </code> level purchases with an corresponding <code> order_date </code> and <code> product_id </code> information for when and what menu items were ordered.

|Customer ID|Order Date|Product ID|
|---|---|---|
|A| 2021-01-01| 1|
|A| 2021-01-01| 2|
|A| 2021-01-07| 2|
|A| 2021-01-10| 3|
|A| 2021-01-11| 3|
|A| 2021-01-11| 3|
|B| 2021-01-01| 2|
|B| 2021-01-02| 2|
|B| 2021-01-04| 1|
|B| 2021-01-11| 1|
|B| 2021-01-16| 3|
|B| 2021-02-01| 3|
|C| 2021-01-01| 3|
|C| 2021-01-01| 3|
|C| 2021-01-07| 3|

  * ### <code> Menu </code>

The <code> menu </code> table maps the <code> product_id </code> to the actual <code> product_name </code> and price of each menu item.

|Product ID|Product Name|Price|
|---|---|---|
|1| sushi| 10|
|2| curry| 15|
|3| ramen| 12|


  * ### <code> Members </code>

The final <code> members </code> table captures the <code> join_date </code> when a <code> customer_id </code> joined the beta version of the Danny’s Diner loyalty program.

|Customer ID|Join Date|
|---|---|
|A| 2021-01-07|
|B| 2021-01-09|



# Case Study Solutions 🔑 <a name="case-study-solutions"></a>
---------------
Danny's got his dream diner running, but boy does he have a lot of questions he wanted answers to. Luckily, I have all of the solutions executed using single line SQL queries.

Let me take you through each of them!

#### Question 1: What is the total amount each customer spent at the restaurant?

#### Difficulty Level: 🔘 🔘

```sql
select s.customer_id AS MEMBER_NAME, SUM(m.price) AS AMOUNT_SPENT
FROM sales AS s INNER JOIN menu AS m 
ON s.product_id = m.product_id
GROUP BY customer_id
ORDER BY customer_id;

```
|Member_Name|Amount_Spent|
|---|---|
|A| 76|
|B| 74|
|C| 36|

Customer A is the biggest spender of them all with a whopping 76$! That's a lot of yummy sushi! 

#### Question 2: How many days has each customer visited the restaurant?

#### Difficulty Level: 🔘

```sql
SELECT customer_id AS MEMBER_NAME, COUNT(DISTINCT order_date) AS NO_OF_DAYS_VISITED
FROM sales
GROUP BY customer_id;

```
|Member_Name|NO OF DAYS VISITED|
|---|---|
|A| 4|
|B| 6|
|C| 2|

Customer B seems to be a frequent visitor, Danny's Diner needs to start thinking of a discount program!

#### Question 3: What was the first item from the menu purchased by each customer?

#### Difficulty Level: 🔘🔘

```sql

WITH cte_order AS (
    SELECT s.customer_id, m.product_name,
    ROW_NUMBER() OVER(
        PARTITION BY s.customer_id
        ORDER BY s.order_date,
        s.product_id
    ) AS first_purchase
    FROM sales AS s JOIN menu AS m
    ON s.product_id = m.product_id
)

SELECT * from cte_order WHERE first_purchase = 1;

```
|Customer Id|Product Name|First Purchase|
|---|---|---|
|A| sushi|1|
|B| curry|1|
|C| ramen|1|

Well, you know what they say, you always remember your firsts! 


#### Question 4: What is the most purchased item on the menu and how many times was it purchased by all customers?

#### Difficulty Level: 🔘🔘

```sql

SELECT TOP 1 m.product_name, COUNT(s.product_id) AS PURCHASE_COUNT
FROM sales AS s INNER JOIN menu AS m
ON s.product_id = m.product_id
GROUP BY product_name
ORDER BY PURCHASE_COUNT DESC;
)

SELECT * from cte_order WHERE first_purchase = 1;

```
|Product Name|Purchase Count|
|---|---|
|Ramen| 8|


I wonder if there's a secret ingrediant that goes into the Ramen to make it such a top seller! 


#### Question 5: Which item was the most popular for each customer?

#### Difficulty Level: 🔘🔘🔘

```sql

WITH popular_order_cte AS (
    SELECT s.customer_id, m.product_name, COUNT(s.product_id) AS order_count,
    ROW_NUMBER() OVER(
        PARTITION BY s.customer_id
        ORDER BY COUNT(s.customer_id) DESC
    ) AS order_rank
    FROM sales AS s JOIN menu AS m
    ON s.product_id = m.product_id
    GROUP BY s.customer_id, m.product_name
)

SELECT * from popular_order_cte where order_rank=1;

```
|Customer Id|Product Name|Order Count| Order Rank|
|---|---|---|
|A| ramen|3|1|
|B| sushi|2|1|
|C| ramen|3|1|

Looks like A & C are on the same team Ramen while Customer B prefers Sushi. I'm gonna side with B.



# Bonus Questions! 💃🏻 <a name="bonus-questions"></a>
---------------
Well, we've come so far, why not help Danny out just a little more?

### Bonus Question 1: Recreate the Member or Not table with a Y/N column.

### Difficulty Level: 🔘🔘🔘

```sql

SELECT s.customer_id, s.order_date, m.product_name, m.price,
CASE 
    WHEN mem.join_date > s.order_date THEN 'N'
    WHEN mem.join_date <= s.order_date THEN 'Y'
    ELSE 'N'
    END AS valid_member
FROM sales AS s LEFT JOIN menu AS m ON s.product_id = m.product_id 
LEFT JOIN members AS mem
ON s.customer_id = mem.customer_id;

```
|Customer Id|Order Date|Product Name|Price|Valid Member|
|---|---|---|---|---|
|A| 2021-01-01| sushi| 10| N|
|A| 2021-01-01| curry| 15| N|
|A| 2021-01-07| curry| 15| Y|
|A| 2021-01-10| ramen| 12| Y|
|A| 2021-01-11| ramen| 12| Y|
|A| 2021-01-11| ramen| 12| Y|
|B| 2021-01-01| curry| 15| N|
|B| 2021-01-02| curry| 15| N|
|B| 2021-01-04| sushi| 10| N|
|B| 2021-01-11| sushi| 10| Y|
|B| 2021-01-16| ramen| 12| Y|
|B| 2021-02-01| ramen| 12| Y|
|C| 2021-01-01| ramen| 12| N|
|C| 2021-01-01| ramen| 12| N|
|C| 2021-01-07| ramen| 12| N|

### Bonus Question 2: Rank all items!

### Difficulty Level: 🔘🔘🔘🔘

```sql


WITH overall_rank_cte AS(
SELECT s.customer_id, s.order_date, m.product_name, m.price,
CASE 
    WHEN mem.join_date > s.order_date THEN 'N'
    WHEN mem.join_date <= s.order_date THEN 'Y'
    ELSE 'N'
    END AS valid_member
FROM sales AS s LEFT JOIN menu AS m ON s.product_id = m.product_id 
LEFT JOIN members AS mem
ON s.customer_id = mem.customer_id
)

SELECT *,
CASE
WHEN valid_member = 'N' THEN NULL
ELSE
RANK () OVER(PARTITION BY customer_id, valid_member
ORDER BY order_date) 
END AS member_ranking
FROM overall_rank_cte;


```

|Customer Id|Order Date|Product Name|Price|Valid Member|Member Ranking|
|---|---|---|---|---|---|
|A| 2021-01-01| sushi| 10| N| NULL|
|A| 2021-01-01| curry| 15| N| NULL|
|A| 2021-01-07| curry| 15| Y| 1|
|A| 2021-01-10| ramen| 12| Y| 2|
|A| 2021-01-11| ramen| 12| Y| 3|
|A| 2021-01-11| ramen| 12| Y| 3|
|B| 2021-01-01| curry| 15| N| NULL|
|B| 2021-01-02| curry| 15| N| NULL|
|B| 2021-01-04| sushi| 10| N| NULL|
|B| 2021-01-11| sushi| 10| Y| 1|
|B| 2021-01-16| ramen| 12| Y| 2|
|B| 2021-02-01| ramen| 12| Y| 3|
|C| 2021-01-01| ramen| 12| N| NULL|
|C| 2021-01-01| ramen| 12| N| NULL|
|C| 2021-01-07| ramen| 12| N| NULL|





Is it just me, or is anybody else really hungry for some ramen? Feedback & suggestions are welcome!
© Akshaya Parthasarathy, 2021

