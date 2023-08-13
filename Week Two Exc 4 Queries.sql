

DELIMITER //

CREATE PROCEDURE AddBooking(IN newBookingID INT, IN bookingCustomer INT, IN bookTableNo INT, IN bookTime DATETIME,  bookedEmployee INT)
BEGIN

DECLARE bookedTable INT;


START TRANSACTION;

SELECT
	CASE WHEN bookTime In ( SELECT BookingSlot from Bookings WHERE TableNo = bookTableNo )
		THEN 1
	ELSE
	        0
	END
	INTO bookedTable;

INSERT INTO Bookings (BookingID, BookingSlot, TableNo, CustomerID, EmployeeID)
VALUES 
(newBookingID, bookTime, bookTableNo, bookingCustomer, bookedEmployee);
IF (bookedTable = 1)
THEN
	SELECT CONCAT('Table ',bookTableNo, ' is already booked - booking cancelled') AS 'Confirmation';
	ROLLBACK;
ELSE
	SELECT 'New Booking Added' AS 'Confirmation';
	COMMIT;	
END IF;
END //

DELIMITER ;


CALL AddBooking(9, 3, 4, '2022-12-17 00:00:00', 6);





DELIMITER //

CREATE PROCEDURE UpdateBooking(IN upBookingID INT, IN bookTime DATETIME)
BEGIN

DECLARE originalTable INT;
DECLARE bookedTable INT;

START TRANSACTION;

SELECT Bookings.TableNo INTO originalTable FROM Bookings WHERE Bookings.BookingID = upBookingID;


SELECT
	CASE WHEN bookTime In ( SELECT BookingSlot from Bookings WHERE TableNo = originalTable )
		THEN 1
	ELSE
	        0
	END
	INTO bookedTable;

UPDATE Bookings 
	SET BookingSlot = bookTime
    WHERE BookingID = upBookingID;
    
IF (bookedTable = 1)
THEN
	SELECT CONCAT('Conflicts with other reservation - booking cancelled') AS 'Confirmation';
	ROLLBACK;
ELSE
	SELECT CONCAT('Booking ',upBookingID, ' updated.') AS 'Confirmation';
	COMMIT;	
END IF;
END //

DELIMITER ;


CALL UpdateBooking(9, '2022-12-16 00:00:00');




DELIMITER //

CREATE PROCEDURE CancelBooking(IN upBookingID INT)
BEGIN

START TRANSACTION;

DELETE FROM Bookings
    WHERE BookingID = upBookingID;
    
COMMIT;
SELECT CONCAT('Booking ', upBookingID, ' cancelled.') AS Confirmation;

END //

DELIMITER ;


CALL CancelBooking(9);
