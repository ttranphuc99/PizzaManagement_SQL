--1. Nhập mã khách hàng xuất ra tổng tiền khách đã chi
CREATE FUNCTION viewTotalHistoryPrice (@cusID int)
RETURNS float
AS
BEGIN
	RETURN (SELECT sum(totalPrice) FROM Orders WHERE cusID = @cusID)
END

SELECT [dbo].[viewTotalHistoryPrice] (1)

--2. nhập mã voucher xuất ra số lượng voucher đã dùng
CREATE FUNCTION viewCurrentVoucherInUse (@voucherCode nvarchar(50))
RETURNS int
AS
BEGIN
	RETURN (
		SELECT count(voucherID)
		FROM Orders 
		WHERE voucherID = (SELECT voucherID FROM Vouchers WHERE voucherCode = @voucherCode)
	)
END

SELECT [dbo].[viewCurrentVoucherInUse] ('THUBAVUIVE')

--3. nhập mã sản phẩm xuất ra số lượng sản phẩm đã bán được
CREATE FUNCTION viewSaleProduct (@proID int)
RETURNS int
AS
BEGIN
	RETURN (
		SELECT sum(detailQuantity)
		FROM OrderDetail
		WHERE proID = @proID
	)
END

SELECT [dbo].[viewSaleProduct] (22)