WITH clv_base AS (
    SELECT
        customer_id,
        COUNT(DISTINCT invoice_id)                        AS total_orders,
        ROUND(SUM(revenue), 2)                            AS total_revenue,
        ROUND(AVG(revenue), 2)                            AS avg_order_value,
        MIN(invoice_date)                                 AS first_purchase,
        MAX(invoice_date)                                 AS last_purchase,
        DATEDIFF(MONTH,
            MIN(invoice_date),
            MAX(invoice_date)) + 1                        AS active_months
    FROM silver_transactions
    GROUP BY customer_id
),
clv_calculated AS (
    SELECT *,
        -- Purchase frequency per month
        ROUND(CAST(total_orders AS FLOAT) / 
              NULLIF(active_months, 0), 2)                AS monthly_purchase_freq,

        -- Average Order Value × Monthly Frequency × 12
        ROUND(
            avg_order_value *
            (CAST(total_orders AS FLOAT) / NULLIF(active_months,0)) * 12
        , 2)                                              AS predicted_annual_clv
    FROM clv_base
)
SELECT *,
    CASE
        WHEN predicted_annual_clv >= 5000 THEN 'Platinum'
        WHEN predicted_annual_clv >= 2000 THEN 'Gold'
        WHEN predicted_annual_clv >= 500  THEN 'Silver'
        ELSE                                   'Bronze'
    END AS clv_tier
INTO gold_clv
FROM clv_calculated;

-- Quick check
SELECT clv_tier,
       COUNT(*)                             AS customers,
       ROUND(AVG(predicted_annual_clv), 2) AS avg_clv,
       ROUND(SUM(total_revenue), 2)        AS total_revenue
FROM gold_clv
GROUP BY clv_tier
ORDER BY avg_clv DESC;
