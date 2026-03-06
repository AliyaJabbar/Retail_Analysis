-- We use 2011-12-31 as our analysis date
DECLARE @analysis_date DATE = '2011-12-31';

WITH rfm_base AS (
    SELECT
        customer_id,
        MAX(invoice_date)                        AS last_purchase_date,
        COUNT(DISTINCT invoice_id)               AS frequency,
        ROUND(SUM(revenue), 2)                   AS monetary,
        DATEDIFF(DAY, MAX(invoice_date), 
                 @analysis_date)                 AS recency_days
    FROM silver_transactions
    GROUP BY customer_id
),

-- Step 2 — Score each dimension 1-5 using NTILE
rfm_scored AS (
    SELECT *,
        NTILE(5) OVER (ORDER BY recency_days ASC)  AS r_score,
        NTILE(5) OVER (ORDER BY frequency DESC)    AS f_score,
        NTILE(5) OVER (ORDER BY monetary DESC)     AS m_score
    FROM rfm_base
),

-- Step 3 — Assign business segment labels
rfm_segmented AS (
    SELECT *,
        CONCAT(r_score, f_score, m_score) AS rfm_code,
        r_score + f_score + m_score       AS rfm_total_score,
        CASE
            WHEN r_score >= 4 AND f_score >= 4                   THEN 'Champions'
            WHEN r_score >= 3 AND f_score >= 3                   THEN 'Loyal Customers'
            WHEN r_score >= 4 AND f_score <= 2                   THEN 'New Customers'
            WHEN r_score = 3  AND f_score <= 3                   THEN 'Potential Loyalists'
            WHEN r_score <= 2 AND f_score >= 4                   THEN 'At Risk'
            WHEN r_score <= 2 AND f_score BETWEEN 2 AND 3        THEN 'Need Attention'
            WHEN r_score = 1  AND f_score <= 2                   THEN 'Lost Customers'
            ELSE                                                       'Others'
        END AS segment
    FROM rfm_scored
)
SELECT * INTO gold_rfm FROM rfm_segmented;

-- Verify segments
SELECT segment, COUNT(*) AS customers,
       ROUND(AVG(monetary),2) AS avg_revenue
FROM gold_rfm
GROUP BY segment
ORDER BY avg_revenue DESC;
