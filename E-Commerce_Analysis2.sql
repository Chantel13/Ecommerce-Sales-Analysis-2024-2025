E-COMMERCE PROJECT ANALYSIS

OBJECTIVE: **Objective:** To analyse e-commerce performance using SQL, evaluate year-on-year changes in sales, customer acquisition, and purchasing behaviour, and identify key business trends and opportunities for improvement.

TOOLS: SQL Server, SSMS

AUTHOR: MS MNYONI, CHANTEL

1. DATA OVERVIEW

-- Check number of Customers
	SELECT COUNT(*) AS TotalCustomers
	FROM Customers;

-- Check number of Order_Items
	SELECT COUNT(*) AS TotalOrderItems
	FROM Order_Items;

-- Check number of Orders
	SELECT COUNT(*) AS TotalOrders
	FROM Orders;

-- Check number of Payments
	SELECT COUNT(*) AS TotalPayments
	FROM Payments;

-- Check number of Products
	SELECT COUNT(*) AS TotalProducts
	FROM Products;

-- Check number of Shipping
	SELECT COUNT(*) AS TotalShipping
	FROM Shipping;

2. DATA QUALITY CHECKS

--Check for duplicate customers 
SELECT 
	CustomerID, 
	COUNT(*) NumberOfCustomers 
FROM Customers 
GROUP BY CustomerID 
HAVING COUNT(*) > 1; 

--Check for SignupDates greater than 2025 but less than 2024 
SELECT 
	SignupDate 
FROM Customers 
WHERE SignupDate <= '2024/01/01'
AND SignupDate > '2026/01/01';

--Check for NULL signup dates
SELECT 
    CustomerID,
    SignupDate
FROM Customers 
WHERE SignupDate IS NULL;

--Check for duplicate products  
SELECT 
	ProductID, 
	COUNT(*) NumberOfProducts 
FROM Products  
GROUP BY ProductID  
HAVING COUNT(*) > 1; 

--Check for unit prices less than 0 
SELECT 
    UnitPrice 
FROM Products 
WHERE UnitPrice < 0; 

--Check for duplicate payments  
SELECT 
	PaymentID, 
	COUNT(*) NumberOfPayments 
FROM Payments  
GROUP BY PaymentID 
HAVING COUNT(*) > 1; 

--Check for amounts less than 0 
SELECT
    PaymentID,
    Amount 
FROM Payments 
WHERE Amount < 0;

--Check for Payment Dates greater than 2025 but less than 2024 
SELECT 
	PaymentDate 
FROM Payments 
WHERE PaymentDate <= '2024/01/01'
AND PaymentDate > '2026/01/01';

--Check for NULL payment dates
SELECT 
    PaymentID,
    PaymentDate
FROM Payments 
WHERE PaymentDate IS NULL;

--Check for NULL payment dates
SELECT 
    PaymentID,
    Amount
FROM Payments 
WHERE Amount IS NULL;

--Check for duplicate shippings  
SELECT 
	ShippingID, 
	COUNT(*) NumberOfShippings 
FROM Shipping 
GROUP BY ShippingID  
HAVING COUNT(*) > 1;

--Check for Delivery dates that occur before the Ship Date  
SELECT 
	DeliveryDate, 
	ShipDate 
FROM Shipping  
WHERE DeliveryDate < ShipDate
AND DeliveryDate <> '2025/02/30';

--Check for NULL delivery dates
SELECT 
    ShippingID,
    DeliveryDate
FROM Shipping 
WHERE DeliveryDate IS NULL;

--Check for NULL ship dates
SELECT 
    ShippingID,
    ShipDate
FROM Shipping 
WHERE ShipDate IS NULL;

--Check for duplicate orders 
SELECT 
	OrderID, 
	COUNT(*) NumberOfOrders 
FROM Orders  
GROUP BY OrderID  
HAVING COUNT(*) > 1; 

--Check for Order Dates greater than 2025 but less than 2024 
SELECT 
	OrderDate 
FROM Orders 
WHERE OrderDate <= '2024/01/01'
AND OrderDate > '2026/01/01'

--Check for NULL order dates
SELECT
    OrderID,
    OrderDate 
