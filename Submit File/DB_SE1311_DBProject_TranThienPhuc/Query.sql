--sản phẩm từng loại được mua nhiều nhất trong tháng 11
--1. Pizza
SELECT P.proID, proName, proPrice, sum(detailQuantity) as sumQuantity
FROM Products P, Orders O, OrderDetail D
WHERE P.proID = D.proID AND O.orderID = D.orderID AND proType = 'pizza' AND
	MONTH(createdTime) = 11 AND YEAR(createdTime) = 2018
GROUP BY P.proID, proName, proPrice
HAVING sum(detailQuantity) >= all (
	SELECT sum(detailQuantity)
	FROM Products P, Orders O, OrderDetail D
	WHERE P.proID = D.proID AND O.orderID = D.orderID AND proType = 'pizza' AND
		MONTH(createdTime) = 11 AND YEAR(createdTime) = 2018
	GROUP BY P.proID, proName, proPrice
)

--2. Sides
SELECT P.proID, proName, proPrice, sum(detailQuantity) as sumQuantity
FROM Products P, Orders O, OrderDetail D
WHERE P.proID = D.proID AND O.orderID = D.orderID AND proType = 'sides' AND
	MONTH(createdTime) = 11 AND YEAR(createdTime) = 2018
GROUP BY P.proID, proName, proPrice
HAVING sum(detailQuantity) >= all (
	SELECT sum(detailQuantity)
	FROM Products P, Orders O, OrderDetail D
	WHERE P.proID = D.proID AND O.orderID = D.orderID AND proType = 'sides' AND
		MONTH(createdTime) = 11 AND YEAR(createdTime) = 2018
	GROUP BY P.proID, proName, proPrice
)

--3. Drink
SELECT P.proID, proName, proPrice, sum(detailQuantity) as sumQuantity
FROM Products P, Orders O, OrderDetail D
WHERE P.proID = D.proID AND O.orderID = D.orderID AND proType = 'drinks' AND
	MONTH(createdTime) = 11 AND YEAR(createdTime) = 2018
GROUP BY P.proID, proName, proPrice
HAVING sum(detailQuantity) >= all (
	SELECT sum(detailQuantity)
	FROM Products P, Orders O, OrderDetail D
	WHERE P.proID = D.proID AND O.orderID = D.orderID AND proType = 'drinks' AND
		MONTH(createdTime) = 11 AND YEAR(createdTime) = 2018
	GROUP BY P.proID, proName, proPrice
)

--4. Desserts
SELECT P.proID, proName, proPrice, sum(detailQuantity) as sumQuantity
FROM Products P, Orders O, OrderDetail D
WHERE P.proID = D.proID AND O.orderID = D.orderID AND proType = 'desserts' AND
	MONTH(createdTime) = 11 AND YEAR(createdTime) = 2018
GROUP BY P.proID, proName, proPrice
HAVING sum(detailQuantity) >= all (
	SELECT sum(detailQuantity)
	FROM Products P, Orders O, OrderDetail D
	WHERE P.proID = D.proID AND O.orderID = D.orderID AND proType = 'desserts' AND
		MONTH(createdTime) = 11 AND YEAR(createdTime) = 2018
	GROUP BY P.proID, proName, proPrice
)

--5. Nhân viên duyệt nhiều đơn hàng nhất trong tháng 11
SELECT E.empID, empName, empEmail, count(orderID) as orderQuantity
FROM Employees E, Orders O
WHERE E.empID = O.empID AND MONTH(createdTime) = 11 AND YEAR(createdTime) = 2018
GROUP BY E.empID, empName, empEmail
HAVING count(orderID) >= all (
	SELECT count(orderID) as orderQuantity
	FROM Employees E, Orders O
	WHERE E.empID = O.empID
	GROUP BY E.empID, empName, empEmail
)

