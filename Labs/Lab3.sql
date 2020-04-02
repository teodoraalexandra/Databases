/*Stored procedure that receives as a parameter a version number and brings the database to that version*/
CREATE OR ALTER PROCEDURE ChangeVersion (@WantedVersion int)
AS      
	DECLARE @CurrentVersion int
	DECLARE @Procedure VARCHAR(50)
	SET @CurrentVersion = (SELECT CURRENTVERSION.CrtV
						FROM CURRENTVERSION)
	IF (@WantedVersion < 0 OR @WantedVersion > 7)
		RAISERROR('This version does not exist.', 16,16);
	ELSE 
		BEGIN
		IF (@WantedVersion > @CurrentVersion)
			BEGIN
			WHILE(@CurrentVersion != @WantedVersion)
				BEGIN
					SET @Procedure = (SELECT VERSIONS.USP
									FROM VERSIONS
									WHERE VERSIONS.TGetV = @CurrentVersion + 1)
					EXEC @Procedure
					SET @CurrentVersion = @CurrentVersion + 1
					UPDATE CURRENTVERSION SET CrtV = @CurrentVersion
				END;
			END;
		ELSE
			BEGIN 
			WHILE (@CurrentVersion != @WantedVersion)
				BEGIN
					SET @Procedure = (SELECT VERSIONS.RUSP
									FROM VERSIONS
									WHERE VERSIONS.TGetV = @CurrentVersion)
					EXEC @Procedure
					SET @CurrentVersion = @CurrentVersion - 1
					UPDATE CURRENTVERSION SET CrtV = @CurrentVersion
				END;
			END;
		END;
GO   

EXEC ChangeVersion 0
SELECT * FROM CURRENTVERSION;
SELECT * FROM VERSIONS;
GO

/*a. modify the type of a column;*/
CREATE OR ALTER PROCEDURE USPAlterSalaryInCoachFromIntToFloat
AS
	ALTER TABLE Coach
	ALTER COLUMN Salary FLOAT;
GO
EXEC USPAlterSalaryInCoachFromIntToFloat
GO

CREATE OR ALTER PROCEDURE USPAlterSalaryInCoachFromFloatToInt
AS
	ALTER TABLE Coach
	ALTER COLUMN Salary INT;
GO
EXEC USPAlterSalaryInCoachFromFloatToInt
GO

/*b. add / remove a column;*/
CREATE OR ALTER PROCEDURE USPAddSalaryToDietician
AS
	ALTER TABLE Dietician
	ADD Salary INT;
GO
EXEC USPAddSalaryToDietician
GO

CREATE OR ALTER PROCEDURE USPDropSalaryFromDietician
AS
	ALTER TABLE Dietician
	DROP COLUMN Salary;
GO
EXEC USPDropSalaryFromDietician
GO

/*CREATE OR ALTER PROCEDURE USPDropCompanyFromDietician
AS
	ALTER TABLE Dietician
	DROP COLUMN Company;
GO
EXEC USPDropCompanyFromDietician
GO

CREATE OR ALTER PROCEDURE USPAddCompanyToDietician
AS
	ALTER TABLE Dietician
	ADD Salary INT;
GO
EXEC USPAddCompanyToDietician
GO*/

/*c. add / remove a DEFAULT constraint;*/
CREATE OR ALTER PROCEDURE USPAddDFDomainForCertificat
AS
	ALTER TABLE Certificat
	ADD CONSTRAINT df_Domain
	DEFAULT 'Personal trainer' FOR Domain;
GO
EXEC USPAddDFDomainForCertificat
GO

CREATE OR ALTER PROCEDURE USPDropDFDomainFromCertificat
AS
	ALTER TABLE Certificat
	DROP CONSTRAINT df_Domain;
GO
EXEC USPDropDFDomainFromCertificat
GO

