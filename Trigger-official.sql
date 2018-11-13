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

CREATE TRIGGER