--6. Khách mua nhiều đơn hàng nhất trong tháng 11
SELECT C.cusID, cusName, cusPhone, count(orderID) as orderQuantity
FROM Customers C, Orders O
WHERE C.cusID = O.cusID AND MONTH(createdTime) = 11 AND YEAR(createdTime) = 2018
GROUP BY C.cusID, cusName, cusPhone
HAVING count(orderID) >= all (
	SELECT count(orderID) as orderQuantity
	FROM Customers C, Orders O
	WHERE C.cusID = O.cusID AND MONTH(createdTime) = 11 AND YEAR(createdTime) = 2018
	GROUP BY C.cusID, cusName, cusPhone
)

--7. Khách sử dụng nhiều voucher nhất trong tháng 11
SELECT C.cusID, cusName, cusEmail, count(voucherID)
FROM Customers C, Orders O
WHERE C.cusID = O.cusID AND MONTH(createdTime) = 11 AND YEAR(createdTime) = 2018
GROUP BY C.cusID, cusName, cusEmail
HAVING count(voucherID) >= all (
	SELECT count(voucherID)
	FROM Customers C, Orders O
	WHERE C.cusID = O.cusID
	GROUP BY C.cusID, cusName, cusEmail
)

--8. Khách chi nhiều tiền nhất tháng 11
SELECT C.cusID, cusName, cusPhone, sum(totalPrice) as totalPrice
FROM Customers C, Orders O
WHERE C.cusID = O.cusID AND MONTH(createdTime) = 11 AND YEAR(createdTime) = 2018
GROUP BY C.cusID, cusName, cusPhone
HAVING sum(totalPrice) >= all (
	SELECT sum(totalPrice) as totalPrice
	FROM Customers C, Orders O
	WHERE C.cusID = O.cusID AND MONTH(createdTime) = 11 AND YEAR(createdTime) = 2018
	GROUP BY C.cusID, cusName, cusPhone
)

--9. Sản phẩm được mua ít nhất trong tháng 11
SELECT P.proID, proName, proPrice, proType, sum(detailQuantity) as totalQuantity
FROM Products P, OrderDetail D, Orders O
WHERE P.proID = D.proID AND D.orderID = O.orderID AND MONTH(createdTime) = 11 AND YEAR(createdTime) = 2018
GROUP BY P.proID, proName, proPrice, proType
HAVING sum(detailQuantity) <= all (
	SELECT sum(detailQuantity) as totalQuantity
	FROM Products P, OrderDetail D, Orders O
	WHERE P.proID = D.proID AND D.orderID = O.orderID AND MONTH(createdTime) = 11 AND YEAR(createdTime) = 2018
	GROUP BY P.proID, proName, proPrice, proType
)

--10. Sản phẩm không được mua trong tháng 11
SELECT P.proID, proName, proPrice, proType
FROM Products P
WHERE P.proID not in (
	SELECT proID
	FROM OrderDetail D, Orders O
	WHERE D.orderID = O.orderID AND MONTH(createdTime) = 11 AND YEAR(createdTime) = 2018
)

--11. Voucher có số lượng sử dụng nhiều nhất trong tháng 11
SELECT V.voucherID, voucherCode, voucherName, voucherQuantity, count(O.voucherID) as voucherQuantity 
FROM Vouchers V, Orders O
WHERE V.voucherID = O.voucherID AND MONTH(createdTime) = 11 AND YEAR(createdTime) = 2018
GROUP BY V.voucherID, voucherCode, voucherName, voucherQuantity
HAVING count(O.voucherID) >= all (
	SELECT count(O.voucherID) as voucherQuantity 
	FROM Vouchers V, Orders O
	WHERE V.voucherID = O.voucherID AND MONTH(createdTime) = 11 AND YEAR(createdTime) = 2018
	GROUP BY V.voucherID, voucherCode, voucherName, voucherQuantity
)

