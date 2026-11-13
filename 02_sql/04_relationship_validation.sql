
-- ============================================================
-- Project Name : Maven Fuzzy Factory
-- File Name    : 04_relationship_validation.sql
-- Sections     : 1 - 6
-- Objective    : Validate logical relationships between
--                operational tables, identify orphan records,
--                and verify parent-child data consistency.
-- Validation   : 16 checks completed - ALL PASS
-- ============================================================


-- ============================================================
-- SECTION 1: WEBSITE SESSIONS & PAGEVIEWS
-- ============================================================

-- Relationship:
-- website_sessions.website_session_id
--     -> website_pageviews.website_session_id


-- 1.1 Check pageviews without a matching website session
-- RESULT: PASS
-- Total pageviews: 1,188,124
-- Orphan pageviews: 0

SELECT
    COUNT(*) AS total_pageviews,
    SUM(s.website_session_id IS NULL) AS orphan_pageviews
FROM website_pageviews p
LEFT JOIN website_sessions s
    ON p.website_session_id = s.website_session_id;


-- 1.2 Identify unmatched pageview records
-- RESULT: PASS
-- Unmatched records: 0 rows

SELECT
    p.website_pageview_id,
    p.website_session_id,
    p.created_at
FROM website_pageviews p
LEFT JOIN website_sessions s
    ON p.website_session_id = s.website_session_id
WHERE s.website_session_id IS NULL;


-- ============================================================
-- SECTION 2: WEBSITE SESSIONS & ORDERS
-- ============================================================

-- Relationship:
-- website_sessions.website_session_id
--     -> orders.website_session_id


-- 2.1 Check orders without a matching website session
-- RESULT: PASS
-- Total orders: 32,313
-- Orphan orders: 0

SELECT
    COUNT(*) AS total_orders,
    SUM(s.website_session_id IS NULL) AS orphan_orders
FROM orders o
LEFT JOIN website_sessions s
    ON o.website_session_id = s.website_session_id;


-- 2.2 Identify unmatched order records
-- RESULT: PASS
-- Unmatched records: 0 rows

SELECT
    o.order_id,
    o.website_session_id,
    o.user_id,
    o.created_at
FROM orders o
LEFT JOIN website_sessions s
    ON o.website_session_id = s.website_session_id
WHERE s.website_session_id IS NULL;


-- ============================================================
-- SECTION 3: ORDERS & ORDER ITEMS
-- ============================================================

-- Relationship:
-- orders.order_id
--     -> order_items.order_id


-- 3.1 Check order items without a matching order
-- RESULT: PASS
-- Total order items: 40,025
-- Orphan order items: 0

SELECT
    COUNT(*) AS total_order_items,
    SUM(o.order_id IS NULL) AS orphan_order_items
FROM order_items oi
LEFT JOIN orders o
    ON oi.order_id = o.order_id;


-- 3.2 Identify unmatched order item records
-- RESULT: PASS
-- Unmatched records: 0 rows

SELECT
    oi.order_item_id,
    oi.order_id,
    oi.product_id,
    oi.created_at
FROM order_items oi
LEFT JOIN orders o
    ON oi.order_id = o.order_id
WHERE o.order_id IS NULL;


-- 3.3 Check orders without any order items
-- RESULT: PASS
-- Orders without items: 0

SELECT
    COUNT(*) AS orders_without_items
FROM orders o
LEFT JOIN order_items oi
    ON o.order_id = oi.order_id
WHERE oi.order_id IS NULL;


-- ============================================================
-- SECTION 4: PRODUCTS & ORDER ITEMS
-- ============================================================

-- Relationship:
-- products.product_id
--     -> order_items.product_id


-- 4.1 Check order items without a matching product
-- RESULT: PASS
-- Total order items: 40,025
-- Orphan product references: 0

SELECT
    COUNT(*) AS total_order_items,
    SUM(p.product_id IS NULL) AS orphan_product_references
FROM order_items oi
LEFT JOIN products p
    ON oi.product_id = p.product_id;


-- 4.2 Identify unmatched product references
-- RESULT: PASS
-- Unmatched records: 0 rows

SELECT
    oi.order_item_id,
    oi.order_id,
    oi.product_id
FROM order_items oi
LEFT JOIN products p
    ON oi.product_id = p.product_id
WHERE p.product_id IS NULL;


