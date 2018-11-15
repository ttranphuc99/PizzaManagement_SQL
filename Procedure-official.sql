--1. Nhập mã voucher thì xuất ra thông tin voucher và những khách hàng nào đã sử dụng voucher này
CREATE PROC findVoucherDetail @voucherCode nvarchar(50)
AS
BEGIN
	DECLARE @voucherID int = (SELECT voucherID FROM Vouchers WHERE voucherCode = @voucherCode)

	--get voucher detail
	DECLARE @voucherName nvarchar(50) = (SELECT voucherName FROM Vouchers WHERE voucherCode = @voucherCode)
	DECLARE @voucherQuantity int = (SELECT voucherQuantity FROM Vouchers WHERE voucherCode = @voucherCode)
	DECLARE @createdDate datetime = (SELECT createdDate FROM Vouchers WHERE voucherCode = @voucherCode)
	DECLARE @endedDate datetime = (SELECT endedDate FROM Vouchers WHERE voucherCode = @voucherCode)

	--get current quantity
	DECLARE @curQuantity int = (
		SELECT count(V.voucherID)
		FROM Orders O, Vouchers V
		WHERE O.voucherID = V.voucherID and V.voucherID = @voucherID
	)
	
	PRINT('Voucher Detail')
	PRINT('Voucher ID' +SPACE(5)+ 'Voucher Code' +SPACE(5)+ 'Voucher Name' +SPACE(5)+ 'Voucher Quantity' +SPACE(5)+ 'Voucher Current Quantity' +SPACE(5)+
			'Voucher CreatedDate' + SPACE(5)+ 'Voucher EndedDate')
	PRINT(CONVERT(varchar,@voucherID) +SPACE(5)+ @voucherCode +SPACE(5)+ @voucherName +SPACE(5)+ CONVERT(varchar,@voucherQuantity) +SPACE(5)+
			CONVERT(varchar,@curQuantity) +SPACE(5)+ CONVERT(varchar,@createdDate) +SPACE(5)+ CONVERT(varchar,@endedDate))

	--get Customer use this voucher
	DECLARE @cusID int, @cusName nvarchar(50), @totalPrice float, @createTime datetime, @empID int, @empName nvarchar(50)
	DECLARE ptCusOrder CURSOR FOR SELECT cusID, totalPrice, createdTime, empID FROM Orders WHERE voucherID = @voucherID

	OPEN ptCusOrder
	FETCH NEXT FROM ptCusOrder INTO @cusID, @totalPrice, @createTime, @empID
	PRINT('')
	PRINT('Customer ID' +SPACE(5)+ 'Customer Name' +SPACE(5)+ 'Total Price' +SPACE(5)+ 'Create Time' +SPACE(5)+ 'Employee ID' +SPACE(5)+ 'Employee Name')

	WHILE (@@FETCH_STATUS = 0)
	BEGIN
		SET @cusName = (SELECT cusName FROM Customers WHERE cusID = @cusID)
		SET @empName = (SELECT empName FROM Employees WHERE empID = @empID)

		PRINT(CONVERT(varchar,@cusID) +SPACE(5)+ @cusName +SPACE(5)+ CONVERT(varchar,@totalPrice) +SPACE(5)+ CONVERT(varchar,@createTime) +SPACE(5)+ 
				CONVERT(varchar,@empID) +SPACE(5)+ @empName)

		FETCH NEXT FROM ptCusOrder INTO @cusID, @totalPrice, @createTime, @empID
	END

	CLOSE ptCusOrder
	DEALLOCATE ptCusOrder
END

EXEC findVoucherDetail THUBAVUIVE

--2. Nhập mã khách hàng thì xuất ra lịch sử mua hàng của khách hàng
CREATE PROC viewHistoryOrder @cusID int
AS
BEGIN
	DECLARE @cusName nvarchar(50) = (SELECT cusName FROM Customers WHERE cusID = @cusID)
	PRINT('Customer name: ' + @cusName)

	DECLARE @orderID int, @voucherID int, @totalPrice float, @createdTime datetime, @orderStatus nvarchar(50), @empID int, @empName nvarchar(50)
	DECLARE ptOrder CURSOR FOR SELECT orderID, voucherID, totalPrice, createdTime, orderStatus, empID FROM Orders WHERE cusID = @cusID

	OPEN ptOrder
	FETCH NEXT FROM ptOrder INTO @orderID, @voucherID, @totalPrice, @createdTime, @orderStatus, @empID

	PRINT('Order ID' +SPACE(5)+ 'Voucher ID' +SPACE(5)+ 'Total Price' +SPACE(5)+ 'Created Time' +SPACE(5)+
			'Order Status' +SPACE(5)+ 'Employee ID' +SPACE(5)+ 'Employee Name')

	WHILE (@@FETCH_STATUS = 0)
	BEGIN
		SET @empName = (SELECT empName FROM Employees WHERE empID = @empID)
		if (@voucherID is null) SET @voucherID = 0
		PRINT(CONVERT(varchar, @orderID) +SPACE(5)+ CONVERT(varchar, @voucherID) +SPACE(5)+ CONVERT(varchar, @totalPrice) +SPACE(5)+ CONVERT(varchar, @createdTime) +SPACE(5)+
			@orderStatus +SPACE(5)+ CONVERT(varchar, @empID) +SPACE(5)+ @empName)

		FETCH NEXT FROM ptOrder INTO @orderID, @voucherID, @totalPrice, @createdTime, @orderStatus, @empID
	END

	CLOSE ptOrder
	DEALLOCATE ptOrder
