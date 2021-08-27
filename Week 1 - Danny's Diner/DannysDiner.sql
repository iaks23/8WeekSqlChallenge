/*Q1*/
select s.customer_id AS MEMBER_NAME, SUM(m.price) AS AMOUNT_SPENT
FROM sales AS s INNER JOIN menu AS m 
ON s.product_id = m.product_id
GROUP BY customer_id
ORDER BY customer_id;

/*Q2*/
SELECT customer_id AS MEMBER_NAME, COUNT(DISTINCT order_date) AS NO_OF_DAYS_VISITED
FROM sales
GROUP BY customer_id;

/*Q3*/
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

/*Q4*/
SELECT TOP 1 m.product_name, COUNT(s.product_id) AS PURCHASE_COUNT
FROM sales AS s INNER JOIN menu AS m
ON s.product_id = m.product_id
GROUP BY product_name
ORDER BY PURCHASE_COUNT DESC;

/*Q5*/
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


/*Q6*/
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


/*Q7*/
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


/*Q8*/
SELECT s.customer_id, COUNT(s.product_id) AS items_bought, SUM(m.price) AS total_amount
FROM sales AS s 
JOIN members AS mem
ON s.customer_id = mem.customer_id
JOIN menu AS m 
ON s.product_id = m.product_id
WHERE s.order_date < mem.join_date
GROUP BY s.customer_id;

/*Q9*/
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

/*Q10*/
WITH valid_dates_cte AS
(
    SELECT *,
    DATEADD(DAY, 6, join_date) AS valid_date,
    EOMONTH('2021-01-31') AS last_date
    FROM members AS mem
)

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

/*BQ1*/
SELECT s.customer_id, s.order_date, m.product_name, m.price,
CASE 
    WHEN mem.join_date > s.order_date THEN 'N'
    WHEN mem.join_date <= s.order_date THEN 'Y'
    ELSE 'N'
    END AS valid_member
FROM sales AS s LEFT JOIN menu AS m ON s.product_id = m.product_id 
LEFT JOIN members AS mem
ON s.customer_id = mem.customer_id;


/*BQ2*/
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
