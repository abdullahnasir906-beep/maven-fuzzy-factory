# Maven Fuzzy Factory — Business Analysis SQL

**File:** `05_business_analysis.sql`  
**Author:** Abdullah Nasir  
**Database:** `maven_fuzzy_factory`

```sql
-- ====================================================================
-- Project Name  : Maven Fuzzy Factory
-- File Name     : 05_business_analysis.sql
-- Author        : Abdullah Nasir
-- Section       : Business Analysis
-- Database      : maven_fuzzy_factory
--
-- OBJECTIVE:
-- Analyze business performance using transactional, product,
-- customer, website acquisition, conversion, monthly sales,
-- and refund data.
--
-- ANALYSIS GRAIN:
-- 1. Order Level:
--    Overall sales, customer purchases and monthly order metrics.
--
-- 2. Order Item Level:
--    Product sales, product profitability and refund analysis.
--
-- 3. Website Session Level:
--    Acquisition source and website conversion analysis.
--
-- BUSINESS FRAMEWORK:
-- Business Objective
-- -> Business Questions
-- -> SQL Analysis
-- -> Key Findings
-- -> Business Interpretation
-- -> Business Recommendations
--
-- DASHBOARD STRUCTURE:
-- Page 1: Sales & Product Performance
-- Page 2: Marketing & Business Trends
--
-- IMPORTANT DATA LIMITATIONS:
-- 1. No explicit order-item quantity column is available.
-- 2. Customer demographic information is not available.
-- 3. Payment method and discount information are not available.
-- 4. Inventory stock and product availability data are not available.
-- 5. NULL utm_source values cannot automatically be classified
--    as Direct Traffic.
-- ====================================================================


-- ====================================================================
-- PAGE 1: SALES & PRODUCT PERFORMANCE
-- ====================================================================


-- ====================================================================
-- SECTION 1: OVERALL SALES PERFORMANCE
-- ====================================================================

-- BUSINESS OBJECTIVE:
-- Evaluate overall sales performance and business profitability.
--
-- BUSINESS QUESTIONS:
-- 1. How many orders were recorded?
-- 2. How many unique customers made purchases?
-- 3. What is the total recorded items_purchased value?
-- 4. How much revenue was generated?
-- 5. What was the total cost of goods sold?
-- 6. How much gross profit was generated?
-- 7. What was the overall profit margin?
-- 8. What was the average order value?
--
-- KEY METRICS:
-- Revenue       = SUM(orders.price_usd)
-- COGS          = SUM(orders.cogs_usd)
-- Gross Profit  = Revenue - COGS
-- Profit Margin = Gross Profit / Revenue * 100
-- AOV           = Revenue / Total Orders
--
-- GRAIN:
-- One record represents one order.
--
-- NOTE:
-- Order-level metrics are calculated from the orders table
-- to avoid duplicating order values through item-level joins.
--
-- items_purchased is an order-level field. Its sum should not
-- automatically be interpreted as verified physical product units.


-- 1.1 Overall Sales & Profitability Overview

SELECT
    COUNT(order_id) AS total_orders,

    COUNT(DISTINCT user_id) AS unique_customers,

    SUM(items_purchased) AS total_units_purchased,

    ROUND(SUM(price_usd), 2) AS total_revenue,

    ROUND(SUM(cogs_usd), 2) AS total_cogs,

    ROUND(
        SUM(price_usd) - SUM(cogs_usd),
        2
    ) AS gross_profit,

    ROUND(
        (SUM(price_usd) - SUM(cogs_usd))
        / NULLIF(SUM(price_usd), 0) * 100,
        2
    ) AS profit_margin_percentage,

    ROUND(
        SUM(price_usd) / NULLIF(COUNT(order_id), 0),
        2
    ) AS average_order_value

FROM orders;


-- ====================================================================
-- SECTION 2: TRANSACTION-LEVEL SALES ANALYSIS
-- ====================================================================

-- BUSINESS OBJECTIVE:
-- Examine individual order-item records and their relationship
-- with customers, products, sales values and associated costs.
--
-- BUSINESS QUESTIONS:
-- 1. When was each order placed?
-- 2. Which customer made the purchase?
-- 3. Which product was associated with the order item?
-- 4. What was the sales value and associated cost?
-- 5. How much gross profit was generated per order-item record?
--
-- GRAIN:
-- One record represents one order-item record.
--
-- NOTE:
-- The dataset does not provide an explicit quantity column
-- at the order-item level.
--
-- derived_item_record_quantity = 1 represents one database
-- order-item record, not a verified physical unit quantity.
--
-- Order date is obtained from orders.created_at.


-- 2.1 Transaction-Level Sales Detail

SELECT
    oi.order_item_id,

    oi.order_id,

    o.user_id AS customer_id,

    o.created_at AS transaction_date,

    oi.product_id,

    p.product_name,

    1 AS derived_item_record_quantity,

    ROUND(oi.price_usd, 2) AS sales_value,

    ROUND(oi.cogs_usd, 2) AS cost_of_goods_sold,

    ROUND(
        oi.price_usd - oi.cogs_usd,
        2
    ) AS gross_profit,

    ROUND(
        (oi.price_usd - oi.cogs_usd)
        / NULLIF(oi.price_usd, 0) * 100,
        2
    ) AS profit_margin_percentage

FROM order_items oi

INNER JOIN orders o
    ON oi.order_id = o.order_id

INNER JOIN products p
    ON oi.product_id = p.product_id

ORDER BY
    o.created_at,
    oi.order_id,
    oi.order_item_id;


-- ====================================================================
-- SECTION 3: PRODUCT PERFORMANCE & PROFITABILITY
-- ====================================================================

-- BUSINESS OBJECTIVE:
-- Identify products that contribute most to sales and gross profit.
--
-- BUSINESS QUESTIONS:
-- 1. Which products generate the highest revenue?
-- 2. Which products have the highest order-item record volume?
-- 3. Which products generate the highest gross profit?
-- 4. Which products have the highest and lowest profit margins?
-- 5. How much does each product contribute to total revenue?
--
-- GRAIN:
-- One aggregated record per product.
--
-- SOURCE:
-- order_items provides product-level sales and cost information.
--
-- NOTE:
-- Order-item record counts are not necessarily equivalent
-- to verified physical unit quantities.


-- 3.1 Product Sales & Profitability Overview

SELECT
    p.product_id,

    p.product_name,

    COUNT(oi.order_item_id) AS total_order_item_records,

    COUNT(DISTINCT oi.order_id) AS total_orders,

    COUNT(DISTINCT o.user_id) AS unique_customers,

    ROUND(SUM(oi.price_usd), 2) AS total_revenue,

    ROUND(SUM(oi.cogs_usd), 2) AS total_cogs,

    ROUND(
        SUM(oi.price_usd) - SUM(oi.cogs_usd),
        2
    ) AS gross_profit,

    ROUND(
        (SUM(oi.price_usd) - SUM(oi.cogs_usd))
        / NULLIF(SUM(oi.price_usd), 0) * 100,
        2
    ) AS profit_margin_percentage

FROM order_items oi

INNER JOIN products p
    ON oi.product_id = p.product_id

INNER JOIN orders o
    ON oi.order_id = o.order_id

GROUP BY
    p.product_id,
    p.product_name

ORDER BY total_revenue DESC;


-- 3.2 Product Revenue Contribution
--
-- BUSINESS QUESTION:
-- What percentage of total product revenue is contributed
-- by each product?
--
-- FORMULA:
-- Product Revenue / Total Order Item Revenue * 100


SELECT
    p.product_id,

    p.product_name,

    ROUND(SUM(oi.price_usd), 2) AS product_revenue,

    ROUND(
        SUM(oi.price_usd)
        / NULLIF(
            (SELECT SUM(price_usd) FROM order_items),
            0
        ) * 100,
        2
    ) AS revenue_contribution_percentage

FROM order_items oi

INNER JOIN products p
    ON oi.product_id = p.product_id

GROUP BY
    p.product_id,
    p.product_name

ORDER BY product_revenue DESC;


-- 3.3 Product Profitability Ranking
--
-- BUSINESS QUESTION:
-- Which products generate the highest absolute gross profit?
--
-- NOTE:
-- Gross profit ranking and profit margin ranking measure
-- different aspects of product performance.


SELECT
    p.product_id,

    p.product_name,

    ROUND(
        SUM(oi.price_usd) - SUM(oi.cogs_usd),
        2
    ) AS gross_profit,

    ROUND(
        (SUM(oi.price_usd) - SUM(oi.cogs_usd))
        / NULLIF(SUM(oi.price_usd), 0) * 100,
        2
    ) AS profit_margin_percentage

FROM order_items oi

INNER JOIN products p
    ON oi.product_id = p.product_id

GROUP BY
    p.product_id,
    p.product_name

ORDER BY gross_profit DESC;


-- ====================================================================
-- SECTION 4: CUSTOMER PURCHASE PERFORMANCE
-- ====================================================================

-- BUSINESS OBJECTIVE:
-- Understand customer purchase frequency and revenue contribution.
--
-- BUSINESS QUESTIONS:
-- 1. How many orders does each customer make?
-- 2. Which customers make repeat purchases?
-- 3. How much revenue does each customer generate?
-- 4. What is the average order value per customer?
-- 5. How does revenue differ between one-time and repeat customers?
--
-- GRAIN:
-- One aggregated record per customer.
--
-- CUSTOMER IDENTIFIER:
-- orders.user_id
--
-- NOTE:
-- Customer demographic information such as age and gender
-- is not available in the identified dataset schema.
--
-- Customer classification:
-- One-Time Customer = One recorded order
-- Repeat Customer   = More than one recorded order


-- 4.1 Customer Purchase Summary

SELECT
    user_id AS customer_id,

    COUNT(order_id) AS total_orders,

    SUM(items_purchased) AS total_units_purchased,

    ROUND(SUM(price_usd), 2) AS total_revenue,

    ROUND(
        SUM(price_usd) / NULLIF(COUNT(order_id), 0),
        2
    ) AS average_order_value,

    MIN(created_at) AS first_purchase_date,

    MAX(created_at) AS latest_purchase_date,

    CASE
        WHEN COUNT(order_id) > 1
            THEN 'Repeat Customer'
        ELSE 'One-Time Customer'
    END AS customer_type

FROM orders

GROUP BY user_id

ORDER BY total_revenue DESC;


-- 4.2 Customer Purchase Frequency Summary
--
-- BUSINESS QUESTION:
-- How do customer count, revenue and average order frequency
-- differ between one-time and repeat customers?
--
-- GRAIN:
-- One aggregated record per customer type.


SELECT
    customer_type,

    COUNT(*) AS total_customers,

    ROUND(SUM(total_revenue), 2) AS total_revenue,

    ROUND(
        AVG(total_orders),
        2
    ) AS average_orders_per_customer

FROM (
    SELECT
        user_id,

        COUNT(order_id) AS total_orders,

        SUM(price_usd) AS total_revenue,

        CASE
            WHEN COUNT(order_id) > 1
                THEN 'Repeat Customer'
            ELSE 'One-Time Customer'
        END AS customer_type

    FROM orders

    GROUP BY user_id
) customer_summary

GROUP BY customer_type

ORDER BY total_customers DESC;


-- ====================================================================
-- PAGE 2: MARKETING & BUSINESS TRENDS
-- ====================================================================


-- ====================================================================
-- SECTION 5: ACQUISITION & CONVERSION PERFORMANCE
-- ====================================================================

-- BUSINESS OBJECTIVE:
-- Evaluate website acquisition sources and conversion performance.
--
-- BUSINESS QUESTIONS:
-- 1. Which acquisition sources generate the most sessions?
-- 2. Which sources attract the most unique users?
-- 3. Which sources generate the most orders?
-- 4. Which sources have the highest session conversion rate?
-- 5. Does conversion performance differ by device type?
--
-- KEY METRIC:
-- Conversion Rate =
-- Converted Sessions / Total Sessions * 100
--
-- CONVERSION DEFINITION:
-- A website session is considered converted when at least
-- one associated order is recorded.
--
-- NOTE:
-- NULL utm_source is retained as Unknown / NULL.
-- It must not automatically be classified as Direct Traffic.
--
-- Unique users across acquisition sources are not necessarily
-- additive because one user may appear under multiple sources.


-- 5.1 Website Traffic by Acquisition Source

SELECT
    COALESCE(utm_source, 'Unknown / NULL') AS acquisition_source,

    COUNT(*) AS total_sessions,

    COUNT(DISTINCT user_id) AS unique_users,

    SUM(is_repeat_session = 0) AS new_sessions,

    SUM(is_repeat_session = 1) AS repeat_sessions

FROM website_sessions

GROUP BY
    COALESCE(utm_source, 'Unknown / NULL')

ORDER BY total_sessions DESC;


-- 5.2 Conversion Performance by Acquisition Source
--
-- BUSINESS QUESTION:
-- Which acquisition sources generate the highest
-- session conversion rates?
--
-- GRAIN:
-- One aggregated record per acquisition source.
--
-- NOTE:
-- Orders are joined through website_session_id.
-- DISTINCT is used to prevent duplicate session and order
-- counting if the join produces multiple matching records.


SELECT
    COALESCE(s.utm_source, 'Unknown / NULL')
        AS acquisition_source,

    COUNT(DISTINCT s.website_session_id) AS total_sessions,

    COUNT(DISTINCT
        CASE
            WHEN o.order_id IS NOT NULL
            THEN s.website_session_id
        END
    ) AS converted_sessions,

    COUNT(DISTINCT o.order_id) AS total_orders,

    ROUND(
        COUNT(DISTINCT
            CASE
                WHEN o.order_id IS NOT NULL
                THEN s.website_session_id
            END
        )
        / NULLIF(COUNT(DISTINCT s.website_session_id), 0)
        * 100,
        2
    ) AS conversion_rate_percentage

FROM website_sessions s

LEFT JOIN orders o
    ON s.website_session_id = o.website_session_id

GROUP BY
    COALESCE(s.utm_source, 'Unknown / NULL')

ORDER BY conversion_rate_percentage DESC;


-- 5.3 Conversion Performance by Device Type
--
-- BUSINESS QUESTION:
-- Does website conversion performance differ
-- between desktop and mobile sessions?
--
-- GRAIN:
-- One aggregated record per device type.


SELECT
    s.device_type,

    COUNT(DISTINCT s.website_session_id) AS total_sessions,

    COUNT(DISTINCT
        CASE
            WHEN o.order_id IS NOT NULL
            THEN s.website_session_id
        END
    ) AS converted_sessions,

    COUNT(DISTINCT o.order_id) AS total_orders,

    ROUND(
        COUNT(DISTINCT
            CASE
                WHEN o.order_id IS NOT NULL
                THEN s.website_session_id
            END
        )
        / NULLIF(COUNT(DISTINCT s.website_session_id), 0)
        * 100,
        2
    ) AS conversion_rate_percentage

FROM website_sessions s

LEFT JOIN orders o
    ON s.website_session_id = o.website_session_id

GROUP BY s.device_type

ORDER BY conversion_rate_percentage DESC;


-- ====================================================================
-- SECTION 6: MONTHLY SALES & YEAR-OVER-YEAR TRENDS
-- ====================================================================

-- BUSINESS OBJECTIVE:
-- Analyze monthly business performance and identify
-- recurring sales patterns over time.
--
-- BUSINESS QUESTIONS:
-- 1. How does monthly revenue change over time?
-- 2. How does monthly order volume change?
-- 3. Are there recurring monthly sales patterns?
-- 4. How does performance compare across different years?
-- 5. Which products contribute to monthly revenue?
--
-- NOTE:
-- Monthly revenue and order trends can reveal recurring patterns.
-- However, these patterns alone do not prove seasonality.
--
-- The dataset ends on 19 March 2015.
-- March 2015 is therefore an incomplete month and should not
-- be compared directly with complete March periods.


-- 6.1 Monthly Sales Performance
--
-- BUSINESS QUESTION:
-- How do revenue, COGS, gross profit and order volume
-- change from month to month?
--
-- GRAIN:
-- One aggregated record per calendar month.


SELECT
    YEAR(created_at) AS sales_year,

    MONTH(created_at) AS month_number,

    MONTHNAME(created_at) AS month_name,

    COUNT(order_id) AS total_orders,

    SUM(items_purchased) AS total_units_purchased,

    ROUND(SUM(price_usd), 2) AS total_revenue,

    ROUND(SUM(cogs_usd), 2) AS total_cogs,

    ROUND(
        SUM(price_usd) - SUM(cogs_usd),
        2
    ) AS gross_profit,

    ROUND(
        SUM(price_usd) / NULLIF(COUNT(order_id), 0),
        2
    ) AS average_order_value

FROM orders

GROUP BY
    YEAR(created_at),
    MONTH(created_at),
    MONTHNAME(created_at)

ORDER BY
    sales_year,
    month_number;


-- 6.2 Year-over-Year Monthly Revenue Comparison
--
-- BUSINESS QUESTION:
-- How does revenue for the same calendar month
-- compare across different years?
--
-- SUGGESTED VISUALIZATION:
-- X-axis : Month
-- Legend : Year
-- Y-axis : Monthly Revenue
--
-- NOTE:
-- This query returns monthly revenue by year.
-- YoY percentage growth can be calculated separately
-- using the previous year's monthly revenue.


SELECT
    YEAR(created_at) AS sales_year,

    MONTH(created_at) AS month_number,

    MONTHNAME(created_at) AS month_name,

    ROUND(SUM(price_usd), 2) AS monthly_revenue

FROM orders

GROUP BY
    YEAR(created_at),
    MONTH(created_at),
    MONTHNAME(created_at)

ORDER BY
    month_number,
    sales_year;


-- 6.3 Year-over-Year Monthly Order Comparison
--
-- BUSINESS QUESTION:
-- How does monthly order volume compare
-- across the same calendar months in different years?
--
-- SUGGESTED VISUALIZATION:
-- X-axis : Month
-- Legend : Year
-- Y-axis : Monthly Orders


SELECT
    YEAR(created_at) AS sales_year,

    MONTH(created_at) AS month_number,

    MONTHNAME(created_at) AS month_name,

    COUNT(order_id) AS monthly_orders

FROM orders

GROUP BY
    YEAR(created_at),
    MONTH(created_at),
    MONTHNAME(created_at)

ORDER BY
    month_number,
    sales_year;


-- 6.4 Monthly Product Revenue Trends
--
-- BUSINESS OBJECTIVE:
-- Understand how individual products contribute
-- to monthly revenue over time.
--
-- BUSINESS QUESTIONS:
-- 1. Which products generate the highest monthly revenue?
-- 2. How does each product's revenue change over time?
-- 3. How does the product portfolio contribute to sales growth?
--
-- GRAIN:
-- One aggregated record per product per calendar month.
--
-- NOTE:
-- total_order_item_records represents database records,
-- not independently verified physical unit quantities.


SELECT
    YEAR(oi.created_at) AS sales_year,

    MONTH(oi.created_at) AS month_number,

    MONTHNAME(oi.created_at) AS month_name,

    p.product_name,

    COUNT(oi.order_item_id) AS total_order_item_records,

    ROUND(SUM(oi.price_usd), 2) AS monthly_revenue

FROM order_items oi

INNER JOIN products p
    ON oi.product_id = p.product_id

GROUP BY
    YEAR(oi.created_at),
    MONTH(oi.created_at),
    MONTHNAME(oi.created_at),
    p.product_name

ORDER BY
    sales_year,
    month_number,
    monthly_revenue DESC;


-- ====================================================================
-- SECTION 7: REFUND & REVENUE IMPACT
-- ====================================================================

-- BUSINESS OBJECTIVE:
-- Evaluate the financial impact of recorded refunds
-- on overall and product-level revenue.
--
-- BUSINESS QUESTIONS:
-- 1. How many refund records were recorded?
-- 2. How many distinct orders had refunds?
-- 3. How much money was refunded?
-- 4. What percentage of gross order revenue was refunded?
-- 5. Which products have the highest refund amounts?
-- 6. Which products have the highest refund-to-revenue ratios?
--
-- IMPORTANT:
-- Refunds are aggregated separately from sales to prevent
-- duplicated sales values when multiple refunds exist.
--
-- Refund-adjusted revenue is not equivalent to net profit.
-- Operating expenses and other financial adjustments
-- are not included in this analysis.


-- 7.1 Overall Refund Performance
--
-- KEY METRICS:
-- Total Refunds = Count of refund records
-- Refunded Orders = Count of distinct refunded orders
-- Refund Percentage =
-- Total Refund Amount / Gross Order Revenue * 100
--
-- Estimated Revenue After Refunds =
-- Gross Order Revenue - Total Refund Amount


SELECT
    COUNT(r.order_item_refund_id) AS total_refunds,

    COUNT(DISTINCT r.order_id) AS refunded_orders,

    ROUND(
        SUM(r.refund_amount_usd),
        2
    ) AS total_refund_amount,

    ROUND(
        SUM(r.refund_amount_usd)
        / NULLIF(
            (SELECT SUM(price_usd) FROM orders),
            0
        ) * 100,
        2
    ) AS refund_percentage_of_gross_revenue,

    ROUND(
        (SELECT SUM(price_usd) FROM orders)
        - SUM(r.refund_amount_usd),
        2
    ) AS estimated_revenue_after_refunds

FROM order_item_refunds r;


-- 7.2 Refund Performance by Product
--
-- BUSINESS OBJECTIVE:
-- Identify products with higher refund amounts
-- and refund-to-revenue ratios.
--
-- GRAIN:
-- One aggregated record per product.
--
-- APPROACH:
-- 1. Aggregate product sales separately.
-- 2. Aggregate product refunds separately.
-- 3. Join the two aggregated datasets to products.
--
-- This prevents sales values from being duplicated
-- when multiple refund records exist for an order item.
--
-- METRIC:
-- Refund Percentage of Product Revenue =
-- Product Refund Amount / Product Revenue * 100
--
-- NOTE:
-- A higher refund percentage indicates a larger refund amount
-- relative to recorded product revenue. It does not, by itself,
-- establish the reason for the refunds.


WITH product_sales AS (
    SELECT
        product_id,

        COUNT(order_item_id) AS total_order_item_records,

        ROUND(SUM(price_usd), 2) AS product_revenue

    FROM order_items

    GROUP BY product_id
),

product_refunds AS (
    SELECT
        oi.product_id,

        COUNT(r.order_item_refund_id) AS total_refunds,

        ROUND(SUM(r.refund_amount_usd), 2) AS total_refund_amount

    FROM order_item_refunds r

    INNER JOIN order_items oi
        ON r.order_item_id = oi.order_item_id

    GROUP BY oi.product_id
)

SELECT
    p.product_id,

    p.product_name,

    COALESCE(ps.total_order_item_records, 0)
        AS total_order_item_records,

    COALESCE(ps.product_revenue, 0)
        AS product_revenue,

    COALESCE(pr.total_refunds, 0)
        AS total_refunds,

    COALESCE(pr.total_refund_amount, 0)
        AS total_refund_amount,

    ROUND(
        COALESCE(pr.total_refund_amount, 0)
        / NULLIF(ps.product_revenue, 0) * 100,
        2
    ) AS refund_percentage_of_product_revenue

FROM products p

LEFT JOIN product_sales ps
    ON p.product_id = ps.product_id

LEFT JOIN product_refunds pr
    ON p.product_id = pr.product_id

ORDER BY total_refund_amount DESC;


-- ====================================================================
-- END OF BUSINESS ANALYSIS
--
-- TOTAL SECTIONS : 7
-- TOTAL QUERIES  : 16
--
-- All queries were executed and their outputs reviewed
-- during the business analysis validation process.
-- ====================================================================
```