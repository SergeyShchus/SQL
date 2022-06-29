CREATE PROCEDURE dbo.CreateOrder
(
      @CustomerID INT
    , @CustomerNotes NVARCHAR(MAX)
    , @Products XML
)
AS BEGIN

    SET NOCOUNT ON;

    DECLARE @OrderID INT

    INSERT INTO dbo.Orders (CustomerID, CustomerNotes)
    VALUES (@CustomerID, @CustomerNotes)

    SET @OrderID = SCOPE_IDENTITY()

    INSERT INTO dbo.OrderDetails (OrderID, ProductID, Quantity)
    SELECT @OrderID
         , t.c.value('@ProductID', 'INT')
         , t.c.value('@Quantity', 'INT')
    FROM @Products.nodes('items/item') t(c)

END