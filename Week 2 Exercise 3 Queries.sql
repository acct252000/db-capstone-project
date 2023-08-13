
more queries
Christine Stoner
You
Sun 8/13/2023 1:55 PM

INSERT INTO Bookings (BookingID, BookingSlot, TableNo, CustomerID, EmployeeID)
VALUES
(1, '2022-10-10 00:00:000', 5, 1, 2),
(2, '2022-11-12 00:00:000', 3, 3, 3),
(3, '2022-10-11 00:00:000', 2, 2, 4),
(4, '2022-10-13 00:00:000', 2, 1, 5);

DELIMITER //

CREATE PROCEDURE CheckBooking(IN bookTime DATETIME, IN checkTable INT)
BEGIN
SELECT
	CASE WHEN bookTime In ( SELECT BookingSlot from Bookings WHERE TableNo = checkTable )
		THEN CONCAT('Table ',checkTable, ' is already booked') 
	ELSE
		CONCAT('Table ',checkTable, ' is available') 
	END
	AS 'Booking Status';
END //

DELIMITER ;

CALL CheckBooking('2022-11-12 00:00:00', 3);




DELIMITER //

CREATE PROCEDURE AddValidBooking(IN bookTime DATETIME, IN checkTable INT, IN bookingCustomer INT, bookedEmployee INT)
BEGIN

DECLARE newBookingID INT;
DECLARE bookedTable INT;


START TRANSACTION;

SELECT MAX(BookingID) + 1 INTO newBookingID FROM Bookings;

SELECT
	CASE WHEN bookTime In ( SELECT BookingSlot from Bookings WHERE TableNo = checkTable )
		THEN 1
	ELSE
	        0
	END
	INTO bookedTable;

INSERT INTO Bookings (BookingID, BookingSlot, TableNo, CustomerID, EmployeeID)
VALUES 
(newBookingID, bookTime, checkTable, bookingCustomer, bookedEmployee);
IF (bookedTable = 1)
THEN
	SELECT CONCAT('Table ',checkTable, ' is already booked - booking cancelled') AS 'Booking Status';
	ROLLBACK;
ELSE
	SELECT CONCAT('Table ',checkTable, ' is available - booked') AS 'Booking Status';
	COMMIT;	
END IF;
END //

DELIMITER ;


CALL AddValidBooking('2022-12-17 00:00:00', 6, 1, 1);







