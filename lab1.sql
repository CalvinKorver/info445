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


insert into VISIT (DoctorID, PatientID, VisitDate) values (3, 3, '1990-12-30 04:09:31');
insert into VISIT (DoctorID, PatientID, VisitDate) values (1, 5, '1999-09-17 12:09:07');
insert into VISIT (DoctorID, PatientID, VisitDate) values (4, 1, '2003-09-11 22:41:35');
insert into VISIT (DoctorID, PatientID, VisitDate) values (1, 3, '1994-06-03 04:59:00');
insert into VISIT (DoctorID, PatientID, VisitDate) values (3, 4, '1992-06-12 11:19:08');

