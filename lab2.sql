use [cjkorver_Lab2]


select * from [dbo].[WorkingTable]

declare @PT_ID INT -- Variable to hold output from the uspGetPetType procesdure
declare @C_ID INT
declare @T_ID INT
declare @GenderID INT

declare @ID int -- This will hold min pk
declare @PetName varchar(50)
declare @PetType varchar(50)
declare @Country varchar(50)
declare @Temper varchar(50)
declare @DOB Date
declare @gender varchar(20)
declare @Run INT = (SELECT COUNT(*) FROM WorkingTable)

While @Run >0
BEGIN
SET @ID = (SELECT MIN(PetID) FROM WorkingTable)
SET @PetName = (SELECT PetName FROM WorkingTable WHERE PetID = @ID)
SET @PetType = (SELECT PetType FROM WorkingTable WHERE PetID = @ID)
SET @Country = (SELECT Country FROM WorkingTable WHERE PetID = @ID)
SET @Temper = (SELECT Temperment FROM WorkingTable WHERE PetID = @ID)
SET @dob = (SELECT dob FROM WorkingTable WHERE PetID = @ID)

IF @PetName IS NULL
    BEGIN
    PRINT 'Cannot process pet with no name'
    RAISERROR ('No pet... no processing', 11,1)
    RETURN
    END

exec uspGetPetTypeID
@PetTypeName = @PetType
@PetTypeID = @PT_ID OUTPUT

IF @PT_ID IS NULL
    BEGIN
    PRINT 'PetTypeID is null... this is not good'
    RAISERROR ('code sucks... we are done', 11,1)
    RETURN
    END


BEGIN Tran T1
INSERT INTO tblPet (PetName, PetTypeID, DateOfBirth, TemperamentID, Country)
VALUES (@PetName, @PT_ID, @DOB, @TemperamentID, @Country)
IF @@ERROR <> 0
    ROLLBACK TRAN T1



DELETE FROM WorkingTable WHERE PetID = @ID
SET @Run = @run - 1



SET




SELECT(CASE 
        WHEN State IN ("Claifornia", "Oregon","Idaho")
        THEN "FRIENDLY"
        WHEN State IN ("Michigan", "Ohio","Indiana")
        THEN "BIG TEN"
        WHEN State IN ("Texas", "Oklahoma")
        THEN "BIG 12"
        ELSE "UNKNOWN"
        END
    )
    AS "StateType", COUNT(*) AS "NumStudents"
FROM STUDENT stud
JOIN STUDENT_STATE ss on stud.StudentID == ss.StudentID
JOIN STATE s on s.StateID == stud.StateID

GROUP BY (CASE
    WHEN State IN ("California", "Oregon", "Idaho")
    THEN "Friendly"
    WHEN State IN ("Michigan", "OHIO", "Indiana")
    THEN "Big Ten"
    WHEN State IN ("Texas", "Oklahoma")
    THEN "Big 12"
    ELSE "Unknown"
    END
)
ORDER BY "NumStudents"