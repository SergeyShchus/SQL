CREATE PROCEDURE dbo.GetCustomerID
(
      @FullName NVARCHAR(150)
    , @Email VARCHAR(50)
    , @Phone VARCHAR(50)
    , @CustomerID INT OUT
)
AS BEGIN

    SET NOCOUNT ON;

    SELECT @CustomerID = CustomerID
    FROM dbo.Customers
    WHERE Email = @Email

    IF @CustomerID IS NULL BEGIN

        INSERT INTO dbo.Customers (FullName, Email, Phone)
        VALUES (@FullName, @Email, @Phone)

        SET @CustomerID = SCOPE_IDENTITY()

    END

END