/*UPDATE AND DETELE FOR AT LEAST 3 TABLES*/
/*AND, OR, NOT,  {<,<=,=,>,>=,<> }, IS [NOT] NULL, IN, BETWEEN, LIKE*/

UPDATE Client
SET Goal = 'Endurance'
WHERE FirstName = 'Marry' AND LastName = 'Smith';

UPDATE Client
SET CoachId = 2
WHERE Goal = 'Fit Aspect' OR Goal = 'Healthy Lifestyle';

UPDATE Client
SET Goal = 'Muscle Gain'
WHERE NOT CoachId = 2;

UPDATE Certificat
SET Domain = 'Zumba' 
WHERE CertificateId > 4;

UPDATE Certificat
SET DateReceived = '2019-10-25' 
WHERE CertificateId >= 3;

UPDATE Certificat
SET CoachId = 4 
WHERE CertificateId < 2;

UPDATE Certificat
SET Domain = 'Circuit' 
WHERE CertificateId <= 1;

UPDATE Certificat
SET Domain = 'Dancing' 
WHERE CertificateId = 3;

UPDATE Certificat
SET DateReceived = '2018-02-02' 
WHERE CertificateId <> 1;

UPDATE Coach
SET FirstName = 'Teodora'
WHERE Username IS NOT NULL;

UPDATE Coach
Set LastName = 'Dan'
WHERE Username IS NULL;

UPDATE Coach
SET FirstName = 'Julie'
WHERE Username IN (5544, 8374);

UPDATE Coach
SET FirstName = 'Marry'
WHERE Username BETWEEN 1500 AND 3000;

UPDATE Coach
SET LastName = 'Green'
WHERE FirstName LIKE 'M%';

DELETE FROM Article WHERE ArticleId = 5 AND About = 'Healthy lifestyle';
DELETE FROM Article WHERE DieticianId = 4 OR About = 'Weight loss';
DELETE FROM Article WHERE NOT ArticleDate = '2019-10-06';

DELETE FROM Dietician WHERE Username IS NULL;
DELETE FROM Dietician WHERE Username IN (0,50);
DELETE FROM Dietician WHERE Username BETWEEN 15 AND 100;
DELETE FROM Dietician WHERE FirstName LIKE 'A%';

DELETE FROM Competition WHERE CompetitionId > 4;
DELETE FROM Competition WHERE Country = 'Hungary';
DELETE FROM OrderItem WHERE NutritionId < 2;
DELETE FROM OrderItem WHERE ProteinId <> 2;
DELETE FROM Dietician WHERE Age >= 50;
DELETE FROM Dietician WHERE Age <= 18;


/*a. 2 queries with the union operation*/
/*1. Find the ids, name, and bonus salary of the coaches who has more than 30 years or has clients with the goal of gaining muscle*/
SELECT Cl.CoachId
FROM Client Cl
WHERE Cl.Goal = 'Muscle Gain'
UNION 
SELECT Co.CoachId
FROM Coach Co
WHERE Co.Age > 30

/*---Compute also the bonus salary using formula: bonus_salary = salary * 1.5 + 3.---*/
SELECT DISTINCT Co.CoachId, Co.FirstName, Co.LastName, Co.Salary AS Net_Salary, Co.Salary * 1.5 + 3 AS Bonus_Salary
FROM Client Cl, Coach Co
WHERE Co.Age > 30 OR (Cl.CoachId = Co.CoachId AND Cl.Goal = 'Muscle Gain')

/*2. Find the ids of the dieticians who works at Gym Beam or has an article about lifestyle*/
SELECT D.DieticianId
FROM Dietician D
WHERE D.Company = 'GymBeam'
UNION 
SELECT A.DieticianId
FROM Article A
WHERE A.About = 'Lifestyle'

SELECT DISTINCT D.DieticianId
FROM Dietician D, Article A
WHERE D.Company = 'GymBeam' OR (D.DieticianId = A.DieticianId AND A.About = 'Lifestyle')

/*b. 2 queries with the intersection operation*/
/*1. Find the ids of the coaches who are younger than 25 and has a certificate in crossfit*/
SELECT Co.CoachId
FROM Coach Co
WHERE Co.Age < 25
INTERSECT
SELECT Ce.CoachId
FROM Certificat Ce
WHERE Ce.Domain = 'Crossfit'

