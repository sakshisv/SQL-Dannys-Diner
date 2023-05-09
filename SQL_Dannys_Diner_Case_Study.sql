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

--Q4. What is the most purchased item on the menu and how many times was it purchased by all customers?

select top 1 b.product_name, count(*) as purchased_item_count
from sales a
left join menu b
on a.product_id = b.product_id
group by a.product_id, b.product_name
order by 2 desc

--Q5. Which item was the most popular for each customer?

With items_cte as (
select a.customer_id, b.product_name, count(*) item_count,
dense_rank() over (partition by customer_id order by count(a.product_id) desc) as rank
from sales a
left join menu b
on a.product_id = b.product_id
group by a.customer_id, b.product_name)


select customer_id, product_name, item_count
from items_cte
where rank = 1

--Q6. Which item was purchased first by the customer after they became a member?

With member_cte as (
select b.customer_id, b.order_date, c.product_name,
DENSE_RANK() over (partition by b.customer_id order by b.order_date) as rank
from members a
left join sales b
on a.customer_id = b. customer_id
left join menu c
on b.product_id = c.product_id
where b.order_date >= a.join_date)

select customer_id, order_date, product_name from member_cte
where rank = 1

--Q7. Which item was purchased just before the customer became a member?

With member_sales_cte as (
select b.customer_id, b.order_date, c.product_name,
DENSE_RANK() over (partition by b.customer_id order by b.order_date desc) as rank
from members a
left join sales b
on a.customer_id = b. customer_id
left join menu c
on b.product_id = c.product_id
where b.order_date < a.join_date)

select customer_id, order_date, product_name from member_sales_cte
where rank = 1

--Q8. What is the total items and amount spent for each member before they became a member?

select b.customer_id, count(b.product_id) as total_items, sum(c.price) amount_spent
from members a
left join sales b
on a.customer_id = b. customer_id
left join menu c
on b.product_id = c.product_id
where b.order_date < a.join_date
group by b.customer_id

--Q9. If each $1 spent equates to 10 points and sushi has a 2x points multiplier - how many points would each customer have?

With customer_points_cte as (
select *, 
Case when product_name = 'sushi' then (price) * 20
else (price) * 10 
end as points
from menu)

select b.customer_id, sum(a.points) as Total_points from customer_points_cte a
left join sales b
on a.product_id = b.product_id
group by b.customer_id
	








