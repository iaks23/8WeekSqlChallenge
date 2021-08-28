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
|---|---|---|---|
|A| ramen|3|1|
|B| sushi|2|1|
|C| ramen|3|1|

Looks like A & C are on the same team Ramen while Customer B prefers Sushi. I'm gonna side with B.

#### Question 6: Which item was purchased first by the customer after they became a member?

#### Difficulty Level: 🔘🔘🔘

```sql

WITH member_cte AS (
    SELECT s.customer_id, mem.join_date, s.order_date, s.product_id,
    ROW_NUMBER() OVER(
        PARTITION BY s.customer_id
        ORDER BY s.order_date) AS order_rank
    FROM sales AS s JOIN members AS mem
    ON s.customer_id = mem.customer_id
    WHERE s.order_date >= mem.join_date
    )
    SELECT s.customer_id, s.order_date, m.product_name
     from member_cte AS s JOIN menu AS m 
     ON s.product_id = m.product_id
     WHERE order_rank = 1;


```
|Customer Id|Order Date|Product Name|
|---|---|---|
|A| 2021-01-07|curry|
|B| 2021-01-11|sushi|

#### Question 7: Which item was purchased just before the customer became a member?

#### Difficulty Level: 🔘🔘

```sql

WITH member_cte AS (

    SELECT s.customer_id, mem.join_date, s.order_date, s.product_id,
    DENSE_RANK() OVER(
        PARTITION BY s.customer_id
        ORDER BY s.order_date DESC) AS order_rank
    FROM sales AS s JOIN members AS mem
    ON s.customer_id = mem.customer_id
    WHERE s.order_date < mem.join_date
    )
    SELECT s.customer_id, s.order_date, m.product_name 
    FROM member_cte s JOIN menu m 
    ON s.product_id = m.product_id
    WHERE order_rank=1;


```
|Customer Id|Order Date|Product Name|
|---|---|---|
|A| 2021-01-01|sushi|
|A| 2021-01-01|curry|
|B| 2021-01-04|sushi|

Customer A & B both had sushi ust before they became memmbers, looks like it might've been the deciding dish!


#### Question 8: What is the total items and amount spent for each member before they became a member?

#### Difficulty Level: 🔘🔘

```sql

SELECT s.customer_id, COUNT(s.product_id) AS items_bought, SUM(m.price) AS total_amount
FROM sales AS s 
JOIN members AS mem
ON s.customer_id = mem.customer_id
JOIN menu AS m 
ON s.product_id = m.product_id
WHERE s.order_date < mem.join_date
GROUP BY s.customer_id;


```
|Customer Id|Items Bought|Total Amount|
|---|---|---|
|A| 2|25|
|B| 3|40|

Customer B remains the biggest spender even after the membership program! That's some loyalty.


#### Question 9: If each $1 spent equates to 10 points and sushi has a 2x points multiplier - how many points would each customer have?

#### Difficulty Level: 🔘🔘🔘🔘

```sql

WITH points_cte AS(
    SELECT *,
    CASE
    WHEN product_id= 1
    THEN price * 20
    ELSE price * 10
    END AS points
    FROM menu
)
SELECT s.customer_id, SUM(p.points) AS total_points
FROM sales AS s JOIN points_cte AS p 
ON s.product_id = p.product_id
GROUP BY s.customer_id;


```
|Customer Id|Total Points|
|---|---|
|A| 860|
|B| 940|
|C| 360|

Customer B takes the lead with 940 points, followed by A with 860, and C with 360. Hope they use these points up for some good discounts!

#### Question 10: In the first week after a customer joins the program (including their join date) they earn 2x points on all items, not just sushi - how many points do customer A and B have at the end of January?

#### Difficulty Level: 🥵

Now this one had me stumped for quite a while and the only way to tackle this is to divide the question up and answer each part individually. 

Firstly: We need to find out the validity of the 2X points program for those who become members, this means that any item that a member buys within a week of their membership is worth 2x the points. 

```sql

WITH valid_dates_cte AS
(
    SELECT *,
    DATEADD(DAY, 6, join_date) AS valid_date,
    EOMONTH('2021-01-31') AS last_date
    FROM members AS mem
)


```

Secondly: Conditions. Conditions. Conditions.

There are 4 conditions to be checked for:

1. Calculate the validity of the 2X points, for all items for all memmbers.
2. Calculate 2x points for anyone who buys Sushi. 
3. Apply condition from previous question of providing 1x points on items other than Sushi.
4. Calculate all this only for the month of January.

```sql

SELECT v.customer_id, v.join_date, v.valid_date, v.last_date, s.order_date, m.product_name, m.price,
SUM(CASE
    WHEN s.order_date >= v.join_date AND s.order_date < v.valid_date THEN 2 * 10 * m.price 
    WHEN m.product_name = 'SUSHI' THEN 2 * 10 * m.price
    ELSE 10 * m.price 
    END) AS points 
FROM valid_dates_cte AS v JOIN
sales AS s ON v.customer_id = s.customer_id 
JOIN menu AS m 
ON s.product_id = m.product_id
WHERE s.order_date < v.last_date
GROUP BY v.customer_id, s.order_date, v.join_date, v.valid_date, v.last_date, m.product_name, m.price;


```


|Customer Id|Join Date|Valid Date|Last Date|Order Date| Product Name|Price|Points|
|---|---|---|---|---|---|---|---|
|A| 2021-01-07| 2021-01-13| 2021-01-31| 2021-01-01| curry| 15| 150|
|A| 2021-01-07| 2021-01-13| 2021-01-31| 2021-01-01| sushi| 10| 200|
|A| 2021-01-07| 2021-01-13| 2021-01-31| 2021-01-07| curry| 15| 300|
|A| 2021-01-07| 2021-01-13| 2021-01-31| 2021-01-10| ramen| 12| 240|
|A| 2021-01-07| 2021-01-13| 2021-01-31| 2021-01-11| ramen| 12| 480|
|B| 2021-01-09| 2021-01-15| 2021-01-31| 2021-01-01| curry| 15| 150|
|B| 2021-01-09| 2021-01-15| 2021-01-31| 2021-01-02| curry| 15| 300|
|B| 2021-01-09| 2021-01-15| 2021-01-31| 2021-01-04| sushi| 10| 200|
|B| 2021-01-09| 2021-01-15| 2021-01-31| 2021-01-11| sushi| 10| 400|
|B| 2021-01-09| 2021-01-15| 2021-01-31| 2021-01-16| ramen| 12| 120|


By the end of January:

Customer A's total points: 1130
Customer B's total points: 820


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


----------------------


Is it just me, or is anybody else really hungry for some ramen? Feedback & suggestions are welcome!

----------------------

© Akshaya Parthasarathy, 2021

