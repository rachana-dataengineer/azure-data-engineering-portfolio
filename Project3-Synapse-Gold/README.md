# Project 3 — Synapse Analytics (Gold Layer)

## 🎯 Objective
Create business-ready gold layer reports using 
Azure Synapse Analytics Serverless SQL Pool. 
Query silver Parquet files directly using 
OPENROWSET and create 3 business views.

## 🏗️ Architecture
ADLS Gen2 Silver Container

(Cleaned Parquet files)

↓

Azure Synapse Analytics

(Serverless SQL Pool)

↓

Gold Layer — 3 Business Reports:

Total Sales by Territory
Employee Count by Department
Top 10 Products by Sales

↓

Physical Parquet files in gold/

(via CETAS — Create External Table As Select)

## 🛠️ Tools Used
- Azure Synapse Analytics
- Serverless SQL Pool (free tier)
- OPENROWSET
- CETAS (Create External Table As Select)
- ADLS Gen2
- Parquet file format

## 📋 What Was Built
- Synapse workspace (synapse-rachana-proj)
- gold_db database in Serverless SQL Pool
- Database scoped credential for storage access
- External data source pointing to ADLS
- External file format (Parquet)
- 3 virtual gold views
- 3 physical gold external tables (CETAS)

## 🔑 Key Concepts Learned
- Synapse Serverless vs Dedicated SQL Pool
- OPENROWSET — query files without importing
- Schema on read vs schema on write
- CETAS — write query results as Parquet files
- Database scoped credentials for storage access
- Medallion architecture gold layer patterns
- IAM role assignments (Managed Identity)

## ⚠️ Challenges Faced
- South India region does not support Synapse SQL
  → Resolved by using Central India region
- HNS disabled on original storage account
  → Created new HNS-enabled account (adlsrachanagen2ci)
- SQL admin credentials cannot access ADLS
  → Exported data as CSV and loaded to Power BI

## 📊 Results
```sql
-- Verification query results:
Report                  Rows
Sales by Territory      10
Employees by Dept       16
Top 10 Products         10
```
- 3 virtual gold views created in gold_db
- 3 physical Parquet files written to gold/ container
- Data accessible via Synapse SQL and Power BI

## 💰 Cost
- Serverless SQL Pool: $5 per TB scanned
- Actual cost for this project: < $0.01