create procedure uspGetCourseID
@C_Name varchar(30),
@CrID INT OUTPUT
AS
SET @CrID = (SELECT CourseID FROM tblCourse where CourseName = @CourseName)
Return @CrID

create procedure 
@Class varchar(40),
@Year char(4),
@Section char(2),
@Course varchar(40), -- number that is in the time schedule
@Quart varchar(40),
@Room varchar(40),
@Sched varchar(40),
@Format varchar(40),
@Begin DATE
AS 

if @Quart = 'summer' and @Format = 'online'
    Begin   
    print ('hey no summer courses online')
    raiserror('shit', 11,1)
    return
    end

DECLARE @CR_ID INT
declare @Q_ID INT
declare @S_ID INT
declare @R_ID INT
declare @F_ID INT

SET @Q_ID = (SELECT QuarterID FROM tblQuarter where QuarterName = @QuarterName)
SET @S_ID = (SELECT ScheduleID FROM tblSCHEDULE WHERE ScheduleName = @Sched)
SET @R_ID = (SELECT RoomID FROM tblROOM WHERE RoomName = @Room)
SET @F_ID = (SELECT FormatID FROM tblFORMAT WHERE FOrmatName = @Format)

EXEC uspGetCourseID
@C_Name = @Course
@CrID = @CR_ID OUTPUT

if @CR_ID is null
    BEGIN

    PRINT 'course id is null....problem'
    raiserror ('@CR_ID can not be null', 11, 1)
    RETURN 
    END


begin tran t1
insert into COURSE() VALUES ()
if @@error <> 0
rollback tran t1
else
commit tran t1


-- WE DO NOT NEED TO DO NULL CHECK FOR ALLLLL FOREIGN KEYS



-- Business Rules
/* If the class year is 2020, students cannot register for more than ---
*/

create function fnNoMoreThan2_400Level_INFO()
RETURNS INT
AS
BEGIN
    DECLARE @Ret INT = 0
    IF EXISTS( 
        SELECT * FROM tblCOLLEGE c
        JOIN tblDEPARTMENT d ON c.CollegeID = d.CollegeID
        JOIN tblCOURSE cr ON d.DeptID = cr.DeptID
        JOIN tblCLASS cs ON cr.CourseID = CS.CourseID
        JOIN tblCLASS_LIST cl ON cs.CLassID = CL.CLassID
        JOIN tblPERSON_ROLE pr ON cl.PERSONRoleID = pr.PERSONRoleID
        JOIN tblROLE r ON pr.RoleID = r.RoleID
        WHERE r.RoleName = 'Student'
        AND c.CollegeName = 'Information School'
        AND cs.ClassYear = '2020'
        AND cr.CourseName LIKE '%4__'
        GROUP BY cl.PERSONRoleID
        HAVING COUNT(*) > 2
    )
    SET @Ret = 1
    Return @Ret
END
GO

ALTER TABLE tblCLASS_LIST
ADD CONSTRAINT ck_NoInfo400_2020
CHECK (fnNoMoreThan2_400Level_INFO() = 0)



/* write code for view return the list of all colleges and the number of classes that they have held on west campus year to date. minimum 2

*/
create view WestCampus
AS
SELECT CollegeName, Count(*)  AS NumClassesWestCampus
FROM tblCOLLEGE c
join tblDEPARTMENT d on c.CollegeID = d.CollegeID
join tblCourse cr ON d.DeptID = cr.DeptID
join tblClass cs on cr.CourseID = CS.CourseID
WHERE l.LocationName = 'West Campus'
AND YEAR(cs.BeginDate) = YEAR(GetDate())








/*
Extra Credit: Write the code to create a stored 
procedure to populate the PERSON_CONTACT
 table with two new people
  (they do not exist in the PERSON table yet!!)
  with an existing relationship.
*/

CREATE PROCEDURE uspInsertPersonContact
    @Fname1 varchar(40)
    @LName1 varchar(40),
    @NetID1 varchar(40),
    @Gender1 varchar(40),
    @Fname2 varchar(40)
    @LName2 varchar(40),
    @NetID2 varchar(40),
    @Gender2 varchar(40),
    @RelationshipName varchar(40)
    AS
    DECLARE @P1_ID INT
    DECLARE @P2_ID INT
    DECLARE @Gender1_ID INT = (SELECT GenderID FROM GENDER WHERE GenderName = @Gender1)
    DECLARE @Gender2_ID INT = (SELECT GenderID FROM GENDER WHERE GenderName = @Gender2)
    DECLARE @Rel_ID INT


    IF @Gender1_ID is null
    begin print('should not be null')
    raiserror('not good',11,1)
    return END

    INSERT INTO PERSON(FName, LName, NetID, GenderID) 
    VALUES(@Fname1, @Fname2, @Gender1_ID)
    SET @P1_ID = SCOPE_IDENTITY()

    INSERT INTO PERSON(FName, LName, NetID, GenderID)
    VALUES(@Fname2, @Fname2, @Gender2_ID)
    SET @P2_ID = SCOPE_IDENTITY()

    INSERT INTO RELATIONSHIP(RelationshipName) VALUES(@RelationshipName)
    SET @Rel_ID = SCOPE_IDENTITY()

    INSERT INTO PERSON_CONTACT(Person1ID, Person2ID, RelationshipID)
    VALUES(@P1_ID, @P2_ID, @Rel_ID)

    IF ERROR <> 0
    ROLLBACK TRAN t1
    ELSE COMMIT TRAN t1
    

