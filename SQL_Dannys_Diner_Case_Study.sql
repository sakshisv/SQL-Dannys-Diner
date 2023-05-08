use Dannys_Diner

select * from members
select * from menu
select * from sales

-- Q1. What is the total amount each customer spent at the restaurant?

select a.customer_id, sum(b.price) total_amount from sales a
left join menu b
on a.product_id = b.product_id
group by a.customer_id

--Q2. How many days has each customer visited the restaurant?

select customer_id, count(distinct(order_date)) as visit_count from sales
group by customer_id

--Q3. What was the first item from the menu purchased by each customer?

With order_cte as(
select a.customer_id, a.order_date, b.product_name,
DENSE_RANK() over (PARTITION BY a.customer_id order by a.order_date) as rank
from sales a
left join menu b
on a.product_id = b.product_id)

select customer_id, product_name
from order_cte
where rank = 1
group by customer_id, product_name

