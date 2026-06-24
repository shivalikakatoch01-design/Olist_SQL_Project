SET SESSION sql_mode = '';
USE olist_db;

DROP TABLE IF EXISTS order_reviews;
DROP TABLE IF EXISTS order_payments;
DROP TABLE IF EXISTS order_items;
DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS customers;
DROP TABLE IF EXISTS products;
DROP TABLE IF EXISTS sellers;
DROP TABLE IF EXISTS product_category_name_translation;
DROP TABLE IF EXISTS geolocation;

-- 1. CUSTOMERS TABLE
CREATE TABLE customers 
(customer_id VARCHAR(50) PRIMARY KEY, 
customer_unique_id VARCHAR(50), 
customer_zip_code_prefix INT, 
customer_city VARCHAR(100), 
customer_state VARCHAR(2));
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/olist_customers_dataset.csv' 
INTO TABLE customers 
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"' 
LINES TERMINATED BY '\n' 
IGNORE 1 ROWS;

-- 2. ORDERS
CREATE TABLE orders 
(order_id VARCHAR(50) PRIMARY KEY, 
customer_id VARCHAR(50), 
order_status VARCHAR(20), 
order_purchase_timestamp DATETIME NULL, 
order_approved_at DATETIME NULL, 
order_delivered_carrier_date DATETIME NULL, 
order_delivered_customer_date DATETIME NULL, 
order_estimated_delivery_date DATETIME NULL, 
FOREIGN KEY (customer_id) 
REFERENCES customers(customer_id));
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/olist_orders_dataset.csv' 
INTO TABLE orders 
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"' 
LINES TERMINATED BY '\n' 
IGNORE 1 ROWS 
(@oid, @cid, @os, @p1, @a1, @d1, @d2, @e1) 
SET order_id=@oid, 
customer_id=@cid, 
order_status=@os, 
order_purchase_timestamp=NULLIF(@p1,''), 
order_approved_at=NULLIF(@a1,''), 
order_delivered_carrier_date=NULLIF(@d1,''), 
order_delivered_customer_date=NULLIF(@d2,''), 
order_estimated_delivery_date=NULLIF(@e1,'');

-- 3. ORDER ITEMS
CREATE TABLE order_items 
(order_id VARCHAR(50), 
order_item_id INT, 
product_id VARCHAR(50), 
seller_id VARCHAR(50), 
shipping_limit_date DATETIME NULL, 
price DECIMAL(10,2), 
freight_value DECIMAL(10,2), 
PRIMARY KEY (order_id, order_item_id));
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/olist_order_items_dataset.csv' 
INTO TABLE order_items 
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"' 
LINES TERMINATED BY '\n' 
IGNORE 1 ROWS;

-- 4. PRODUCTS
CREATE TABLE products 
(product_id VARCHAR(50) PRIMARY KEY, 
product_category_name VARCHAR(100), 
product_name_length INT NULL, 
product_description_length INT NULL, 
product_photos_qty INT NULL, 
product_weight_g INT NULL, 
product_length_cm INT NULL, 
product_height_cm INT NULL, 
product_width_cm INT NULL);
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/olist_products_dataset.csv' 
INTO TABLE products 
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"' 
LINES TERMINATED BY '\n' 
IGNORE 1 ROWS 
(@id,@cat,@nl,@dl,@pq,@wg,@lc,@hc,@wc) 
SET product_id=@id, 
product_category_name=NULLIF(@cat,''), 
product_name_length=NULLIF(@nl,''), 
product_description_length=NULLIF(@dl,''), 
product_photos_qty=NULLIF(@pq,''), 
product_weight_g=NULLIF(@wg,''), 
product_length_cm=NULLIF(@lc,''), 
product_height_cm=NULLIF(@hc,''), 
product_width_cm=NULLIF(@wc,'');

-- 5. SELLERS
CREATE TABLE sellers 
(seller_id VARCHAR(50) PRIMARY KEY, 
seller_zip_code_prefix INT, 
seller_city VARCHAR(100), 
seller_state VARCHAR(2));
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/olist_sellers_dataset.csv' 
INTO TABLE sellers 
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"' 
LINES TERMINATED BY '\n' 
IGNORE 1 ROWS;

