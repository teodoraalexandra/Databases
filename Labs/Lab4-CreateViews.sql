/*A view with a SELECT statement operating on one table - 
	Show clients that has a goal to gain muscle.*/
CREATE OR ALTER VIEW ClientMuscleGain AS
SELECT C.FirstName, C.LastName, C.Goal, C.City
FROM Client C
WHERE C.Goal = 'Muscle Gain'

SELECT * FROM ClientMuscleGain

/*A view with a SELECT statement operating on at least 2 tables -
	Show coaches that has a certificate in Zumba.*/
CREATE OR ALTER VIEW CoachWithZumbaCertificate AS 
SELECT Co.FirstName, Co.LastName, Co.Salary, Ce.DateReceived
FROM Coach Co inner join Certificat Ce on Co.CoachId = Ce.CoachId
WHERE Ce.Domain = 'Zumba'

SELECT * FROM CoachWithZumbaCertificate

/*A view with a SELECT statement that has a GROUP BY clause and operates on at least 2 tables - 
	Show thinnest athletes under 30 years who has been competing for at least 2 times.*/
CREATE OR ALTER VIEW MostActiveAthlete AS
SELECT A.AthleteId, A.FirstName, A.LastName, MIN(A.WeightA) as WeightA
FROM Athlete A
WHERE A.Age < 30
GROUP BY A.AthleteId, A.FirstName, A.LastName
HAVING 1 < (SELECT COUNT(*)
			FROM Participate P
			WHERE A.AthleteId = P.AthleteId)

SELECT * FROM MostActiveAthlete

/*A table with a single column primary key and no foreign keys*/
SELECT * FROM PhotoSesion
/*A table with a single column primary key and at least one foreign key*/
SELECT * FROM Article
/*A table with a multicolumn primary key*/
SELECT * FROM Organize

/*INSERT INTO TABLES AND VIEWS*/
SELECT * FROM Tables
INSERT INTO Tables(Name)
VALUES ('PhotoSesion')
INSERT INTO Tables(Name)
VALUES ('Article')
INSERT INTO Tables(Name)
VALUES ('Organize')

SELECT * FROM Views
INSERT INTO Views(Name)
VALUES ('ClientMuscleGain')
INSERT INTO Views(Name)
VALUES ('CoachWithZumbaCertificate')
INSERT INTO Views(Name)
VALUES ('MostActiveAthlete')
