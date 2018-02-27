/*



*/

create procedure insertOrder(
    @FName varchar(50),
    @LName varchar(50),
    @DOB varchar(50),
    @PName varchar(50),
    @ODate DATE,
    @Qty int
)
AS
DECLARE @C_ID int
DECLARE @P_ID int

-- SET @C_ID = (SELECT CustID FROM CUSTOMER WHERE FName = @FName and LName = @LName)
-- OR
EXEC uspGetCustomerID @Fname, @Lname, @DOB, @C_ID OUTPUT
EXEC uspGetProductID @PName, @P_ID OUTPUT

IF @C_ID is null
begin print '@C_ID must not be null'
raiserror('error', 11,1)
return END

IF @P_ID is null
begin print '@P_ID must not be null'
raiserror('error', 11,1)
return END

BEGIN TRAN t1
insert into ORDER(P_ID, C_ID, ODate, Qty) VALUES (@P_id, @C_id, @ODate, @Qty)
if @@error <> 0
rollback tran t1
else 
commit tran t1

USE AdventureWorks
GO
SELECT ProductNumber, Category =
        CASE ProductLine
            WHEN 'R' THEN 'Road'
            WHEN 'M' THEN 'Mountain'
            WHEN 'T' THEN 'Touring'
            WHEN 'S' THEN 'Other sale items'
            ELSE 'not for sale'
        END,
    Name 
FROM Production.Production
ORDER BY ProductNumber
GO



/*
•	Create at least one stored procedure that takes in several parameters of friendly names and INSERTs into multiple tables in an explicit transaction with proper error-handling "eg. CREATE NEW CLASS"
•	Create at least one business rule or computed column leveraging a function "if classyear is 2020, only 2 400 level info points"
•	Create at least one stored procedure that calls a second stored procedure (‘nested’ stored procedures) leveraging OUTPUT parameter
•	Create at least one complex view (multiple JOINs, GROUP BY, HAVING, CASE)"write the code to return the list of classes (not the actual classes) by college on west campus year to date CREATE VIEW"
*/


use tweety

create table tweetyOne
(ID1 in identity(1,1) primary key not null,
TweetyOneName varchar(50) not null)
GO


create table tweetyTwo
(ID2 in identity(1,1) primary key not null,
TweetyTwoName varchar(50) not null,
ID1 INt foreign key references tweetyone (ID1) no null)
GO


begin tran t1
INSERT INTO TweetyName
insert into tweetyTwo(TweetyTwoName, ID1)


