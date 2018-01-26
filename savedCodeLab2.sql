/*

INSERT INTO PET_TYPE SELECT Distinct(PET_TYPE) FROM RAW_PetData
INSERT INTO GENDER select DISTINCT(GENDER) FROM RAW_PetData
INSERT INTO TEMPERAMENT select DISTINCT(TEMPERAMENT) FROM RAW_PetData
INSERT INTO COUNTRY select DISTINCT(COUNTRY) FROM RAW_PetData


USE [cjkorver_Lab2]
GO

/****** Object:  Table [dbo].[RAW_PetData]    Script Date: 1/25/2018 2:26:58 PM ******/
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


create procedure uspGetPetTypeID(
@PetTypeName varchar(50))
AS
declare @PetTypeID INT
begin tran t1
SET @PetTypeID = (SELECT PetTypeID FROM PET_TYPE WHERE PetTypeName = @PetTypeName)
RETURN @PetTypeID

create procedure uspGetTempID(
@TempName varchar(50))
AS
declare @TempID INT
begin tran t1
SET @TempID = (SELECT TempID FROM TEMPERAMENT WHERE TempName = @TempName)
RETURN @TempID

create procedure uspGetCountryID(
	@CountryName varchar(50)
)
AS declare @CountryID INT
begin tran t1
SET @CountryID = (SELECT CountryID FROM COUNTRY WHERE CountryName = @CountryName)
RETURN @CountryID

*/

create procedure uspGetGenderID(
	@GenderName varchar(50)
)
AS declare @GenderID INT
begin tran t1
SET @GenderID = (SELECT GenderID FROM GENDER WHERE GenderName = @GenderName)
Return @GenderID



