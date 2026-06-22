# Project 2 — Databricks Transformation (Silver Layer)

## 🎯 Objective
Transform raw Parquet files from bronze layer to 
cleaned silver layer using Azure Databricks and 
PySpark. Apply data quality improvements and 
standardization across all 66 tables.

## 🏗️ Architecture
ADLS Gen2 Bronze Container

(Raw Parquet files — 65 tables)

↓

Azure Databricks

(PySpark Transformation)

↓

ADLS Gen2 Silver Container

(Cleaned Parquet files — 66 tables)

## 🛠️ Tools Used
- Azure Databricks
- PySpark
- ADLS Gen2
- Parquet file format
- Python

## 📋 What Was Built
- Databricks cluster (rachana-cluster)
- Storage account connection via account key
- PySpark notebook: bronze_to_silver_transform
- Automated transformation for all 66 tables
- Dynamic schema detection and processing

## 🔄 Transformations Applied
- Added LoadedAt timestamp column to all tables
- Dropped rowguid column (not needed for analytics)
- Standardized Parquet output format
- Organized silver layer by schema/table structure

## 🔑 Key Concepts Learned
- Databricks workspace and cluster management
- PySpark DataFrame operations
- Reading and writing Parquet files from ADLS
- Dynamic transformation across multiple tables
- wasbs:// vs abfss:// storage endpoints
- Bronze to Silver medallion architecture pattern

## ⚠️ Challenges Faced
- Storage account HNS disabled — used wasbs:// endpoint
- rowguid column caused issues — dropped during transform
- Dynamic schema handling across 66 different tables

## 📊 Results
- 66 tables successfully transformed
- All tables stored as Parquet in silver/
- LoadedAt column added for audit tracking
- Silver layer organized by schema:
  silver/Sales/SalesOrderHeader/
  silver/HumanResources/Department/
  silver/Production/Product/