SELECT Co.CoachId
FROM Coach Co
WHERE Co.CoachId IN 
(SELECT Ce.CoachId
FROM Certificat Ce
WHERE Ce.Domain = 'Crossfit')

SELECT Co.CoachId
FROM Coach Co, Certificat Ce1, Certificat Ce2
WHERE 
	Co.CoachId = Ce1.CoachId AND Co.Age < 25 
	AND
	Co.CoachId = Ce2.CoachId AND Ce2.Domain = 'Crossfit'

/*2. Find the ids of the clients who place an order in 25.10.2019 and has as goal to gain muscle*/
SELECT C.ClientId
FROM Client C
WHERE C.Goal = 'Muscle Gain'
INTERSECT
SELECT O.ClientId
FROM Orders O
WHERE O.OrdersDate = '2019-10-25'

SELECT C.ClientId
FROM Client C
WHERE C.Goal = 'Muscle Gain' AND C.ClientId IN 
(SELECT O.ClientId
FROM Orders O
WHERE O.OrdersDate = '2019-10-25')

SELECT DISTINCT C.ClientId
FROM Client C, Orders O1, Orders O2
WHERE 
	C.ClientId = O1.ClientId AND C.Goal = 'Muscle Gain'
	AND
	C.ClientId = O2.ClientId AND O2.OrdersDate = '2019-10-25'

/*c. 2 queries with the difference operation*/
/*1. Find the ids and name of the coaches who are older than 20, but has no athlete to coach*/
SELECT C.CoachId
FROM Coach C
WHERE C.Age > 20
EXCEPT
SELECT A.CoachId
FROM Athlete A, Coach C2
WHERE A.CoachId = C2.CoachId

SELECT C.CoachId
FROM Coach C
WHERE C.Age > 20 AND C.CoachId NOT IN
(SELECT A.CoachId
FROM Athlete A, Coach C2
WHERE A.CoachId = C2.CoachId)

/*2. Find the ids of the coaches who are older than 30, but has no official certificate*/
SELECT Co.CoachId
FROM Coach Co
WHERE NOT Co.Age < 30
EXCEPT
SELECT Ce.CoachId
FROM Certificat Ce, Coach Co2
WHERE Ce.CoachId = Co2.CoachId

SELECT Co.CoachId
FROM Coach Co
WHERE Co.Age > 30 AND Co.CoachId NOT IN
(SELECT Ce.CoachId
FROM Certificat Ce, Coach Co2
WHERE Ce.CoachId = Co2.CoachId)

/*d. 4 queries with INNER JOIN, LEFT JOIN, RIGHT JOIN, and FULL JOIN;*/
/*		one query will join at least 3 tables, while another one will join at least two many-to-many relationships;*/

SELECT Co.FirstName, Co.LastName, O.OrdersDate 
FROM Orders O
INNER JOIN Client Cl ON O.ClientId = Cl.ClientId
INNER JOIN Coach Co ON Cl.CoachId = Co.CoachIdSELECT Co.FirstName, Co.LastName, Ce.Domain, Ce.DateReceived 
FROM Coach Co
LEFT OUTER JOIN Certificat Ce ON Co.CoachId = Ce.CoachId
SELECT D.FirstName, D.LastName, D.Company, A.Title
FROM Dietician D
RIGHT OUTER JOIN Article A ON D.DieticianId = A.DieticianId/*---Compute also the time spend/photographer if an athlete will be 10 minutes late.---*/SELECT A.FirstName, A.LastName, A.Age, A.HeightA, A.WeightA, C.CompetitionDate, C.Country, Ph.Photographer, Ph.TimeSpend, Ph.TimeSpend + 10 AS MaxTime, Ph.PriceFROM Athlete AFULL JOIN Participate P on A.AthleteId = P.AthleteIdFULL JOIN Competition C on P.CompetitionId = C.CompetitionIdFULL JOIN Organize O on C.CompetitionId = O.CompetitionIdFULL JOIN PhotoSesion Ph on O.PhotoSesionSId = Ph.PhotoSesionSId
/*e. 2 queries using the IN operator to introduce a subquery in the WHERE clause;*/
/*		in at least one query, the subquery should include a subquery in its own WHERE clause;*/
/*1. Find all coaches who have a certificate in gymnastics.*/
SELECT Co.FirstName, Co.LastName
FROM Coach Co
WHERE Co.CoachId IN (SELECT Ce.CoachId
					FROM Certificat Ce	
					WHERE Ce.Domain = 'Gymnastics')