-- ============================================================
-- SECTION 5: ORDERS, ORDER ITEMS & REFUNDS
-- ============================================================

-- Relationship 1:
-- orders.order_id
--     -> order_item_refunds.order_id


-- 5.1 Check refunds without a matching order
-- RESULT: PASS
-- Total refunds: 1,731
-- Orphan order references: 0

SELECT
    COUNT(*) AS total_refunds,
    SUM(o.order_id IS NULL) AS orphan_order_references
FROM order_item_refunds r
LEFT JOIN orders o
    ON r.order_id = o.order_id;


-- 5.2 Identify refunds without a matching order
-- RESULT: PASS
-- Unmatched records: 0 rows

SELECT
    r.order_item_refund_id,
    r.order_id,
    r.order_item_id,
    r.refund_amount_usd
FROM order_item_refunds r
LEFT JOIN orders o
    ON r.order_id = o.order_id
WHERE o.order_id IS NULL;


-- Relationship 2:
-- order_items.order_item_id
--     -> order_item_refunds.order_item_id


-- 5.3 Check refunds without a matching order item
-- RESULT: PASS
-- Total refunds: 1,731
-- Orphan order item references: 0

SELECT
    COUNT(*) AS total_refunds,
    SUM(oi.order_item_id IS NULL) AS orphan_order_item_references
FROM order_item_refunds r
LEFT JOIN order_items oi
    ON r.order_item_id = oi.order_item_id;


-- 5.4 Identify refunds without a matching order item
-- RESULT: PASS
-- Unmatched records: 0 rows

SELECT
    r.order_item_refund_id,
    r.order_id,
    r.order_item_id,
    r.refund_amount_usd
FROM order_item_refunds r
LEFT JOIN order_items oi
    ON r.order_item_id = oi.order_item_id
WHERE oi.order_item_id IS NULL;


-- 5.5 Check order consistency between refunds and order items
-- RESULT: PASS
-- Order ID mismatches: 0 rows
--
-- A refund's order_id should match the order_id
-- associated with its referenced order_item_id.

SELECT
    r.order_item_refund_id,
    r.order_id AS refund_order_id,
    oi.order_id AS actual_order_id,
    r.order_item_id
FROM order_item_refunds r
INNER JOIN order_items oi
    ON r.order_item_id = oi.order_item_id
WHERE r.order_id <> oi.order_id;


-- ============================================================
-- SECTION 6: PRIMARY PRODUCT CONSISTENCY
-- ============================================================

-- 6.1 Check that each order has exactly one primary item
-- RESULT: PASS
-- Orders with an invalid primary item count: 0 rows

SELECT
    o.order_id,
    COUNT(
        CASE
            WHEN oi.is_primary_item = 1 THEN 1
        END
    ) AS primary_item_count
FROM orders o
LEFT JOIN order_items oi
    ON o.order_id = oi.order_id
GROUP BY o.order_id
HAVING primary_item_count <> 1;


-- 6.2 Validate primary_product_id against primary order item
-- RESULT: PASS
-- Primary product mismatches: 0 rows
--
-- Verify that the primary_product_id stored in orders
-- matches the product_id of its primary order item.

SELECT
    o.order_id,
    o.primary_product_id,
    oi.product_id AS primary_item_product_id
FROM orders o
LEFT JOIN order_items oi
    ON o.order_id = oi.order_id
    AND oi.is_primary_item = 1
WHERE oi.order_item_id IS NULL
   OR o.primary_product_id <> oi.product_id;


-- ============================================================
-- VALIDATION SUMMARY
-- ============================================================
--
-- Section 1: Website Sessions & Pageviews       PASS (2/2)
-- Section 2: Website Sessions & Orders          PASS (2/2)
-- Section 3: Orders & Order Items               PASS (3/3)
-- Section 4: Products & Order Items             PASS (2/2)
-- Section 5: Orders, Order Items & Refunds      PASS (5/5)
-- Section 6: Primary Product Consistency       PASS (2/2)
--
-- TOTAL CHECKS: 16
-- PASSED      : 16
-- FAILED      : 0
-- PENDING     : 0
--
-- Conclusion:
-- No orphan records or relationship inconsistencies
-- were identified in the tested relationships.
--
-- NOTE:
-- These checks validate logical relationships through SQL.
-- They do not create physical FOREIGN KEY constraints.
--
-- ============================================================
-- END OF RELATIONSHIP VALIDATION
-- ============================================================
