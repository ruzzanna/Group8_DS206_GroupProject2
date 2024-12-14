DECLARE @DatabaseName NVARCHAR(255) = 'ORDER_DDS'; 
DECLARE @SchemaName NVARCHAR(255) = 'dbo'; 
DECLARE @FactTableName NVARCHAR(255) = 'FactOrders'; 
DECLARE @StagingTableName NVARCHAR(255) = 'Staging_Orders'; 
DECLARE @StartDate DATE = '2024-01-01'; 
DECLARE @EndDate DATE = '2024-12-31'; 

DECLARE @SQL NVARCHAR(MAX);

SET @SQL = N'
USE [' + @DatabaseName + N'];

-- MERGE statement for upsert operations in the fact table
MERGE ' + QUOTENAME(@SchemaName) + N'.' + QUOTENAME(@FactTableName) + N' AS Target
USING (
    SELECT 
        s.staging_raw_id,
        d.SOR_ID,
        s.OrderID,
        c.CustomerKey,
        e.EmployeeKey,
        s.OrderDate,
        s.RequiredDate,
        s.ShippedDate,
        sp.ShipperKey,
        s.Freight,
        t.TerritoryKey
    FROM ' + QUOTENAME(@SchemaName) + N'.' + QUOTENAME(@StagingTableName) + N' s
    INNER JOIN ' + QUOTENAME(@SchemaName) + N'.Dim_SOR d
        ON d.Staging_Raw_ID = s.staging_raw_id
        AND d.Staging_Table_Name = ''' + QUOTENAME(@SchemaName) + N'.' + QUOTENAME(@StagingTableName) + N'''
    LEFT JOIN ' + QUOTENAME(@SchemaName) + N'.DimCustomers c
        ON s.CustomerID = c.CustomerID
    LEFT JOIN ' + QUOTENAME(@SchemaName) + N'.DimEmployees e
        ON s.EmployeeID = e.EmployeeID
    LEFT JOIN ' + QUOTENAME(@SchemaName) + N'.DimShippers sp
        ON s.ShipVia = sp.ShipperID
    LEFT JOIN ' + QUOTENAME(@SchemaName) + N'.DimTerritories t
        ON s.TerritoryKey = t.TerritoryKey
    WHERE s.OrderDate BETWEEN @StartDate AND @EndDate
) AS Source
ON Target.OrderID = Source.OrderID
WHEN MATCHED THEN
    UPDATE SET 
        CustomerKey = Source.CustomerKey,
        EmployeeKey = Source.EmployeeKey,
        OrderDate = Source.OrderDate,
        RequiredDate = Source.RequiredDate,
        ShippedDate = Source.ShippedDate,
        ShipperKey = Source.ShipperKey,
        Freight = Source.Freight,
        TerritoryKey = Source.TerritoryKey,
        SOR_ID = Source.SOR_ID
WHEN NOT MATCHED BY Target THEN
    INSERT (OrderID, CustomerKey, EmployeeKey, OrderDate, RequiredDate, ShippedDate, ShipperKey, Freight, TerritoryKey, SOR_ID)
    VALUES (Source.OrderID, Source.CustomerKey, Source.EmployeeKey, Source.OrderDate, Source.RequiredDate, Source.ShippedDate, Source.ShipperKey, Source.Freight, Source.TerritoryKey, Source.SOR_ID);
';

EXEC sp_executesql @SQL, 
    N'@StartDate DATE, @EndDate DATE',
    @StartDate, @EndDate;