FROM Orders 
WHERE OrderDate IS NULL;

--Check for duplicate orderitems  
SELECT 
	OrderItemID, 
	COUNT(*) NumberOfOrderItems 
FROM Order_Items  
GROUP BY OrderItemID  
HAVING COUNT(*) > 1; 

--Check for quantity values less than 0 
SELECT 
    OrderItemID,
    Quantity 
FROM Order_Items 
WHERE Quantity < 0;

--Check for quantity values less than 0 
SELECT 
    UnitPrice 
FROM Order_Items 
WHERE UnitPrice < 0;

--Check for NULL quantity values
SELECT 
    OrderItemID,
    Quantity 
FROM Order_Items 
WHERE Quantity IS NULL;

3. CUSTOMER ACQUISITION AND BEHAVIOUR
--How has the number of new customers signups changed monthly from January 2024 to December 2025

SELECT
	YEAR(SignupDate) Year,
	DATENAME(Month,SignupDate) Month,
	COUNT(*) NumberOfNewCustomers
FROM Customers
WHERE SignupDate IS NOT NULL
	AND SignupDate >= '2024/01/01'
	AND SignupDate < '2026/01/01'
GROUP BY
	YEAR(SignupDate),
	DATENAME(Month, SignupDate),
	MONTH(SignupDate)
ORDER BY Year, MONTH(SignupDate);

-- On average, how many days does it take customers to place their first order after signing up

WITH FirstOrderDate AS
(
    SELECT
        c.CustomerID,
        c.SignupDate,
        MIN(o.OrderDate) AS FirstOrder
    FROM Customers c
    JOIN Orders o
        ON c.CustomerID = o.CustomerID
    WHERE c.SignupDate IS NOT NULL
      AND o.OrderDate IS NOT NULL
      AND o.OrderDate >= c.SignupDate
    GROUP BY
        c.CustomerID,
        c.SignupDate
)
SELECT
    AVG(CAST(DATEDIFF(DAY, SignupDate, FirstOrder)
        AS DECIMAL(10,2))) AS AverageDaysToFirstOrder
FROM FirstOrderDate;

4. SALES AND REGIONAL PERFORMANCE

-- What is the total sales revenue by quarter, and how has it changed over time

SELECT
	YEAR(o.OrderDate) Year,
	DATEPART(QUARTER, o.OrderDate) Quarter,
	SUM(oi.Quantity * oi.UnitPrice) TotalSales
FROM Customers c
JOIN Orders o
	ON c.customerID = o.customerID
JOIN Order_Items oi
	ON o.orderID = oi.orderID
WHERE YEAR(o.OrderDate) IS NOT NULL
	AND DATENAME(QUARTER, o.OrderDate) IS NOT NULL
GROUP BY
	YEAR(o.OrderDate),
	DATEPART(QUARTER, o.OrderDate)
ORDER BY Year, Quarter;

-- How does the total number of orders placed by new customers differe from existing customers, and what is their average order value 

SELECT
	CASE 
		WHEN YEAR(c.SignupDate) = 2025 
		THEN 'New Customer' 
		ELSE 'Existing Customer' 
	END AS CustomerType,
	COUNT(o.OrderID) NumberOfOrders,
	SUM(oi.Quantity * oi.UnitPrice) * 1.0
    / COUNT(DISTINCT o.OrderID) AS AverageOrderValue
FROM Customers c
	JOIN Orders o
ON c.customerid = o.customerid
	JOIN Order_Items oi
ON o.orderid = oi.orderid
WHERE o.OrderDate >= '2025/01/01'
  AND o.OrderDate < '2026/01/01'
GROUP BY
	CASE WHEN YEAR(c.SignupDate) = 2025 
		THEN 'New Customer' 
			ELSE 'Existing Customer' END;

-- Total number of orders placed in each year

SELECT
    YEAR(OrderDate) AS OrderYear,
    COUNT(DISTINCT OrderID) AS NumberOfOrders
FROM Orders
WHERE OrderDate >= '20240101'
  AND OrderDate < '20260101'
GROUP BY YEAR(OrderDate)
ORDER BY OrderYear;

