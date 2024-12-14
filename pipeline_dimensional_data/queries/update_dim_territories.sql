USE ORDER_DDS;

MERGE DimTerritories AS Target
USING (
    SELECT 
        s.staging_raw_id,
        d.SOR_ID,
        s.TerritoryID,
        s.TerritoryDescription,
        s.RegionID
    FROM dbo.Staging_Territories s
    INNER JOIN Dim_SOR d
        ON d.Staging_Raw_ID = s.staging_raw_id
        AND d.Staging_Table_Name = 'dbo.Staging_Territories'
) AS Source
ON Target.TerritoryID = Source.TerritoryID
WHEN MATCHED THEN
    UPDATE SET 
        TerritoryDescription = Source.TerritoryDescription,
        RegionKey = Source.RegionID,
        SOR_ID = Source.SOR_ID
WHEN NOT MATCHED BY Target THEN
    INSERT (TerritoryID, TerritoryDescription, RegionKey, SOR_ID, StartDate, IsCurrent)
    VALUES (Source.TerritoryID, Source.TerritoryDescription, Source.RegionID, Source.SOR_ID, GETDATE(), 1);