-- 6. ORDER PAYMENTS
CREATE TABLE order_payments (order_id VARCHAR(50), 
payment_sequential INT, 
payment_type VARCHAR(20), 
payment_installments INT, 
payment_value DECIMAL(10,2), PRIMARY KEY (order_id, payment_sequential));
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/olist_order_payments_dataset.csv' 
INTO TABLE order_payments 
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"' 
LINES TERMINATED BY '\n' 
IGNORE 1 ROWS;

-- 7. ORDER REVIEWS
/* CREATE TABLE order_reviews (review_id VARCHAR(50), 
order_id VARCHAR(50), 
review_score INT, 
review_comment_title VARCHAR(255), 
review_comment_message TEXT, 
review_creation_date DATETIME NULL, 
review_answer_timestamp DATETIME NULL, PRIMARY KEY (review_id));
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/olist_order_reviews_dataset.csv' 
INTO TABLE order_reviews 
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"' 
LINES TERMINATED BY '\n' 
IGNORE 1 ROWS 
(@rid,@oid,@rs,@rt,@rm,@rd,@ra) 
SET review_id=@rid, order_id=@oid, review_score=NULLIF(@rs,''), review_comment_title=NULLIF(@rt,''), 
review_comment_message=NULLIF(@rm,''), review_creation_date=NULLIF(@rd,''), 
review_answer_timestamp=NULLIF(@ra,'');*/

DROP TABLE IF EXISTS order_reviews;
CREATE TABLE order_reviews (
    review_id VARCHAR(50),
    order_id VARCHAR(50),
    review_score INT,
    review_comment_title VARCHAR(255),
    review_comment_message TEXT,
    review_creation_date DATETIME NULL,
    review_answer_timestamp DATETIME NULL
);

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/olist_order_reviews_dataset.csv'
INTO TABLE order_reviews
FIELDS TERMINATED BY ',' ENCLOSED BY '"' LINES TERMINATED BY '\n' IGNORE 1 ROWS
(@rid,@oid,@rs,@rt,@rm,@rd,@ra)
SET review_id=@rid, order_id=@oid, review_score=NULLIF(@rs,''),
review_comment_title=NULLIF(@rt,''), review_comment_message=NULLIF(@rm,''),
review_creation_date=NULLIF(@rd,''), review_answer_timestamp=NULLIF(@ra,'');

-- 8. CATEGORY TRANSLATION
/* CREATE TABLE product_category_name_translation 
(product_category_name VARCHAR(100) PRIMARY KEY, 
product_category_name_english VARCHAR(100));
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/olist_product_category_name_translation.csv' 
INTO TABLE product_category_name_translation 
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"' 
LINES TERMINATED BY '\n' 
IGNORE 1 ROWS;*/

DROP TABLE IF EXISTS product_category_name_translation;
CREATE TABLE product_category_name_translation (
    product_category_name VARCHAR(100) PRIMARY KEY,
    product_category_name_english VARCHAR(100)
);

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/product_category_name_translation.csv'
INTO TABLE product_category_name_translation
FIELDS TERMINATED BY ',' ENCLOSED BY '"' LINES TERMINATED BY '\n' IGNORE 1 ROWS;

-- 9. GEOLOCATION
CREATE TABLE geolocation 
(zip_code_prefix INT, lat DECIMAL(10,6), 
lng DECIMAL(10,6), city VARCHAR(100), state VARCHAR(2));
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/olist_geolocation_dataset.csv' 
INTO TABLE geolocation 
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"' 
LINES TERMINATED BY '\n' 
IGNORE 1 ROWS;

SELECT 'customers' AS table_name, COUNT(*) AS row_count FROM customers UNION ALL
SELECT 'orders', COUNT(*) FROM orders UNION ALL
SELECT 'order_items', COUNT(*) FROM order_items UNION ALL
SELECT 'products', COUNT(*) FROM products UNION ALL
SELECT 'sellers', COUNT(*) FROM sellers UNION ALL
SELECT 'order_payments', COUNT(*) FROM order_payments UNION ALL
SELECT 'order_reviews', COUNT(*) FROM order_reviews UNION ALL
SELECT 'product_category_name_translation', COUNT(*) FROM product_category_name_translation UNION ALL
SELECT 'geolocation', COUNT(*) FROM geolocation;