/*CREATE OR ALTER PROCEDURE USPDropDFAboutFromArticle
AS
	ALTER TABLE Article
	DROP CONSTRAINT df_About;
GO
EXEC USPDropDFAboutFromArticle
GO

CREATE OR ALTER PROCEDURE USPAddDFAboutForArticle
AS
	ALTER TABLE Article
	ADD CONSTRAINT df_About
	DEFAULT 'Health' FOR About;
GO
EXEC USPAddDFAboutForArticle
GO*/

/*d. add / remove a primary key;*/
CREATE OR ALTER PROCEDURE USPAddPKForArticle
AS
	ALTER TABLE Article
	ADD CONSTRAINT pk_Article PRIMARY KEY(ArticleId);
GO
EXEC USPAddPKForArticle
GO

CREATE OR ALTER PROCEDURE USPDropPKFromArticle
AS
	ALTER TABLE Article
	DROP CONSTRAINT pk_Article;
GO
EXEC USPDropPKFromArticle
GO

/*CREATE PROCEDURE USPDropPKFromOrderItem
AS
	 declare @PrimaryKeyName sysname = 
    (select CONSTRAINT_NAME 
     from INFORMATION_SCHEMA.TABLE_CONSTRAINTS 
     where CONSTRAINT_TYPE = 'PRIMARY KEY' and TABLE_SCHEMA='dbo' and TABLE_NAME = 'OrderItem'
    )

	IF @PrimaryKeyName is not null
	begin
		declare @SQL_PK NVARCHAR(MAX) = 'alter table dbo.OrderItem drop constraint ' + @PrimaryKeyName
		print (@SQL_PK)
		EXEC sp_executesql @SQL_PK;
	end
GO
EXEC USPDropPKFromOrderItem
GO

CREATE PROCEDURE USPAddPKForOrderItem
AS
	ALTER TABLE OrderItem
	ADD PRIMARY KEY (OrderItemId);
GO
EXEC USPAddPKForOrderItem
GO*/

/*e. add / remove a candidate key;*/
CREATE OR ALTER PROCEDURE USPAddUCForDietician
AS
	ALTER TABLE Dietician
	ADD CONSTRAINT uc_username UNIQUE (username);
GO
EXEC USPAddUCForDietician
GO

CREATE OR ALTER PROCEDURE USPDropUCFromDietician
AS
	ALTER TABLE Dietician
	DROP CONSTRAINT uc_username;
GO
EXEC USPDropUCFromDietician
GO

/*CREATE PROCEDURE USPDropUCFromClient
AS
	declare @UniqueKeyName sysname = 
    (select CONSTRAINT_NAME 
     from INFORMATION_SCHEMA.TABLE_CONSTRAINTS 
     where CONSTRAINT_TYPE = 'UNIQUE' and TABLE_SCHEMA='dbo' and TABLE_NAME = 'Client'
    )

	IF @UniqueKeyName is not null
	begin
		declare @SQL_PK NVARCHAR(MAX) = 'alter table dbo.Client drop constraint ' + @UniqueKeyName
		print (@SQL_PK)
		EXEC sp_executesql @SQL_PK;
	end
GO
EXEC USPDropUCFromClient
GO

CREATE PROCEDURE USPAddUCForClient
AS
	ALTER TABLE Client
	ADD UNIQUE (username);
GO
EXEC USPAddUCForClient
GO*/

/*f. add / remove a foreign key;*/
CREATE OR ALTER PROCEDURE USPAddFKCoachIdForCertificat
AS
	ALTER TABLE Certificat
	ADD CONSTRAINT fk_Coach FOREIGN KEY (CoachId) REFERENCES Coach(CoachId);
GO
EXEC USPAddFKCoachIdForCertificat
GO

CREATE OR ALTER PROCEDURE USPDropFKCoachIdFromCertificat
AS
	ALTER TABLE Certificat
	DROP CONSTRAINT fk_Coach
GO
EXEC USPDropFKCoachIdFromCertificat
GO

