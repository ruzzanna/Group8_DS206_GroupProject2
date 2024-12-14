USE ORDER_DDS;

MERGE DimShippers AS Target
USING (
    SELECT 
        s.staging_raw_id,
        d.SOR_ID,
        s.ShipperID,
        s.CompanyName,
        s.Phone
    FROM dbo.Staging_Shippers s
    INNER JOIN Dim_SOR d
        ON d.Staging_Raw_ID = s.staging_raw_id
        AND d.Staging_Table_Name = 'dbo.Staging_Shippers'
) AS Source
ON Target.ShipperID = Source.ShipperID
WHEN MATCHED THEN
    UPDATE SET 
        CompanyName = Source.CompanyName,
        Phone = Source.Phone,
        SOR_ID = Source.SOR_ID
WHEN NOT MATCHED BY Target THEN
    INSERT (ShipperID, CompanyName, Phone, SOR_ID)
    VALUES (Source.ShipperID, Source.CompanyName, Source.Phone, Source.SOR_ID);