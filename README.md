# Maven Fuzzy Factory — E-Commerce Business Analysis

**Author:** Abdullah Nasir  
**Database:** `maven_fuzzy_factory`  
**Tools:** MySQL Workbench, SQL, Power BI  
**Project Type:** E-Commerce Business Intelligence & Data Analytics

---

## 1. Project Overview

This project analyzes the operational data of Maven Fuzzy Factory, an e-commerce business, to understand its sales performance, product profitability, customer purchasing behavior, website acquisition channels, conversion performance, monthly business trends, and refund activity.

Using SQL, I performed data profiling, data quality checks, relationship validation, and business analysis across six operational tables.

The analysis focuses on translating raw transactional and website activity data into meaningful business insights that can support better commercial and marketing decisions.

## 2. Business Objectives

The main objective is to evaluate business performance and identify opportunities for improvement through data analysis.

The analysis addresses five key areas:

1. **Sales Performance** — Evaluate revenue, cost of goods sold, gross profit, profit margin, and average order value.
2. **Product Performance** — Identify top-performing products based on revenue, gross profit, and profitability.
3. **Customer Behavior** — Understand customer purchasing frequency and compare one-time and repeat customer contributions.
4. **Marketing & Conversion** — Evaluate acquisition sources, website traffic, and conversion performance across acquisition channels and devices.
5. **Business Trends & Refunds** — Analyze monthly performance, year-over-year trends, product revenue patterns, and refund impact.

## 3. Dataset Overview

The project uses six operational tables and one data dictionary table.

| Table | Description |
|---|---|
| `website_sessions` | Website traffic, acquisition sources, users, and device information |
| `website_pageviews` | Website pageview activity and session navigation |
| `products` | Product information and product creation dates |
| `orders` | Order transactions, customer identifiers, revenue, and COGS |
| `order_items` | Product-level order records and associated sales values |
| `order_item_refunds` | Refund transactions associated with order items |
| `data_dictionary` | Reference information describing the dataset fields |

### Dataset Record Counts

| Operational Table | Records |
|---|---:|
| website_sessions | 472,871 |
| website_pageviews | 1,188,124 |
| products | 4 |
| orders | 32,313 |
| order_items | 40,025 |
| order_item_refunds | 1,731 |

**Data coverage:** March 2012 – April 2015, depending on the table.

The latest recorded order date is 19 March 2015, while refund records extend to 1 April 2015.

## 4. Data Analysis Workflow

The project follows a structured analytical workflow:

### Step 1 — Database Setup

- Created the project database and operational tables.
- Imported the raw dataset into MySQL.
- Reviewed the database structure and available fields.

### Step 2 — Data Profiling

Performed initial data exploration to understand:

- Table structures and column definitions.
- Record counts across operational tables.
- Available date ranges.
- Selected-column NULL values.
- Sample records and data dictionary definitions.

### Step 3 — Data Quality Checks

Performed SQL validation to investigate:

- Duplicate primary key records.
- Missing values in selected columns.
- Binary field distributions.
- Invalid or unexpected numerical values.
- Negative sales, cost, and refund amounts.
- Date consistency across related tables.

### Step 4 — Relationship Validation

Validated logical relationships between operational tables:

- Website sessions and pageviews.
- Website sessions and orders.
- Orders and order items.
- Products and order items.
- Orders, order items, and refunds.
- Primary product consistency between orders and order items.

All 16 relationship validation checks returned zero unmatched or inconsistent records.

*Note: These checks validate logical relationships in the data. They do not mean physical foreign key constraints were created in the database.*

### Step 5 — Business Analysis

Developed 16 SQL queries across seven analytical sections to answer business questions and calculate relevant performance metrics.

## 5. SQL Analysis Structure

The SQL analysis is organized into two main analytical pages.

### Page 1 — Sales & Product Performance

