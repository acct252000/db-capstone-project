Week 2 Task One Queries

CREATE VIEW OrdersView AS
	SELECT Orders.OrderId, SUM(OrderDeliveryStatus.Quantity) AS Quantity, SUM(Menu.Cost) AS Cost
	FROM Orders INNER JOIN OrderDeliveryStatus ON Orders.OrderID = OrderDeliveryStatus.OrderID
	INNER JOIN Menu ON OrderDeliveryStatus.MenuID = Menu.MenuID
	GROUP BY Orders.OrderID
	HAVING SUM(OrderDeliveryStatus.Quantity) > 2;


SELECT * FROM OrdersView;   


 SELECT Customers.CustomerID, CONCAT(Customers.FirstName, " ", Customers.LastName) AS FullName, Orders.OrderId, SUM(Menu.Cost) AS Cost, Menu.MenuName, MenuItems.CourseName
	FROM Customers INNER JOIN Bookings ON Customers.CustomerID = Bookings.CustomerID
	INNER JOIN Orders on Orders.BookingID = Bookings.BookingID
	INNER JOIN OrderDeliveryStatus ON Orders.OrderID = OrderDeliveryStatus.OrderID
	INNER JOIN Menu ON OrderDeliveryStatus.MenuID = Menu.MenuID
	INNER JOIN MenuItems ON Menu.MenuItemsID = MenuItems.MenuItemsID
	GROUP BY 1,2,3,5,6
	HAVING SUM(Menu.Cost) > 150

--note returns nothing based on data.  Attached screenshot for > 20


SElECT Menu.MenuName from Menu
	WHERE Menu.MenuID in ( SELECT OrderDeliveryStatus.MenuID  from OrderDeliveryStatus group by OrderDeliveryStatus.MenuID HAVING Count(OrderDeliveryStatus.OrderID)> 2)