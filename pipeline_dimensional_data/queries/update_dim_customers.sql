USE ORDER_DDS;

MERGE DimCustomers AS Target
USING (
    SELECT 
        s.staging_raw_id,
        d.SOR_ID,
        s.CustomerID,
        s.CustomerName AS CompanyName,
        s.ContactName,
        NULL AS ContactTitle, -- Adjust if ContactTitle exists
        s.Address,
        s.City,
        NULL AS Region, -- Adjust if Region exists
        NULL AS PostalCode, -- Adjust if PostalCode exists
        s.Country,
        NULL AS Phone, -- Adjust if Phone exists
        NULL AS Fax -- Adjust if Fax exists
    FROM dbo.Staging_Customers s
    INNER JOIN Dim_SOR d
        ON d.Staging_Raw_ID = s.staging_raw_id
        AND d.Staging_Table_Name = 'dbo.Staging_Customers'
) AS Source
ON Target.CustomerID = Source.CustomerID
WHEN MATCHED THEN
    UPDATE SET 
        CompanyName = Source.CompanyName,
        ContactName = Source.ContactName,
        Address = Source.Address,
        City = Source.City,
        Country = Source.Country,
        SOR_ID = Source.SOR_ID
WHEN NOT MATCHED BY Target THEN
    INSERT (CustomerID, CompanyName, ContactName, Address, City, Country, SOR_ID, StartDate, IsCurrent)
    VALUES (Source.CustomerID, Source.CompanyName, Source.ContactName, Source.Address, Source.City, Source.Country, Source.SOR_ID, GETDATE(), 1);