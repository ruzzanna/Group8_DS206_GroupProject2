USE ORDER_DDS;

MERGE DimRegion AS Target
USING (
    SELECT 
        s.staging_raw_id,
        d.SOR_ID,
        s.RegionID,
        s.RegionDescription
    FROM dbo.Staging_Region s
    INNER JOIN Dim_SOR d
        ON d.Staging_Raw_ID = s.staging_raw_id
        AND d.Staging_Table_Name = 'dbo.Staging_Region'
) AS Source
ON Target.RegionID = Source.RegionID
WHEN MATCHED THEN
    UPDATE SET 
        RegionDescription = Source.RegionDescription,
        SOR_ID = Source.SOR_ID
WHEN NOT MATCHED BY Target THEN
    INSERT (RegionID, RegionDescription, SOR_ID, StartDate, IsCurrent)
    VALUES (Source.RegionID, Source.RegionDescription, Source.SOR_ID, GETDATE(), 1);