/*CREATE OR ALTER PROCEDURE USPDropFKCompetitionIdFromOrganize
AS
	DECLARE @ConstraintName nvarchar(200)
	SELECT 
    @ConstraintName = KCU.CONSTRAINT_NAME
	FROM INFORMATION_SCHEMA.REFERENTIAL_CONSTRAINTS AS RC 
	INNER JOIN INFORMATION_SCHEMA.KEY_COLUMN_USAGE AS KCU
    ON KCU.CONSTRAINT_CATALOG = RC.CONSTRAINT_CATALOG  
    AND KCU.CONSTRAINT_SCHEMA = RC.CONSTRAINT_SCHEMA 
    AND KCU.CONSTRAINT_NAME = RC.CONSTRAINT_NAME
	WHERE
    KCU.TABLE_NAME = 'Organize' AND
    KCU.COLUMN_NAME = 'CompetitionId'
	IF @ConstraintName IS NOT NULL EXEC('alter table Organize drop  CONSTRAINT ' + @ConstraintName)
GO
EXEC USPDropFKCompetitionIdFromOrganize
GO

CREATE OR ALTER PROCEDURE USPAddFKCompetitionIdForOrganize
AS
	ALTER TABLE Organize
	ADD FOREIGN KEY (CompetitionId) REFERENCES Competition(CompetitionId);
GO
EXEC USPAddFKCompetitionIdForOrganize
GO*/

/*g. create / remove a table.*/
CREATE OR ALTER PROCEDURE USPCreateDiploma
AS
	CREATE TABLE Diploma (
		DiplomaId int NOT NULL PRIMARY KEY,
		University varchar(50),
		Specialization varchar(50),
		DieticianId int FOREIGN KEY REFERENCES Dietician(DieticianId)
	);
GO
EXEC USPCreateDiploma
GO

CREATE OR ALTER PROCEDURE USPDropDiploma
AS
	DROP TABLE Diploma
GO
EXEC USPDropDiploma
GO

/*CREATE OR ALTER PROCEDURE USPDropOrganize
AS
	DROP TABLE Organize
GO
EXEC USPDropOrganize
GO

CREATE OR ALTER PROCEDURE USPCreateOrganize
AS
	CREATE TABLE Organize (
		OrganizeId int NOT NULL PRIMARY KEY,
		CompetitionId int FOREIGN KEY REFERENCES Competition(CompetitionId),
		PhotoSesionSId int FOREIGN KEY REFERENCES PhotoSesion(PhotoSesionSId)
	);
GO
EXEC USPCreateOrganize
GO*/

/*CREATE TABLE CURRENT VERSION*/
CREATE TABLE CURRENTVERSION (
	CrtV INT
)

INSERT INTO CURRENTVERSION VALUES (0)
SELECT * FROM CURRENTVERSION;

/*CREATE VERSIONS TGetV, TABLE USP, RUSP*/
CREATE TABLE VERSIONS (
	TGetV INT,
	USP VARCHAR(50),
	RUSP VARCHAR(50),
)

INSERT INTO VERSIONS VALUES (1, 'USPAlterSalaryInCoachFromIntToFloat','USPAlterSalaryInCoachFromFloatToInt')
INSERT INTO VERSIONS VALUES (2, 'USPAddSalaryToDietician','USPDropSalaryFromDietician')
INSERT INTO VERSIONS VALUES (3, 'USPAddDFDomainForCertificat','USPDropDFDomainFromCertificat')
INSERT INTO VERSIONS VALUES (4, 'USPAddPKForArticle','USPDropPKFromArticle')
INSERT INTO VERSIONS VALUES (5, 'USPAddUCForDietician','USPDropUCFromDietician')
INSERT INTO VERSIONS VALUES (6, 'USPAddFKCoachIdForCertificat','USPDropFKCoachIdFromCertificat')
INSERT INTO VERSIONS VALUES (7, 'USPCreateDiploma','USPDropDiploma')
