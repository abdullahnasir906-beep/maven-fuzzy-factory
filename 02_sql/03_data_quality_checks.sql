
-- ============================================================
-- Project Name : Maven Fuzzy Factory
-- File Name    : 03_data_quality_checks.sql
-- Sections     : 1 - 4
-- Objective    : Validate data quality, identify duplicate
--                Primary Keys, inspect NULL values, detect
--                invalid values, and check date consistency.
-- ============================================================


-- ============================================================
-- SECTION 1: DUPLICATE PRIMARY KEY CHECKS
-- ============================================================

-- 1. Check duplicate IDs across all operational tables

SELECT
    'website_sessions' AS table_name,
    website_session_id AS duplicate_id,
    COUNT(*) AS duplicate_count
FROM website_sessions
GROUP BY website_session_id
HAVING COUNT(*) > 1

UNION ALL

SELECT
    'website_pageviews',
    website_pageview_id,
    COUNT(*)
FROM website_pageviews
GROUP BY website_pageview_id
HAVING COUNT(*) > 1

UNION ALL

SELECT
    'products',
    product_id,
    COUNT(*)
FROM products
GROUP BY product_id
HAVING COUNT(*) > 1

UNION ALL

SELECT
    'orders',
    order_id,
    COUNT(*)
FROM orders
GROUP BY order_id
HAVING COUNT(*) > 1

UNION ALL

SELECT
    'order_items',
    order_item_id,
    COUNT(*)
FROM order_items
GROUP BY order_item_id
HAVING COUNT(*) > 1

UNION ALL

SELECT
    'order_item_refunds',
    order_item_refund_id,
    COUNT(*)
FROM order_item_refunds
GROUP BY order_item_refund_id
HAVING COUNT(*) > 1;


-- RESULT:
-- 0 rows returned.
--
-- FINDING:
-- No duplicate Primary Key values were detected
-- across the six operational tables.
--
-- Status: PASS


-- ============================================================
-- SECTION 2: NULL VALUE VALIDATION
-- ============================================================

-- 1. Check NULL values in website_sessions

SELECT
    'website_sessions' AS table_name,
    COUNT(*) AS total_rows,
    SUM(website_session_id IS NULL) AS null_session_id,
    SUM(user_id IS NULL) AS null_user_id,
    SUM(created_at IS NULL) AS null_created_at,
    SUM(utm_source IS NULL) AS null_utm_source,
    SUM(device_type IS NULL) AS null_device_type
FROM website_sessions;


-- 2. Check NULL values in website_pageviews

SELECT
    'website_pageviews' AS table_name,
    COUNT(*) AS total_rows,
    SUM(website_pageview_id IS NULL) AS null_pageview_id,
    SUM(created_at IS NULL) AS null_created_at,
    SUM(website_session_id IS NULL) AS null_session_id,
    SUM(pageview_url IS NULL) AS null_pageview_url
FROM website_pageviews;


-- 3. Check NULL values in products

SELECT
    'products' AS table_name,
    COUNT(*) AS total_rows,
    SUM(product_id IS NULL) AS null_product_id,
    SUM(created_at IS NULL) AS null_created_at,
    SUM(product_name IS NULL) AS null_product_name
FROM products;


-- 4. Check NULL values in orders

SELECT
    'orders' AS table_name,
    COUNT(*) AS total_rows,
    SUM(order_id IS NULL) AS null_order_id,
    SUM(created_at IS NULL) AS null_created_at,
    SUM(website_session_id IS NULL) AS null_session_id,
    SUM(user_id IS NULL) AS null_user_id,
    SUM(primary_product_id IS NULL) AS null_primary_product_id,
    SUM(items_purchased IS NULL) AS null_items_purchased,
    SUM(price_usd IS NULL) AS null_price_usd,
    SUM(cogs_usd IS NULL) AS null_cogs_usd
FROM orders;


-- 5. Check NULL values in order_items

