USE ITCompany
GO

IF OBJECT_ID('Projects', 'U') IS NOT NULL
	DROP TABLE Projects
IF OBJECT_ID('Employees', 'U') IS NOT NULL
	DROP TABLE Employees
IF OBJECT_ID('Assignments', 'U') IS NOT NULL
	DROP TABLE Assignments
IF OBJECT_ID('Promotions', 'U') IS NOT NULL
	DROP TABLE Promotions

CREATE TABLE Projects (
	PID INT PRIMARY KEY IDENTITY(1,1),
	Name VARCHAR(300),
	Deadline DATETIME
)

CREATE TABLE Employees (
	EID INT PRIMARY KEY IDENTITY(1,1),
	Name VARCHAR(300),
	Address VARCHAR(300),
	PhoneNumber VARCHAR(300)
)

CREATE TABLE Assignments (
	EID INT REFERENCES Employees(EID),
	PID INT REFERENCES Projects(PID),
	StartDate DATETIME,
	EndDate DATETIME,
	PRIMARY KEY(EID, PID)
)

CREATE TABLE Promotions (
	PRID INT PRIMARY KEY IDENTITY(1,1),
	EID INT REFERENCES Employees(EID),
	FunctionGiven VARCHAR(300),
	PYear INT,
	UNIQUE (EID, PYear)
)

GO
CREATE OR ALTER PROCEDURE uspNewAssignment @EName VARCHAR(100), @PName VARCHAR(100), @StartDate DATETIME, @EndDate DATETIME
AS
	DECLARE @PID INT = (SELECT PID FROM Projects P WHERE P.Name = @PName)
	DECLARE @EID INT = (SELECT EID FROM Employees E WHERE E.Name = @EName)
	
	IF @PID IS NULL OR @EID IS NULL
	BEGIN
		RAISERROR('No such employee/ project', 16, 1)
		RETURN -1
	END;
	IF EXISTS(SELECT * FROM Assignments WHERE EID = @EID AND PID = @PID)
		UPDATE Assignments 
		SET StartDate = @StartDate, EndDate = @EndDate
		WHERE EID = @EID AND PID = @PID
	ELSE 
		INSERT Assignments(EID, PID, StartDate, EndDate) VALUES (@EID, @PID, @StartDate, @EndDate)
GO

INSERT INTO Employees VALUES('Teodora', 'A1', '12345'), ('Mara', 'A2', '12345'), ('Alexandra', 'A3', '12345')
INSERT INTO Projects VALUES('P1', '2020-02-02'), ('P2', '2020-02-02'), ('P3', '2020-02-02')
INSERT INTO Assignments VALUES (1, 1, '2017-01-01', '2018-01-01'), (1, 2, '2015-02-02', '2016-01-01'),
							(2, 1, '2012-04-04', '2016-01-01'), (3, 3, '2010-01-01', '2011-05-05')


SELECT * FROM Employees
SELECT * FROM Projects
SELECT * FROM Assignments

/* - FIRST SELECT
1, 1, '2017-01-01', '2018-01-01' 
1, 2, '2015-02-02', '2016-01-01'
2, 1, '2012-04-04', '2016-01-01'
3, 3, '2010-01-01', '2011-05-05'
*/

/*Updates*/
EXEC uspNewAssignment 'Teodora', 'P1', '2010-05-05', '2020-01-01'
EXEC uspNewAssignment 'Mara', 'P1', '2013-01-01', '2020-02-02'
/*New ones*/
EXEC uspNewAssignment 'Alexandra', 'P1', '2011-01-01', '2015-01-01'
EXEC uspNewAssignment 'Mara', 'P2', '2000-02-02', '2001-01-01'

/* - SECOND SELECT
1, 1, '2010-05-05', '2020-01-01' 
1, 2, '2015-02-02', '2016-01-01'
2, 1, '2013-01-01', '2020-02-02'
3, 3, '2010-01-01', '2011-05-05'
3, 1, '2011-01-01', '2015-01-01'
2, 2, '2000-02-02', '2001-01-01'
*/

SELECT * FROM Employees
SELECT * FROM Projects
SELECT * FROM Assignments

GO
CREATE OR ALTER VIEW vEmployeesWithAllProjects
AS
SELECT E.Name
FROM Employees E
WHERE NOT EXISTS
	(SELECT P.PID
	FROM Projects P
	EXCEPT
	SELECT A.PID
	FROM Assignments A
	WHERE A.EID = E.EID)
GO

EXEC uspNewAssignment 'Teodora', 'P3', '2000-02-02', '2001-01-01'

SELECT * FROM vEmployeesWithAllProjects
/*Teodora works for all.*/

GO
CREATE OR ALTER FUNCTION ufEmployeesWithNrOfPromotions(@P INT)
RETURNS TABLE
RETURN
	SELECT E.Name
	FROM Employees E
	WHERE E.EID IN 
		(SELECT P.EID
		FROM Promotions P
		GROUP BY P.EID
		HAVING COUNT(*) >= @P)
go

INSERT INTO Promotions VALUES (1, 'CEO', 2017)
INSERT INTO Promotions VALUES (1, 'CEO', 2018)
INSERT INTO Promotions VALUES (1, 'CEO', 2019)

INSERT INTO Promotions VALUES (2, 'Manager', 2017)
INSERT INTO Promotions VALUES (2, 'Manager', 2018)
INSERT INTO Promotions VALUES (2, 'Manager', 2019)

SELECT * FROM ufEmployeesWithNrOfPromotions(2)  

/*Because of the uniqueness: this will give an error*/
INSERT INTO Promotions VALUES (1, 'Manager', 2017)
INSERT INTO Promotions VALUES (2, 'CEO', 2017)