/*2. Find the name of top 3 heaviest athletes who went to a competition held in USA.*/
SELECT TOP 3 A.FirstName, A.LastName
FROM Athlete A
WHERE A.AthleteId IN (SELECT P.AthleteId
					FROM Participate P
					WHERE P.CompetitionId IN ( SELECT Co.CompetitionId
												FROM Competition Co
												WHERE Co.Country = 'USA'))
ORDER BY A.WeightA

/*f. 2 queries using the EXISTS operator to introduce a subquery in the WHERE clause;*/
/*1. Find the name of the clients who are coached by Julie Mathew.*/
SELECT C.FirstName, C.LastName
FROM Client C
WHERE EXISTS (SELECT *
			FROM Coach Co
			WHERE C.CoachId = Co.CoachId AND Co.FirstName = 'Julie' AND Co.LastName = 'Mathew')

/*2. Find the name of the dieticians who have articles about fat loss.*/
SELECT D.FirstName, D.LastName
FROM Dietician D
WHERE EXISTS (SELECT *
			FROM Article A
			WHERE D.DieticianId = A.DieticianId AND A.About = 'Fat loss')

/*g. 2 queries with a subquery in the FROM clause;*/  
/*1. Find the name of the clients who placed the order on the black friday.*/
SELECT C.FirstName, C.LastName
FROM Client C INNER JOIN
	(SELECT *
	FROM Orders O
	WHERE O.OrdersDate = '2019-11-29') bf
ON C.ClientId = bf.ClientId

/*2. Find the id of the orders where clients have ordered strawberry protein.*/
SELECT O.OrderItemId
FROM OrderItem O INNER JOIN
	(SELECT *
	FROM Protein P
	WHERE P.ProteinName = 'Strawberry Protein') sp
ON O.ProteinId = sp.ProteinId

/*h. 4 queries with the GROUP BY clause, 3 of which also contain the HAVING clause; 
2 of the latter will also have a subquery in the HAVING clause; 
use the aggregation operators: COUNT, SUM, AVG, MIN, MAX;*/

/*1. Find the name and average age of the dieticians who wrote at least 2 articles about gaining muscle.*/   
SELECT D.FirstName, D.LastName, AVG(D.Age) as Age
FROM Dietician D, Article A
WHERE D.DieticianId = A.DieticianId AND A.About = 'Muscle gain'
GROUP BY D.FirstName, D.LastName
HAVING COUNT(*) >= 2

/*2. Find the name of the name of the oldest coaches who was at least 2 certificates.*/
SELECT Co.CoachId, Co.FirstName, Co.LastName, MAX(Co.Age) as Age
FROM Coach Co
GROUP BY Co.CoachId, Co.FirstName, Co.LastName
HAVING 1 < (SELECT COUNT(*)
			FROM Certificat Ce
			WHERE Co.CoachId = Ce.CoachId)

/*3.  Find the name of the thinnest junior athlete (under 30 years) who has been competing for at least 2 times.*/
SELECT A.AthleteId, A.FirstName, A.LastName, MIN(A.WeightA) as WeightA
FROM Athlete A
WHERE A.Age < 30
GROUP BY A.AthleteId, A.FirstName, A.LastName
HAVING 1 < (SELECT COUNT(*)
			FROM Participate P
			WHERE A.AthleteId = P.AthleteId)

/*4. Find the id of the orders who have placed at least 2 orders which sum was greater than 100.*/
SELECT C.FirstName
FROM Orders O INNER JOIN Client C ON O.ClientId = C.ClientId
WHERE O.OrderId IN 
	(SELECT OI.OrderId
	FROM OrderItem OI 
	INNER JOIN Protein P ON OI.ProteinId = P.ProteinId 
	INNER JOIN Nutrition N ON OI.NutritionId = N.NutritionId
	GROUP BY OI.OrderId
	HAVING (SUM(P.Price)) > 100)
GROUP BY C.FirstName
HAVING COUNT(*) > 1

/*i. 4 queries using ANY and ALL to introduce a subquery in the WHERE clause; 
2 of them should be rewritten with aggregation operators, 
while the other 2 should also be expressed with [NOT] IN. 8 queries here*/

