create procedure uspInsertEmployeeLocation
@Street_Add varchar(40),
@City varchar(40),
@Fname varchar(40),
@Lname varchar(40)
AS
DECLARE @E_ID int = (SELECT EmployeeID FROM tblEMPLOYEE WHERE Fname = @Fname AND Lname = @Lname)
DECLARE @L_ID int = (SELECT LocationID FROM tblLOCATION WHERE StreetAddress = @Street_Add AND City = @City)

IF @E_ID is null
begin print '@E_ID is null there is no matching name'
raiserror('nulllll',11,1)
return end

IF @L_ID is null
begin print '@L_ID is null there is no matching name'
raiserror('l id is nulllll,',11,1)
return end

insert into tblEMPLOYEE_LOCATION(EmployeeID, LocationID) VALUES (@E_ID, @L_ID)
IF @@error <> 0
ROLLBACK Tran T1
else commit tran T1



CREATE PROCEDURE uspInsertEmployeeLocation_WRAPPER
@RUN int
AS
declare @E_ID int -- Employee ID
declare @L_ID int -- Location ID
declare @E_TableSize int
declare @L_TableSize int
declare @L_Rand int

declare @F varchar(40)
declare @L varchar(40)
declare @SA varchar(40)
declare @C varchar(40)

While @RUN > 0
    BEGIN

    -- Get Employee random ID --
    SET @E_TableSize = (SELECT COUNT(*) FROM tblEMPLOYEE)
    SET @E_ID = (SELECT RAND() * @E_TableSize)
    IF @E_ID < 1
        BEGIN PRINT 'Employee ID is less than 1'
        SET @E_ID = (SELECT RAND() * @E_TableSize)
        END

    -- Get Location random ID --
    SET @L_TableSize = (SELECT COUNT(*) FROM tblLOCATION)
    SET @L_ID= (SELECT RAND() * @L_TableSize)
    IF @L_ID < 1
        BEGIN PRINT 'Employee ID is less than 1'
        SET @L_ID = (SELECT RAND() * @L_TableSize)
        END

    PRINT @RUN

    SET @F = (SELECT TOP 1 Fname FROM tblEMPLOYEE WHERE EmployeeID = @E_ID)
    SET @L = (SELECT TOP 1 Lname FROM tblEMPLOYEE WHERE EmployeeID = @E_ID)
    SET @SA = (SELECT TOP 1 StreetAddress FROM tblLOCATION WHERE LocationID = @L_ID)
    SET @C = (SELECT TOP 1 City FROM tblLOCATION WHERE LocationID = @L_ID)

    exec uspInsertEmployeeLocation
    @Street_Add = @SA,
    @City = @C,
    @Fname = @F,
    @Lname = @L

    SET @Run = @Run - 1
    end