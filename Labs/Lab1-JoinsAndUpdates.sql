/*START UPDATE*/
UPDATE Dietician
SET Username = 1932
WHERE DieticianId = 1;

UPDATE Dietician
SET Username = 0239
WHERE DieticianId = 2;

UPDATE Dietician
SET Username = 1939
WHERE DieticianId = 3;

UPDATE Dietician
SET Username = 0019
WHERE DieticianId = 4;

UPDATE Dietician
SET Username = 2518
WHERE DieticianId = 5;

UPDATE Article
SET DieticianId = 1
WHERE ArticleId = 1;

UPDATE Article
SET DieticianId = 1
WHERE ArticleId = 2;

UPDATE Article
SET DieticianId = 4
WHERE ArticleId = 3;

UPDATE Article
SET DieticianId = 5
WHERE ArticleId = 4;

UPDATE Article
SET DieticianId = 1
WHERE ArticleId = 5;

UPDATE Coach
SET Username = 5544
WHERE CoachId = 1;

UPDATE Coach
SET Username = 0192
WHERE CoachId = 2;

UPDATE Coach
SET Username = 8374
WHERE CoachId = 3;

UPDATE Coach
SET Username = 2000
WHERE CoachId = 4;

UPDATE Coach
SET Username = 2943
WHERE CoachId = 5;

UPDATE Certificat
SET CoachId = 1
WHERE CertificateId = 2;

UPDATE Certificat
SET CoachId = 2
WHERE CertificateId = 3;

UPDATE Certificat
SET CoachId = 3
WHERE CertificateId = 4;

UPDATE Certificat
SET CoachId = 4
WHERE CertificateId = 5;

UPDATE Certificat
SET CoachId = 5
WHERE CertificateId = 1;

UPDATE Client
SET Username = 9283, CoachId = 3
WHERE ClientId = 1;

UPDATE Client
SET Username = 1924, CoachId = 2
WHERE ClientId = 2;

UPDATE Client
SET Username = 9202, CoachId = 1
WHERE ClientId = 3;

UPDATE Client
SET Username = 8273, CoachId = 5
WHERE ClientId = 4;

UPDATE Client
SET Username = 2847, CoachId = 4
WHERE ClientId = 5;

UPDATE Athlete
Set CoachId = 3
WHERE AthleteId = 1;

UPDATE Athlete
Set CoachId = 3
WHERE AthleteId = 2;

UPDATE Athlete
Set CoachId = 5
WHERE AthleteId = 3;

UPDATE Athlete
Set CoachId = 4
WHERE AthleteId = 4;

UPDATE Athlete
Set CoachId = 1
WHERE AthleteId = 5;
/*END UPDATE*/

/*START JOINS*/
select * from Client
inner join Account on Client.Username = Account.Username
inner join Coach on Client.CoachId = Coach.CoachId

select * from Coach
inner join Account on Coach.Username = Account.Username

select * from Certificat
inner join Coach on Certificat.CoachId = Coach.CoachId

select * from Article
inner join Dietician on Article.DieticianId = Dietician.DieticianId

select * from Dietician
inner join Account on Dietician.Username = Account.Username

select * from Category
inner join Competition on Category.CompetitionId = Competition.CompetitionId
inner join Athlete on Category.CompetitionId = Competition.CompetitionId
/*END JOINS*/


