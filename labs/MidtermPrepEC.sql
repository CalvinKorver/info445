create procedure uspPopulateClass
    @ClassName varchar(50),
    @ClassYear DATE,
    @Section varchar(50),
    @CourseName varchar(50),
    @QuarterName varchar(50),
    @RoomName varchar(50),
    @ScheduleName varchar(50),
    @FormatName varchar(50)
    @BeginDate DATE
AS
DECLARE @CourseID INT
DECLARE @QuarterID INT
DECLARE @RoomID INT
DECLARE @ScheduleID INT
DECLARE @FormatID INT

SET @CourseID = (select CourseID where CourseName = @CourseName)
set @QuarterID = (select QuarterID where QuarterName = @QuarterName)
set @RoomID = (select RoomID where RoomName = @RoomName)
set @ScheduleID = (select ScheduleID where ScheduleName = @ScheduleName)
set @FormatID = (select FormatID where FormatName = @FormatName)

if @CourseID is null
begin print 'id shouldnt be null bro'
raiserror('Transaction can not continue due to null id', 11,1)
return end

if @QuarterID is null
begin print 'id shouldnt be null bro'
raiserror('Transaction can not continue due to null id', 11,1)
return end

if @RoomID is null
begin print 'id shouldnt be null bro'
raiserror('Transaction can not continue due to null roomid', 11,1)
return end

if @ScheduleID is null
begin print 'id shouldnt be null bro'
raiserror('Transaction can not continue due to null scheduleid', 11,1)
return end

if @FormatID is null
begin print 'id shouldnt be null bro'
raiserror('Transaction can not continue due to null  formatid', 11,1)
return end

begin tran t1
insert into CLASS(ClassName, ClassYear, Section, CourseID, QuarterID, RoomID, ScheduleID, FormatID, BeginDate) values (@ClassName, @ClassYear, @Section, @CourseID, @QuarterID, @RoomID, @ScheduleID , @FormatID, BeginDate)

if @@error <> 0
rollback tran t1
else 
commit tran t1

/*
Write code for the business rule: If the class year is 2020, 
students cannot register for more than two 400-level info courses.
*/
create function myRule()
Returns INT
AS
Begin
DECLARE @ret INT = 0

IF exists (Select COUNT(c.ClassID) FROM CLASS c
            JOIN CLASS_LIST cl on c.ClassID = cl.ClassID
            JOIN PERSON_ROLE pr ON cl.PersonRoleID = pr.PersonRoleID
            JOIN PERSON p ON pr.PersonID = p.PersonRoleID
            JOIN ROLE r on pr.RoleID = r.RoleID
            JOIN COURSE crs ON c.CourseID = crs.CourseID
            JOIN DEPARTMENT d ON crs.DeptID = d.DeptID
            WHERE d.DeptName = 'INFO'
            AND YEAR(c.ClassYear) = '2020'
            AND r.RoleName = 'student'
            HAVING crs.CourseName like '%400%')
    SEt @ret = 1
Return @ret
END

/*
-- REMEMBER --
select
where
group by 
having
order by


Write code to create the following report in a view: 
Return the list of all colleges and the number of 
classes they have held on West Campus year-to-date. 
Minimum of 2 classes.
*/

CREATE VIEW 'myView'
AS SELECT college.CollegeName, COUNT(c.ClassID) FROM COLLEGE college 
JOIN DEPARTMENT d ON c.CollegeID = d.DepartmentID
JOIN COURSE c ON d.DeptID = c.DeptID
JOIN CLASS class ON c.CourseID = class.CourseID
join ROOM r ON c.RoomID = r.RoomID
join BUILDING b on r.BuildingID = b.BuildingID
join LOCATION l on b.LocationID = l.LocationID
WHERE l.LocationName = 'West Campus'
AND c.ClassYear = '2018'
HAVING COUNT(c.ClassID) > 2;



select
where
group by 
having
order by

SWGHO

SELECT WHERE GROUPBY HAVING ORDER BY