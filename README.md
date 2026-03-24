# 🛒 Retail Customer Analytics
### ETL Pipeline · RFM Segmentation · CLV Analysis · Power BI Dashboard

![SQL Server](https://img.shields.io/badge/SQL%20Server-2022-red?style=flat-square&logo=microsoftsqlserver)
![Power BI](https://img.shields.io/badge/Power%20BI-Desktop-yellow?style=flat-square&logo=powerbi)
![Dataset](https://img.shields.io/badge/Dataset-1M%2B%20Rows-blue?style=flat-square)
![Status](https://img.shields.io/badge/Status-Complete-green?style=flat-square)

---
![page1](https://github.com/AliyaJabbar/Retail_Analysis/blob/main/dashboard/page1.PNG)
![2](https://github.com/AliyaJabbar/Retail_Analysis/blob/main/dashboard/page2.PNG)
![clv](https://github.com/AliyaJabbar/Retail_Analysis/blob/main/dashboard/page3.PNG)
![product intelligence](https://github.com/AliyaJabbar/Retail_Analysis/blob/main/dashboard/page4.PNG)

## 📌 Project Overview

This is an end-to-end retail analytics solution built on **1 million real transactions** from a UK-based online retailer. The goal was to answer three critical business questions:

- 🔍 **Who are our most valuable customers?**
- 💰 **What is each customer worth long term?**
- 📦 **Which products are driving real revenue?**

The solution covers the full analytics pipeline — from raw messy data to business-ready Power BI dashboards.

---

## 🏗️ Project Architecture

```
Raw Data (CSV)
     │
     ▼
┌─────────────┐
│   BRONZE    │  Raw extraction → raw_transactions (1M rows)
└─────────────┘
     │
     ▼
┌─────────────┐
│   SILVER    │  Cleaning + Transformation → silver_transactions (802,937 rows)
└─────────────┘
     │
     ▼
┌─────────────┐
│    GOLD     │  Business Analytics → gold_rfm + gold_clv
└─────────────┘
     │
     ▼
┌─────────────┐
│  REPORTING  │  4 Power BI Dashboard Pages
└─────────────┘
```

---

## 📊 Dataset

| Property | Detail |
|---|---|
| **Source** | UCI Online Retail II Dataset (Kaggle) |
| **Size** | ~1 Million transactions |
| **Period** | December 2009 — December 2011 |
| **Columns** | Invoice, StockCode, Description, Quantity, InvoiceDate, Price, CustomerID, Country |
| **Geography** | UK-based retailer, 40+ countries |

---

## 🔧 Tech Stack

| Tool | Purpose |
|---|---|
| **SQL Server 2022** | Data ingestion, cleaning, transformation, analytics |
| **SSMS** | Query execution and database management |
| **Power BI Desktop** | Interactive dashboards and DAX measures |
| **GitHub** | Version control and portfolio hosting |

---

## 📁 Repository Structure

```
retail-customer-analytics/
│
├── README.md
│
├── sql/
│   ├── 01_setup.sql                → Database creation + data import
│   ├── 02_bronze_to_silver.sql     → Data cleaning + Silver layer
│   ├── 03_rfm_gold.sql             → RFM segmentation model
│   ├── 04_clv_gold.sql             → Customer Lifetime Value
│   └── 05_reporting_views.sql      → Power BI reporting views
│
└── dashboard/
    └── screenshots/
        ├── page1_sales_overview.png
        ├── page2_customer_segments.png
        ├── page3_clv_analysis.png
        └── page4_product_intelligence.png
```

---

## 🧹 Data Cleaning (Bronze → Silver)

Starting with 1,000,000+ raw records, the following cleaning steps were applied:

| Issue | Action | Rows Removed |
|---|---|---|
| Null CustomerID | Removed anonymous transactions | ~135,000 |
| Negative Quantity | Removed returned orders | ~10,000 |
| Cancelled Invoices (C prefix) | Removed cancellations | ~9,000 |
| Zero/Negative Price | Removed bad pricing records | ~2,000 |
| Junk StockCodes | Removed non-product codes (POST, DOT, M etc.) | ~41,000 |
| **Total Removed** | | **~197,000 rows (19.7%)** |
| **Clean Records** | | **802,937 rows** |

---

## 👥 RFM Customer Segmentation

RFM (Recency, Frequency, Monetary) analysis was performed using **SQL CTEs and NTILE Window Functions** to score and classify 5,862 customers into 8 behavioral segments.

### Scoring Logic
```sql
NTILE(5) OVER (ORDER BY recency_days DESC) AS r_score  -- Low days = recent = high score
NTILE(5) OVER (ORDER BY frequency ASC)    AS f_score  -- High frequency = high score
NTILE(5) OVER (ORDER BY monetary ASC)     AS m_score  -- High spend = high score
```

### Segment Results

| Segment | Customers | Total Revenue | Avg Recency (Days) |
|---|---|---|---|
| **Champions** | 1,455 | £12,065,042 | 41 |
| **Loyal Customers** | 1,293 | £2,557,587 | 98 |
| **Need Attention** | 796 | £1,338,467 | 324 |
| **Others** | 1,145 | £562,278 | 504 |
| **New Customers** | 389 | £362,748 | 48 |
| **At Risk** | 85 | £249,769 | 503 |
| **Potential Loyalists** | 379 | £194,496 | 124 |
| **Lost Customers** | 320 | £121,763 | 536 |

### 🔑 Key Finding
> Champions represent only **26% of customers** but drive **69% of total revenue (£12.1M)**

---

## 💰 Customer Lifetime Value (CLV)

Predicted Annual CLV was calculated for every customer using:

```
Predicted Annual CLV = Avg Order Value × Monthly Purchase Frequency × 12
```

### CLV Tier Distribution

| Tier | Customers | Total Revenue | Avg Predicted CLV |
|---|---|---|---|
| **Platinum** | 53 | £3.5M | Highest |
| **Gold** | — | £1.5M | High |
| **Silver** | — | £2.7M | Medium |
| **Bronze** | Majority | £9.7M | Low |

> Only **53 Platinum customers** contribute **20% of predicted annual revenue**

---

## 📈 Power BI Dashboard — 4 Pages

### Page 1 — Sales Overview
- Total Revenue: **£17.45M**
- Total Orders: **37K**
- Avg Order Value: **£557**
- Total Customers: **5,862**
- Monthly revenue trend (2009–2011)
- Revenue by country — UK dominates at 84%

### Page 2 — Customer Segments
- Customer count by RFM segment (Donut chart)
- Revenue by segment (Bar chart)
- Avg order value by segment
- Segment detail table
- Monetary vs Recency scatter plot

### Page 3 — CLV Analysis
- Avg CLV, Total Predicted Revenue cards
- CLV tier distribution
- Top 10 customers by revenue
- Orders vs CLV scatter plot

### Page 4 — Product Intelligence
- 9M units sold across 4,626 unique products
- Top 10 products by revenue
- Revenue by country (Treemap)
- Units sold vs revenue scatter plot

---

## 💡 Key Business Insights

1. **Champions drive disproportionate value** — 26% of customers = 69% of revenue. Retention of this segment is the #1 business priority.

2. **Lost Customers are a win-back opportunity** — 320 customers with 530+ days inactivity. Targeted re-engagement campaigns could recover significant revenue.

3. **Reverse Pareto on products** — Revenue is healthily diversified across 4,626 products. Top 10 products contribute only 8% of revenue — low concentration risk.

4. **UK market dominance** — 84% of revenue from UK alone. Germany, France and Australia represent untapped international expansion opportunity.

5. **Platinum CLV tier is critical** — Only 53 customers but drive 20% of predicted annual revenue. Losing even 10 of these customers has significant financial impact.

---

## 🐛 Notable Debugging Challenge

During RFM scoring, the initial NTILE ORDER BY logic was reversed — causing top customers (£608K revenue, 145 purchases) to be misclassified as **Lost Customers**.

**Diagnosis:** Cross-checked NTILE scores against raw recency/frequency metrics and identified the ORDER BY direction was inverted.

**Fix:** Corrected ORDER BY to `recency_days DESC` for R score and `frequency ASC` for F score.

**Lesson:** Always validate model output against raw data before building dashboards on top of it.

---

## 🚀 How to Run This Project

1. Download UCI Online Retail II dataset from Kaggle
2. Open SSMS → Create database `RetailAnalytics`
3. Run SQL scripts in order: `01` → `02` → `03` → `04` → `05`
4. Open Power BI Desktop → Connect to SQL Server → localhost → RetailAnalytics
5. Import all gold tables and reporting views
6. Build dashboard or open existing `.pbix` file

---

## 📬 Connect With Me

If you found this project useful or have feedback, feel free to connect!


- 📧 Email: aliyajabbar49@gmail.com

**Open to Data Analyst opportunities in retail and e-commerce across India.**

---

*Dataset Source: UCI Machine Learning Repository — Online Retail II*
