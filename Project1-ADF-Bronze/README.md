# Project 1 — ADF Full Load (Bronze Layer)

## 🎯 Objective
Migrate 65 tables from on-premise SQL Server 
(AdventureWorks2022) to Azure Data Lake Storage 
Gen2 bronze container as Parquet files using 
Azure Data Factory.

## 🏗️ Architecture
On-Premise SQL Server

(AdventureWorks2022)

↓

Self-Hosted Integration Runtime (SHIR)

↓

Azure Data Factory Pipeline

(PL_CopyAllTables_SQLToADLS)

↓

ADLS Gen2 Bronze Container

(65 tables as Parquet files)

## 🛠️ Tools Used
- Azure Data Factory (ADF)
- Self-Hosted Integration Runtime (SHIR)
- Azure Data Lake Storage Gen2
- SQL Server (AdventureWorks2022)
- Parquet file format

## 📋 What Was Built
- Linked service for on-premise SQL Server
- Linked service for ADLS Gen2
- Parameterized datasets (DS_SQL_Source, DS_ADLS_Parquet)
- ForEach pipeline iterating all 65 tables
- Lookup activity fetching all table names dynamically
- Copy activity writing Parquet files to bronze container

## 🔑 Key Concepts Learned
- ADF pipeline components (linked services, datasets, activities)
- Self-Hosted Integration Runtime for on-premise connectivity
- ForEach activity for bulk table migration
- Parquet file format advantages over CSV
- ADLS Gen2 container and folder structure

## ⚠️ Challenges Faced
- SHIR installation and configuration on local machine
- Linked service authentication for on-premise SQL Server
- HierarchyID data type not supported by ADF Copy activity
  → Resolved by excluding unsupported columns

## 📊 Results
- 65 tables successfully migrated
- All tables stored as Parquet files in bronze/
- Pipeline runs in approximately 8-10 minutes
- Data organized by schema/table folder structure:
  bronze/Sales/SalesOrderHeader/
  bronze/HumanResources/Employee/
  bronze/Production/Product/