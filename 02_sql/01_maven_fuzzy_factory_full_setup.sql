-- ====================================================================
-- Project Name  : Maven Fuzzy Factory Full Schema Setup & Staging
-- Description   : Skrip lengkap untuk 7 jadual utama Maven Fuzzy Factory
-- ====================================================================

USE maven_fuzzy_factory;

-- 1. Buang jadual lama (jika ada) untuk elakkan konflik
DROP TABLE IF EXISTS maven_fuzzy_factory_data_dictionary;
DROP TABLE IF EXISTS order_item_refunds;
DROP TABLE IF EXISTS order_items;
DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS products;
DROP TABLE IF EXISTS website_pageviews;
DROP TABLE IF EXISTS website_sessions;

-- 2. Bina Kesemua 7 Jadual
CREATE TABLE website_sessions (
    website_session_id INT PRIMARY KEY,
    created_at DATETIME,
    user_id INT,
    is_repeat_session INT,
    utm_source VARCHAR(100),
    utm_campaign VARCHAR(100),
    utm_content VARCHAR(100),
    device_type VARCHAR(50),
    http_referer VARCHAR(255)
);

CREATE TABLE website_pageviews (
    website_pageview_id INT PRIMARY KEY,
    created_at DATETIME,
    website_session_id INT,
    pageview_url VARCHAR(255)
);

CREATE TABLE products (
    product_id INT PRIMARY KEY,
    created_at DATETIME,
    product_name VARCHAR(150)
);

CREATE TABLE orders (
    order_id INT PRIMARY KEY,
    created_at DATETIME,
    website_session_id INT,
    user_id INT,
    primary_product_id INT,
    items_purchased INT,
    price_usd DECIMAL(10, 2),
    cogs_usd DECIMAL(10, 2)
);

CREATE TABLE order_items (
    order_item_id INT PRIMARY KEY,
    created_at DATETIME,
    order_id INT,
    product_id INT,
    is_primary_item INT,
    price_usd DECIMAL(10, 2),
    cogs_usd DECIMAL(10, 2)
);

CREATE TABLE order_item_refunds (
    order_item_refund_id INT PRIMARY KEY,
    created_at DATETIME,
    order_item_id INT,
    order_id INT,
    refund_amount_usd DECIMAL(10, 2)
);

CREATE TABLE maven_fuzzy_factory_data_dictionary (
    table_name VARCHAR(100),
    column_name VARCHAR(100),
    column_description TEXT
);


-- 3. Import Kesemua Data dari Folder Uploads
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/website_sessions.csv'
INTO TABLE website_sessions
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS;

-- Diubah kepada '\n' khusus untuk website_pageviews mengikut format fail CSV asalnya
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/website_pageviews.csv'
INTO TABLE website_pageviews
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/products.csv'
INTO TABLE products
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS;

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/orders.csv'
INTO TABLE orders
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS;

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/order_items.csv'
INTO TABLE order_items
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS;

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/order_item_refunds.csv'
INTO TABLE order_item_refunds
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS;

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/maven_fuzzy_factory_data_dictionary.csv'
INTO TABLE maven_fuzzy_factory_data_dictionary
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS;


-- 4. Semak Jumlah Keseluruhan Baris (Row Count) untuk Kesemua 7 Jadual
SELECT 'website_sessions' AS table_name, COUNT(*) AS total_rows FROM website_sessions
UNION ALL
SELECT 'website_pageviews', COUNT(*) FROM website_pageviews
UNION ALL
SELECT 'products', COUNT(*) FROM products
UNION ALL
SELECT 'orders', COUNT(*) FROM orders
UNION ALL
SELECT 'order_items', COUNT(*) FROM order_items
UNION ALL
SELECT 'order_item_refunds', COUNT(*) FROM order_item_refunds
UNION ALL
SELECT 'maven_fuzzy_factory_data_dictionary', COUNT(*) FROM maven_fuzzy_factory_data_dictionary;