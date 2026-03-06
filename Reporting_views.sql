-- VIEW 1: Monthly Revenue Trend
CREATE VIEW vw_monthly_trend AS
SELECT
    FORMAT(invoice_date, 'yyyy-MM')      AS year_month,
    YEAR(invoice_date)                   AS yr,
    MONTH(invoice_date)                  AS mn,
    COUNT(DISTINCT invoice_id)           AS total_orders,
    COUNT(DISTINCT customer_id)          AS active_customers,
    ROUND(SUM(revenue), 2)              AS monthly_revenue,
    ROUND(AVG(revenue), 2)              AS avg_order_value
FROM silver_transactions
GROUP BY FORMAT(invoice_date, 'yyyy-MM'),
         YEAR(invoice_date),
         MONTH(invoice_date);
GO

-- VIEW 2: Segment Performance
CREATE VIEW vw_segment_performance AS
SELECT
    r.segment,
    COUNT(DISTINCT r.customer_id)        AS customer_count,
    ROUND(SUM(s.revenue), 2)            AS total_revenue,
    ROUND(AVG(s.revenue), 2)            AS avg_order_value,
    COUNT(DISTINCT s.invoice_id)         AS total_orders,
    ROUND(AVG(r.recency_days), 0)       AS avg_recency_days
FROM gold_rfm r
JOIN silver_transactions s 
    ON r.customer_id = s.customer_id
GROUP BY r.segment;
GO

-- VIEW 3: Product Performance
CREATE VIEW vw_product_performance AS
SELECT
    stock_code,
    description,
    COUNT(DISTINCT invoice_id)           AS times_ordered,
    SUM(quantity)                        AS total_units_sold,
    ROUND(SUM(revenue), 2)              AS total_revenue,
    ROUND(AVG(unit_price), 2)           AS avg_price,
    COUNT(DISTINCT customer_id)          AS unique_customers
FROM silver_transactions
GROUP BY stock_code, description;
GO

-- VIEW 4: Country Revenue
CREATE VIEW vw_country_performance AS
SELECT
    country,
    COUNT(DISTINCT customer_id)          AS customers,
    COUNT(DISTINCT invoice_id)           AS orders,
    ROUND(SUM(revenue), 2)              AS total_revenue
FROM silver_transactions
GROUP BY country;
GO