| Section | Analysis | Business Focus |
|---|---|---|
| 1 | Overall Sales Performance | Revenue, COGS, gross profit, margin, and AOV |
| 2 | Transaction-Level Sales Analysis | Individual order-item records and profitability |
| 3 | Product Performance & Profitability | Product revenue, contribution, and gross profit |
| 4 | Customer Purchase Performance | Customer purchasing frequency and revenue contribution |

### Page 2 — Marketing & Business Trends

| Section | Analysis | Business Focus |
|---|---|---|
| 5 | Acquisition & Conversion Performance | Traffic sources and device conversion |
| 6 | Monthly Sales & YoY Trends | Monthly revenue, orders, and product trends |
| 7 | Refund & Revenue Impact | Refund amounts and product-level refund ratios |

**SQL file:** `sql/05_business_analysis.sql`

## 6. Key Business Findings & Insights

The following findings are based on the SQL analysis outputs.

### 6.1 Overall Sales Performance

| Metric | Result |
|---|---:|
| Total Orders | 32,313 |
| Unique Customers | 31,696 |
| Total Revenue | $1,938,509.75 |
| Total COGS | $722,370.25 |
| Gross Profit | $1,216,139.50 |
| Gross Profit Margin | 62.74% |
| Average Order Value | $59.99 |

**Business Interpretation**

The business generated approximately $1.94 million in recorded revenue and $1.22 million in gross profit, with an overall gross profit margin of 62.74%.

This provides a baseline for evaluating product profitability and overall commercial performance.

### 6.2 Product Performance & Profitability

| Product | Revenue | Revenue Contribution | Gross Profit Margin |
|---|---:|---:|---:|
| The Original Mr. Fuzzy | $1,211,057.74 | 62.47% | 61.01% |
| The Forever Love Bear | $347,702.04 | 17.94% | 62.51% |
| The Birthday Sugar Panda | $229,260.15 | 11.83% | 68.49% |
| The Hudson River Mini bear | $150,489.82 | 7.76% | 68.36% |

**Key Findings**

- The Original Mr. Fuzzy contributed 62.47% of total product revenue.
- It also generated the highest absolute gross profit at $738,893.00.
- The Birthday Sugar Panda recorded the highest gross profit margin at 68.49%.
- The Hudson River Mini bear recorded a gross profit margin of 68.36%.

**Business Interpretation**

The Original Mr. Fuzzy is the main revenue contributor and an important product for maintaining sales performance.

However, the Birthday Sugar Panda and Hudson River Mini bear achieved higher gross profit margins. This shows why product performance should be evaluated using both revenue contribution and profitability rather than revenue alone.

### 6.3 Customer Purchase Behavior

| Customer Type | Customers | Revenue |
|---|---:|---:|
| One-Time Customer | 31,105 | $1,864,153.31 |
| Repeat Customer | 591 | $74,356.44 |

**Key Findings**

- Approximately 98.14% of customers made only one recorded purchase.
- Only 1.86% of customers made more than one recorded purchase.
- One-time customers contributed approximately 96.16% of total revenue.
- Repeat customers contributed approximately 3.84% of total revenue.

**Business Interpretation**

The customer base is heavily concentrated around one-time purchases.

This highlights a potential opportunity to improve customer retention and encourage repeat purchases through post-purchase engagement, personalized product recommendations, and targeted re-engagement campaigns.

However, the available data does not explain why customers did not return.

### 6.4 Acquisition Source Performance

| Acquisition Source | Sessions | Converted Sessions | Conversion Rate |
|---|---:|---:|---:|
| Unknown / NULL | 83,328 | 6,118 | 7.34% |
| bsearch | 62,823 | 4,519 | 7.19% |
| gsearch | 316,035 | 21,333 | 6.75% |
| socialbook | 10,685 | 343 | 3.21% |

**Key Findings**

- gsearch generated the highest traffic volume and the highest number of converted sessions.
- bsearch achieved a higher conversion rate than gsearch.
- Unknown / NULL recorded the highest observed conversion rate, but its acquisition attribution is incomplete.
- socialbook recorded the lowest conversion rate at 3.21%.

**Business Interpretation**