END

EXEC viewHistoryOrder 1

--3. Nhập mã nhân viên thì xuất ra lịch sử duyệt hàng của nhân viên
CREATE PROC viewHistoryConfirm @empID int 
AS
BEGIN
	DECLARE @empName nvarchar(50) = (SELECT empName FROM Employees WHERE empID = @empID)
	PRINT('Employee name: ' + @empName)

	DECLARE @orderID int, @voucherID int, @totalPrice float, @createdTime datetime, @orderStatus nvarchar(50), @cusID int, @cusName nvarchar(50)
	DECLARE ptOrder CURSOR FOR SELECT orderID, voucherID, totalPrice, createdTime, orderStatus, cusID FROM Orders WHERE empID = @empID

	OPEN ptOrder
	FETCH NEXT FROM ptOrder INTO @orderID, @voucherID, @totalPrice, @createdTime, @orderStatus, @cusID

	PRINT('Order ID' +SPACE(5)+ 'Voucher ID' +SPACE(5)+ 'Total Price' +SPACE(5)+ 'Created Time' +SPACE(5)+
			'Order Status' +SPACE(5)+ 'Customer ID' +SPACE(5)+ 'Customer Name')

	WHILE (@@FETCH_STATUS = 0)
	BEGIN
		SET @cusName = (SELECT cusName FROM Customers WHERE cusID = @cusID)
		if (@voucherID is null) SET @voucherID = 0
		PRINT(CONVERT(varchar, @orderID) +SPACE(5)+ CONVERT(varchar, @voucherID) +SPACE(5)+ CONVERT(varchar, @totalPrice) +SPACE(5)+ CONVERT(varchar, @createdTime) +SPACE(5)+
			@orderStatus +SPACE(5)+ CONVERT(varchar, @cusID) +SPACE(5)+ @cusName)

		FETCH NEXT FROM ptOrder INTO @orderID, @voucherID, @totalPrice, @createdTime, @orderStatus, @cusID
	END

	CLOSE ptOrder
	DEALLOCATE ptOrder
END

EXEC viewHistoryConfirm 3

--4. kiểm tra orderdetail hợp lệ
CREATE PROC checkOrderDetail
AS
BEGIN
	DECLARE @proID int, @quantity int, @isCheese bit, @size int, @defaultPrice float, @detailID int
	DECLARE ptDetail CURSOR FOR SELECT proID, detailQuantity, isCheese, proSize, subPrice, detailID FROM OrderDetail

	OPEN ptDetail
	PRINT('ORDERDETAIL INVALID:')

	FETCH NEXT FROM ptDetail INTO @proID, @quantity, @isCheese, @size, @defaultPrice, @detailID

	WHILE (@@FETCH_STATUS = 0)
	BEGIN
		DECLARE @curPrice float = (SELECT proPrice FROM Products WHERE proID = @proID)
		DECLARE @proType nvarchar(20) = (SELECT proType FROM Products WHERE proID = @proID)
		DECLARE @proKind nvarchar(20) = (SELECT proKind FROM Products WHERE proID = @proID)

		if (@proType = 'pizza')
		begin
			--update size
			if (@proKind = 'signature')
			begin
				if (@size = 12) SET @curPrice += 100000
			end
			else if (@proKind = 'premium')
			begin
				if (@size = 9) SET @curPrice += 70000
				else if (@size = 12) SET @curPrice += 150000
			end
			else if (@proKind = 'favorite')
			begin
				if (@size = 9) SET @curPrice += 70000
				else if (@size = 12) SET @curPrice += 60000
			end

			--update cheese
			if (@isCheese = 1) SET @curPrice += 20000 
		end

		SET @curPrice *= @quantity

		if (@curPrice != @defaultPrice) 
		begin
			PRINT('DETAIL ID: ' +CONVERT(varchar,@detailID)+ ' PRICE IN RECORD: ' +CONVERT(varchar,@defaultPrice)+ ' CORRECT PRICE: ' +CONVERT(varchar,@curPrice))
		end 

		FETCH NEXT FROM ptDetail INTO @proID, @quantity, @isCheese, @size, @defaultPrice, @detailID
	END

	CLOSE ptDetail
	DEALLOCATE ptDetail
END

EXEC checkOrderDetail
