USE olist_db;

-- ============================================
-- Olist E-Commerce Business Case Analysis
-- Analyst: Shivalika
-- Dataset: Olist Brazilian E-Commerce (Kaggle)
-- ============================================

-- Q1: Total Revenue and Orders by Year
SELECT 
    YEAR(o.order_purchase_timestamp) AS year,
    COUNT(DISTINCT o.order_id) AS total_orders,
    ROUND(SUM(p.payment_value), 2) AS total_revenue
FROM orders o
JOIN order_payments p ON o.order_id = p.order_id
WHERE o.order_status = 'delivered'
GROUP BY year
ORDER BY year;

-- Q2: Monthly Revenue Trend
SELECT 
    YEAR(o.order_purchase_timestamp) AS year,
    MONTH(o.order_purchase_timestamp) AS month,
    COUNT(DISTINCT o.order_id) AS total_orders,
    ROUND(SUM(p.payment_value), 2) AS total_revenue
FROM orders o
JOIN order_payments p ON o.order_id = p.order_id
WHERE o.order_status = 'delivered'
    AND YEAR(o.order_purchase_timestamp) IN (2017, 2018)
GROUP BY year, month
ORDER BY year, month;

-- Q3: Top 10 Product Categories by Revenue
SELECT 
    t.product_category_name_english AS category,
    COUNT(DISTINCT o.order_id) AS total_orders,
    ROUND(SUM(p.payment_value), 2) AS total_revenue
FROM orders o
JOIN order_items i ON o.order_id = i.order_id
JOIN products pr ON i.product_id = pr.product_id
JOIN product_category_name_translation t 
    ON pr.product_category_name = t.product_category_name
JOIN order_payments p ON o.order_id = p.order_id
WHERE o.order_status = 'delivered'
GROUP BY category
ORDER BY total_revenue DESC
LIMIT 10;

-- Q4: Top 10 Sellers by Revenue
SELECT 
    i.seller_id,
    COUNT(DISTINCT o.order_id) AS total_orders,
    ROUND(SUM(p.payment_value), 2) AS total_revenue
FROM orders o
JOIN order_items i ON o.order_id = i.order_id
JOIN order_payments p ON o.order_id = p.order_id
WHERE o.order_status = 'delivered'
GROUP BY i.seller_id
ORDER BY total_revenue DESC
LIMIT 10;

-- Q5: Delivery Performance
SELECT 
    CASE 
        WHEN order_delivered_customer_date <= order_estimated_delivery_date 
        THEN 'On Time'
        ELSE 'Late'
    END AS delivery_status,
    COUNT(*) AS total_orders,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER(), 2) AS percentage
FROM orders
WHERE order_status = 'delivered'
    AND order_delivered_customer_date IS NOT NULL
GROUP BY delivery_status;