gsearch is the largest traffic acquisition source, while bsearch demonstrates a slightly stronger conversion rate.

The lower conversion rate from socialbook may justify further investigation into audience targeting, landing page relevance, and traffic quality.

However, advertising spend and acquisition costs are not available, so campaign ROI and ROAS cannot be determined from this dataset.

### 6.5 Device Conversion Performance

| Device Type | Sessions | Converted Sessions | Conversion Rate |
|---|---:|---:|---:|
| Desktop | 327,027 | 27,805 | 8.50% |
| Mobile | 145,844 | 4,508 | 3.09% |

**Key Finding**

Desktop conversion performance is approximately 2.75 times higher than mobile conversion performance.

**Business Interpretation**

The conversion gap between desktop and mobile suggests an opportunity to investigate the mobile shopping experience.

Potential areas for further investigation include:

- Mobile website loading speed.
- Navigation and product discovery.
- Checkout usability.
- Mobile payment experience.

The current dataset identifies the conversion difference but does not establish its underlying cause.

### 6.6 Monthly Sales & Year-over-Year Trends

**Key Findings**

- Monthly revenue increased across all 12 calendar months when comparing 2014 with 2013.
- Monthly order volume also increased across all 12 calendar months in the same comparison.
- December 2014 recorded the highest monthly revenue at $144,823.02.
- December 2014 also recorded 2,314 orders.
- March 2015 is an incomplete month because the latest recorded order date is 19 March 2015.

**Business Interpretation**

The increase in both revenue and order volume indicates that the business experienced substantial growth between 2013 and 2014.

The higher revenue was supported by increased order volume, rather than relying solely on changes in average order value.

November and December also recorded relatively strong sales activity. However, recurring monthly patterns alone are insufficient to establish seasonality.

### 6.7 Product Revenue Trends

**Key Findings**

- The Original Mr. Fuzzy was the only product with recorded sales during the initial period in 2012.
- The Forever Love Bear first appeared in recorded sales in January 2013.
- The Birthday Sugar Panda first appeared in recorded sales in December 2013.
- The Hudson River Mini bear first appeared in recorded sales in February 2014.
- By 2014, all four products were contributing to monthly revenue.

**Business Interpretation**

The product portfolio expanded over the observed period, while The Original Mr. Fuzzy continued to contribute the largest share of revenue.

This highlights the importance of monitoring both the growth of newer products and the continued performance of established products.

*First observed sales do not necessarily represent official product launch dates.*

### 6.8 Refund Performance

**Overall Refund Performance**

| Metric | Result |
|---|---:|
| Total Refund Records | 1,731 |
| Refunded Orders | 1,723 |
| Total Refund Amount | $85,338.69 |
| Refund Percentage of Gross Revenue | 4.40% |
| Estimated Revenue After Refunds | $1,853,171.06 |

**Product-Level Refund Performance**

| Product | Refund Records | Refund Amount | Refund-to-Revenue Ratio |
|---|---:|---:|---:|
| The Original Mr. Fuzzy | 1,237 | $61,837.63 | 5.11% |
| The Birthday Sugar Panda | 301 | $13,842.99 | 6.04% |
| The Forever Love Bear | 129 | $7,738.71 | 2.23% |
| The Hudson River Mini bear | 64 | $1,919.36 | 1.28% |

**Key Findings**

- Total recorded refunds amounted to $85,338.69.
- Refunds represented 4.40% of gross order revenue.
- The Original Mr. Fuzzy recorded the highest refund amount.
- The Birthday Sugar Panda recorded the highest refund-to-revenue ratio at 6.04%.
- The Hudson River Mini bear recorded the lowest ratio at 1.28%.

**Business Interpretation**

Although The Original Mr. Fuzzy generated the highest refund amount, this should be considered alongside its significantly larger revenue contribution.

The Birthday Sugar Panda has the highest refund-to-revenue ratio, making it a potential candidate for further investigation.

Refund reasons are not included in the dataset, so no specific cause can be established.

## 7. Business Recommendations

