MERGE DimCategories AS Target
USING (
    SELECT 
        s.staging_raw_id,
        s.CategoryID,
        s.CategoryName,
        s.Description,
        d.SOR_ID
    FROM Staging_Categories s
    INNER JOIN Dim_SOR d
        ON d.Staging_Raw_ID = s.staging_raw_id
        AND d.Staging_Table_Name = 'Staging_Categories'
) AS Source
ON Target.CategoryID = Source.CategoryID
WHEN MATCHED THEN
    UPDATE SET 
        CategoryName = Source.CategoryName,
        Description = Source.Description
WHEN NOT MATCHED BY Target THEN
    INSERT (CategoryID, CategoryName, Description, SOR_ID)
    VALUES (Source.CategoryID, Source.CategoryName, Source.Description, Source.SOR_ID);