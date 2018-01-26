use [cjkorver_Lab2]


select * from [dbo].[WorkingTable]

declare @id int -- This will hold min pk
declare @petName varchar(50)
declare @petType varchar(50)
declare @Country varchar(50)
declare @temper varchar(50)
declare @dob Date
declare @gender varchar(20)
declare @Run INT = (SELECT COUNT(*) FROM WorkingTable)

While @Run >0
BEGIN



SET