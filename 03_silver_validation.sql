```sql
-- 1. Validate Silver data quality
SELECT
    COUNT(*) AS total_rows,
    SUM(CASE WHEN customer_id IS NULL THEN 1 ELSE 0 END)
        AS missing_customer_ids,
    SUM(CASE WHEN invoice_id LIKE 'C%' THEN 1 ELSE 0 END)
        AS cancellation_rows,
    SUM(CASE WHEN quantity <= 0 THEN 1 ELSE 0 END)
        AS non_positive_quantity_rows,
    SUM(CASE WHEN unit_price <= 0 THEN 1 ELSE 0 END)
        AS non_positive_prices,
    SUM(CASE WHEN stock_code IS NULL THEN 1 ELSE 0 END)
        AS missing_stock_codes
FROM dbo.silver_transactions;


-- 2. Compare Bronze and Silver row counts
SELECT
    'Bronze' AS data_layer,
    COUNT(*) AS total_rows
FROM dbo.online_retail_II

UNION ALL

SELECT
    'Silver' AS data_layer,
    COUNT(*) AS total_rows
FROM dbo.silver_transactions;


-- 3. Validate key counts in Silver
SELECT
    COUNT(*) AS total_rows,
    COUNT(DISTINCT invoice_id) AS unique_invoices,
    COUNT(DISTINCT customer_id) AS unique_customers,
    COUNT(DISTINCT stock_code) AS unique_products
FROM dbo.silver_transactions;
```
