
-- ====================================================================
-- Project Name : Maven Fuzzy Factory
-- File Name    : 02_data_profiling.sql
-- Author       : Abdullah Nasir
-- Description  : Initial profiling of the seven imported tables.
-- Database     : MySQL 8.0
-- ====================================================================

USE maven_fuzzy_factory;


-- ============================================================
-- 1. TABLE STRUCTURE OVERVIEW
-- Check columns, data types, NULL settings and primary keys.
-- ============================================================

SELECT
    table_name,
    column_name,
    column_type,
    is_nullable,
    column_key
FROM information_schema.columns
WHERE table_schema = DATABASE()
ORDER BY table_name, ordinal_position;


-- ============================================================
-- 2. ROW COUNT PROFILE
-- Check the total number of records in each table.
-- ============================================================

SELECT 'website_sessions' AS table_name, COUNT(*) AS total_rows
FROM website_sessions

UNION ALL

SELECT 'website_pageviews', COUNT(*)
FROM website_pageviews

UNION ALL

SELECT 'products', COUNT(*)
FROM products

UNION ALL

SELECT 'orders', COUNT(*)
FROM orders

UNION ALL

SELECT 'order_items', COUNT(*)
FROM order_items

UNION ALL

SELECT 'order_item_refunds', COUNT(*)
FROM order_item_refunds

UNION ALL

SELECT 'maven_fuzzy_factory_data_dictionary', COUNT(*)
FROM maven_fuzzy_factory_data_dictionary;


-- ============================================================
-- 3. DATE RANGE PROFILE
-- Understand the date coverage of the dataset.
-- ============================================================

SELECT
    'website_sessions' AS table_name,
    MIN(created_at) AS earliest_date,
    MAX(created_at) AS latest_date
FROM website_sessions

UNION ALL

SELECT
    'website_pageviews',
    MIN(created_at),
    MAX(created_at)
FROM website_pageviews

UNION ALL

SELECT
    'products',
    MIN(created_at),
    MAX(created_at)
FROM products

UNION ALL

SELECT
    'orders',
    MIN(created_at),
    MAX(created_at)
FROM orders

UNION ALL

SELECT
    'order_items',
    MIN(created_at),
    MAX(created_at)
FROM order_items

UNION ALL

SELECT
    'order_item_refunds',
    MIN(created_at),
    MAX(created_at)
FROM order_item_refunds;


-- ============================================================
-- 4. NULL VALUE PROFILE
-- Count missing values in selected important columns.
-- NULL values are identified, not automatically treated as errors.
-- ============================================================

SELECT
    'website_sessions' AS table_name,
    COUNT(*) AS total_rows,
    SUM(website_session_id IS NULL) AS null_session_id,
    SUM(user_id IS NULL) AS null_user_id,
    SUM(created_at IS NULL) AS null_created_at,
    SUM(utm_source IS NULL) AS null_utm_source,
    SUM(device_type IS NULL) AS null_device_type
FROM website_sessions

UNION ALL

SELECT
    'website_pageviews',
    COUNT(*),
    SUM(website_pageview_id IS NULL),
    SUM(website_session_id IS NULL),
    SUM(created_at IS NULL),
    SUM(pageview_url IS NULL),
    NULL
FROM website_pageviews

UNION ALL

SELECT
    'products',
    COUNT(*),
    SUM(product_id IS NULL),
    SUM(created_at IS NULL),
    SUM(product_name IS NULL),
    NULL,
    NULL
FROM products

UNION ALL

SELECT
    'orders',
    COUNT(*),
    SUM(order_id IS NULL),
    SUM(website_session_id IS NULL),
    SUM(user_id IS NULL),
    SUM(created_at IS NULL),
    SUM(price_usd IS NULL)
FROM orders

UNION ALL

SELECT
    'order_items',
    COUNT(*),
    SUM(order_item_id IS NULL),
    SUM(order_id IS NULL),
    SUM(product_id IS NULL),
    SUM(price_usd IS NULL),
    SUM(cogs_usd IS NULL)
FROM order_items

UNION ALL

SELECT
    'order_item_refunds',
    COUNT(*),
    SUM(order_item_refund_id IS NULL),
    SUM(order_item_id IS NULL),
    SUM(order_id IS NULL),
    SUM(refund_amount_usd IS NULL),
    SUM(created_at IS NULL)
FROM order_item_refunds

UNION ALL

SELECT
    'maven_fuzzy_factory_data_dictionary',
    COUNT(*),
    SUM(table_name IS NULL),
    SUM(column_name IS NULL),
    SUM(column_description IS NULL),
    NULL,
    NULL
FROM maven_fuzzy_factory_data_dictionary;


-- ============================================================
-- 5. SAMPLE DATA PREVIEW
-- Inspect a small sample from each table.
-- ============================================================

SELECT * FROM website_sessions LIMIT 5;
SELECT * FROM website_pageviews LIMIT 5;
SELECT * FROM products LIMIT 5;
SELECT * FROM orders LIMIT 5;
SELECT * FROM order_items LIMIT 5;
SELECT * FROM order_item_refunds LIMIT 5;
SELECT * FROM maven_fuzzy_factory_data_dictionary LIMIT 5;

-- ============================================================
-- 6. DATA DICTIONARY REVIEW
-- Understand table and column definitions.
-- ============================================================

SELECT
    table_name,
    column_name,
    column_description
FROM maven_fuzzy_factory_data_dictionary
ORDER BY table_name, column_name;
