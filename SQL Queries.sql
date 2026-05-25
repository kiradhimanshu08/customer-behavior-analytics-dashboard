create database if not exists customer_behaviour;
use customer_behaviour;
show tables;
select * from customer_shopping limit 10;

-- Q1 Total revenue by male vs female
SELECT gender,
SUM(`purchase_amount_(usd)`) AS total_revenue
FROM customer_shopping
GROUP BY gender;

-- Q2 Customers who used discounts and spent above average
SELECT customer_id, `purchase_amount_(usd)`
FROM customer_shopping
WHERE discount_applied='Yes'
AND `purchase_amount_(usd)` >
(
SELECT AVG(`purchase_amount_(usd)`)
FROM customer_shopping
);

-- Q3. Which are the top 5 products with the highest average review rating?
SELECT item_purchased,
AVG(review_rating) AS avg_rating
FROM customer_shopping
GROUP BY item_purchased
ORDER BY avg_rating DESC
LIMIT 5;

-- Q4. Compare the average purchase amount between Standard and Express Shipping.
SELECT shipping_type,
AVG(`purchase_amount_(usd)`) AS avg_purchase
FROM customer_shopping
GROUP BY shipping_type;

-- Q5. Do subscribed customers spend more? Compare average spend and total revenue between subscribed and non-subscribed customers.
SELECT subscription_status,
AVG(`purchase_amount_(usd)`) AS avg_spend,
SUM(`purchase_amount_(usd)`) AS total_revenue
FROM customer_shopping
GROUP BY subscription_status;

-- Q6. Which 5 products have the highest percentage of purchases with discounts applied?
SELECT item_purchased,
ROUND(
SUM(CASE WHEN discount_applied='Yes' THEN 1 ELSE 0 END)
*100/COUNT(*),2
) AS discount_percentage
FROM customer_shopping
GROUP BY item_purchased
ORDER BY discount_percentage DESC
LIMIT 5;

-- Q7. Segment customers into New, Returning, and Loyal based on their total number of previous purchases, and show the count of each segment.
SELECT
CASE
WHEN previous_purchases<=2 THEN 'New'
WHEN previous_purchases<=5 THEN 'Returning'
ELSE 'Loyal'
END AS customer_segment,
COUNT(*) AS total_customers
FROM customer_shopping
GROUP BY customer_segment;

-- Q8. What are the top 3 most purchased products within each category?
WITH ranked_products AS
(
SELECT
category,
item_purchased,
COUNT(*) total_purchases,
ROW_NUMBER() OVER
(
PARTITION BY category
ORDER BY COUNT(*) DESC
) AS rn
FROM customer_shopping
GROUP BY category,item_purchased
)
SELECT *
FROM ranked_products
WHERE rn<=3;

-- Q9. Are customers who are repeat buyers (more than 5 previous purchases) also likely to subscribe?
SELECT subscription_status,
COUNT(*) total_customers
FROM customer_shopping
WHERE previous_purchases > 5
GROUP BY subscription_status;

-- Q10. What is the revenue contribution of each age group?
SELECT age_group,
SUM(`purchase_amount_(usd)`) AS total_revenue
FROM customer_shopping
GROUP BY age_group
ORDER BY total_revenue desc;

SELECT * FROM customer_shopping;