/*1. Find the name of top 5 coaches with the net salary grater than any of the salaries of the coahces from Cluj-Napoca.*/
SELECT TOP 5 C1.FirstName, C1.LastName 
FROM Coach C1
WHERE C1.Salary > ANY
	(SELECT C2.Salary 
	FROM Coach C2 
	WHERE C2.City LIKE 'Cluj Napoca')
ORDER BY C1.Salary

SELECT TOP 5 C1.FirstName, C1.LastName  
FROM Coach C1
WHERE C1.Salary > (SELECT MIN(C2.Salary) 
					FROM Coach C2 
					WHERE C2.City LIKE 'Cluj Napoca')
ORDER BY C1.Salary

/*2. Find the name of the coaches with the net salary grater than all of the salaries of the coaches from Cluj-Napoca.*/
/*---Compute also the brutto which is computed with formula: brutto_salary = 500 + salary.---*/
SELECT C1.FirstName, C1.LastName, C1.Salary AS Net, 500 + C1.Salary AS Brutto
FROM Coach C1
WHERE C1.Salary > ALL
	(SELECT C2.Salary 
	FROM Coach C2 
	WHERE C2.City like 'Cluj Napoca')

SELECT C1.FirstName, C1.LastName
FROM Coach C1
WHERE C1.Salary > (SELECT MAX(C2.Salary) 
					FROM Coach C2 
					WHERE C2.City like 'Cluj Napoca')

/*3. Find the name of the coaches that are from a city different from any of the clients.*/
SELECT C1.FirstName, C1.LastName 
FROM Coach C1
WHERE C1.City <> ALL
		(SELECT C.City 
		FROM Client C)

SELECT C1.FirstName, C1.LastName 
FROM Coach C1
WHERE C1.City NOT IN 
		(SELECT C.City 
		FROM Client C)

/*4. Find the name of the coaches that have the same age with any of the clients.*/
SELECT C1.FirstName, C1.LastName 
FROM Coach C1
WHERE FLOOR(DATEDIFF(DAY, C1.DOB, GETDATE()) / 365.25) = ANY
		(SELECT FLOOR(DATEDIFF(DAY, C.DOB, GETDATE()) / 365.25) 
		FROM Client C)

SELECT C1.FirstName, C1.LastName 
FROM Coach C1
WHERE FLOOR(DATEDIFF(DAY, C1.DOB, GETDATE()) / 365.25) IN 
		(SELECT FLOOR(DATEDIFF(DAY, C.DOB, GETDATE()) / 365.25) 
		FROM Client C)

/*ADITIONAL TABLES FOR MANY TO MANY RELATIONSHIP - REDESIGN DATABASE*/
CREATE TABLE PhotoSesion
( 
PhotoSesionSId INT PRIMARY KEY,
PhotoSesionDate DATE, 
Photographer VARCHAR(50),
TimeSpend INT,
Price INT,
);

insert into PhotoSesion (PhotoSesionSId, PhotoSesionDate, Photographer, TimeSpend, Price)
values (1, GETDATE(), 'Amalia', 60, 200)
insert into PhotoSesion (PhotoSesionSId, PhotoSesionDate, Photographer, TimeSpend, Price)
values (2, GETDATE(), 'Mirela', 90, 350)
insert into PhotoSesion (PhotoSesionSId, PhotoSesionDate, Photographer, TimeSpend, Price)
values (3, GETDATE(), 'Doru', 100, 500)
insert into PhotoSesion (PhotoSesionSId, PhotoSesionDate, Photographer, TimeSpend, Price)
values (4, GETDATE(), 'Cristian', 40, 100)
insert into PhotoSesion (PhotoSesionSId, PhotoSesionDate, Photographer, TimeSpend, Price)
values (5, GETDATE(), 'Paul', 30, 100)

CREATE TABLE Organize 
(
OrganizeId INT PRIMARY KEY,
CompetitionId INT,
PhotoSesionSId INT,
FOREIGN KEY (CompetitionId) REFERENCES Competition(CompetitionId),
FOREIGN KEY (PhotoSesionSId) REFERENCES PhotoSesion(PhotoSesionSId),
);


insert into Organize (OrganizeId, CompetitionId, PhotoSesionSId)
values (1, 2, 4)
insert into Organize (OrganizeId, CompetitionId, PhotoSesionSId)
values (2, 4, 5)
insert into Organize (OrganizeId, CompetitionId, PhotoSesionSId)
values (3, 1, 3)
insert into Organize (OrganizeId, CompetitionId, PhotoSesionSId)
values (4, 2, 1)