SELECT
    'order_items' AS table_name,
    COUNT(*) AS total_rows,
    SUM(order_item_id IS NULL) AS null_order_item_id,
    SUM(created_at IS NULL) AS null_created_at,
    SUM(order_id IS NULL) AS null_order_id,
    SUM(product_id IS NULL) AS null_product_id,
    SUM(is_primary_item IS NULL) AS null_is_primary_item,
    SUM(price_usd IS NULL) AS null_price_usd,
    SUM(cogs_usd IS NULL) AS null_cogs_usd
FROM order_items;


-- 6. Check NULL values in order_item_refunds

SELECT
    'order_item_refunds' AS table_name,
    COUNT(*) AS total_rows,
    SUM(order_item_refund_id IS NULL) AS null_refund_id,
    SUM(created_at IS NULL) AS null_created_at,
    SUM(order_item_id IS NULL) AS null_order_item_id,
    SUM(order_id IS NULL) AS null_order_id,
    SUM(refund_amount_usd IS NULL) AS null_refund_amount
FROM order_item_refunds;


-- PREVIOUS NULL VALIDATION RESULTS:
--
-- website_sessions:
-- Total Rows: 472,871
-- NULL utm_source: 83,328
-- Other checked columns: 0 NULL values
--
-- website_pageviews:
-- Total Rows: 1,188,124
-- All checked columns: 0 NULL values
--
-- products:
-- Total Rows: 4
-- All checked columns: 0 NULL values
--
-- orders:
-- Total Rows: 32,313
-- All checked columns: 0 NULL values
--
-- order_items:
-- Total Rows: 40,025
-- All checked columns: 0 NULL values
--
-- order_item_refunds:
-- Total Rows: 1,731
-- All checked columns: 0 NULL values
--
-- FINDING:
-- Missing values were identified only in
-- website_sessions.utm_source among the checked columns.
--
-- Total missing utm_source values: 83,328.
-- All other checked columns across the six tables
-- contained no NULL values.
--
-- Status: COMPLETED


-- ============================================================
-- ADDITIONAL INVESTIGATION: NULL UTM SOURCE
-- ============================================================

-- Total NULL utm_source sessions: 83,328
--
-- Referrer breakdown:
-- No Referrer : 39,917 sessions
-- Gsearch     : 35,202 sessions
-- Bsearch     :  8,209 sessions
--
-- FINDING:
-- Missing utm_source values cannot automatically be
-- classified as Direct Traffic.
--
-- ACTION:
-- Original NULL values are preserved.
-- No data replacement or deletion was performed.


-- ============================================================
-- SECTION 3: INVALID VALUE CHECKS
-- ============================================================

-- 1. Validate is_repeat_session binary values
-- Expected:
-- 0 = First-time session
-- 1 = Repeat session

SELECT
    is_repeat_session,
    COUNT(*) AS total_sessions
FROM website_sessions
GROUP BY is_repeat_session
ORDER BY is_repeat_session;


-- RESULT:
-- 0 : 394,318 sessions
-- 1 :  78,553 sessions
-- Total: 472,871 sessions
--
-- FINDING:
-- Only expected binary values (0 and 1) were found.
-- No NULL group or unexpected category was returned.
--
-- Status: PASS


-- 2. Validate is_primary_item binary values
-- Expected:
-- 0 = Non-primary item
-- 1 = Primary item

SELECT
    is_primary_item,
    COUNT(*) AS total_order_items
FROM order_items
GROUP BY is_primary_item
ORDER BY is_primary_item;


-- RESULT:
-- 0 :  7,712 order items
-- 1 : 32,313 order items
-- Total: 40,025 order items
--
-- FINDING:
-- Only expected binary values (0 and 1) were found.
-- No NULL group or unexpected category was returned.
--
-- Status: PASS


-- 3. Validate items_purchased distribution

SELECT
    items_purchased,
    COUNT(*) AS total_orders
