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

