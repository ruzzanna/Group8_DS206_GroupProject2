USE ORDER_DDS;

MERGE DimSuppliers AS Target
USING (
    SELECT 
        s.staging_raw_id,
        d.SOR_ID,
        s.SupplierID,
        s.CompanyName,
        s.ContactName,
        s.ContactTitle,
        s.Address,
        s.City,
        s.PostalCode,
        s.Country,
        s.Phone,
        s.Fax
    FROM dbo.Staging_Suppliers s
    INNER JOIN Dim_SOR d
        ON d.Staging_Raw_ID = s.staging_raw_id
        AND d.Staging_Table_Name = 'dbo.Staging_Suppliers'
) AS Source
ON Target.SupplierID = Source.SupplierID
WHEN MATCHED THEN
    UPDATE SET 
        CompanyName = Source.CompanyName,
        ContactName = Source.ContactName,
        ContactTitle = Source.ContactTitle,
        Address = Source.Address,
        City = Source.City,
        PostalCode = Source.PostalCode,
        Country = Source.Country,
        Phone = Source.Phone,
        Fax = Source.Fax,
        SOR_ID = Source.SOR_ID
WHEN NOT MATCHED BY Target THEN
    INSERT (SupplierID, CompanyName, ContactName, ContactTitle, Address, City,  PostalCode, Country, Phone, Fax, SOR_ID)
    VALUES (Source.SupplierID, Source.CompanyName, Source.ContactName, Source.ContactTitle, Source.Address, Source.City,  Source.PostalCode, Source.Country, Source.Phone, Source.Fax, Source.SOR_ID);