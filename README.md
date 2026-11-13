# Maven Fuzzy Factory — E-Commerce Diagnostic Analytics

**Author:** Abdullah Nasir  
**Database:** `maven_fuzzy_factory`  
**Tools:** MySQL Workbench, SQL, Power BI  
**Project Type:** E-Commerce Business Intelligence & Diagnostic Data Analytics

## 1. Project Overview

This project investigates the business performance of Maven Fuzzy Factory, an e-commerce business, using transactional and website activity data.

The primary objective is to move beyond reporting business performance metrics and investigate the factors and patterns associated with observed business outcomes.

Using SQL, I performed data profiling, data quality assessment, relationship validation, and diagnostic business analysis across six operational tables.

The analysis investigates:

- Sales and gross profitability performance.
- Product revenue contribution and profitability differences.
- Customer purchasing frequency and retention patterns.
- Acquisition source and device-level conversion differences.
- Monthly revenue and order growth patterns.
- Product-level refund exposure and revenue impact.

The project emphasizes identifying performance gaps, comparing business segments, investigating possible contributing factors, and translating analytical findings into business recommendations.

**Analytical Approach:** Descriptive Analytics foundation followed by Diagnostic Analytics.

## 2. Business Objectives

The project investigates five major business areas.

### 2.1 Sales & Profitability

- Evaluate revenue, COGS, gross profit, gross profit margin, and average order value.
- Investigate the relationship between revenue contribution and product profitability.
- Identify products contributing most significantly to overall gross profit.

### 2.2 Product Performance

- Compare product revenue contributions.
- Investigate differences in gross profit margins.
- Examine product-level refund exposure.
- Identify products requiring further profitability and refund investigation.

### 2.3 Customer Behavior

- Compare one-time and repeat customer purchasing patterns.
- Evaluate customer revenue contributions.
- Investigate the extent of customer purchasing concentration.
- Identify potential customer retention opportunities.

### 2.4 Marketing & Conversion

- Compare acquisition source traffic and conversion rates.
- Investigate conversion differences between desktop and mobile sessions.
- Identify acquisition channels with relatively stronger or weaker conversion performance.
- Evaluate potential website optimization opportunities.

### 2.5 Business Trends & Refunds

- Compare monthly revenue and order growth between 2013 and 2014.
- Investigate product revenue development over time.
- Evaluate refund exposure against recorded revenue.
- Identify areas requiring additional operational investigation.

## 3. Dataset Overview

The project uses six operational tables and one data dictionary table.

| Table | Description |
|---|---|
| website_sessions | Website traffic, acquisition sources, users, and device information |
| website_pageviews | Pageview activity and session navigation |
| products | Product information and product creation dates |
| orders | Order transactions, customer identifiers, revenue, and COGS |
| order_items | Product-level order records and associated sales values |
| order_item_refunds | Refund transactions associated with order items |
| data_dictionary | Reference information describing dataset fields |

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

### Step 1 — Database Setup

- Created the project database.
- Imported the raw CSV datasets into MySQL.
- Reviewed table structures and available columns.
- Inspected the data dictionary.

### Step 2 — Data Profiling

Investigated:

- Table structures and column definitions.
- Record counts.
- Available date ranges.
- Selected-column NULL values.
- Sample records.
- Data dictionary definitions.

### Step 3 — Data Quality Checks

Performed SQL validation to investigate:

- Duplicate primary key records.
- Missing values in selected columns.
- Binary field distributions.
- Invalid or unexpected numerical values.
- Negative sales, cost, and refund amounts.
- Date consistency across related tables.

### Step 4 — Relationship Validation

Validated logical relationships between:

- Website sessions and pageviews.
- Website sessions and orders.
- Orders and order items.
- Products and order items.
- Orders, order items, and refunds.
- Primary product consistency between orders and order items.

All 16 relationship validation checks returned zero unmatched or inconsistent records.

**Note:** These checks validate logical relationships in the data. They do not mean physical foreign key constraints were created in the database.

### Step 5 — Business Analysis

Developed 16 SQL queries across seven analytical sections to investigate business performance and identify differences between business segments.

## 5. SQL Analysis Structure

The SQL analysis is organized into two analytical pages.

### Page 1 — Sales & Product Performance

