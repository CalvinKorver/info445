/*
1. Diagram and write the DDL to create a database with the following 4 entities 
CUSTOMER
PRODUCT
PRODUCT_TYPE
ORDER
*/
create db quiz2 GO
USE quiz2 GO;

create table PROD_TYPE(
    @PT_ID int identity(1,1) primary key not null,
    @PT_Name varchar(40) not null
);

create table CUST(
    @C_ID int identity(1,1) primary key not null,
    @CFname varchar(40) not null,
    @CLname varchar(40) not null,
    @DOB DATE not null
);

create table PROD(
    @P_ID int identity(1,1) primary key not null,
    @PName varchar(40) not null,
    @PT_ID int foreign key references PROD_TYPE(PT_ID) not null
);

create table ORDER(
    @O_ID int identity(1,1) primary key not null,
    @P_ID int foreign key references PROD(P_ID) not null,
    @C_ID int foreign key references CUST(C_ID) not null,
    @Quant int not null,
    @ODate DATE not null
);


/*
2. Write the SQL code to populate each lookup table with three rows each
*/

insert into PROD_TYPE(PT_Name) VALUES
    ('tent'),
    ('weapon'),
    ('shoes');

insert into CUST(CFname,CLname,DOB) VALUES 
    ('jack', 'johnson', '2011-12-01'),
    ('bilbo', 'baggins', '1993-02-12'),
    ('frodo', 'gamgee', '1663-02-42');

insert into PROD(PName, PT_ID) VALUES 
    ('Longsword', (SELECT PT_ID FROM PROD_TYPE WHERE PT_Name = 'weapon')),
    ('Boots', (SELECT PT_ID FROM PROD_TYPE WHERE PT_Name = 'shoes')),
    ('super zip', (SELECT PT_ID FROM PROD_TYPE WHERE PT_Name = 'tent'));


/*
Write the SQL code to create two 'GetID' stored procedures
    a. uspGetCustomerID with parameters Fname, Lname, and BirthDay
    b. uspGetProductID with parameter ProductName
*/


/*
inquire about SYNTAX from https://docs.microsoft.com/en-us/sql/connect/jdbc/using-a-stored-procedure-with-output-parameters
*/
create procedure uspGetCustomerID
    @Fname varchar(40),
    @Lname varchar(40),
    @BirthDay varchar(40),
    @ID int OUTPUT
    AS
    SET @ID = (SELECT C_ID FROM CUSTOMER WHERE CFname = @Fname AND CLname = @Lname)
    return


create procedure uspGetProductID
    @ProductName varchar(40),
    @res int OUTPUT
    AS
    SET @res = (SELECT P_ID FROM PRODUCT WHERE ProductName = @ProductName)
    return

        




=if(
    and(not(ISBLANK(F5)), not(ISBLANK(H5)), not(ISBLANK(J5))), 30,
    if(and(not(ISBLANK(F5)), not(ISBLANK(H5)) )) , 25, 20))