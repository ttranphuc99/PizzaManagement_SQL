--cập nhật dữ liệu khi insert OrderDetail
CREATE TRIGGER updateTotalPrice on OrderDetail after insert
AS
BEGIN
	DECLARE @detailID int = (
		SELECT detailID
		FROM inserted
	)

	DECLARE @orderID int = (
		SELECT orderID
		FROM inserted
	)

	DECLARE @proID int = (
		SELECT proID
		FROM inserted
	)

	DECLARE @curPrice float = (
		SELECT proPrice
		FROM Products P join inserted I
		ON P.proID = I.proID
	)

	DECLARE @quantity int = (
		SELECT detailQuantity
		FROM inserted
	)

	DECLARE @isCheese bit = (
		SELECT isCheese
		FROM inserted 
	)

	DECLARE @size int = (
		SELECT proSize
		FROM inserted
	)

	DECLARE @proKind nvarchar(20) = (
		SELECT proKind
		FROM inserted I, Products P
		WHERE I.proID = P.proID
	) 

	DECLARE @proType nvarchar(20) = (
		SELECT proType
		FROM inserted I, Products P
		WHERE I.proID = P.proID
	) 

	DECLARE @flag int = 1

	--check not pizza but have isCheese and proSize
	if (@proType != 'pizza' and (@isCheese is not null or @size is not null)) 
	begin
		print('Not valid product, fail to add order detail')
		SET @flag = 0--ROLLBACK TRAN
	end 
	else
	--update current price 
	begin
		--update current price of pizza
		if (@proType = 'pizza')
		begin
			--update size
			if (@proKind = 'signature')
			begin
				if (@size = 7) 
				begin
					print('Sinature pizza does not have size of 7')
					SET @flag = 0--ROLLBACK TRAN
				end
			end
		end
	end

	if (@flag = 0) 
	begin
		ROLLBACK TRAN
	end
	else 
	begin
		DECLARE @total float = (
			SELECT SUM(subPrice)
			FROM Orders O, OrderDetail D
			WHERE O.orderID = D.orderID and O.orderID = @orderID
		)
		
		DECLARE @voucherID int = (
			SELECT voucherID 
			FROM Orders O, OrderDetail D
			WHERE O.orderID = D.orderID and detailID = @detailID
		)

		DECLARE @percentDiscount float = (
			SELECT percentDiscount
			FROM Vouchers
			WHERE voucherID = @voucherID
		)

		DECLARE @maxDiscount float = (
			SELECT maxDiscount
			FROM Vouchers
			WHERE voucherID = @voucherID
		)

		DECLARE @priceDiscount float = (
			SELECT priceDiscount
			FROM Vouchers
			WHERE voucherID = @voucherID
		)

		if (@voucherID is not null)
		BEGIN
			if (@percentDiscount is not null) 
			BEGIN
				DECLARE @discount float = @total * @percentDiscount
				if (@discount > @maxDiscount) SET @discount = @maxDiscount

				SET @total -= @discount 
			END
			else 
			BEGIN
				if (@total < @priceDiscount) SET @total = 0
				else SET @total -= @priceDiscount
			END
		END	

		UPDATE Orders
		SET totalPrice = @total
		WHERE orderID = @orderID

		
	end
END

--cập nhật dữ liệu khi delete OrderDetail
CREATE TRIGGER deleteOrderDetail ON OrderDetail AFTER DELETE
AS
BEGIN
	DECLARE @detailID int = (
		SELECT detailID
		FROM deleted
	)

	DECLARE @orderID int = (
		SELECT orderID
		FROM deleted
	)

	DECLARE @total float = (
			SELECT SUM(subPrice)
			FROM Orders O, OrderDetail D
			WHERE O.orderID = D.orderID and O.orderID = @orderID
		)
		
	DECLARE @voucherID int = (
		SELECT voucherID 
		FROM Orders O, OrderDetail D
		WHERE O.orderID = D.orderID and detailID = @detailID
	)

	DECLARE @percentDiscount float = (
		SELECT percentDiscount
		FROM Vouchers
		WHERE voucherID = @voucherID
	)

	DECLARE @maxDiscount float = (
		SELECT maxDiscount
		FROM Vouchers
		WHERE voucherID = @voucherID
	)

	DECLARE @priceDiscount float = (
		SELECT priceDiscount
		FROM Vouchers
		WHERE voucherID = @voucherID
	)

	if (@voucherID is not null)
	BEGIN
		if (@percentDiscount is not null) 
		BEGIN
			DECLARE @discount float = @total * @percentDiscount
			if (@discount > @maxDiscount) SET @discount = @maxDiscount
			SET @total -= @discount 
		END
		else 
		BEGIN
			if (@total < @priceDiscount) SET @total = 0
			else SET @total -= @priceDiscount
		END
	END	

	UPDATE Orders
	SET totalPrice = @total
	WHERE orderID = @orderID
END

