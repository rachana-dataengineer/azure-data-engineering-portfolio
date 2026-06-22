-- Project 4: Watermark Table and Stored Procedure
-- Run in SSMS on AdventureWorks2022 database

USE AdventureWorks2022;
GO

-- Create watermark table
CREATE TABLE dbo.watermark_table (
    table_name       VARCHAR(100),
    last_loaded_time DATETIME
);
GO

-- Insert initial watermark
INSERT INTO dbo.watermark_table VALUES
('SalesOrderHeader', '2000-01-01 00:00:00');
GO

-- Create stored procedure
CREATE OR ALTER PROCEDURE dbo.usp_update_watermark
    @table_name       VARCHAR(100),
    @last_loaded_time DATETIME
AS
BEGIN
    UPDATE dbo.watermark_table
    SET last_loaded_time = @last_loaded_time
    WHERE table_name = @table_name;
END;
GO

-- Grant execute permission
GRANT EXECUTE ON dbo.usp_update_watermark TO adfuser;
GO