| Section | Analysis | Diagnostic Focus |
|---|---|---|
| 1 | Overall Sales Performance | Establish the overall profitability baseline |
| 2 | Transaction-Level Sales Analysis | Examine individual order-item sales and profitability |
| 3 | Product Performance & Profitability | Investigate differences in revenue contribution and margins |
| 4 | Customer Purchase Performance | Investigate customer purchasing concentration and repeat behavior |

### Page 2 — Marketing & Business Trends

| Section | Analysis | Diagnostic Focus |
|---|---|---|
| 5 | Acquisition & Conversion Performance | Investigate conversion differences across acquisition sources and devices |
| 6 | Monthly Sales & YoY Trends | Examine monthly growth patterns and business performance changes |
| 7 | Refund & Revenue Impact | Investigate product-level refund exposure |

SQL file: `02_sql/05_business_analysis.sql`

## 6. Diagnostic Findings & Business Insights

The following findings are based on the available SQL analysis outputs.

Each section distinguishes between observed evidence, diagnostic interpretation, and areas requiring further investigation.

### 6.1 Overall Sales & Profitability Diagnosis

| Metric | Result |
|---|---:|
| Total Orders | 32,313 |
| Unique Customers | 31,696 |
| Total Revenue | $1,938,509.75 |
| Total COGS | $722,370.25 |
| Gross Profit | $1,216,139.50 |
| Gross Profit Margin | 62.74% |
| Average Order Value | $59.99 |

**Diagnostic Findings**

The business generated approximately $1.94 million in recorded revenue, with $1.22 million in gross profit.

The overall gross profit margin was 62.74%.

This establishes a profitability baseline for investigating differences between individual products and customer segments.

**Business Interpretation**

Overall profitability is positive at the gross profit level. However, the aggregate margin does not show whether profitability is evenly distributed across products.

The product-level analysis is therefore necessary to identify which products contribute most to gross profit and which achieve stronger margins.

**Diagnostic Direction**

Investigate product-level revenue, COGS, and gross profit contribution rather than relying exclusively on overall profitability.

### 6.2 Product Revenue & Profitability Diagnosis

| Product | Revenue | Revenue Contribution | Gross Profit Margin |
|---|---:|---:|---:|
| The Original Mr. Fuzzy | $1,211,057.74 | 62.47% | 61.01% |
| The Forever Love Bear | $347,702.04 | 17.94% | 62.51% |
| The Birthday Sugar Panda | $229,260.15 | 11.83% | 68.49% |
| The Hudson River Mini bear | $150,489.82 | 7.76% | 68.36% |

**Diagnostic Findings**

1. The Original Mr. Fuzzy generated 62.47% of total product revenue.
2. It also generated the highest absolute gross profit at $738,893.00.
3. Its gross profit margin of 61.01% was lower than the other three products.
4. The Birthday Sugar Panda achieved the highest gross profit margin at 68.49%.
5. The Hudson River Mini bear achieved a gross profit margin of 68.36%.

**Diagnostic Interpretation**

The Original Mr. Fuzzy dominates overall revenue and gross profit because of its significantly larger revenue contribution.

However, its gross profit margin is lower than the other products.

This indicates a difference between revenue scale and margin efficiency.

The Birthday Sugar Panda and Hudson River Mini bear demonstrate stronger gross profit margins despite contributing smaller revenue amounts.

**Potential Business Implications**

- The Original Mr. Fuzzy is important for maintaining overall revenue and gross profit.
- Higher-margin products may represent opportunities for further commercial evaluation.
- Product strategy should consider both absolute gross profit and gross profit margin.

The available data does not establish why product margins differ.

### 6.3 Customer Purchasing Behavior Diagnosis

| Customer Type | Customers | Revenue |
|---|---:|---:|
| One-Time Customer | 31,105 | $1,864,153.31 |
| Repeat Customer | 591 | $74,356.44 |

**Diagnostic Findings**

- Approximately 98.14% of customers made only one recorded purchase.
- Approximately 1.86% made more than one recorded purchase.
- One-time customers contributed approximately 96.16% of revenue.
- Repeat customers contributed approximately 3.84% of revenue.

**Diagnostic Interpretation**

The business demonstrates a strong concentration of revenue among customers who made only one recorded purchase.

This indicates that repeat purchasing contributes relatively little to overall recorded revenue.

The gap between one-time and repeat customers highlights customer retention as an area requiring further investigation.

However, the dataset does not explain why customers did not return.