--12. Voucher có số lượng sử dụng ít nhất trong tháng 11
SELECT V.voucherID, voucherCode, voucherName, voucherQuantity, count(O.voucherID) as voucherQuantity 
FROM Vouchers V, Orders O
WHERE V.voucherID = O.voucherID AND MONTH(createdTime) = 11 AND YEAR(createdTime) = 2018
GROUP BY V.voucherID, voucherCode, voucherName, voucherQuantity
HAVING count(O.voucherID) <= all (
	SELECT count(O.voucherID) as voucherQuantity 
	FROM Vouchers V, Orders O
	WHERE V.voucherID = O.voucherID AND MONTH(createdTime) = 11 AND YEAR(createdTime) = 2018
	GROUP BY V.voucherID, voucherCode, voucherName, voucherQuantity
)

--13. Voucher không được dùng trong tháng 11
SELECT voucherID, voucherCode, voucherName, voucherQuantity
FROM Vouchers
WHERE voucherID not in (
	SELECT V.voucherID
	FROM Vouchers V, Orders O 
	WHERE V.voucherID = O.voucherID AND MONTH(createdTime) = 11 AND YEAR(createdTime) = 2018
)

--14. Voucher nào còn hạn sử dụng
SELECT voucherID, voucherCode, voucherName, voucherQuantity, createdDate, endedDate
FROM Vouchers
WHERE endedDate > GETDATE()

--15. Khách hàng mới order lần đầu trong tháng 11
SELECT C.cusID, cusName, cusAddress
FROM Customers C, Orders O
WHERE C.cusID = O.cusID and createdTime >= '20181101' 
		and C.cusID not in (
			SELECT C.cusID
			FROM Customers C, Orders O
			WHERE C.cusID = O.cusID and createdTime < '20181101'
		)
GROUP BY C.cusID, cusName, cusAddress
HAVING count(orderID) = 1

--16. Khách hàng hủy đơn nhiều nhất
SELECT C.cusID, cusName, cusAddress, count(orderID) as numOfCancel
FROM Customers C, Orders O
WHERE C.cusID = O.cusID and orderStatus = 'canceled'
GROUP BY C.cusID, cusName, cusAddress
HAVING count(orderID) >= all (
	SELECT count(orderID) as numOfCancel
	FROM Customers C, Orders O
	WHERE C.cusID = O.cusID and orderStatus = 'canceled'
	GROUP BY C.cusID, cusName, cusAddress
)

--17. Địa điểm có nhiều order nhất trong tháng 11
SELECT cusAddress, count(orderID) as numOfOrders
FROM Customers C, Orders O
WHERE C.cusID = O.cusID and createdTime >= '20181101'
GROUP BY cusAddress
HAVING count(orderID) >= all (
	SELECT count(orderID) as numOfOrders
	FROM Customers C, Orders O
	WHERE C.cusID = O.cusID and createdTime >= '20181101'
	GROUP BY cusAddress
)

--18. Sản phẩm có số lượng ORDER bị hủy nhiều nhất
SELECT P.proID, proName, proType, count(O.orderID) as numOfOrders
FROM Products P, OrderDetail D, Orders O
WHERE P.proID = D.proID and D.orderID = O.orderID and orderStatus = 'canceled'
GROUP BY P.proID, proName, proType
HAVING count(O.orderID) >= all (
	SELECT count(O.orderID) as numOfOrders
	FROM Products P, OrderDetail D, Orders O
	WHERE P.proID = D.proID and D.orderID = O.orderID and orderStatus = 'canceled'
	GROUP BY P.proID, proName, proType
)

--19. Nhân viên quản lí order bị hủy nhiều nhất
SELECT E.empID, empName, empEmail, count(orderID) as numOfOrders
FROM Employees E, Orders O
WHERE E.empID = O.empID and orderStatus = 'canceled'
GROUP BY E.empID, empName, empEmail
HAVING count(orderID) >= all (
	SELECT count(orderID) as numOfOrders
	FROM Employees E, Orders O
	WHERE E.empID = O.empID and orderStatus = 'canceled'
	GROUP BY E.empID, empName, empEmail
)