CREATE TRIGGER updateOrderDetail ON OrderDetail after UPDATE
AS
BEGIN
	DECLARE @detailID int = (
		SELECT detailID
		FROM deleted
	)

	DECLARE @orderID int = (
		SELECT orderID
		FROM deleted
	)

	DECLARE @total float = (
			SELECT SUM(subPrice)
			FROM Orders O, OrderDetail D
			WHERE O.orderID = D.orderID and O.orderID = @orderID
		)
		
	DECLARE @voucherID int = (
		SELECT voucherID 
		FROM Orders O, OrderDetail D
		WHERE O.orderID = D.orderID and detailID = @detailID
	)

	DECLARE @percentDiscount float = (
		SELECT percentDiscount
		FROM Vouchers
		WHERE voucherID = @voucherID
	)

	DECLARE @maxDiscount float = (
		SELECT maxDiscount
		FROM Vouchers
		WHERE voucherID = @voucherID
	)

	DECLARE @priceDiscount float = (
		SELECT priceDiscount
		FROM Vouchers
		WHERE voucherID = @voucherID
	)

	if (@voucherID is not null)
	BEGIN
		if (@percentDiscount is not null) 
		BEGIN
			DECLARE @discount float = @total * @percentDiscount
			if (@discount > @maxDiscount) SET @discount = @maxDiscount
			SET @total -= @discount 
		END
		else 
		BEGIN
			if (@total < @priceDiscount) SET @total = 0
			else SET @total -= @priceDiscount
		END
	END	

	UPDATE Orders
	SET totalPrice = @total
	WHERE orderID = @orderID

	DECLARE @proID int = (
		SELECT proID
		FROM inserted
	)

	DECLARE @curPrice float = (
		SELECT proPrice
		FROM Products P join inserted I
		ON P.proID = I.proID
	)

	DECLARE @quantity int = (
		SELECT detailQuantity
		FROM inserted
	)

	DECLARE @isCheese bit = (
		SELECT isCheese
		FROM inserted 
	)

	DECLARE @size int = (
		SELECT proSize
		FROM inserted
	)

	DECLARE @proKind nvarchar(20) = (
		SELECT proKind
		FROM inserted I, Products P
		WHERE I.proID = P.proID
	) 

	DECLARE @proType nvarchar(20) = (
		SELECT proType
		FROM inserted I, Products P
		WHERE I.proID = P.proID
	) 

	DECLARE @flag int = 1

	--check not pizza but have isCheese and proSize
	if (@proType != 'pizza' and (@isCheese is not null or @size is not null)) 
	begin
		print('Not valid product, fail to add order detail')
		SET @flag = 0--ROLLBACK TRAN
	end 
	else
	--update current price 
	begin
		--update current price of pizza
		if (@proType = 'pizza')
		begin
			--update size
			if (@proKind = 'signature')
			begin
				if (@size = 7) 
				begin
					print('Sinature pizza does not have size of 7')
					SET @flag = 0--ROLLBACK TRAN
				end
			end
		end
	end

	if (@flag = 0) 
	begin
		ROLLBACK TRAN
	end
	else 
	begin
		SET @total = (
			SELECT SUM(subPrice)
			FROM Orders O, OrderDetail D
			WHERE O.orderID = D.orderID and O.orderID = @orderID
		)
		
		SET @voucherID = (
			SELECT voucherID 
			FROM Orders O, OrderDetail D
			WHERE O.orderID = D.orderID and detailID = @detailID
		)

		SET @percentDiscount = (
			SELECT percentDiscount
			FROM Vouchers
			WHERE voucherID = @voucherID
		)

		SET @maxDiscount = (
			SELECT maxDiscount
			FROM Vouchers
			WHERE voucherID = @voucherID
		)

		SET @priceDiscount = (
			SELECT priceDiscount
			FROM Vouchers
			WHERE voucherID = @voucherID
		)

		if (@voucherID is not null)
		BEGIN
			if (@percentDiscount is not null) 
			BEGIN
				SET @discount = @total * @percentDiscount
				if (@discount > @maxDiscount) SET @discount = @maxDiscount

				SET @total -= @discount 
			END
			else 
			BEGIN
				if (@total < @priceDiscount) SET @total = 0
				else SET @total -= @priceDiscount
			END
		END	

		UPDATE Orders
		SET totalPrice = @total
		WHERE orderID = @orderID		
	end
END

--trigger khi insert hoặc update product, nếu là pizza thì description ko đc null, drink và dessert thì proKind phải null
CREATE TRIGGER checkProduct ON Products AFTER INSERT, UPDATE
AS
BEGIN
	DECLARE @proType nvarchar(20) = (SELECT proType FROM inserted)
	DECLARE @proDes nvarchar(max) = (SELECT proDescrt FROM inserted)
	DECLARE @proKind nvarchar(20) = (SELECT proKind FROM inserted)

	DECLARE @flag bit = 0

	if (@proType = 'pizza')
	begin
		if (@proDes is null) SET @flag = 1
	end
	else if (@proType != 'sides')
	begin
		if (@proKind is not null) SET @flag = 1
	end

	if (@flag = 1) 
	begin
		RAISERROR('Invalid Product', 16, 1)
		ROLLBACK TRAN
	end
END