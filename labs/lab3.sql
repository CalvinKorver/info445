RESTORE DATABASE Lab3_445_cjkorver FROM DISK = 'C:\SQL\Lab3_445_Template.bak'
WITH 
MOVE 'Lab3_445' TO 'C:\SQL\Lab3_445_cjkorver.mdf',
MOVE 'Lab3_445_log' TO 'C:\SQL\Lab3_445_cjkorver.ldf', RECOVERY, STATS


create procedure uspGetCustID(
	@First varchar(50),
	@Last varchar(50),
	@Birth DATE,
	@Zip int,
	@CustID int output)
	AS
	BEGIN
	set @CustID = (select CustomerID from tblCUSTOMER where CustomerFname = @First
					AND CustomerLname = @Last AND DateOfBirth = @Birth AND CustomerZIP = @Zip)
	return @CustID
	end

create procedure uspGetCustID(
	@ProductName varchar(50),
	@output int output)
	AS
	declare @output int
	BEGIN
	set @output = (select ProductID from tblPRODUCT where ProductName = @productName)
	return @output
	end

 
CREATE PROCEDURE uspInsertOrder
@Fname varchar(60)
@Lname varchar(60)
@DOB Date,
@C_Zip varchar(25)
@Product varchar(100)
@Qty numeric(5,0),
@OrderDate Date 
AS
DECLARE @PID INT
DECLARE @CID INT

IF @OrderDate IS NULL
	BEGIN
	SET @OrderDate = (SELECT GetDate())
	END

EXEC uspGetProdID
@P_Name = @Product,
@P_ID = @PID OUTPUT

EXEC uspGetCustID
@First = @Fname,
@Last = @Lname,
@Birth = @DOB,
@Zip = @C_Zip,
@CustID = @CID OUTPUT

IF @CID IS NULL
	BEGIN
	PRINT '@CID IS NULL and will fail on insert statement; process terminated'
	RAISERROR ('CustomerID variable @CID cannot be NULL', 11,1)
	RETURN
	END

IF @PID IS NULL
	BEGIN
	PRINT '@PID IS NULL and will fail on insert statement; process terminated'
	RAISERROR ('ProductID variable @PID cannot be NULL', 11,1)
	RETURN
	END

BEGIN TRAN G1
INSERT INTO tblORDER (OrderDate, CustomerID, ProductID, Quantity)
VALUES (@OrderDate, @CID, @PID, @Qty)
IF @@ERROR <> 0
	ROLLBACK TRAN G1
ELSE 
	COMMIT TRAN G1


Alter Procedure uspInsertOrder_WRAPPER
@Run INT -- We need this to keep track of the while loop
AS
declare @F varchar(60)
declare @L varchar(60)
declare @B date
declare @ProD varchar(60)
declare @Z int
declare @CustomerID int
declare @ProductID int
declare @C_Count INT
declare @P_Count int
declare @RandomOrderDate DATE
declare @Quant int

SET @C_Count = (SELECT COUNT(*) FROM tblCustomer)
SET @P_Count = (Select COUNT(*) FROM tblProduct)

while @Run > 0
    BEGIN
    SET @ProductID = (SELECT @P_Count * RAND())
    IF @ProductID < 1
        BEGIN PRINT '@ProductID is less than 1'
        SET @ProductID = (SELECT @P_Count * RAND())
        END

    SET @CustomerID = (SELECT @P_Count * RAND())
    IF @CustomerID < 1
        BEGIN PRINT '@CustomerID is less than 1, reassigning'
        SET @CustomerID = (SELECT @C_Count * RAND())
            IF @CustomerID < 1
                BEGIN
                PRINT '@CustomerID is less than 1, reassigning value'
                SET @CustomerID = (SELECT @C_Count * RAND())
                END
        END
    PRINT @Run

    SET @F = (SELECT TOP 1 CustomerFname FROM tblCustomer WHERE CustomerID = @CustomerID)
    SET @L = (SELECT TOP 1 CustomerLname FROM tblCustomer WHERE CustomerID = @CustomerID)
    SET @B = (SELECT TOP 1 DateOfBirth	 FROM tblCustomer WHERE CustomerID = @CustomerID)
	SET @Z = (SELECT TOP 1 CustomerZip FROM tblCUSTOMER where CustomerID = @CustomerID)
    SET @ProD = (SELECT TOP 1 ProductName FROM tblProduct WHERE ProductID = @ProductID)

    SET @RandomOrderDate = (SELECT GetDate() - (4000  * RAND()))

    SET @Quant = (SELECT 6 * Rand() + 1)

    if @ProD is NULL
    begin print '@ProD is null, there is no matching prodCtuName'
    RAISERROR('nulll value for prodName,.... terminating trans', 11,1)
    return END

    exec uspInsertOrder
    @Fname = @F,
    @Lname = @L,
    @DOB = @B,
    @Product = @ProD,
    @OrderDate = @RandomOrderDate,
    @Qty = @Quant,
	@C_Zip = @Z
    SET @Run = @Run - 1
    end


BACKUP DATABASE Lab3_445_cjkorver TO DISK = 'C:\SQL\Lab3_445_cjkorver.bak'
exec uspInsertOrder_WRAPPER 1000
BACKUP DATABASE Lab3_445_cjkorver TO DISK = 'C:\SQL\Lab3_445_cjkorver.bak'
WITH DIFFERENTIAL
BACKUP LOG Lab3_445_cjkorver TO DISK = 'C:\SQL\Lab3_445_cjkorver.bak'

-- Alternate executing the wrapper/synthetic transaction with a number of executions under 100 and taking LOG or DIFFERENTIAL backups (~5 times)

exec uspInsertOrder_WRAPPER 60
BACKUP DATABASE Lab3_445_cjkorver TO DISK = 'C:\SQL\Lab3_445_cjkorver.bak'
WITH DIFFERENTIAL
exec uspInsertOrder_WRAPPER 60
BACKUP DATABASE Lab3_445_cjkorver TO DISK = 'C:\SQL\Lab3_445_cjkorver.bak'
WITH DIFFERENTIAL
exec uspInsertOrder_WRAPPER 60
BACKUP DATABASE Lab3_445_cjkorver TO DISK = 'C:\SQL\Lab3_445_cjkorver.bak'
WITH DIFFERENTIAL
exec uspInsertOrder_WRAPPER 60
BACKUP DATABASE Lab3_445_cjkorver TO DISK = 'C:\SQL\Lab3_445_cjkorver.bak'
WITH DIFFERENTIAL
exec uspInsertOrder_WRAPPER 60
BACKUP DATABASE Lab3_445_cjkorver TO DISK = 'C:\SQL\Lab3_445_cjkorver.bak'
WITH DIFFERENTIAL


DROP DATABASE Lab3_445_cjkorver

RESTORE HEADERONLY FROM DISK = 'C:\SQL\Lab3_445_cjkorver.bak'

RESTORE DATABASE Lab3_445_cjkorver FROM DISK = 'C:\SQL\Lab3_445_cjkorver.bak' WITH FILE = 1, NORECOVERY
RESTORE DATABASE Lab3_445_cjkorver FROM DISK = 'C:\SQL\Lab3_445_cjkorver.bak' WITH FILE = 4, NORECOVERY
RESTORE LOG Lab3_445_cjkorver FROM DISK = 'C:\SQL\Lab3_445_cjkorver.bak' WITH FILE = 5, NORECOVERY
RESTORE LOG Lab3_445_cjkorver FROM DISK = 'C:\SQL\Lab3_445_cjkorver.bak' WITH FILE = 6, RECOVERY, STOPAT = '2018-02-01 16:40:00.000'
