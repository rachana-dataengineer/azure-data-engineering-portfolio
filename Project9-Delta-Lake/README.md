# Project 9 — Delta Lake Advanced

## 🎯 Objective
Upgrade silver layer from plain Parquet files to 
Delta Lake format. Implement production-grade patterns 
including MERGE/UPSERT, SCD Type 2, OPTIMIZE, VACUUM, 
and Time Travel on AdventureWorks sales data.

## 🏗️ Architecture
ADLS Gen2 Silver Container

(Plain Parquet files)

↓

Azure Databricks

(Delta Lake conversion)

↓

ADLS Gen2 Silver/Delta Container

(Delta tables with transaction log)

↓

Operations performed:

├── MERGE/UPSERT (incremental updates)

├── SCD Type 2 (historical tracking)

├── OPTIMIZE + ZORDER (performance)

├── VACUUM (storage cleanup)

└── Time Travel (version queries)

## 🛠️ Tools Used
- Azure Databricks
- Delta Lake
- PySpark
- ADLS Gen2
- Databricks Workflows

## 📋 What Was Built
- Converted SalesOrderHeader Parquet → Delta format
- MERGE operation on SalesOrderHeader
- SCD Type 2 implementation on Department table
- OPTIMIZE with ZORDER BY (TerritoryID, OrderDate)
- VACUUM RETAIN 168 HOURS
- Time Travel demo (Status 5 → 99 → recover v0)
- Databricks Workflow: delta_silver_processing
  (scheduled daily at 3AM IST)

## 🔑 Key Concepts Learned
- Delta Lake vs plain Parquet differences
- _delta_log transaction log structure
- ACID transactions in Delta Lake
- MERGE/UPSERT — whenMatchedUpdate + whenNotMatchedInsertAll
- SCD Type 2 — effective dates + is_current flag
- OPTIMIZE — small file compaction
- Z-ORDER — data skipping for query performance
- VACUUM — old file cleanup and retention policy
- Time Travel — query by version or timestamp
- DESCRIBE HISTORY — view all Delta operations

## 📊 Delta Table History
Version 0 → WRITE    (initial Parquet to Delta conversion)

Version 1 → WRITE

Version 2 → MERGE    (incremental UPSERT operation)

Version 3 → WRITE

Version 4 → OPTIMIZE (file compaction + ZORDER)

Version 5 → VACUUM   (old file cleanup)

Version 6 → UPDATE   (Time Travel demo)

## 💡 SCD Type 2 Implementation
```python
# Expire changed records
target.alias('t').merge(
    source.alias('s'),
    't.DepartmentID = s.DepartmentID AND t.is_current = true
     AND t.Name != s.Name'
).whenMatchedUpdate(set={
    'effective_end_date': 'current_date()',
    'is_current': 'false'
}).execute()

# Insert new version
source_with_scd.write.format('delta').mode('append').save(path)
```

## 🕐 Time Travel Demo
```python
# Query data BEFORE update (Version 0)
df_v0 = spark.read.format('delta')
    .option('versionAsOf', 0)
    .load(delta_path)
# Shows Status = 5 (original)

# Query CURRENT data (after update)
df_current = spark.read.format('delta').load(delta_path)
# Shows Status = 99 (updated)

# Time travel PROVES we can recover original values
```

## ⚠️ Challenges Faced
- HNS disabled on adlsrachana2025
  → Used wasbs:// endpoint instead of abfss://
- Employee table missing in silver
  → Used Department table for SCD Type 2 demo
- Maven library PERMISSION_DENIED on cluster
  → Used Python approach for streaming

## 📊 Results
- SalesOrderHeader: 31,465 rows in Delta format
- MERGE completed successfully
- SCD Type 2: 16 Department records with history
- OPTIMIZE: small files compacted to 128MB target
- VACUUM: files older than 7 days removed
- Time Travel: successfully queried Version 0
- Databricks Workflow scheduled daily at 3AM IST