FROM orders
GROUP BY items_purchased
ORDER BY items_purchased;


-- RESULT:
-- 1 item : 24,601 orders
-- 2 items:  7,712 orders
-- Total  : 32,313 orders
--
-- FINDING:
-- Orders contain either 1 or 2 purchased items.
-- No unexpected quantity categories were identified.
--
-- Status: PASS


-- 4. Check invalid items_purchased values

SELECT
    order_id,
    items_purchased
FROM orders
WHERE items_purchased <= 0;


-- RESULT:
-- 0 rows returned.
--
-- FINDING:
-- No orders were found with items_purchased
-- less than or equal to zero.
--
-- Status: PASS


-- 5. Check negative order prices and costs

SELECT
    order_id,
    price_usd,
    cogs_usd
FROM orders
WHERE price_usd < 0
   OR cogs_usd < 0;


-- RESULT:
-- 0 rows returned.
--
-- FINDING:
-- No negative order prices or costs were detected.
--
-- Status: PASS


-- 6. Check negative order item prices and costs

SELECT
    order_item_id,
    order_id,
    price_usd,
    cogs_usd
FROM order_items
WHERE price_usd < 0
   OR cogs_usd < 0;


-- RESULT:
-- 0 rows returned.
--
-- FINDING:
-- No negative order item prices or costs were detected.
--
-- Status: PASS


-- 7. Check negative refund amounts

SELECT
    order_item_refund_id,
    order_id,
    order_item_id,
    refund_amount_usd
FROM order_item_refunds
WHERE refund_amount_usd < 0;


-- RESULT:
-- 0 rows returned.
--
-- FINDING:
-- No negative refund amounts were detected.
--
-- Status: PASS


-- 8. Validate device_type categories

SELECT
    device_type,
    COUNT(*) AS total_sessions
FROM website_sessions
GROUP BY device_type
ORDER BY device_type;


-- RESULT:
-- desktop : 327,027 sessions
-- mobile  : 145,844 sessions
-- Total   : 472,871 sessions
--
-- FINDING:
-- Two device categories were identified:
-- Desktop and Mobile.
-- No unexpected categories were detected.
--
-- Status: PASS


-- 9. Validate utm_source categories

SELECT
    utm_source,
    COUNT(*) AS total_sessions
FROM website_sessions
GROUP BY utm_source
ORDER BY total_sessions DESC;


-- RESULT:
-- gsearch    : 316,035 sessions
-- NULL       :  83,328 sessions
-- bsearch    :  62,823 sessions
-- socialbook :  10,685 sessions
-- Total      : 472,871 sessions
--
-- FINDING:
-- Three non-NULL acquisition sources were identified.
-- Missing utm_source values remain NULL and are not
-- automatically classified as Direct Traffic.
--
-- Status: COMPLETED


-- 10. Inspect pageview URL values

SELECT
    pageview_url,
    COUNT(*) AS total_pageviews
FROM website_pageviews
GROUP BY pageview_url
ORDER BY total_pageviews DESC;


-- RESULT:
-- 16 distinct pageview URLs identified.
--
-- Highest pageview counts:
-- /products                    : 261,231
-- /the-original-mr-fuzzy       : 162,525
-- /home                        : 137,576
-- /lander-2                    : 131,170
-- /cart                        :  94,953
-- /lander-3                    :  79,000
-- /lander-5                    :  68,166
-- /shipping                    :  64,484
-- /billing-2                   :  48,441
-- /lander-1                    :  47,574
-- /thank-you-for-your-order    :  32,313
-- /the-forever-love-bear       :  26,033
-- /the-birthday-sugar-panda    :  19,046
-- /lander-4                    :   9,385
-- /billing                     :   3,617
-- /the-hudson-river-mini-bear  :   2,610
--
-- FINDING:
-- /products recorded the highest number of pageviews.
-- The thank-you page recorded 32,313 pageviews,
-- matching the total number of order records.
--
-- NOTE:
-- Pageviews represent page visits, not unique users
-- or independently confirmed conversions.
--
-- Status: COMPLETED


