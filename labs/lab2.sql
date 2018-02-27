use cjkorver_Lab2


-- CREATE TABLE STATEMENTS
CREATE TABLE PET_TYPE(
    PetTypeID INT IDENTITY(1,1) PRIMARY KEY,
    PetTypeName varchar(50)
);
CREATE TABLE COUNTRY(
    CountryID INT IDENTITY(1,1) PRIMARY KEY,
    CountryName varchar(50)
);
CREATE TABLE GENDER(
    GenderID INT IDENTITY(1,1) PRIMARY KEY,
    GenderName varchar(50)
);
CREATE TABLE TEMPERAMENT(
    TempID INT IDENTITY(1,1) PRIMARY KEY,
    TempName varchar(50)
);

-- INSERT INTO LOOKUP TABLES
INSERT INTO PET_TYPE SELECT Distinct(PET_TYPE) FROM RAW_PetData
INSERT INTO GENDER select DISTINCT(GENDER) FROM RAW_PetData
INSERT INTO TEMPERAMENT select DISTINCT(TEMPERAMENT) FROM RAW_PetData
INSERT INTO COUNTRY select DISTINCT(COUNTRY) FROM RAW_PetData

-- STORED PROCEDURE 1
create procedure uspGetPetTypeID(
@PetTypeName varchar(50),
@res int output)
begin tran t1
SET @res = (SELECT PetTypeID FROM PET_TYPE WHERE PetTypeName = @PetTypeName)
return

-- STORED PROCEDURE 2
create procedure uspGetTempID(
@TempName varchar(50),
@res int output)
AS
SET @res = (SELECT TempID FROM TEMPERAMENT WHERE TempName = @TempName)
return

-- STORED PROCEDURE 3
create procedure uspGetCountryID(
	@CountryName varchar(50),
@res int output)
AS
SET @res = (SELECT CountryID FROM COUNTRY WHERE CountryName = @CountryName)
return

-- STORED PROCEDURE 4
create procedure uspGetGenderID(
	@GenderName varchar(50),
@res int output)
AS
SET @res = (SELECT GenderID FROM GENDER WHERE GenderName = @GenderName)
return

-- CREATE RAW TABLE WITH PRIMARY KEYS FOR COPYING
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[RAW_PetData_PK](
	[PK_ID] [int] identity(1,1),
	[PETNAME] [nvarchar](255) NULL,
	[PET_TYPE] [nvarchar](255) NULL,
	[TEMPERAMENT] [nvarchar](255) NULL,
	[COUNTRY] [nvarchar](255) NULL,
	[DATE_BIRTH] [datetime] NULL,
	[GENDER] [nvarchar](255) NULL
) ON [PRIMARY]
insert into RAW_PetData_PK(PetName, Pet_Type, Temperament, Country, Date_Birth, Gender)
select PetName, Pet_Type, Temperament, Country, Date_Birth, Gender FROM RAW_PetData
GO

DELETE FROM PET_TYPE WHERE PetTypeName is null;

-- CODE TO  POPULATE THE PET TABLE USING SPROCS WITH WHILE LOOPS ETC.
select * from [dbo].[RAW_PetData_PK]
declare @PT_ID INT -- Variable to hold output from the uspGetPetType procesdure
declare @C_ID INT
declare @T_ID INT
declare @G_ID INT
declare @TemperamentID INT

declare @ID int -- This will hold min pk
declare @PetName varchar(50)
declare @PetType varchar(50)
declare @Country varchar(50)
declare @Temper varchar(50)
declare @DOB Date
declare @gender varchar(20)
declare @Run INT = (SELECT COUNT(*) FROM RAW_PetData_PK)
SELEcT * FROM RAW_PetData_PK
While @Run >0

BEGIN
	SET @ID = (SELECT MIN(PK_ID) FROM RAW_PetData_PK)
	SET @PetName = (SELECT PetName FROM RAW_PetData_PK WHERE PK_ID = @ID)
	SET @PetType = (SELECT Pet_Type FROM RAW_PetData_PK WHERE PK_ID = @ID)
	SET @Country = (SELECT Country FROM RAW_PetData_PK WHERE PK_ID = @ID)
	SET @Temper = (SELECT TEMPERAMENT FROM RAW_PetData_PK WHERE PK_ID = @ID)
	SET @dob = (SELECT DATE_BIRTH FROM RAW_PetData_PK WHERE PK_ID = @ID)
	SET @gender = (SELECT GENDER FROM RAW_PetData_PK WHERE PK_ID = @ID)

	IF @PetName IS NULL OR @PetType is null OR @Temper is null OR @Country is null OR @DOB is null or @gender is null
	   BEGIN
	   PRINT 'Cannot process pet with missing specifications'
	   RAISERROR ('No pet... no processing', 11,1)
	   RETURN
	   END



	exec uspGetPetTypeID @PetType,
	@PT_ID  OUTPUT
	IF @PT_ID IS NULL
	   BEGIN
	   PRINT @PetType
	   RAISERROR ('code sucks... we are done', 11,1)
	   RETURN
	   END

	exec uspGetTempID @Temper,
	@T_ID OUTPUT
	IF @T_ID IS NULL
	   BEGIN
	   PRINT 'T_ID is null... this is not good'
	   RAISERROR ('code sucks... we are done', 11,1)
	   RETURN
	   END

	exec uspGetCountryID @Country,
	@C_ID OUTPUT
	IF @C_ID IS NULL
	   BEGIN
	   PRINT 'C_ID is null... this is not good'
	   RAISERROR ('code sucks... we are done', 11,1)
	   RETURN
	   END

	exec uspGetGenderID @Gender,
	@G_ID OUTPUT
	IF @G_ID IS NULL
	   BEGIN
	   PRINT 'G_ID is null... this is not good'
	   RAISERROR ('code sucks... we are done', 11,1)
	   RETURN
	   END


	BEGIN Tran T1
	INSERT INTO PET(PetTypeID, CountryID, TempID, DOB, GenderID, PetName)
	VALUES (@PT_ID, @C_ID, @T_ID, @DOB, @G_ID, @PetName)
	IF @@ERROR <> 0
	   ROLLBACK TRAN T1
	else
		commit tran t1

	DELETE FROM RAW_PetData_PK WHERE PK_ID = @ID
	SET @Run = @run - 1
END