Possible areas to investigate include:

- Time between first and subsequent purchases.
- Customer purchasing intervals.
- Product combinations among repeat customers.
- Customer re-engagement opportunities.

**Potential Business Implication**

Customer retention initiatives may provide an opportunity to increase repeat purchasing, but their effectiveness would need to be measured using additional customer-level analysis.

### 6.4 Acquisition Source Conversion Diagnosis

| Acquisition Source | Sessions | Converted Sessions | Conversion Rate |
|---|---:|---:|---:|
| Unknown / NULL | 83,328 | 6,118 | 7.34% |
| bsearch | 62,823 | 4,519 | 7.19% |
| gsearch | 316,035 | 21,333 | 6.75% |
| socialbook | 10,685 | 343 | 3.21% |

**Diagnostic Findings**

- gsearch generated the highest traffic volume.
- gsearch also generated the highest number of converted sessions.
- bsearch achieved a higher conversion rate than gsearch.
- Unknown / NULL recorded the highest observed conversion rate, but attribution is incomplete.
- socialbook recorded the lowest conversion rate at 3.21%.

**Diagnostic Interpretation**

Traffic volume and conversion efficiency show different patterns.

Although gsearch generates the largest number of sessions and conversions, its conversion rate is lower than bsearch.

This indicates that the largest traffic acquisition source is not necessarily the most efficient based on conversion rate alone.

The socialbook conversion rate is substantially lower than the other identified acquisition sources.

This creates a diagnostic question around traffic quality, audience relevance, and landing page performance.

However, the available data does not establish which factor explains the conversion differences.

**Potential Business Implications**

- Investigate why bsearch converts at a higher rate than gsearch.
- Review socialbook traffic quality and landing page relevance.
- Improve acquisition attribution for Unknown / NULL sessions.
- Evaluate acquisition efficiency using advertising cost data if available.

Campaign ROI and ROAS cannot be determined without advertising expenditure data.

### 6.5 Device Conversion Diagnosis

| Device Type | Sessions | Converted Sessions | Conversion Rate |
|---|---:|---:|---:|
| Desktop | 327,027 | 27,805 | 8.50% |
| Mobile | 145,844 | 4,508 | 3.09% |

**Diagnostic Findings**

Desktop conversion performance is approximately 2.75 times higher than mobile conversion performance.

The conversion rate difference is approximately 5.41 percentage points.

**Diagnostic Interpretation**

The difference indicates that mobile sessions convert at a substantially lower rate than desktop sessions.

This is an important performance gap because mobile represents a meaningful portion of total website traffic.

The difference warrants further investigation into the mobile customer journey.

Potential diagnostic areas include:

- Pageview navigation and exit patterns.
- Product page engagement.
- Progression from product pages to cart.
- Checkout progression.
- Differences in session behavior between devices.

**Potential Business Implications**

Investigate mobile shopping and checkout usability before implementing website changes.

The current dataset identifies the conversion gap but does not establish its underlying cause.

### 6.6 Monthly Sales & Year-over-Year Growth Diagnosis

**Diagnostic Findings**

- Monthly revenue increased across all 12 calendar months in 2014 compared with 2013.
- Monthly order volume also increased across all 12 calendar months.
- December 2014 recorded the highest monthly revenue at $144,823.02.
- December 2014 recorded 2,314 orders.
- March 2015 is an incomplete month because the latest recorded order date is 19 March 2015.

**Diagnostic Interpretation**

Revenue and order volume increased together across all calendar months when comparing 2013 with 2014.

This suggests that the observed revenue growth was supported by increased order activity rather than relying exclusively on changes in average order value.

December 2014 recorded the highest monthly revenue and order volume among the reported findings.

However, monthly performance alone cannot determine whether growth was driven by increased website traffic, improved conversion, changes in product mix, or other commercial factors.

**Potential Business Implications**

Further investigate:

- Monthly website session growth.
- Monthly session conversion rates.
- Monthly average order value.
- Product-level revenue contribution over time.

These comparisons would help distinguish traffic-driven growth from conversion-driven or transaction-value-driven growth.

### 6.7 Product Revenue Development Diagnosis

**Diagnostic Findings**

- The Original Mr. Fuzzy was the only product with recorded sales during the initial period in 2012.
- The Forever Love Bear first appeared in recorded sales in January 2013.
- The Birthday Sugar Panda first appeared in recorded sales in December 2013.
- The Hudson River Mini bear first appeared in recorded sales in February 2014.
- By 2014, all four products contributed to monthly revenue.

