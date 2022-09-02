USE [8_week_sql_challenge];

---Creating the required Tables in the DB
CREATE TABLE sales (
  "customer_id" VARCHAR(1),
  "order_date" DATE,
  "product_id" INT
);

INSERT INTO sales
  ("customer_id", "order_date", "product_id")
VALUES
  ('A', '2021-01-01', '1'),
  ('A', '2021-01-01', '2'),
  ('A', '2021-01-07', '2'),
  ('A', '2021-01-10', '3'),
  ('A', '2021-01-11', '3'),
  ('A', '2021-01-11', '3'),
  ('B', '2021-01-01', '2'),
  ('B', '2021-01-02', '2'),
  ('B', '2021-01-04', '1'),
  ('B', '2021-01-11', '1'),
  ('B', '2021-01-16', '3'),
  ('B', '2021-02-01', '3'),
  ('C', '2021-01-01', '3'),
  ('C', '2021-01-01', '3'),
  ('C', '2021-01-07', '3');
 

 CREATE TABLE menu (
  "product_id" INTEGER,
  "product_name" VARCHAR(5),
  "price" INTEGER
);

INSERT INTO menu
  ("product_id", "product_name", "price")
VALUES
  ('1', 'sushi', '10'),
  ('2', 'curry', '15'),
  ('3', 'ramen', '12');

CREATE TABLE members (
  "customer_id" VARCHAR(1),
  "join_date" DATE
);

INSERT INTO members
  ("customer_id", "join_date")
VALUES
  ('A', '2021-01-07'),
  ('B', '2021-01-09');

SELECT *
FROM dbo.members

SELECT * 
FROM dbo.sales

SELECT * 
FROM dbo.menu

SELECT *
FROM dbo.sales s
JOIN dbo.menu m ON s.product_id = m.product_id
JOIN dbo.members mem on mem.customer_id = s.customer_id;


----------------------------------------------------Case Study Questions

--1. What is the total amount each customer spent at the restaurant?

SELECT s.customer_id,
       SUM(m.price) As Total_amount_spent
FROM dbo.sales s
JOIN dbo.menu m ON s.product_id = m.product_id
GROUP BY customer_id;

--2. How many days has each customer visited the restaurant?

SELECT s.customer_id,
       COUNT(DISTINCT s.order_date) As No_of_days_visited_restaurant
FROM dbo.sales s
JOIN dbo.menu m ON s.product_id = m.product_id
GROUP BY customer_id;

--3. What was the first item from the menu purchased by each customer?


SELECT DISTINCT customer_id,
       product_name
       
FROM (
        SELECT  s.customer_id,
                RANK() OVER(PARTITION BY s.customer_id ORDER BY s.order_date) AS P_rank,
		        m.product_name
				FROM dbo.sales s
				JOIN dbo.menu m ON s.product_id = m.product_id
     ) x
WHERE P_rank = 1;

--4. What is the most purchased item on the menu and how many times was it purchased by all customers?


SELECT 
       product_name AS most_purchased_item,
	   count_of_orders
FROM (
       SELECT m.product_name,
              COUNT(s.order_date) AS count_of_orders,
			  RANK() OVER(ORDER BY COUNT(s.order_date) DESC) AS Rank
       FROM dbo.sales s
       JOIN dbo.menu m ON s.product_id = m.product_id
       GROUP BY m.product_name
	   ) x
WHERE RANK =1;

--5. Which item was the most popular for each customer

SELECT 
       customer_id,
	   product_name AS Most_popular_for_the_Customer
	   
FROM (
       SELECT s.customer_id,
			  m.product_name,
              COUNT(s.product_id) AS count_of_orders,
			  RANK() OVER(PARTITION BY s.customer_id ORDER BY COUNT(m.product_name) DESC) AS Rank
       FROM dbo.sales s
       JOIN dbo.menu m ON s.product_id = m.product_id
       GROUP BY s.customer_id, m.product_name
	   ) x
WHERE RANK = 1;


--6. Which item was purchased first by the customer after they became a member?

SELECT customer_id,
       product_id,
	   product_name,
	   order_date
FROM(
SELECT s.product_id,
       m.product_name,
	   s.customer_id,
	   s.order_date,
	   RANK() OVER(PARTITION BY s.customer_id ORDER BY s.order_date) AS d_rank 
FROM dbo.sales s
JOIN dbo.menu m ON s.product_id = m.product_id
WHERE s.order_date >= (SELECT join_date
                       FROM dbo.members mem
					   WHERE mem.customer_id = s.customer_id)
--ORDER BY s.order_date 
) x
WHERE d_rank = 1;


--7. Which item was purchased just before the customer became a member?

SELECT customer_id,
       product_id,
	   product_name,
	   order_date
FROM(
SELECT s.product_id,
       m.product_name,
	   s.customer_id,
	   s.order_date,
	   RANK() OVER(PARTITION BY s.customer_id ORDER BY s.order_date DESC) AS d_rank 
FROM dbo.sales s
JOIN dbo.menu m ON s.product_id = m.product_id
WHERE s.order_date < (SELECT join_date
                       FROM dbo.members mem
					   WHERE mem.customer_id = s.customer_id)
) x
WHERE d_rank = 1;

--8. What is the total items and amount spent for each member before they became a member?


SELECT count(s.product_id) AS [Total Items],
       --m.product_name,
	   --s.customer_id,
	   --s.order_date,
	   SUM(m.price) AS [Total amount spent]
	   
	   --RANK() OVER(PARTITION BY s.customer_id ORDER BY s.order_date DESC) AS d_rank 
FROM dbo.sales s
JOIN dbo.menu m ON s.product_id = m.product_id
WHERE s.order_date < (SELECT join_date
                       FROM dbo.members mem
					   WHERE mem.customer_id = s.customer_id) 

--9. If each $1 spent equates to 10 points and sushi has a 2x points multiplier - how many points would each customer have?

SELECT customer_id,
       sum(points) AS [Points for each Customer]
FROM 
(SELECT s.customer_id,
       m.product_name,
	   CASE WHEN m.product_name NOT IN ('sushi') THEN sum(m.price) * 10
	        WHEN m.product_name IN ('sushi') THEN SUM(m.price) * 2
			ELSE 0 
	        END AS points
FROM dbo.sales s
JOIN dbo.menu m ON s.product_id = m.product_id
GROUP BY s.customer_id,m.product_name
) x
GROUP BY customer_id


/*10. In the first week after a customer joins the program (including their join date) they earn 2x points on all items, not just sushi 
- how many points do customer A and B have at the end of January?*/

SELECT customer_id,
       sum(points) AS [Points for each Customer]
FROM 
(SELECT s.customer_id,
       m.product_name,
	   CASE WHEN m.product_name NOT IN ('sushi') THEN sum(m.price) * 2
	        WHEN m.product_name IN ('sushi') THEN SUM(m.price) 
			ELSE 0 
	        END AS points
FROM dbo.sales s
JOIN dbo.menu m ON s.product_id = m.product_id
WHERE s.order_date BETWEEN (SELECT join_date
                            FROM dbo.members mem
					        WHERE mem.customer_id = s.customer_id) AND DATEADD(day, 7,(SELECT join_date
							                                                           FROM dbo.members mem  
																					   WHERE mem.customer_id = s.customer_id)
	                                                                           )
GROUP BY s.customer_id,m.product_name
) x
GROUP BY customer_id
-------------------------------
																
