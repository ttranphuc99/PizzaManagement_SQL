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


