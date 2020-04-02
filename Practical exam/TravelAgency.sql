USE TravelAgency
GO

IF OBJECT_ID('Offices', 'U') IS NOT NULL
	DROP TABLE Offices 
IF OBJECT_ID('Destination', 'U') IS NOT NULL
	DROP TABLE Destination
IF OBJECT_ID('Hotel', 'U') IS NOT NULL
	DROP TABLE Hotel
IF OBJECT_ID('Packages', 'U') IS NOT NULL
	DROP TABLE Packages
IF OBJECT_ID('Bookings', 'U') IS NOT NULL
	DROP TABLE Bookings

CREATE TABLE Offices (
	OID INT PRIMARY KEY IDENTITY(1,1),
	Address VARCHAR(300)
)

CREATE TABLE Destination (
	DID INT PRIMARY KEY IDENTITY(1,1),
	Name VARCHAR(300),
	SecurityScore INT 
)

CREATE TABLE Hotel (
	HID INT PRIMARY KEY IDENTITY(1,1),
	Name VARCHAR(300),
    Stars INT, 
	DID INT REFERENCES Destination(DID)
)

CREATE TABLE Package (
	PID INT PRIMARY KEY IDENTITY(1,1),
	StartDate DATE,
	EndDate DATE,
	Price INT,
	HID INT REFERENCES Hotel(HID)
)

CREATE TABLE Bookings (
	OID INT REFERENCES Offices(OID),
	PID INT REFERENCES Package(PID),
	NrOfPersons INT,
	BookingDate DATE
)

GO
CREATE OR ALTER PROCEDURE uspDeleteUnsafeBookings 
AS
	BEGIN
		DELETE B
		FROM Bookings B INNER JOIN Package P ON B.PID = P.PID INNER JOIN Hotel H ON H.HID = P.HID INNER JOIN Destination D ON H.DID = D.DID
		WHERE D.SecurityScore = 2
	END;
GO

INSERT INTO Offices(Address) VALUES ('Primaverii'), ('Maramuresului')
INSERT INTO Destination(Name, SecurityScore) VALUES ('Paris', 0), ('Cluj', 0), ('Maramures', 1), ('Braila', 1), ('Vaslui', 2), ('Botosani', 2)
INSERT INTO Hotel(Name, Stars, DID) VALUES ('SafeHotel', 5, 1), ('UnSafeHotel', 1, 5)
INSERT INTO Package(StartDate, EndDate, Price, HID) VALUES ('2020-02-02', '2020-02-02', 100, 1), ('2020-02-02', '2020-02-02', 200, 1),
														 ('2020-02-02', '2020-02-02', 100, 2), ('2020-02-02', '2020-02-02', 200, 2)
INSERT INTO Bookings(OID, PID, NrOfPersons, BookingDate) VALUES 
													(2, 3, 50, '2020-02-02'),
													(2, 3, 60, '2020-02-02'),
													(2, 4, 70, '2020-02-02'),
													(2, 4, 80, '2020-02-02')

SELECT * FROM Offices
SELECT * FROM Destination
SELECT * FROM Hotel
SELECT * FROM Package
SELECT * FROM Bookings

/* - FIRST SELECT
1, 1 -s
1, 2 -s
1, 2 -s
1, 2 -s
2, 3 -u
2, 3 -u
2, 4 -u
2, 4 -u
*/

/*Updates*/
EXEC uspDeleteUnsafeBookings

/* - SECOND SELECT
1, 1 -s
1, 2 -s
1, 2 -s
1, 2 -s
*/

SELECT * FROM Bookings


SELECT * FROM Offices
SELECT * FROM Bookings
SELECT * FROM Package

INSERT INTO Bookings(OID, PID, NrOfPersons, BookingDate) VALUES (1, 3, 150, '2020-02-02')
INSERT INTO Bookings(OID, PID, NrOfPersons, BookingDate) VALUES (1, 4, 250, '2020-02-02')

GO
CREATE OR ALTER VIEW vOfficesForAllPackages
AS
SELECT O.Address
FROM Offices O
WHERE NOT EXISTS
	(SELECT P.PID
	FROM Package P
	EXCEPT
	SELECT B.PID
	FROM Bookings B
	WHERE B.OID = O.OID)
GO

SELECT * FROM vOfficesForAllPackages
/*1 works for all -> Office from 'Primaverii' has booking on all 4 packages*/



SELECT * FROM Bookings B INNER JOIN Package P ON B.PID = P.PID INNER JOIN Hotel H ON P.HID = H.HID

GO
CREATE OR ALTER FUNCTION ufHotelsWithACertainNumberOfPerson (@NrPersons INT)
RETURNS TABLE AS RETURN
	
	SELECT H.Name, H.Stars
	FROM Hotel H
	INNER JOIN Package P on H.HID = P.HID
	INNER JOIN Bookings B ON P.PID = B.PID
	GROUP BY H.Name, H.Stars
	HAVING SUM(B.NrOfPersons) > @NrPersons
go

SELECT * FROM ufHotelsWithACertainNumberOfPerson (300)