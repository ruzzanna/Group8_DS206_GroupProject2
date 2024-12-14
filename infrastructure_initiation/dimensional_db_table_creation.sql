USE ORDER_DDS;

DROP TABLE IF EXISTS FactOrders;
DROP TABLE IF EXISTS DimTerritories;
DROP TABLE IF EXISTS DimSuppliers;
DROP TABLE IF EXISTS DimShippers;
DROP TABLE IF EXISTS DimRegion;
DROP TABLE IF EXISTS DimProducts;
DROP TABLE IF EXISTS DimEmployees;
DROP TABLE IF EXISTS DimCustomers;
DROP TABLE IF EXISTS DimCategories;
DROP TABLE IF EXISTS Dim_SOR;

CREATE TABLE Dim_SOR (
    SOR_ID INT IDENTITY(1,1) PRIMARY KEY,
    Staging_Raw_ID INT NOT NULL,
    Staging_Table_Name NVARCHAR(255) NOT NULL
);

CREATE TABLE DimCategories (
    CategoryKey INT IDENTITY(1,1) PRIMARY KEY,
    SOR_ID INT NOT NULL,
    CategoryID INT NOT NULL,
    CategoryName NVARCHAR(255),
    Description NVARCHAR(MAX)
);

CREATE TABLE DimCustomers (
    CustomerKey INT IDENTITY(1,1) PRIMARY KEY,
    SOR_ID INT NOT NULL,
    CustomerID INT NOT NULL,
    CompanyName NVARCHAR(255),
    ContactName NVARCHAR(255),
    ContactTitle NVARCHAR(255),
    Address NVARCHAR(MAX),
    City NVARCHAR(255),
    Region NVARCHAR(255),
    PostalCode NVARCHAR(20),
    Country NVARCHAR(255),
    Phone NVARCHAR(50),
    Fax NVARCHAR(50),
    StartDate DATE NOT NULL,
    EndDate DATE NULL,
    IsCurrent BIT DEFAULT 1
);

CREATE TABLE DimEmployees (
    EmployeeKey INT IDENTITY(1,1) PRIMARY KEY,
    SOR_ID INT NOT NULL,
    EmployeeID INT NOT NULL,
    LastName NVARCHAR(255),
    FirstName NVARCHAR(255),
    Title NVARCHAR(255),
    TitleOfCourtesy NVARCHAR(50),
    BirthDate DATE,
    HireDate DATE,
    Address NVARCHAR(MAX),
    City NVARCHAR(255),
    Region NVARCHAR(255),
    PostalCode NVARCHAR(20),
    Country NVARCHAR(255),
    HomePhone NVARCHAR(50),
    Extension NVARCHAR(10),
    Notes NVARCHAR(MAX),
    ReportsTo INT,
    PhotoPath NVARCHAR(255),
    IsDeleted BIT DEFAULT 0
);

CREATE TABLE DimSuppliers (
    SupplierKey INT IDENTITY(1,1) PRIMARY KEY,
    SOR_ID INT NOT NULL,
    SupplierID INT NOT NULL,
    CompanyName NVARCHAR(255),
    ContactName NVARCHAR(255),
    ContactTitle NVARCHAR(255),
    Address NVARCHAR(MAX),
    City NVARCHAR(255),
    Region NVARCHAR(255),
    PostalCode NVARCHAR(20),
    Country NVARCHAR(255),
    Phone NVARCHAR(50),
    Fax NVARCHAR(50),
    HomePage NVARCHAR(MAX),
    IsCurrent BIT DEFAULT 1,
    PreviousSupplierKey INT NULL
);

CREATE TABLE DimProducts (
    ProductKey INT IDENTITY(1,1) PRIMARY KEY,
    SOR_ID INT NOT NULL,
    ProductID INT NOT NULL,
    ProductName NVARCHAR(255),
    SupplierKey INT,
    CategoryKey INT,
    QuantityPerUnit NVARCHAR(255),
    UnitPrice DECIMAL(18,2),
    UnitsInStock INT,
    UnitsOnOrder INT,
    ReorderLevel INT,
    Discontinued BIT,
    FOREIGN KEY (CategoryKey) REFERENCES DimCategories(CategoryKey),
    FOREIGN KEY (SupplierKey) REFERENCES DimSuppliers(SupplierKey)
);

CREATE TABLE DimRegion (
    RegionKey INT IDENTITY(1,1) PRIMARY KEY,
    SOR_ID INT NOT NULL,
    RegionID INT NOT NULL,
    RegionDescription NVARCHAR(255),
    RegionCategory NVARCHAR(255),
    RegionImportance INT,
    StartDate DATE NOT NULL,
    EndDate DATE NULL,
    IsCurrent BIT DEFAULT 1
);

CREATE TABLE DimShippers (
    ShipperKey INT IDENTITY(1,1) PRIMARY KEY,
    SOR_ID INT NOT NULL,
    ShipperID INT NOT NULL,
    CompanyName NVARCHAR(255),
    Phone NVARCHAR(50),
    IsDeleted BIT DEFAULT 0
);

CREATE TABLE DimTerritories (
    TerritoryKey INT IDENTITY(1,1) PRIMARY KEY,
    SOR_ID INT NOT NULL,
    TerritoryID INT NOT NULL,
    TerritoryDescription NVARCHAR(255),
    TerritoryCode NVARCHAR(50),
    RegionKey INT,
    StartDate DATE NOT NULL,
    EndDate DATE NULL,
    IsCurrent BIT DEFAULT 1,
    FOREIGN KEY (RegionKey) REFERENCES DimRegion(RegionKey)
);

CREATE TABLE FactOrders (
    OrderKey INT IDENTITY(1,1) PRIMARY KEY,
    SOR_ID INT NOT NULL,
    OrderID INT NOT NULL,
    CustomerKey INT,
    EmployeeKey INT,
    OrderDate DATE,
    RequiredDate DATE,
    ShippedDate DATE,
    ShipperKey INT,
    Freight DECIMAL(18,2),
    ShipName NVARCHAR(255),
    ShipAddress NVARCHAR(MAX),
    ShipCity NVARCHAR(255),
    ShipRegion NVARCHAR(255),
    ShipPostalCode NVARCHAR(20),
    ShipCountry NVARCHAR(255),
    TerritoryKey INT,
    FOREIGN KEY (CustomerKey) REFERENCES DimCustomers(CustomerKey),
    FOREIGN KEY (EmployeeKey) REFERENCES DimEmployees(EmployeeKey),
    FOREIGN KEY (ShipperKey) REFERENCES DimShippers(ShipperKey),
    FOREIGN KEY (TerritoryKey) REFERENCES DimTerritories(TerritoryKey)
);