-- ============================================================
-- SECTION 4: DATE AND LOGICAL CONSISTENCY CHECKS
-- ============================================================

-- 1. Check orders created before their website sessions

SELECT
    o.order_id,
    o.website_session_id,
    s.created_at AS session_created_at,
    o.created_at AS order_created_at
FROM orders o
INNER JOIN website_sessions s
    ON o.website_session_id = s.website_session_id
WHERE o.created_at < s.created_at;


-- RESULT:
-- 0 rows returned.
--
-- FINDING:
-- No orders were found with a creation timestamp
-- earlier than their corresponding website sessions.
--
-- Status: PASS


-- 2. Check pageviews created before their website sessions

SELECT
    p.website_pageview_id,
    p.website_session_id,
    s.created_at AS session_created_at,
    p.created_at AS pageview_created_at
FROM website_pageviews p
INNER JOIN website_sessions s
    ON p.website_session_id = s.website_session_id
WHERE p.created_at < s.created_at;


-- RESULT:
-- 0 rows returned.
--
-- FINDING:
-- No pageviews were found with a creation timestamp
-- earlier than their corresponding website sessions.
--
-- Execution time: 1.735 sec
-- Status: PASS


-- 3. Check order items created before their orders

SELECT
    oi.order_item_id,
    oi.order_id,
    o.created_at AS order_created_at,
    oi.created_at AS order_item_created_at
FROM order_items oi
INNER JOIN orders o
    ON oi.order_id = o.order_id
WHERE oi.created_at < o.created_at;


-- RESULT:
-- 0 rows returned.
--
-- FINDING:
-- No order items were found with a creation timestamp
-- earlier than their corresponding orders.
--
-- Status: PASS


-- 4. Check refunds created before their orders

SELECT
    r.order_item_refund_id,
    r.order_id,
    o.created_at AS order_created_at,
    r.created_at AS refund_created_at
FROM order_item_refunds r
INNER JOIN orders o
    ON r.order_id = o.order_id
WHERE r.created_at < o.created_at;


-- RESULT:
-- 0 rows returned.
--
-- FINDING:
-- No refunds were found with a creation timestamp
-- earlier than their corresponding orders.
--
-- Execution time: 0.016 sec
-- Status: PASS


-- ============================================================
-- FINAL DATA QUALITY CHECK SUMMARY
-- ============================================================
--
-- SECTION 1: DUPLICATE PRIMARY KEY CHECKS
-- Result: No duplicate Primary Key values detected.
-- Status: PASS
--
-- SECTION 2: NULL VALUE VALIDATION
-- Result: 83,328 NULL values found in utm_source.
-- Other checked columns: 0 NULL values.
-- Status: COMPLETED
--
-- SECTION 3: INVALID VALUE CHECKS
-- Binary values: PASS
-- Items purchased distribution: PASS
-- Invalid item quantities: PASS
-- Negative order prices and costs: PASS
-- Negative order item prices and costs: PASS
-- Negative refund amounts: PASS
-- Device categories: PASS
-- UTM source categories: COMPLETED
-- Pageview URL inspection: COMPLETED
--
-- SECTION 4: DATE AND LOGICAL CONSISTENCY
-- Orders before sessions: PASS
-- Pageviews before sessions: PASS
-- Order items before orders: PASS
-- Refunds before orders: PASS
--
-- IMPORTANT NOTES:
-- 1. NULL utm_source values were preserved.
-- 2. No source records were deleted or modified.
-- 3. NULL validation covers only the selected columns.
-- 4. These checks are diagnostic and do not create
--    database constraints or modify source data.
--
-- Overall Status: COMPLETED
--
-- ============================================================
-- END OF DATA QUALITY CHECKS
-- ============================================================