**Diagnostic Interpretation**

The business expanded its recorded product sales portfolio over the observed period.

The Original Mr. Fuzzy remained the dominant revenue contributor, while newer products contributed additional revenue streams.

This suggests that the business developed a broader product portfolio without displacing its original main revenue contributor.

However, the available analysis does not establish whether newer products increased total demand or shifted purchases away from existing products.

First observed sales do not necessarily represent official product launch dates.

**Potential Business Implications**

Monitor product revenue contribution over time to understand whether newer products are developing sustainable sales performance.

### 6.8 Refund & Revenue Impact Diagnosis

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

**Diagnostic Findings**

- Recorded refunds totalled $85,338.69.
- Refunds represented 4.40% of gross order revenue.
- The Original Mr. Fuzzy recorded the highest refund amount.
- The Birthday Sugar Panda recorded the highest refund-to-revenue ratio at 6.04%.
- The Hudson River Mini bear recorded the lowest ratio at 1.28%.

**Diagnostic Interpretation**

The Original Mr. Fuzzy generated the highest absolute refund amount, but it also represents the largest share of product revenue.

The Birthday Sugar Panda presents a different pattern: it has the highest refund-to-revenue ratio despite contributing a smaller share of total revenue.

This indicates that refund exposure should be evaluated relative to product revenue rather than by refund amount alone.

The Birthday Sugar Panda therefore represents a potential priority for further investigation.

**Potential Business Implications**

- Investigate refund reasons by product.
- Compare refunded and non-refunded order-item characteristics.
- Examine refund timing.
- Evaluate whether refund patterns are concentrated within specific periods.

Refund reasons are not included in the dataset, so no specific cause can be established.

## 7. Cross-Analysis: Connecting Business Findings

This section connects findings across different analytical areas to provide a broader diagnostic perspective.

| Observed Pattern | Related Findings | Diagnostic Implication |
|---|---|---|
| Revenue concentration | Original Mr. Fuzzy contributes 62.47% of revenue | Overall performance depends heavily on one product |
| Margin differences | Original Mr. Fuzzy has a 61.01% margin versus 68.49% for Birthday Sugar Panda | Revenue leadership does not necessarily mean margin leadership |
| Customer concentration | 98.14% of customers are one-time purchasers | Repeat purchasing represents a potential retention opportunity |
| Acquisition efficiency gap | bsearch converts at 7.19% versus gsearch at 6.75% | Traffic volume and conversion efficiency should be evaluated separately |
| Device conversion gap | Desktop converts at 8.50% versus mobile at 3.09% | Mobile customer journey requires further investigation |
| Refund exposure | Birthday Sugar Panda has the highest refund ratio at 6.04% | Product-level refund performance deserves additional investigation |
| Business growth | All 12 months of 2014 exceeded corresponding 2013 months in revenue and orders | Further investigation should identify the drivers of growth |

### Overall Diagnostic Assessment

The available findings reveal several important performance patterns:

1. **Product dependency:** A substantial proportion of revenue comes from The Original Mr. Fuzzy.
2. **Profitability differences:** Products with lower revenue contributions can achieve stronger gross profit margins.
3. **Customer retention gap:** Most recorded customers made only one purchase.
4. **Acquisition efficiency differences:** Acquisition sources generate different conversion rates despite differences in traffic volume.
5. **Mobile conversion gap:** Mobile sessions convert substantially less frequently than desktop sessions.
6. **Refund exposure differences:** Product-level refund ratios vary considerably.
7. **Business growth:** Revenue and order volume increased across all calendar months in 2014 compared with 2013.

These patterns identify where business performance differs and where additional investigation may provide value.

They do not independently establish causal relationships.

## 8. Business Recommendations

Based on the diagnostic findings, the following actions are recommended for further investigation.

| Area | Recommended Investigation | Business Purpose |
|---|---|---|
| Product Dependency | Evaluate the revenue and gross profit contribution of the main product | Understand concentration risk |
| Product Profitability | Compare pricing, COGS, and margins across products | Identify profitability improvement opportunities |
| Customer Retention | Investigate purchase intervals and repeat customer behavior | Understand retention opportunities |
| Mobile Conversion | Examine mobile page navigation and checkout progression | Identify potential conversion barriers |
| Acquisition Marketing | Compare conversion performance with campaign expenditure | Evaluate acquisition efficiency |
| Refund Management | Investigate refund reasons and product-level patterns | Identify possible operational or product issues |
| Business Growth | Compare traffic, conversion, AOV, and order growth | Understand the drivers of revenue growth |

