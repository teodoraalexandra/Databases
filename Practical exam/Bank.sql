USE Bank
GO

IF OBJECT_ID('Customers', 'U') IS NOT NULL
	DROP TABLE Customers
IF OBJECT_ID('BankAcc', 'U') IS NOT NULL
	DROP TABLE BankAcc
IF OBJECT_ID('ATMS', 'U') IS NOT NULL
	DROP TABLE ATMS
IF OBJECT_ID('Cards', 'U') IS NOT NULL
	DROP TABLE Cards
IF OBJECT_ID('Transactions', 'U') IS NOT NULL
	DROP TABLE Transactions

CREATE TABLE Customers (
	CID INT PRIMARY KEY IDENTITY(1,1),
	Name VARCHAR(300),
	DOB DATE
)

CREATE TABLE BankAcc (
	BID INT PRIMARY KEY IDENTITY(1,1),
	IBAN VARCHAR(300),
	CurrBalance INT,
	Holder INT REFERENCES Customers(CID)
)

CREATE TABLE Cards (
	CID INT PRIMARY KEY IDENTITY(1,1),
	Number VARCHAR(300),
	CVV INT, 
	BID INT REFERENCES BankAcc(BID)
)

CREATE TABLE ATMS (
	AID INT PRIMARY KEY IDENTITY(1,1),
	Address VARCHAR(300)
)

CREATE TABLE Transactions (
	AID INT REFERENCES ATMS(AID),
	CID INT REFERENCES Cards(CID),
	TSUM INT,
	TTIME DATETIME
)

GO
CREATE OR ALTER PROCEDURE uspDeleteTransaction @CID INT
AS
	IF @CID IS NULL
	BEGIN
		RAISERROR('No such card', 16, 1)
		RETURN -1
	END;
	BEGIN
		DELETE FROM Transactions 
		WHERE CID = @CID
	END;
GO

INSERT INTO Customers(Name, DOB) VALUES ('Teodora', '1999-02-02'), ('Mara', '2000-01-01')
INSERT INTO BankAcc(IBAN, CurrBalance, Holder) VALUES ('12345', 100, 2), ('67809', 200, 1)
INSERT INTO Cards(Number, CVV, BID) VALUES ('12345', 234, 1), ('67809', 567, 2)
INSERT INTO ATMS(Address) VALUES ('Cluj'), ('Campia')
INSERT INTO Transactions(AID, CID, TSUM, TTIME) VALUES (1, 1, 100, '2020-02-02'), 
													(2, 1, 200, '2020-02-02'),
													(1, 2, 400, '2020-02-02')


SELECT * FROM Transactions

/* - FIRST SELECT
1, 1
2, 1
1, 2
*/

/*Updates*/
EXEC uspDeleteTransaction 1

/* - SECOND SELECT
1, 2
*/

SELECT * FROM Transactions

GO
CREATE OR ALTER VIEW vCardsForAllAtms
AS
SELECT C.Number
FROM Cards C
WHERE NOT EXISTS
	(SELECT A.AID
	FROM ATMS A
	EXCEPT
	SELECT T.AID
	FROM Transactions T
	WHERE T.CID = C.CID)
GO

INSERT INTO Transactions(AID, CID, TSUM, TTIME) VALUES (2, 2, 200, '2020-02-02')
SELECT * FROM Transactions

SELECT * FROM vCardsForAllAtms
/*2 works for all -> its number is 67809*/

GO
CREATE OR ALTER FUNCTION ufCardsWithBigTransactions (@TSUM INT)
RETURNS TABLE AS RETURN
	SELECT C.Number, C.CVV
	FROM Cards C
	INNER JOIN Transactions T on C.CID = T.CID 
	GROUP BY C.Number, C.CVV 
	HAVING SUM(T.TSUM) > 2000
go

SELECT * FROM Transactions
INSERT INTO Transactions VALUES (2, 2, 1800, '2019-01-01')

SELECT * FROM ufCardsWithBigTransactions (2)