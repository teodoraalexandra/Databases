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