These recommendations are investigation priorities rather than confirmed solutions.

## 9. Data Limitations & Assumptions

The following limitations affect the scope of diagnostic conclusions.

- **No explicit order-item quantity field:** The dataset does not provide a separate quantity column at the order-item level. `items_purchased` is an order-level field and should not automatically be treated as verified product-level physical units.
- **No customer demographics:** Age, gender, and other demographic attributes are unavailable.
- **No payment method or discount information:** Payment preferences and discount effectiveness cannot be evaluated.
- **No inventory information:** Stock levels, availability, and inventory turnover cannot be analyzed.
- **Incomplete acquisition attribution:** NULL `utm_source` values are retained as Unknown / NULL and are not automatically classified as Direct Traffic.
- **No advertising cost data:** ROI, ROAS, and acquisition cost cannot be calculated.
- **No refund reasons:** Refund amounts and ratios can be evaluated, but the reasons behind refunds cannot be established.
- **Incomplete March 2015 data:** March 2015 must be treated as a partial month in monthly comparisons.
- **No causal evidence:** Observed relationships and performance differences do not independently prove the reasons behind business outcomes.

Diagnostic findings should therefore be interpreted as evidence-based observations and investigation opportunities rather than definitive explanations of causation.

## 10. Project Structure

```text
Second Project/
│
├── 01_data/
│   └── raw/
│       └── Maven+Fuzzy+Factory/
│           ├── maven_fuzzy_factory_data_dictionary.csv
│           ├── order_item_refunds.csv
│           ├── order_items.csv
│           ├── orders.csv
│           ├── products.csv
│           ├── website_pageviews.csv
│           └── website_sessions.csv
│
├── 02_sql/
│   ├── 01_maven_fuzzy_factory_full_setup.sql
│   ├── 02_data_profiling.sql
│   ├── 03_data_quality_checks.sql
│   ├── 04_relationship_validation.sql
│   └── 05_business_analysis.sql
│
├── 03_python/
│
├── 04_dashboard/
│
├── .gitignore
└── README.md
```

Note: Raw CSV datasets are maintained locally and excluded from Git tracking through `.gitignore`.

## 11. Skills Demonstrated

### SQL & Database Analysis

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
- Logical relationship validation

### Diagnostic Data Analytics

- Revenue and profitability investigation
- Product contribution and margin comparison
- Customer purchasing concentration analysis
- Acquisition source conversion comparison
- Device-level conversion analysis
- Monthly and year-over-year performance comparison
- Product revenue development analysis
- Refund exposure investigation
- Cross-analysis of business performance patterns
- Evidence-based business interpretation

### Business Intelligence

- KPI identification
- Business question formulation
- Analytical reporting
- Dashboard planning
- Business performance monitoring
- Translating SQL outputs into business insights
- Developing investigation-oriented business recommendations

## 12. Conclusion

This project demonstrates an end-to-end SQL-based analytical workflow, progressing from database exploration and data validation to business performance investigation.

Rather than focusing exclusively on what happened, the diagnostic analysis investigates differences between products, customer segments, acquisition sources, devices, and business periods.

The findings highlight several important areas:

- Revenue is heavily concentrated in The Original Mr. Fuzzy.
- Higher-margin products do not necessarily generate the highest revenue.
- The customer base is heavily concentrated around one-time purchases.
- Acquisition sources demonstrate different conversion performance.
- Desktop sessions convert substantially better than mobile sessions.
- Revenue and order volume increased across all calendar months in 2014 compared with 2013.
- Product-level refund exposure varies, with the Birthday Sugar Panda recording the highest refund-to-revenue ratio.

The project also emphasizes the importance of validating data relationships, selecting appropriate analytical grains, avoiding duplicated aggregations, and recognizing the limitations of available information.

The overall objective is to demonstrate how SQL can be used not only to report business performance but also to investigate performance gaps, identify contributing patterns, and support evidence-based business decisions.

**Project Status: SQL-Based Diagnostic Analysis Completed**

**Author:** Abdullah Nasir