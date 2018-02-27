create function fn_totalDollarsCustomer(@custy int)
RETURN INT
AS BEGIN
DECLARE @ret INT
SET @res = 
(SELECT SUM(ProductPrice * o.Quantity) AS TotalSpent FROM tblProduct prod
    JOIN tblBRAND b ON prod.BrandID = b.BrandID
    JOIN tblORDER o ON prod.ProductID = o.ProductID
    JOIN tblCUSTOMER cust ON o.CustomerID = cust.CustomerID
    WHERE b.BrandName = 'Bodum' AND cust.CustomerID = @custy)
Return @ret
END

ALTER TABLE tblCUSTOMER
ADD TotalSpentAmount
AS (dbo.fn_totalDollarsCustomer(CustomerID))