CREATE DATABASE cjkorver_Lab1
GO

USE cjkorver_Lab1
GO

CREATE TABLE DOCTOR(
    DoctorID INT IDENTITY(1,1) primary key not null,
    DoctorFName varchar(50) not null,
    DoctorLName varchar(50) not null,
    DoctorDOB DATE not null,
    DoctorGender varchar(1) not null

)
GO

CREATE TABLE PATIENT(
    PatientID INT IDENTITY(1,1) primary key not null,
    PatientFName varchar(50) not null,
    PatientLName varchar(50) not null,
    PatientDOB DATE not null,
    PatientGender varchar(1) not null
)

CREATE TABLE VISIT(
    VisitID INT IDENTITY(1,1) primary key not null,
    DoctorID INT FOREIGN KEY REFERENCES DOCTOR(DoctorID) not null,
    PatientID INT FOREIGN KEY REFERENCES PATIENT(PatiendID) not null,
    VisitDate DATETIME not null
)

insert into DOCTOR (DoctorFName, DoctorLName, DoctorDOB, DoctorGender) values ('Kele', 'Aspinal', '6/28/1977', 'M');
insert into DOCTOR (DoctorFName, DoctorLName, DoctorDOB, DoctorGender) values ('Mavis', 'Baxter', '11/30/1986', 'F');
insert into DOCTOR (DoctorFName, DoctorLName, DoctorDOB, DoctorGender) values ('Freddi', 'Gherardini', '12/29/1981', 'F');
insert into DOCTOR (DoctorFName, DoctorLName, DoctorDOB, DoctorGender) values ('Gaby', 'Cramb', '1/14/1989', 'M');
insert into DOCTOR (DoctorFName, DoctorLName, DoctorDOB, DoctorGender) values ('Barney', 'Profit', '11/10/1979', 'M');

insert into PATIENT (PatientFName, PatientLName, PatientDOB, PatientGender) values ('Bradney', 'Goddard', '1/30/2001', 'M');
insert into PATIENT (PatientFName, PatientLName, PatientDOB, PatientGender) values ('Clair', 'Sijmons', '6/4/1988', 'M');
insert into PATIENT (PatientFName, PatientLName, PatientDOB, PatientGender) values ('Bellanca', 'Kedwell', '2/27/1986', 'F');
insert into PATIENT (PatientFName, PatientLName, PatientDOB, PatientGender) values ('Allan', 'Cracker', '3/27/2004', 'M');
insert into PATIENT (PatientFName, PatientLName, PatientDOB, PatientGender) values ('Drew', 'Lghan', '2/6/1972', 'M');

-- Create a stored procedure to get the ID of a given doctor,  with DoctorFName and DoctorLName as input parameters and DoctorID as an OUTPUT parameter.

CREATE PROCEDURE uspFindDoctorID
@DoctorFName varchar(25),
@DoctorLName varchar(25)
AS
DECLARE @Res INT

BEGIN TRAN T1

SET @Res = (SELECT DoctorID FROM DOCTOR
WHERE DoctorFName = @DoctorFName AND DoctorLName = @DoctorLName)

RETURN @Res


-- 6) Create a stored procedure to get the ID of a given patient, with PatientFName, PatientLName, and PatientDOB as input parameters and PatientID as an OUTPUT parameter.

CREATE PROCEDURE uspFindPatientID
@PatientFName varchar(25),
@PatientLName varchar(25),
@PatientDOB DATE
AS
DECLARE @Res INT

BEGIN TRAN T1
SET @Res = (SELECT PatientID FROM PATIENT
            WHERE PatientFName = @PatientFName AND PatientLName = @PatientLName AND PatientDOB = @PatientDOB)
RETURN @Res

-- 7) Create a stored procedure to populate the transactional table that tracks visits between doctors and patients with DoctorFName, DoctorLName, PatientFName, PatientLName, PatientDOB and VisitDate as input parameters. This stored procedure should nest the other two stored procedures to get doctor and patient IDs, then insert a single record in an explicit transaction.

CREATE PROCEDURE uspPopulateVisits
@DFName varchar(25),
@DLName varchar(25),
@PFName varchar(25),
@PLName varchar(25),
@PDOB varchar(25),
@VDate DATETIME

AS BEGIN TRAN T1
EXEC @PatientID = uspFindPatientID @PatientFName = @PFName, @PatientLName = @PLName, @PatientDOB =@PDOB OUTPUT

EXEC @DoctorID = uspFindDoctorID @DoctorFName = @DFName, @DoctorLName = @DLName OUTPUT

INSERT INTO VISIT(DoctorID, PatientID, VisitDate) VALUES(@DoctorID, @PatientID, @VDate)

IF @@ERROR <> 0
	ROLLBACK TRAN
ELSE
	COMMIT TRAN
GO

