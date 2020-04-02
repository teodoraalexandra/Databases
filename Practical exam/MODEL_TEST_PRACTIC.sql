USE Shop
GO

IF OBJECT_ID('ShoesModel', 'U') IS NOT NULL
	DROP TABLE ShoesModel
IF OBJECT_ID('Shoes', 'U') IS NOT NULL
	DROP TABLE Shoes
IF OBJECT_ID('PresShop', 'U') IS NOT NULL
	DROP TABLE PresShop
IF OBJECT_ID('PresShopShoes', 'U') IS NOT NULL
	DROP TABLE PresShopShoes
IF OBJECT_ID('Women', 'U') IS NOT NULL
	DROP TABLE Women
IF OBJECT_ID('OrderDetails', 'U') IS NOT NULL
	DROP TABLE OrderDetails

CREATE TABLE ShoesModel (
	SMID INT PRIMARY KEY IDENTITY(1,1),
	Name VARCHAR(300),
	Season VARCHAR(300)
)

CREATE TABLE Shoes (
	SID INT PRIMARY KEY IDENTITY(1,1),
	Price INT,
	SMID INT REFERENCES ShoesModel(SMID)
)

CREATE TABLE PresShop (
	PID INT PRIMARY KEY IDENTITY(1,1),
	Name VARCHAR(300),
	City VARCHAR(300)
)

CREATE TABLE PresShopShoes (
	ShopID INT REFERENCES PresShop(PID),
	ShoeID INT REFERENCES Shoes(SID),
	Available INT, 
	PRIMARY KEY(ShopID, ShoeId)
)

CREATE TABLE Women (
	WID INT PRIMARY KEY IDENTITY(1,1),
	Name VARCHAR(300),
	MaxAmount INT
)

CREATE TABLE OrderDetails (
	WID INT REFERENCES Women(WID),
	SID INT REFERENCES Shoes(SID),
	NrBrought INT,
	SumSpent INT
)

GO
CREATE OR ALTER PROCEDURE uspShoeToShop @ShoeId INT, @ShopId INT, @NrOfShoes INT
AS
	IF @ShoeId IS NULL OR @ShopId IS NULL
	BEGIN
		RAISERROR('No such shoe/ shop', 16, 1)
		RETURN -1
	END;
	IF EXISTS(SELECT * FROM PresShopShoes WHERE ShoeID = @ShoeId AND ShopID = @ShopId)
		UPDATE PresShopShoes
		SET Available = @NrOfShoes
		WHERE ShoeID = @ShoeId AND ShopID = @ShopId
	ELSE 
		INSERT PresShopShoes(ShopID, ShoeID, Available) VALUES (@ShopId, @ShoeId, @NrOfShoes)
GO

INSERT INTO ShoesModel VALUES ('SH1', 'SUMMER'), ('SH2', 'WINTER')
INSERT INTO Shoes VALUES (100, 1), (200, 2)
INSERT INTO PresShop VALUES ('S1', 'CLUJ'), ('S2', 'CAMPIA')
INSERT INTO PresShop VALUES ('S3', 'CAMPENI')
INSERT INTO PresShopShoes VALUES (1, 2, 100), (1, 1, 200), (2, 1, 300), (2, 2, 400)
INSERT INTO Women VALUES ('N1', 100), ('N2', 200)
INSERT INTO OrderDetails VALUES (1, 1, 100, 90)

SELECT * FROM PresShopShoes
EXEC uspShoeToShop 1, 1, 1000
EXEC uspShoeToShop 1, 3, 200

GO
CREATE OR ALTER VIEW vRoutesWithAllStations
AS
SELECT W.Name, O.NrBrought
FROM Women W INNER JOIN OrderDetails O ON W.WID = O.WID INNER JOIN Shoes S ON S.SID = O.SID INNER JOIN ShoesModel SM ON S.SMID = SM.SMID
WHERE O.NrBrought > 2
GO

SELECT * FROM vRoutesWithAllStations

GO
CREATE OR ALTER FUNCTION ufWomenShoes(@R INT)
RETURNS TABLE
RETURN
	SELECT S.SID
	FROM Shoes S
	WHERE S.SID IN 
		(SELECT P.ShoeID
		FROM PresShopShoes p
		GROUP BY P.ShoeID
		HAVING COUNT(*) >= @R)
go

SELECT * FROM ufWomenShoes (3)
SELECT * FROM PresShopShoes