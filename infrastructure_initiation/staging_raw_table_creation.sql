DROP TABLE IF EXISTS dbo.staging_Categories;
DROP TABLE IF EXISTS dbo.staging_Customers;
DROP TABLE IF EXISTS dbo.staging_Employees;
DROP TABLE IF EXISTS dbo.staging_Order_Details;
DROP TABLE IF EXISTS dbo.staging_Orders;
DROP TABLE IF EXISTS dbo.staging_Products;
DROP TABLE IF EXISTS dbo.staging_Region;
DROP TABLE IF EXISTS dbo.staging_Shippers;
DROP TABLE IF EXISTS dbo.staging_Suppliers;
DROP TABLE IF EXISTS dbo.staging_Territories;

USE ORDER_DDS;


CREATE TABLE dbo.Categories (
    CategoryID INT PRIMARY KEY,
    CategoryName NVARCHAR(255),
    Description NVARCHAR(MAX)
);

CREATE TABLE dbo.Staging_Categories (
    staging_raw_id INT IDENTITY(1,1) PRIMARY KEY,
    CategoryID INT,
    CategoryName NVARCHAR(255),
    Description NVARCHAR(MAX)
);

CREATE TABLE dbo.Customers (
    CustomerID INT PRIMARY KEY,
    CustomerName NVARCHAR(255),
    ContactName NVARCHAR(255),
    Address NVARCHAR(MAX),
    City NVARCHAR(255),
    Country NVARCHAR(255)
);

CREATE TABLE dbo.Staging_Customers (
    staging_raw_id INT IDENTITY(1,1) PRIMARY KEY,
    CustomerID INT,
    CustomerName NVARCHAR(255),
    ContactName NVARCHAR(255),
    Address NVARCHAR(MAX),
    City NVARCHAR(255),
    Country NVARCHAR(255)
);

-- Employees
CREATE TABLE dbo.Employees (
    EmployeeID INT PRIMARY KEY,
    FirstName NVARCHAR(255),
    LastName NVARCHAR(255),
    Title NVARCHAR(255),
    HireDate DATE,
    ReportsTo INT
);

CREATE TABLE dbo.Staging_Employees (
    staging_raw_id INT IDENTITY(1,1) PRIMARY KEY,
    EmployeeID INT,
    FirstName NVARCHAR(255),
    LastName NVARCHAR(255),
    Title NVARCHAR(255),
    HireDate DATE,
    ReportsTo INT
);

CREATE TABLE dbo.OrderDetails (
    OrderID INT,
    ProductID INT,
    Quantity INT,
    UnitPrice DECIMAL(18,2),
    Discount FLOAT,
    PRIMARY KEY (OrderID, ProductID)
);

CREATE TABLE dbo.Staging_OrderDetails (
    staging_raw_id INT IDENTITY(1,1) PRIMARY KEY,
    OrderID INT,
    ProductID INT,
    Quantity INT,
    UnitPrice DECIMAL(18,2),
    Discount FLOAT
);

CREATE TABLE dbo.Orders (
    OrderID INT PRIMARY KEY,
    CustomerID INT,
    EmployeeID INT,
    OrderDate DATE,
    ShipVia INT,
    Freight DECIMAL(18,2),
    ShipName NVARCHAR(255),
    ShipAddress NVARCHAR(MAX)
);

CREATE TABLE dbo.Staging_Orders (
    staging_raw_id INT IDENTITY(1,1) PRIMARY KEY,
    OrderID INT,
    CustomerID INT,
    EmployeeID INT,
    OrderDate DATE,
    ShipVia INT,
    Freight DECIMAL(18,2),
    ShipName NVARCHAR(255),
    ShipAddress NVARCHAR(MAX)
);

CREATE TABLE dbo.Products (
    ProductID INT PRIMARY KEY,
    ProductName NVARCHAR(255),
    SupplierID INT,
    CategoryID INT,
    QuantityPerUnit NVARCHAR(255),
    UnitPrice DECIMAL(18,2),
    UnitsInStock INT,
    UnitsOnOrder INT,
    ReorderLevel INT,
    Discontinued BIT
);

CREATE TABLE dbo.Staging_Products (
    staging_raw_id INT IDENTITY(1,1) PRIMARY KEY,
    ProductID INT,
    ProductName NVARCHAR(255),
    SupplierID INT,
    CategoryID INT,
    QuantityPerUnit NVARCHAR(255),
    UnitPrice DECIMAL(18,2),
    UnitsInStock INT,
    UnitsOnOrder INT,
    ReorderLevel INT,
    Discontinued BIT
);

CREATE TABLE dbo.Region (
    RegionID INT PRIMARY KEY,
    RegionDescription NVARCHAR(255)
);

CREATE TABLE dbo.Staging_Region (
    staging_raw_id INT IDENTITY(1,1) PRIMARY KEY,
    RegionID INT,
    RegionDescription NVARCHAR(255)
);

CREATE TABLE dbo.Shippers (
    ShipperID INT PRIMARY KEY,
    CompanyName NVARCHAR(255),
    Phone NVARCHAR(50)
);

CREATE TABLE dbo.Staging_Shippers (
    staging_raw_id INT IDENTITY(1,1) PRIMARY KEY,
    ShipperID INT,
    CompanyName NVARCHAR(255),
    Phone NVARCHAR(50)
);

CREATE TABLE dbo.Suppliers (
    SupplierID INT PRIMARY KEY,
    CompanyName NVARCHAR(255),
    ContactName NVARCHAR(255),
    ContactTitle NVARCHAR(255),
    Address NVARCHAR(MAX),
    City NVARCHAR(255),
    PostalCode NVARCHAR(20),
    Country NVARCHAR(255),
    Phone NVARCHAR(50),
    Fax NVARCHAR(50)
);

CREATE TABLE dbo.Staging_Suppliers (
    staging_raw_id INT IDENTITY(1,1) PRIMARY KEY,
    SupplierID INT,
    CompanyName NVARCHAR(255),
    ContactName NVARCHAR(255),
    ContactTitle NVARCHAR(255),
    Address NVARCHAR(MAX),
    City NVARCHAR(255),
    PostalCode NVARCHAR(20),
    Country NVARCHAR(255),
    Phone NVARCHAR(50),
    Fax NVARCHAR(50)
);

CREATE TABLE dbo.Territories (
    TerritoryID NVARCHAR(20) PRIMARY KEY,
    TerritoryDescription NVARCHAR(255),
    RegionID INT
);

CREATE TABLE dbo.Staging_Territories (
    staging_raw_id INT IDENTITY(1,1) PRIMARY KEY,
    TerritoryID NVARCHAR(20),
    TerritoryDescription NVARCHAR(255),
    RegionID INT
);