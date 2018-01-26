use [cjkorver_Lab2]

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

While @Run >0

BEGIN
	SET @ID = (SELECT MIN(PetID) FROM RAW_PetData_PK)
	SET @PetName = (SELECT PetName FROM RAW_PetData_PK WHERE PetID = @ID)
	SET @PetType = (SELECT PetType FROM RAW_PetData_PK WHERE PetID = @ID)
	SET @Country = (SELECT Country FROM RAW_PetData_PK WHERE PetID = @ID)
	SET @Temper = (SELECT Temperment FROM RAW_PetData_PK WHERE PetID = @ID)
	SET @dob = (SELECT dob FROM RAW_PetData_PK WHERE PetID = @ID)

	IF @PetName IS NULL
	   BEGIN
	   PRINT 'Cannot process pet with no name'
	   RAISERROR ('No pet... no processing', 11,1)
	   RETURN
	   END

	exec uspGetPetTypeID
	@PetTypeName = @PetType
	@PT_ID = @PT_ID OUTPUT

	exec uspGetTempID
	@TempName = @Temper
	@TemperamentID = @TempID OUTPUT

	exec uspGetCountryID
	@CountryName = @Country
	@C_ID = @CountryID OUTPUT

	exec uspGetGenderID
	@GenderName = @GenderID
	@G_ID = @GenderID OUTPUT

	IF @PT_ID IS NULL
	   BEGIN
	   PRINT 'PetTypeID is null... this is not good'
	   RAISERROR ('code sucks... we are done', 11,1)
	   RETURN
	   END


	BEGIN Tran T1
	INSERT INTO PET(PetName, PetTypeID, DateOfBirth, TemperamentID, Country, Gender)
	VALUES (@PetName, @PT_ID, @DOB, @T_ID, @C_ID, G_ID)
	IF @@ERROR <> 0
	   ROLLBACK TRAN T1



	DELETE FROM RAW_PetData_PK WHERE PetID = @ID
	SET @Run = @run - 1
END