Based on the observed findings, the following areas deserve further business investigation.

| Area | Recommendation | Business Purpose |
|---|---|---|
| Customer Retention | Explore post-purchase engagement and re-engagement campaigns | Encourage repeat purchases |
| Mobile Conversion | Investigate mobile website and checkout usability | Identify possible conversion barriers |
| Acquisition Marketing | Review traffic quality and campaign performance by source | Improve acquisition efficiency |
| Product Strategy | Monitor revenue contribution and gross profit margin together | Support product-level decisions |
| Refund Management | Investigate refund reasons, particularly for products with higher refund ratios | Identify potential product or service issues |
| Sales Monitoring | Track monthly revenue and order growth | Monitor business performance over time |

These recommendations are areas for further investigation, not confirmed solutions to the observed performance differences.

## 8. Data Limitations & Assumptions

Several limitations were identified during the profiling and analysis process.

1. **No explicit order-item quantity field:** The dataset does not provide a separate quantity column at the order-item level. `items_purchased` is an order-level field and should not automatically be treated as verified product-level physical units.
2. **No customer demographics:** Age, gender, and other demographic attributes are unavailable.
3. **No payment method or discount information:** Payment preferences and discount effectiveness cannot be evaluated.
4. **No inventory information:** Stock levels, availability, and inventory turnover cannot be analyzed.
5. **Incomplete acquisition attribution:** NULL `utm_source` values are retained as Unknown / NULL and are not automatically classified as Direct Traffic.
6. **No advertising cost data:** ROI, ROAS, and acquisition cost cannot be calculated.
7. **No refund reasons:** The analysis identifies refund amounts and ratios but cannot establish why refunds occurred.
8. **Incomplete March 2015 data:** March 2015 must be treated as a partial month in monthly comparisons.

## 9. Project Structure

```text
Maven Fuzzy Factory/
│
├── data/
│   ├── raw/
│   └── processed/
│
├── sql/
│   ├── 01_maven_fuzzy_factory_full_setup.sql
│   ├── 02_data_profiling.sql
│   ├── 03_data_quality_checks.sql
│   ├── 04_relationship_validation.sql
│   └── 05_business_analysis.sql
│
├── reports/
│
├── README.md
└── LICENSE
```

## 10. Skills Demonstrated

**SQL & Database Analysis**
- MySQL
- SELECT, WHERE, GROUP BY, ORDER BY
- Aggregate functions
- INNER JOIN and LEFT JOIN
- Subqueries and Common Table Expressions (CTEs)
- CASE statements and conditional aggregation
- NULLIF and COALESCE
- Date and time functions
- DISTINCT counting
- Data profiling and validation

**Data Analytics**
- Data quality assessment
- Logical relationship validation
- Revenue and profitability analysis
- Customer purchase behavior analysis
- Acquisition and conversion analysis
- Monthly and year-over-year trend analysis
- Refund analysis
- Business interpretation and recommendations

**Business Intelligence**
- KPI identification
- Business question formulation
- Analytical reporting
- Dashboard planning
- Translating SQL outputs into business insights

## 11. Conclusion

This project demonstrates an end-to-end SQL-based analytical workflow, beginning with database exploration and data validation before progressing into business performance analysis.

The findings highlight several important areas:

- The Original Mr. Fuzzy is the primary revenue contributor.
- Customer purchases are heavily concentrated among one-time customers.
- Desktop sessions convert at a substantially higher rate than mobile sessions.
- Revenue and order volume increased across all calendar months in 2014 compared with 2013.
- Product-level refund ratios vary, highlighting opportunities for further investigation.

Beyond writing SQL queries, the project emphasizes understanding data structure, validating relationships, selecting appropriate analytical grains, avoiding duplicated aggregations, and interpreting results in a business context.

The overall goal is to demonstrate how SQL can transform operational data into actionable business insights.

---

**Project Status:** SQL Business Analysis Completed

**Author:** Abdullah Nasir#   m a v e n - f u z z y - f a c t o r y 
 
 