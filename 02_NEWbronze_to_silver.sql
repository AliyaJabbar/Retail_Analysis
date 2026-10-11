```sql
-- Bronze to Silver transformation

SELECT
    CAST(Invoice AS VARCHAR(20)) AS invoice_id,
    CAST(StockCode AS VARCHAR(20)) AS stock_code,
    TRIM(Description) AS description,
    CAST(Quantity AS INT) AS quantity,
    CAST(InvoiceDate AS DATETIME) AS invoice_date,
    CAST(Price AS DECIMAL(10,2)) AS unit_price,
    CAST(Customer_ID AS VARCHAR(20)) AS customer_id,
    TRIM(Country) AS country,
    CAST(Quantity * Price AS DECIMAL(10,2)) AS revenue
INTO dbo.silver_transactions
FROM dbo.online_retail_II
WHERE
    Customer_ID IS NOT NULL
    AND Quantity > 0
    AND Price > 0
    AND Invoice NOT LIKE 'C%'
    AND StockCode IS NOT NULL
    AND StockCode NOT IN (
        'POST', 'DOT', 'M', 'BANK CHARGES',
        'PADS', 'S', 'AMAZONFEE', 'CRUK'
    );


-- Add date-related columns
ALTER TABLE dbo.silver_transactions
ADD
    invoice_year AS YEAR(invoice_date),
    invoice_month AS MONTH(invoice_date),
    invoice_day AS DAY(invoice_date),
    day_of_week AS DATENAME(WEEKDAY, invoice_date);
```
