USE ORDER_DDS;

MERGE DimProducts AS Target
USING (
    SELECT 
        s.staging_raw_id,
        d.SOR_ID,
        s.ProductID,
        s.ProductName,
        s.SupplierID,
        s.CategoryID,
        s.QuantityPerUnit,
        s.UnitPrice
    FROM dbo.Staging_Products s
    INNER JOIN Dim_SOR d
        ON d.Staging_Raw_ID = s.staging_raw_id
        AND d.Staging_Table_Name = 'dbo.Staging_Products'
) AS Source
ON Target.ProductID = Source.ProductID
WHEN MATCHED THEN
    UPDATE SET 
        ProductName = Source.ProductName,
        SupplierKey = Source.SupplierID,
        CategoryKey = Source.CategoryID,
        QuantityPerUnit = Source.QuantityPerUnit,
        UnitPrice = Source.UnitPrice,
        SOR_ID = Source.SOR_ID
WHEN NOT MATCHED BY Target THEN
    INSERT (ProductID, ProductName, SupplierKey, CategoryKey, QuantityPerUnit, UnitPrice, SOR_ID)
    VALUES (Source.ProductID, Source.ProductName, Source.SupplierID, Source.CategoryID, Source.QuantityPerUnit, Source.UnitPrice, Source.SOR_ID);