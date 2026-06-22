-- Project 3: Synapse Gold Layer Views
-- Run in Synapse Studio (gold_db selected)

-- View 1: Total Sales by Territory
CREATE OR ALTER VIEW gold_sales_by_territory AS
SELECT
    t.[Name]                AS TerritoryName,
    t.[CountryRegionCode]   AS Country,
    t.[Group]               AS Region,
    COUNT(DISTINCT h.SalesOrderID) AS TotalOrders,
    ROUND(SUM(h.SubTotal), 2)      AS TotalSales,
    ROUND(SUM(h.TaxAmt), 2)        AS TotalTax,
    ROUND(SUM(h.TotalDue), 2)      AS GrandTotal
FROM OPENROWSET(
    BULK 'https://adlsrachana2025.dfs.core.windows.net/silver/Sales/SalesOrderHeader/',
    FORMAT = 'PARQUET'
) AS h
JOIN OPENROWSET(
    BULK 'https://adlsrachana2025.dfs.core.windows.net/silver/Sales/SalesTerritory/',
    FORMAT = 'PARQUET'
) AS t ON h.TerritoryID = t.TerritoryID
GROUP BY t.[Name], t.[CountryRegionCode], t.[Group];
GO

-- View 2: Employee Count by Department
CREATE OR ALTER VIEW gold_employees_by_department AS
SELECT
    d.[Name]        AS DepartmentName,
    d.[GroupName]   AS DepartmentGroup,
    COUNT(DISTINCT edh.BusinessEntityID) AS EmployeeCount
FROM OPENROWSET(
    BULK 'https://adlsrachana2025.dfs.core.windows.net/silver/HumanResources/EmployeeDepartmentHistory/',
    FORMAT = 'PARQUET'
) AS edh
JOIN OPENROWSET(
    BULK 'https://adlsrachana2025.dfs.core.windows.net/silver/HumanResources/Department/',
    FORMAT = 'PARQUET'
) AS d ON edh.DepartmentID = d.DepartmentID
WHERE edh.EndDate IS NULL
GROUP BY d.[Name], d.[GroupName];
GO

-- View 3: Top 10 Products by Sales
CREATE OR ALTER VIEW gold_top_products_by_sales AS
SELECT TOP 10
    p.[Name]            AS ProductName,
    p.[ProductNumber],
    SUM(od.OrderQty)            AS TotalQuantitySold,
    ROUND(SUM(od.LineTotal), 2) AS TotalRevenue
FROM OPENROWSET(
    BULK 'https://adlsrachana2025.dfs.core.windows.net/silver/Sales/SalesOrderDetail/',
    FORMAT = 'PARQUET'
) AS od
JOIN OPENROWSET(
    BULK 'https://adlsrachana2025.dfs.core.windows.net/silver/Production/Product/',
    FORMAT = 'PARQUET'
) AS p ON od.ProductID = p.ProductID
GROUP BY p.[Name], p.[ProductNumber]
ORDER BY TotalRevenue DESC;
GO

-- Verify all views
SELECT 'Sales by Territory' AS Report, COUNT(*) AS Rows
FROM gold_sales_by_territory
UNION ALL
SELECT 'Employees by Dept', COUNT(*) FROM gold_employees_by_department
UNION ALL
SELECT 'Top 10 Products',   COUNT(*) FROM gold_top_products_by_sales;