--20. Tính tiền thưởng cho nhân viên, nhân viên nào có duyệt nhiều nhất thì thưởng 200, nhiều nhì thì 100, chót thì không
SELECT E.empID, empName, empEmail, count(orderID),
		CASE
			WHEN count(orderID) >= all (
				SELECT count(orderID)
				FROM Employees E, Orders O
				WHERE E.empID = O.empID
				GROUP BY E.empID, empName, empEmail
			) THEN '200 000'
			WHEN count(orderID) >= all (
				SELECT count(orderID)
				FROM Employees E, Orders O
				WHERE E.empID = O.empID
				GROUP BY E.empID, empName, empEmail
				HAVING count(orderID) not in (
					SELECT count(orderID)
					FROM Employees E, Orders O
					WHERE E.empID = O.empID
					GROUP BY E.empID, empName, empEmail
					HAVING count(orderID) >= all (
						SELECT count(orderID)
						FROM Employees E, Orders O
						WHERE E.empID = O.empID
						GROUP BY E.empID, empName, empEmail
					)
				)
			) THEN '100 000'
			ELSE '000 000'
			END
FROM Employees E, Orders O
WHERE E.empID = O.empID
GROUP BY E.empID, empName, empEmail
ORDER BY count(orderID) ASC

--21. Tính tần số voucher sử dụng/tổng order, lớn hơn 0.5 thì trả về high, lớn hơn 0.3, trả về average, thấp hơn trả về low
SELECT V.voucherID, voucherCode, V.createdDate, endedDate, 
		round(count(orderID)*1.0 / (
			SELECT count(orderID)
			FROM Orders
		), 2), 
		CASE
			WHEN count(orderID)*1.0 / (
			SELECT count(orderID)
			FROM Orders
			) >= 0.5 THEN 'HIGH'
			WHEN count(orderID)*1.0 / (
			SELECT count(orderID)
			FROM Orders
			) >= 0.3 THEN 'AVERAGE'	
			ELSE 'LOW'
			END	
FROM Orders O, Vouchers V
WHERE O.voucherID = V.voucherID
GROUP BY V.voucherID, voucherCode, V.createdDate, endedDate

--22. Tính tần số bán ra của sản phẩm có mã là 1 = tổng số lượng / tổng số đơn
SELECT P.proID, proName, proType, 
		round(sum(detailQuantity)*1.0 / (
			SELECT count(O.orderID)
			FROM Products P, OrderDetail D, Orders O
			WHERE P.proID = D.proID and D.orderID = O.orderID and P.proID = 1
		), 2)
FROM Products P, OrderDetail D
WHERE P.proID = D.proID and P.proID = 1
GROUP BY P.proID, proName, proType

--23. Tính tần số pizza mua kèm với cheese
SELECT P.proID, proName , 
		round(sum(detailQuantity)*1.0 / (
			SELECT sum(detailQuantity)
			FROM Products P, OrderDetail D
			WHERE P.proID = D.proID and proType = 'pizza'
		), 2)
FROM Products P, OrderDetail D
WHERE P.proID = D.proID and isCheese = 1
GROUP BY P.proID, proName
ORDER BY round(sum(detailQuantity)*1.0 / (
			SELECT sum(detailQuantity)
			FROM Products P, OrderDetail D
			WHERE P.proID = D.proID
		), 2) DESC

--24. Tìm khách hàng order hơn 2 loại sản phẩm
SELECT C.cusID, cusName, O.orderID, count(detailID)
FROM Customers C, Orders O, OrderDetail D
WHERE C.cusID = O.cusID and O.orderID = D.orderID
GROUP BY C.cusID, cusName, O.orderID
HAVING count(detailID) > 3

--25. Product được order với size lớn nhất nhiều nhất
SELECT P.proID, proName, sum(detailQuantity) as totalQuantity
FROM Products P, OrderDetail D
WHERE P.proID = D.proID and proSize = 12
GROUP BY P.proID, proName
HAVING sum(detailQuantity) >= all (
	SELECT sum(detailQuantity)
	FROM Products P, OrderDetail D
	WHERE P.proID = D.proID and proSize = 12
	GROUP BY P.proID, proName
)