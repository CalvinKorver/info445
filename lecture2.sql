CREATE DATABASE OTTER
USE OTTER

CREATE TABLE tblCUSTOMER_TYPE (
    CustomerTypeID INT IDENTITY(1,1) primary key not null,
    CustomerTypeName varchar(5) not null,
    CustomerTypeDescr varchar(500) not null
)

GO -- Will take the statement above and send it to the server

CREATE TABLE tblCUSTOMER (
    CustomerID INT IDENTITY(1,1) primary key not null,
    CustFName varchar(25) not null,
    CustBirthDate Date not null,
    CustomerTypeID INT FOREIGN KEY REFERENCES tblCUSTOMER_TYPE (CustomerTypeID) not null 
)
GO

CREATE TABLE tblPRODUCT_TYPE(ProductTypeID INT IDENTITY(1,1) Not null,
ProductTypeName varchar(100) not null,
ProductTypeDescr varchar(500) not null,
PRIMARY KEY (ProductTpyeID)

)

-- Product type as a foreign key
ALTER TABLE tblPRODUCT
ADD ProductTypeID INT
FOREIGN KEY REFERENCES tblPRODUCT_TYPE(ProductTypeID)