-- Average order value

SELECT
    YEAR(OrderDate) AS OrderYear,
	SUM(oi.Quantity * oi.UnitPrice) * 1.0 /
    COUNT(DISTINCT o.OrderID) AS NumberOfOrders
FROM Orders o
	JOIN Order_Items oi
ON o.orderid = oi.orderid
WHERE OrderDate >= '20240101'
  AND OrderDate < '20260101'
GROUP BY YEAR(OrderDate)
ORDER BY OrderYear;

-- How does the total sales revenue, number of orders, and average order value differ by province

SELECT
    c.Province,
    COUNT(DISTINCT o.OrderID) AS TotalOrders,
    SUM(oi.Quantity * oi.UnitPrice) AS TotalRevenue,
    CAST(
        SUM(oi.Quantity * oi.UnitPrice) * 1.0
        / NULLIF(COUNT(DISTINCT o.OrderID), 0)
        AS DECIMAL(10,2)
    ) AS AverageOrderValue
FROM Orders o
JOIN Order_Items oi
    ON o.OrderID = oi.OrderID
JOIN Customers c
	ON c.customerid = o.customerid
GROUP BY c.Province
ORDER BY TotalRevenue DESC;

5. PRODUCT PERFOMANCE

-- How does the number of revenue by category differ from 2024 to 2025

SELECT
	p.Category,
	SUM( CASE WHEN YEAR(o.OrderDate) = 2024 THEN oi.Quantity * oi.UnitPrice ELSE 0 END) Revenue2024,
	SUM( CASE WHEN YEAR(o.OrderDate) = 2025 THEN oi.Quantity * oi.UnitPrice ELSE 0 END) Revenue2025
FROM Products p
JOIN Order_Items oi
	ON p.productID = oi.productID
JOIN Orders o
    ON o.orderid = oi.orderid
GROUP BY p.Category;

-- Total units sold by category

SELECT
	p.Category,
	SUM( CASE WHEN YEAR(o.OrderDate) = 2024 THEN oi.Quantity ELSE 0 END) UnitsSold2024,
	SUM( CASE WHEN YEAR(o.OrderDate) = 2025 THEN oi.Quantity ELSE 0 END) UnitsSold2025
FROM Products p
JOIN Order_Items oi
	ON p.productID = oi.productID
JOIN Orders o
    ON o.orderid = oi.orderid
GROUP BY  p.Category;

-- How has the quantity sold by products in the electronics and footwear category change over time

SELECT
	p.ProductName,
	SUM( CASE WHEN YEAR(o.OrderDate) = 2024 THEN oi.Quantity ELSE 0 END) UnitsSold2024,
	SUM( CASE WHEN YEAR(o.OrderDate) = 2025 THEN oi.Quantity ELSE 0 END) UnitsSold2025
FROM Products p
JOIN Order_Items oi
	ON p.productID = oi.productID
JOIN Orders o
    ON o.orderid = oi.orderid
WHERE p.Category = 'Electronics'
    OR p.Category = 'Footwear'
GROUP BY p.ProductName;

-- Average unit price for electronics and footwear products

SELECT
	p.ProductName,
	AVG(CASE WHEN YEAR(o.OrderDate) = 2024 THEN oi.UnitPrice END) AS AvgUnitPrice2024,
	AVG(CASE WHEN YEAR(o.OrderDate) = 2025 THEN oi.UnitPrice END) AS AvgUnitPrice2025
FROM Products p
JOIN Order_Items oi
	ON p.productID = oi.productID
JOIN Orders o
	ON o.orderid = oi.orderid
WHERE p.Category = 'Electronics'
	OR p.Category = 'Footwear'
GROUP BY p.ProductName;

6. PAYMENTS AND FINANCIAL CONTROL 

-- What percentage of attempted payment value fails, and which payment methods have the highest failure rates?

