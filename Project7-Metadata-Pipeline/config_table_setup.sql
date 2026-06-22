-- Project 7: Metadata Driven Pipeline Config Table
-- Run in SSMS on AdventureWorks2022 database

USE AdventureWorks2022;
GO

-- Create config table
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
GO

-- Insert config rows
INSERT INTO dbo.pipeline_config
(source_schema, table_name, load_type, watermark_column, is_enabled)
VALUES
('Sales',          'SalesOrderHeader',  'Incremental', 'ModifiedDate', 1),
('Sales',          'SalesOrderDetail',  'Full',         NULL,           1),
('Sales',          'SalesTerritory',    'Full',         NULL,           1),
('HumanResources', 'Department',        'Full',         NULL,           1),
('Production',     'Product',           'Full',         NULL,           1);
GO

-- Create watermark update procedure
CREATE OR ALTER PROCEDURE dbo.usp_update_config_watermark
    @source_schema VARCHAR(100),
    @table_name    VARCHAR(100),
    @last_loaded   DATETIME
AS
BEGIN
    UPDATE dbo.pipeline_config
    SET last_loaded_time = @last_loaded
    WHERE source_schema = @source_schema
    AND table_name = @table_name;
END;
GO

-- Grant execute permission
GRANT EXECUTE ON dbo.usp_update_config_watermark TO adfuser;
GO

-- Verify
SELECT * FROM dbo.pipeline_config;