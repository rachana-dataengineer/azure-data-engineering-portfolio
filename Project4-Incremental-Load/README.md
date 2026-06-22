# Project 4 — Incremental Load Pipeline

## 🎯 Objective
Replace full load pipeline with an incremental 
load pattern using watermark table. Copy only 
new or changed records since last pipeline run 
instead of copying all data every time.

## 🏗️ Architecture
SQL Server watermark_table

(last_loaded_time)

↓

ADF Lookup (read watermark)    ADF Lookup (read max date)

↓                              ↓

└──────────────┬───────────────┘

↓

ADF Copy (incremental rows only)

WHERE ModifiedDate > last_loaded_time

AND ModifiedDate <= max_date

↓

ADLS Bronze (new Parquet file)

↓

Stored Procedure (update watermark)

## 🛠️ Tools Used
- Azure Data Factory
- SQL Server (watermark table + stored procedure)
- Self-Hosted Integration Runtime
- ADLS Gen2
- Parquet file format

## 📋 What Was Built
- dbo.watermark_table in SQL Server
- dbo.usp_update_watermark stored procedure
- ADF pipeline: PL_Incremental_SalesOrderHeader
- 4 activities: LKP_GetWatermark, LKP_GetMaxDate,
  CPY_Incremental, SP_UpdateWatermark
- Schedule trigger: daily at 2AM IST

## 🔑 Key Concepts Learned
- Watermark pattern for incremental loads
- Difference between full load and incremental load
- ADF Lookup activity (firstRow vs value)
- Dynamic SQL expressions in ADF
- Stored procedure activity in ADF
- Schedule triggers in ADF
- @activity() and dynamic expressions

## ⚠️ Challenges Faced
- EXECUTE permission denied on stored procedure
  → Resolved: GRANT EXECUTE to adfuser
- Dynamic date expression quoting issues
  → Resolved: used escaped single quotes ('')
- SP_UpdateWatermark not connected properly
  → Resolved: added success arrow from Copy activity

## 📊 Results
- First run: copied all rows (watermark = 2000-01-01)
- Watermark updated to: 2014-07-07
- Second run: no rows copied (no new data) ✅
- Proves incremental logic working correctly
- Physical Parquet file created:
  bronze/Sales/SalesOrderHeader_incremental/

## 💡 Business Value
Without incremental load:

Copy 31,465 rows every day

Even if only 50 new rows added
With incremental load:

Copy only new rows since last run

31,415 rows skipped → faster + cheaperv
31,415 rows skipped → faster + cheaperv