WITH FailedPayments AS
(
    SELECT
        PaymentMethod,
        SUM(CASE WHEN PaymentStatus = 'Failed' THEN ABS(Amount) ELSE 0 END) AS FailedFunds,
        SUM(ABS(Amount)) AS TotalPaymentValue
    FROM Payments
    GROUP BY PaymentMethod
)
SELECT
    PaymentMethod,
    CAST( FailedFunds * 100.0
        / NULLIF(TotalPaymentValue, 0)
        AS DECIMAL(10,2)) AS FailedPaymentValueRate
FROM FailedPayments
ORDER BY FailedPaymentValueRate DESC;

-- What percentage of successful payment value is subsequently refunded, and how does this change over time?

WITH RefundedPayments AS
(
    SELECT
        YEAR(PaymentDate) Year,
        MONTH(PaymentDate) Month,
        SUM(CASE WHEN PaymentStatus = 'Refunded' THEN ABS(Amount) ELSE 0 END) AS RefundedFunds,
        SUM(CASE WHEN PaymentStatus = 'Paid' THEN Amount ELSE 0 END) AS SuccessfulPaymentValue
    FROM Payments
    WHERE PaymentDate IS NOT NULL
    GROUP BY YEAR(PaymentDate), MONTH(PaymentDate)
)
SELECT
    Year,
    Month,
    CAST( RefundedFunds * 1.0
        / NULLIF(SuccessfulPaymentValue, 0) * 100
        AS DECIMAL(10,2)) AS RefundedAmountRate
FROM RefundedPayments
ORDER BY Year, Month;

-- How does order status compare with payment status, and are there orders that appear to have been paid despite being cancelled or left incomplete

SELECT  
	o.OrderStatus, 
	p.PaymentStatus,
	COUNT(o.OrderID) AS [Order and Payment Validity]
FROM Orders o 
LEFT JOIN Payments p 
	ON o.orderid = p.orderid
WHERE OrderStatus IS NOT NULL
GROUP BY 
	o.OrderStatus, 
	p.PaymentStatus

7. SHIPPING AND RETURNS

-- Which shipping carriers have the longest average delivery times, and how do their delivery times compare

SELECT
    Carrier,
    AVG(CAST(DATEDIFF(DAY, ShipDate, DeliveryDate) AS DECIMAL(10,2))) AS AverageDeliveryDays
FROM Shipping
WHERE ShipDate IS NOT NULL
  AND DeliveryDate IS NOT NULL
  AND DeliveryDate >= ShipDate
  AND DeliveryDate <> '2025/02/30'
GROUP BY Carrier
ORDER BY AverageDeliveryDays DESC;

-- What percentage of orders are returned, and which product categories have the highest return rates

WITH Returns AS
(
    SELECT
        p.Category,
        COUNT(DISTINCT CASE WHEN s.ShippingStatus = 'Returned' THEN s.OrderID END) AS ReturnedOrders,
        COUNT(DISTINCT s.OrderID) AS TotalOrders
    FROM Shipping s
    JOIN Order_Items oi
        ON s.OrderID = oi.OrderID
    JOIN Products p
        ON oi.ProductID = p.ProductID
    GROUP BY p.Category
)
SELECT
    Category,
    ReturnedOrders,
    TotalOrders,
    CAST( ReturnedOrders * 100.0
        / NULLIF(TotalOrders, 0)
        AS DECIMAL(10,2)) AS ReturnRatePercentage
FROM Returns
ORDER BY ReturnRatePercentage DESC;

-- How does the percentage value of returned items compare with total sales revenue across product categories

WITH ReturnedItems AS
(
    SELECT
        p.Category,
        SUM(oi.Quantity * oi.UnitPrice) AS TotalSales,
        SUM( CASE WHEN s.ShippingStatus = 'Returned' THEN oi.Quantity * oi.UnitPrice ELSE 0 END) AS ReturnedItemValue
    FROM Shipping s
    JOIN Order_Items oi
        ON s.OrderID = oi.OrderID
    JOIN Products p
        ON oi.ProductID = p.ProductID
    GROUP BY p.Category
)
SELECT
    Category,
    CAST( ReturnedItemValue * 100.0
        / NULLIF(TotalSales, 0)
        AS DECIMAL(10,2)) AS ReturnedItemValuePercentage
FROM ReturnedItems
ORDER BY ReturnedItemValuePercentage DESC;