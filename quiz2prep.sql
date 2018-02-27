create table product_type(
    PT_ID int identity(1,1) primary key not null,
    PT_Name varchar(50) not null
)

create table customer(
    C_ID int identity(1,1) primary key not null,
    C_FName varchar(50) not null,
    C_LName varchar(50) not null,
    C_DOB DATE not null

)

create table product(
    P_ID int identity(1,1) primary key not null,
    P_Name varchar(50) not null
    PT_ID int foreign key references product_type(PT_ID) not null
)

create table order(
    O_ID int identity(1,1) primary key not null,
    Quantity int not null,
    O_Date DATE not null,
    P_ID int foreign key references product(P_ID) not null,
    C_ID int foreign key references customer(C_ID) not null
)

insert into product_type(PT_Name) values ("tool");
insert into customer(C_FName, C_LName, C_DOB) VALUES ("Jack", "Johnson", "19950102");

create procedure getCustomerID(
    @CustomerFName varchar(50),
    @CustomerLName varchar(50),
    @CustomerBirthDate DATE,
    @res int OUTPUT)
)
AS
DECLARE @res int
begin
SET @res = (Select C_ID from customer where C_FName = @CustomerFName AND C_LName = @CustomerLName AND C_LName = @CustomerLName)
Return @res
end

create procedure populateOrder(
    @CustomerFName varchar(50),
    @CustomerLName varchar(50),
    @CustomerBirthDate DATE,
    @ProductName varchar(50),
    @Quant int,
    @OrderDate DATE)

    AS

    IF @CustomerLName = "hay" and @CustomerBirthDate between '3/1/1950' AND '4/28/1976' AND @Quant > 2
    begin PRINT "sorry bud"
    Raiserror('customer with fkdjskfjsdkf', 11,1)
    return end

    declare @P_ID int
    declare @C_ID int

    EXEC GetCustID @CustomerFName, @CustomerLName, @CustomerBirthDate, @C_ID OUTPUT
    exec GetProdID @ProductName, @P_ID OUTPUT

    if @C_ID is null
    begin print("sorry, must have a customer id")
    raiserror("Violation", 11, 1)
    return end

    if @P_ID is null
    begin print("sorry must have a proudct id")
    raiserror("violation", 11, 1)
    return end

    begin tran t1
    insert into order(P_ID, C_ID, Quantity, OrderDate) values (@P_ID, @C_ID, @Quant, @OrderDate);
    if @@error <> 0
    rollback tran t1
    else commit tran t1
    