# Project 7 — Metadata Driven Pipeline

## 🎯 Objective
Replace hardcoded ADF pipeline with a metadata-driven 
design where a configuration table controls all pipeline 
behavior. Add new tables without modifying the pipeline 
— just add a row to the config table.

## 🏗️ Architecture
dbo.pipeline_config (SQL Server)

(config table — source of truth)

↓

ADF Lookup Activity

(LKP_ReadConfig — reads all enabled tables)

↓

ADF ForEach Activity

(ForEach_Tables — iterates each config row)

↓

If Condition Activity

(IF_LoadType — full or incremental?)

↙              ↘

Full Load      Incremental Load

(CPY_FullLoad) (CPY_Incremental)

↓

ADLS Bronze Container

(organized by schema/table)

↓

Stored Procedure

(updates watermark per table)

## 🛠️ Tools Used
- Azure Data Factory
- SQL Server (config table + stored procedure)
- Self-Hosted Integration Runtime
- ADLS Gen2
- Dynamic ADF expressions

## 📋 What Was Built
- dbo.pipeline_config table (6 tables configured)
- dbo.usp_update_config_watermark stored procedure
- ADF pipeline: PL_MetadataDriven_Bronze
- LKP_ReadConfig Lookup activity
- ForEach_Tables ForEach activity
- IF_LoadType If Condition activity
- CPY_FullLoad and CPY_Incremental Copy activities

## 🔑 Key Concepts Learned
- Metadata-driven pipeline design pattern
- Config table as single source of truth
- ForEach activity with parallel execution
- If Condition activity for branching logic
- @item() expression inside ForEach
- @activity().output.value vs firstRow
- Dynamic SQL query building with concat()
- IDENTITY(1,1) for auto-increment primary key
- Soft delete pattern (is_enabled flag)
- dbo schema and SQL Server schemas

## 📋 Config Table Structure
```sql
CREATE TABLE dbo.pipeline_config (
    config_id        INT IDENTITY(1,1) PRIMARY KEY,
    source_schema    VARCHAR(100),
    table_name       VARCHAR(100),
    load_type        VARCHAR(20),
    watermark_column VARCHAR(100),
    is_enabled       BIT DEFAULT 1,
    sink_container   VARCHAR(50) DEFAULT 'bronze',
    last_loaded_time DATETIME DEFAULT '2000-01-01'
);
```

## 💡 Key Advantage
Adding new table (hardcoded pipeline):

→ Open ADF Studio

→ Modify ForEach items

→ Add new Copy activity

→ Test and publish

→ Time: 30-60 minutes
Adding new table (metadata pipeline):

→ INSERT one row in config table

→ Next pipeline run picks it up automatically

→ Time: 2 minutes ✅

## ⚠️ Challenges Faced
- HierarchyID data type not supported
  → Resolved: disabled Employee table in config
- Dynamic date quoting syntax error
  → Resolved: used escaped single quotes ('')
- EXECUTE permission denied
  → Resolved: GRANT EXECUTE to adfuser

## 📊 Results
- 6 tables processed dynamically
- Mix of full load and incremental load
- Config table controls all behavior
- New table added in 2 minutes (no pipeline change)
- Disabled table skipped automatically