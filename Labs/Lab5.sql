/* Creating a many-to-many relationship with tables: Managers, Projects and WorksOn */
CREATE TABLE Managers ( --4
	EID INT PRIMARY KEY IDENTITY(1,1),
	CNP INT NOT NULL UNIQUE, 
	Name VARCHAR(255),
	Address VARCHAR(255),
	Salary INT
)

CREATE TABLE Projects ( --5
	PID INT PRIMARY KEY IDENTITY(1,1),
	RemainingDays INT,
	Objective VARCHAR(255),
	AgeCategory INT
)

CREATE TABLE WorksOn ( --6
	WID INT PRIMARY KEY IDENTITY(1,1),
	EID INT FOREIGN KEY REFERENCES Managers(EID),
	PID INT FOREIGN KEY REFERENCES Projects(PID)
)

/* Populate the tables with random values */
EXEC TestInsert 4
EXEC TestInsert 5
EXEC TestInsert 6

SELECT * from Managers
SELECT * FROM Projects
SELECT * FROM WorksOn
/* a. Write queries on Ta such that their execution plans contain the following operators: */
--Set stats on so we can see how many pages are read
SET STATISTICS IO ON

--show the actual execution plan (CTRL + M)
-- EID - CLUSTERED INDEX
-- CNP - NONCLUSTERED INDEX

-- clustered index seek
SELECT M.EID, M.CNP
FROM Managers M
WHERE M.EID = 200;

-- nonclustered index seek
SELECT M.EID, M.CNP
FROM Managers M
WHERE M.CNP = 873877;

-- clustered index scan
SELECT M.EID
FROM Managers M
ORDER BY M.EID;

-- nonclustered index scan
SELECT M.CNP
FROM Managers M
ORDER BY M.CNP;

-- include a non-indexed field (Name) -> key lookup
SELECT M.EID, M.CNP, M.Name
FROM Managers M
WHERE M.CNP = 873877;

/* b. Write a query on table Tb with a WHERE clause of the form WHERE b2 = value and analyze its execution plan. 
Create a nonclustered index that can speed up the query. Recheck the query’s execution plan (operators, SELECT’s estimated subtree cost). */
SELECT P.RemainingDays
FROM Projects P
WHERE RemainingDays = 90;

-- Table 'Projects'. Scan count 1, logical reads 382, physical reads 0, read-ahead reads 0, 
-- lob logical reads 0, lob physical reads 0, lob read-ahead reads 0. -----> CLUSTERED INDEX SCAN

CREATE NONCLUSTERED INDEX idx_RemainingDays
ON Projects(RemainingDays)

-- Table 'Projects'. Scan count 1, logical reads 7, physical reads 0, read-ahead reads 0, 
-- lob logical reads 0, lob physical reads 0, lob read-ahead reads 0. -----> NONCLUSTERED INDEX SEEK

/* c. Create a view that joins at least 2 tables. Check whether existing indexes are helpful; 
if not, reassess existing indexes / examine the cardinality of the tables. */
GO
CREATE OR ALTER VIEW ViewThreeTables AS 
SELECT M.EID, M.CNP, W.WID
FROM WorksOn W INNER JOIN Managers M ON W.EID = M.EID
WHERE M.Salary = 465826

GO
SELECT * FROM ViewThreeTables

--- Table 'Managers'. Scan count 1, logical reads 476, physical reads 0, read-ahead reads 0, 
-- lob logical reads 0, lob physical reads 0, lob read-ahead reads 0.
/*Hash Match (inner join) -> clustered index scan - 100100, 0,463762
						  -> clustered index scan - 10000, 0,0328005*/

CREATE NONCLUSTERED INDEX idx_NC_I
ON Managers(Salary) INCLUDE(CNP)

DROP INDEX idx_NC_I ON Managers

--- Table 'Managers'. Scan count 1, logical reads 2, physical reads 0, read-ahead reads 0, 
-- lob logical reads 0, lob physical reads 0, lob read-ahead reads 0.
/*Hash Match (inner join) -> nonclustered index seek - 1, 0,0032831
						  -> clustered index scan - 10000, 0,0328005*/