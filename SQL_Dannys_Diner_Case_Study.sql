use Dannys_Diner

select * from members
select * from menu
select * from sales

-- Q1. What is the total amount each customer spent at the restaurant?

select a.customer_id, sum(b.price) Total_Amount from sales a
left join menu b
on a.product_id = b.product_id
group by a.customer_id





