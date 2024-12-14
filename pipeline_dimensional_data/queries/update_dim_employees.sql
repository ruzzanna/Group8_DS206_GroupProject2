USE ORDER_DDS;

MERGE DimEmployees AS Target
USING (
    SELECT 
        s.staging_raw_id,
        d.SOR_ID,
        s.EmployeeID,
        s.FirstName,
        s.LastName,
        s.Title,
        s.HireDate,
        NULL AS ReportsTo -- Adjust if ReportsTo exists
    FROM dbo.Staging_Employees s
    INNER JOIN Dim_SOR d
        ON d.Staging_Raw_ID = s.staging_raw_id
        AND d.Staging_Table_Name = 'dbo.Staging_Employees'
) AS Source
ON Target.EmployeeID = Source.EmployeeID
WHEN MATCHED THEN
    UPDATE SET 
        FirstName = Source.FirstName,
        LastName = Source.LastName,
        Title = Source.Title,
        HireDate = Source.HireDate,
        SOR_ID = Source.SOR_ID
WHEN NOT MATCHED BY Target THEN
    INSERT (EmployeeID, FirstName, LastName, Title, HireDate, SOR_ID)
    VALUES (Source.EmployeeID, Source.FirstName, Source.LastName, Source.Title, Source.HireDate, Source.SOR_ID);