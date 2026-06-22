# Project 9 — Delta Lake Advanced
# Run in Azure Databricks notebook

# ============================================
# CELL 1 — Storage Configuration
# ============================================
storage_account_name = 'adlsrachana2025'
storage_account_key  = 'YOUR_STORAGE_ACCOUNT_KEY_HERE'

spark.conf.set(
    f'fs.azure.account.key.{storage_account_name}.blob.core.windows.net',
    storage_account_key
)

silver_path = 'wasbs://silver@adlsrachana2025.blob.core.windows.net/'
delta_path  = 'wasbs://silver@adlsrachana2025.blob.core.windows.net/delta/'

print('Storage configured successfully!')

# ============================================
# CELL 2 — Convert Parquet to Delta Format
# ============================================
from delta.tables import DeltaTable

df = spark.read.parquet(f'{silver_path}Sales/SalesOrderHeader/')

df.write \
  .format('delta') \
  .mode('overwrite') \
  .save(f'{delta_path}Sales/SalesOrderHeader/')

print('Converted to Delta format successfully!')

# ============================================
# CELL 3 — MERGE / UPSERT Operation
# ============================================
from delta.tables import DeltaTable
from pyspark.sql.functions import current_timestamp

# Load existing Delta table (target)
delta_table = DeltaTable.forPath(
    spark,
    f'{delta_path}Sales/SalesOrderHeader/'
)

# Load new incremental data (source)
new_data = spark.read.parquet(
    'wasbs://bronze@adlsrachana2025.blob.core.windows.net/Sales/SalesOrderHeader_incremental/'
).withColumn('LoadedAt', current_timestamp())

# MERGE operation
delta_table.alias('target').merge(
    new_data.alias('source'),
    'target.SalesOrderID = source.SalesOrderID'
).whenMatchedUpdate(set={
    'SubTotal': 'source.SubTotal',
    'TotalDue': 'source.TotalDue',
    'Status':   'source.Status',
    'LoadedAt': 'source.LoadedAt'
}).whenNotMatchedInsertAll(
).execute()

print('MERGE completed successfully!')

# ============================================
# CELL 4 — SCD Type 2 on Department Table
# ============================================
from pyspark.sql.functions import *
from delta.tables import DeltaTable

source_df = spark.read.parquet(
    'wasbs://silver@adlsrachana2025.blob.core.windows.net/HumanResources/Department/'
)

target_path = f'{delta_path}HumanResources/Department_SCD2/'

source_with_scd = source_df \
    .withColumn('effective_start_date', current_date()) \
    .withColumn('effective_end_date', lit('9999-12-31').cast('date')) \
    .withColumn('is_current', lit(True))

try:
    target = DeltaTable.forPath(spark, target_path)

    # Expire changed records
    target.alias('t').merge(
        source_with_scd.alias('s'),
        '''t.DepartmentID = s.DepartmentID
           AND t.is_current = true
           AND t.Name != s.Name'''
    ).whenMatchedUpdate(set={
        'effective_end_date': 'current_date()',
        'is_current':         'false'
    }).execute()

    # Insert new records
    source_with_scd.write \
        .format('delta') \
        .mode('append') \
        .save(target_path)

except:
    # First run
    source_with_scd.write \
        .format('delta') \
        .mode('overwrite') \
        .save(target_path)

print('SCD Type 2 completed!')

# ============================================
# CELL 5 — OPTIMIZE + ZORDER
# ============================================
spark.sql(f'''
    OPTIMIZE delta.`{delta_path}Sales/SalesOrderHeader/`
    ZORDER BY (TerritoryID, OrderDate)
''')
print('OPTIMIZE completed!')

# ============================================
# CELL 6 — VACUUM
# ============================================
spark.sql(f'''
    VACUUM delta.`{delta_path}Sales/SalesOrderHeader/`
    RETAIN 168 HOURS
''')
print('VACUUM completed!')

# ============================================
# CELL 7 — Time Travel
# ============================================
# Query Version 0 (original data)
df_v0 = spark.read.format('delta') \
    .option('versionAsOf', 0) \
    .load(f'{delta_path}Sales/SalesOrderHeader/')

print(f'Version 0 row count: {df_v0.count()}')

# Query current version
df_current = spark.read.format('delta') \
    .load(f'{delta_path}Sales/SalesOrderHeader/')

print(f'Current row count: {df_current.count()}')

# View Delta history
display(spark.sql(f'''
    DESCRIBE HISTORY delta.`{delta_path}Sales/SalesOrderHeader/`
'''))