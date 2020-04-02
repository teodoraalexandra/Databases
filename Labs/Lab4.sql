/*----------CREATE TEST----------*/

/*CREATE TYPE PROCTABEL
   AS TABLE
      ( ID INT IDENTITY(1,1)
      , VALUE VARCHAR(255) );
DECLARE @PROCTABEL AS PROCTABEL*/

GO
CREATE OR ALTER PROCEDURE ProcesareTabel (@idxTabel int, @PROCTABEL PROCTABEL READONLY, @TestName VARCHAR(255))
AS

WHILE @idxTabel < ((select COUNT(*) from @PROCTABEL) + 1)
				BEGIN /*SMALL WHILE*/
				DECLARE @TableName VARCHAR(255) = (SELECT D.VALUE FROM @PROCTABEL D WHERE D.ID = @idxTabel); /*photosesion*/
				DECLARE @NoOfRows int = (SELECT D.VALUE FROM @PROCTABEL D WHERE D.ID = @idxTabel + 1); /*400*/
				DECLARE @Position int = (SELECT D.VALUE FROM @PROCTABEL D WHERE D.ID = @idxTabel + 2); /*4*/
					DECLARE @TestId INT /*Get TestId from the Tests table*/
					SET @TestId = (SELECT TestId
									FROM Tests T
									WHERE T.Name = @TestName)
					DECLARE @TableId INT /*Get the TableId from the table involved*/
					SET @TableId = (SELECT TableID
									FROM Tables T
									WHERE T.Name = @TableName)

					INSERT INTO TestTables(TestID, TableID, NoOfRows, Position) VALUES (@TestId, @TableId, @NoOfRows, @Position)

					SET @idxTabel = @idxTabel + 3
				END; /*END SMALL WHILE*/


GO
CREATE OR ALTER PROCEDURE CreateTest (@TestName varchar(50), @tags NVARCHAR(max))
AS

DECLARE @DYVALUE TABLE (
	ID INT IDENTITY(1,1),
	VALUE NVARCHAR(MAX)
)

INSERT INTO @DYVALUE 
SELECT value  
FROM STRING_SPLIT(@tags, '|')  
WHERE RTRIM(value) <> '';

INSERT INTO Tests(Name) VALUES(@TestName)

DECLARE @idx int = 1
DECLARE @IndividualValue VARCHAR(255);

WHILE @idx < ((select COUNT(*) from @DYVALUE) + 1)
	BEGIN /*BIG WHILE*/
		SET @IndividualValue = (SELECT D.VALUE FROM @DYVALUE D WHERE D.ID = @idx);
		IF CHARINDEX(',' ,@IndividualValue) > 0
			BEGIN /*IF BEGIN*/
			
			DECLARE @PROCTABEL AS PROCTABEL
			INSERT INTO @PROCTABEL 
			SELECT value  
			FROM STRING_SPLIT(@IndividualValue, ',')  
			WHERE RTRIM(value) <> '';

			DECLARE @idxTabel int = 1
			DECLARE @IndividualValueTabel VARCHAR(255);
			END;  /*END IF*/
		ELSE 
			BEGIN /*ELSE*/
			DECLARE @TestId INT /*Get TestId from the Tests table*/
					SET @TestId = (SELECT TestId
									FROM Tests T
									WHERE T.Name = @TestName)
			DECLARE @ViewId INT /*Get the ViewId from the view involved*/
					SET @ViewId = (SELECT ViewID
									FROM Views V
				  				    WHERE V.Name = @IndividualValue)

			INSERT INTO TestViews(TestID, ViewID) VALUES (@TestId, @ViewId)
			END; /*END ELSE*/

	SET @idx = @idx + 1
	END; /*END BIG WHILE*/
EXEC ProcesareTabel @idxTabel, @PROCTABEL, @TestName

GO
EXEC CreateTest 'Test1', '|PhotoSesion,400,2|Article,200,3|MostActiveAthlete|Participate,300,1' 
EXEC CreateTest 'Test2', '|Article,500,1|MostActiveAthlete|ClientMuscleGain|CoachWithZumbaCertificate'
EXEC CreateTest 'Test3', '|ClientMuscleGain|Article,100,1|Participate,200,2'

/*SELECT * FROM Tests
SELECT * FROM TestTables
SELECT * FROM TestViews*/
/*DELETE Tests
DELETE TestTables
DELETE TestViews*/

/*----------INSERT PROCEDURE----------*/
GO
CREATE OR ALTER PROCEDURE SelectRandomFk (@Column VARCHAR(255), @Table VARCHAR(255), @insertString varchar(255) output)
AS
BEGIN
	DECLARE @cmd varchar(100)
	DECLARE @number int

	CREATE TABLE #number (RecordCount INT)

	SELECT @cmd = 'INSERT INTO #number SELECT top 1 [' + @Column + '] FROM [' + @Table + '] order by newid() '
	EXECUTE (@cmd)

	SELECT @number = RecordCount FROM #number
	DROP TABLE #number
	SET @insertString = @insertString + (CAST(@number AS VARCHAR)) + ', ' 
END
GO

GO
CREATE OR ALTER PROCEDURE TestInsert (@TableId INT, @TestId INT)
AS
BEGIN
	DECLARE @Contor INT = 1
	DECLARE @ContorFK int = 1
	DROP TABLE Ref
	CREATE TABLE Ref ( IDFK int identity(1,1) primary key, RefTable VARCHAR(255), RefColumn VARCHAR(255) )
	DECLARE @ForeignKeys INT = 0
	DECLARE @TableName VARCHAR(255) = (SELECT Tables.Name
						FROM Tables
						WHERE Tables.TableID = @TableId)

	DROP TABLE SystemTableColumns
	CREATE TABLE SystemTableColumns (
		SysId int IDENTITY(1,1) PRIMARY KEY,
		ColumnName VARCHAR(50),
		ColumnType VARCHAR(50)
	)
	INSERT INTO SystemTableColumns (ColumnName, ColumnType)
			SELECT c.name, t.name
			FROM sys.objects o INNER JOIN sys.columns c ON o.object_id = c.object_id
					INNER JOIN sys.types t ON c.system_type_id = t.system_type_id
			WHERE o.name = @TableName
			ORDER BY c.column_id

	DECLARE @NrOfRowsThatMustBeInserted INT
	SET @NrOfRowsThatMustBeInserted = (SELECT TestTables.NoOfRows
					FROM TestTables
					WHERE TestTables.TableID = @TableId and TestTables.TestID = @TestId)

	/*This variable will be 5 in this case here*/
	DECLARE @NrOfColumnsFromTable INT
	SET @NrOfColumnsFromTable = (SELECT COUNT(*) FROM SystemTableColumns)
	DECLARE @systemContor INT
	SET @systemContor = 1
	DECLARE @positionContor INT 
	SET @positionContor = 1
	DECLARE @ColumnName VARCHAR(50)
	DECLARE @ColumnType VARCHAR(50)
	
	/*RANDOM PART*/
	DECLARE @RandomDate DATE
	DECLARE @RandomInt INT 
	SET @RandomInt = CAST(RAND() * 5 + 3 as INT)
	DECLARE @RandomVar VARCHAR(50) 
	DECLARE @length INT
	SET @RandomVar = ''
	SET @length = CAST(RAND() * 160 as INT)
	WHILE @length <> 0
		BEGIN
		SET @RandomVar = @RandomVar + CHAR(CAST(RAND() * 96 + 32 as INT))
		SET @length = @length - 1
		END;

	declare @insertString VARCHAR(MAX)
	set @insertString = 'INSERT INTO ' + @TableName + ' VALUES('

	WHILE @positionContor <= @NrOfRowsThatMustBeInserted 
	BEGIN /*1 begin*/
		SET @insertString = 'INSERT INTO ' + @TableName + ' VALUES( '
		PRINT(@TableName)
		WHILE @systemContor <= @NrOfColumnsFromTable 
		BEGIN /*2 begin*/
			SET @ColumnName = (SELECT SystemTableColumns.ColumnName
								FROM SystemTableColumns
								WHERE SystemTableColumns.SysId = @systemContor) /*PhotoSesionDate*/
			SET @ColumnType = (SELECT SystemTableColumns.ColumnType
								FROM SystemTableColumns
								WHERE SystemTableColumns.SysId = @systemContor) /*date*/
			BEGIN /*3 begin*/
				IF @ColumnType = 'date'
				BEGIN
					SET @RandomDate = GETDATE() /*Generate a random date*/
					SET @insertString = @insertString + '''' + (CAST(@RandomDate AS VARCHAR)) + '''' + ', '
				END;

				IF @ColumnType = 'varchar'
				BEGIN
					SET @RandomVar = (SELECT TOP 1 Name
									FROM RandomNames
									ORDER BY NEWID()); /*Generate a random name*/
					SET @insertString = @insertString + '''' + @RandomVar + '''' + ', '
				END;

				IF @ColumnType = 'int' 
				/*INT HAS MORE CASES:
				- It is a simple int, so it must be generated randomly, without any complications :p
				- It is an identity column, so basically we do nothing here
				- It is a foreign key - we get random value from the reference table
				- It is a primary key - we could not set a random value -> we set the @PositionContor for simplicity*/
				BEGIN
					IF columnproperty(object_id(@TableName),@ColumnName,'IsIdentity') = 0
					BEGIN /*BEGIN IDENTITY*/
					/*CHECK IF COLUMN IS FOREIGN KEY*/
						DECLARE @RefTableValue VARCHAR(255)
						DECLARE @RefColumnValue VARCHAR(255)
				
						DECLARE @NrForeignKeys int = (SELECT COUNT(*) FROM sys.foreign_key_columns WHERE OBJECT_NAME(parent_object_id) = @TableName)
					
							insert into Ref(RefTable, RefColumn) values (
								(select top 1 OBJECT_NAME(referenced_object_id) 
								from sys.foreign_key_columns
								where OBJECT_NAME(referenced_object_id) in (select top (@ContorFK) OBJECT_NAME(referenced_object_id) from sys.foreign_key_columns 
										WHERE OBJECT_NAME(parent_object_id) = @TableName 
										order by OBJECT_NAME(referenced_object_id) desc)
								order by OBJECT_NAME(referenced_object_id) asc),

								(select top 1 COL_NAME(parent_object_id, parent_column_id)
								from sys.foreign_key_columns
								where COL_NAME(parent_object_id, parent_column_id) in (select top (@ContorFK) COL_NAME(parent_object_id, parent_column_id) from sys.foreign_key_columns 
										WHERE OBJECT_NAME(parent_object_id) = @TableName
										order by OBJECT_NAME(referenced_object_id) desc)
								order by OBJECT_NAME(referenced_object_id) asc)
							)
						SET @ContorFK = @ContorFK + 1
					
						WHILE @Contor <= @NrForeignKeys
						BEGIN
							SET @RefColumnValue = (SELECT RefColumn FROM Ref WHERE IDFK = @Contor)
							SET @RefTableValue = (SELECT RefTable FROM Ref WHERE IDFK = @Contor)
							IF @NrForeignKeys <> 0
							BEGIN /*FK BEGIN*/
								EXEC SelectRandomFk @RefColumnValue, @RefTableValue, @insertString OUTPUT 
							END; /*FK END*/
							SET @Contor = @Contor + 1
						END;
						
						IF @NrForeignKeys = 0 
							BEGIN 
								SET @RandomInt = RAND()*(100-50)+50; /*Generate random int between 50 and 100*/
								SET @insertString = @insertString + (CAST(@RandomInt AS VARCHAR)) + ', '
							END;
					END; /*END IDENTITY*/
				END;
			END; /*3 end*/
			SET @systemContor = @systemContor + 1
		END; /*2 end*/
		/*BEFORE CLOSING THE INSERT STATEMENT, WE SHOULD DELETE THE LAST COMMA*/
		SET @insertString = CASE @insertString WHEN null THEN null 
							ELSE (
							CASE LEN(@insertString) WHEN 0 THEN @insertString
							ELSE LEFT(@insertString, LEN(@insertString) - 1) 
							END 
							) END
		SET @insertString = @insertString + ')'
		EXEC(@insertString)
		SET @systemContor = 1
		SET @Contor = 1
		SET @ContorFK = 1
		SET @positionContor = @positionContor + 1
		
	END; /*1 end*/
END; /*Procedure end*/
GO

EXEC TestInsert 1, 252
EXEC TestInsert 2, 252
EXEC TestInsert 3, 252

SELECT * FROM PhotoSesion
SELECT * FROM Article
SELECT * FROM Participate

/*----------DELETE PROCEDURE----------*/
GO
CREATE OR ALTER PROCEDURE TestDelete (@TableId INT)
AS
BEGIN
	DECLARE @TableName VARCHAR(50)  
	SET @TableName = (SELECT Tables.Name
					FROM Tables
					WHERE Tables.TableID = @TableId)
	DECLARE @DeleteQuery VARCHAR(50) = 'DELETE FROM ' + @TableName
	EXEC (@DeleteQuery)
END

EXEC TestDelete 1
EXEC TestDelete 2
EXEC TestDelete 3

SELECT * FROM PhotoSesion
SELECT * FROM Article
SELECT * FROM Participate


/*----------SELECT VIEW PROCEDURE----------*/
GO
CREATE OR ALTER PROCEDURE TestSelectViews (@ViewId INT)
AS
BEGIN
	DECLARE @ViewName VARCHAR(50)
	SET @ViewName = (SELECT Views.Name
					FROM Views
					WHERE Views.ViewID = @ViewId)
	DECLARE @SelectQuery VARCHAR(50) = 'SELECT * FROM ' + @ViewName
	EXEC(@SelectQuery)
END;

EXEC TestSelectViews 1
EXEC TestSelectViews 2
EXEC TestSelectViews 3


/*----------RUN PROCEDURE----------*/
GO
CREATE OR ALTER PROCEDURE Run (@TestName VARCHAR(255))
AS 
	DECLARE @StartTime TIME = CONVERT(TIME, GETDATE());
	INSERT INTO TestRuns (Description, StartAt) VALUES ('SUCCESSFUL', @StartTime)
	DECLARE @TestRunId INT = (SELECT MAX(TestRuns.TestRunID)
							FROM TestRuns)

	DECLARE @TestId INT = (SELECT T.TestID
							FROM Tests T
							WHERE T.Name = @TestName)
	
	DECLARE @ViewId INT
	DECLARE @TableId INT

	/*ITERATE THROUGH VIEWS*/
	DECLARE IterateView CURSOR FAST_FORWARD READ_ONLY
	FOR
		SELECT TestViews.ViewID
		FROM TestViews
		WHERE TestViews.TestID = @TestId

	OPEN IterateView 

	FETCH NEXT FROM IterateView INTO @ViewId

	WHILE @@FETCH_STATUS = 0
    BEGIN
		DECLARE @StartTimeView TIME = CONVERT(TIME, GETDATE());
		EXEC TestSelectViews @ViewId
		DECLARE @EndTimeView TIME = CONVERT(TIME, GETDATE());
		INSERT INTO TestRunViews(TestRunID, ViewID, StartAt, EndAt) VALUES (@TestRunId, @ViewId, @StartTimeView, @EndTimeView)
    
        FETCH NEXT FROM IterateView INTO @ViewId

    END

	CLOSE IterateView
	DEALLOCATE IterateView
	/*END VIEWS ITERATION*/

	/*ITERATE THROUGH TABLES - DELETE*/
	DECLARE IterateTablesDelete CURSOR FAST_FORWARD READ_ONLY
	FOR
		SELECT TestTables.TableID
		FROM TestTables
		WHERE TestTables.TestID = @TestId
		ORDER BY TestTables.Position ASC

	OPEN IterateTablesDelete

	FETCH NEXT FROM IterateTablesDelete INTO @TableId
	WHILE @@FETCH_STATUS = 0
	BEGIN
		EXEC TestDelete @TableId
		FETCH NEXT FROM IterateTablesDelete INTO @TableId

	END

	CLOSE IterateTablesDelete
	DEALLOCATE IterateTablesDelete
	/*END TABLE ITERATION - DELETE*/

	/*ITERATE THROUGH TABLES - INSERT*/
	DECLARE IterateTablesInsert CURSOR FAST_FORWARD READ_ONLY
	FOR
		SELECT TestTables.TableID
		FROM TestTables
		WHERE TestTables.TestID = @TestId
		ORDER BY TestTables.Position DESC

	OPEN IterateTablesInsert

	FETCH NEXT FROM IterateTablesInsert INTO @TableId
	WHILE @@FETCH_STATUS = 0
	BEGIN
		DECLARE @StartTimeTable TIME = CONVERT(TIME, GETDATE());
		EXEC TestInsert @TableId, @TestId
		DECLARE @EndTimeTable TIME = CONVERT(TIME, GETDATE());
		INSERT INTO TestRunTables(TestRunID, TableID, StartAt, EndAt) VALUES (@TestRunId, @TableId, @StartTimeTable, @EndTimeTable)
    
        FETCH NEXT FROM IterateTablesInsert INTO @TableId

	END
	CLOSE IterateTablesInsert
	DEALLOCATE IterateTablesInsert
	/*END TABLE ITERATION - INSERT*/


	/*UPDATE TESTS RUN*/
	DECLARE @EndTime TIME = CONVERT(TIME, GETDATE());
	UPDATE TestRuns
	SET TestRuns.EndAt = @EndTime
	WHERE TestRuns.TestRunID = @TestRunId
GO

EXEC Run 'Test1'

SELECT * FROM TestRuns
SELECT * FROM TestRunViews
SELECT * FROM TestRunTables

/*CONCLUZII:
TEST 1 - 6 SECUNDE - 3 TABELE (400 + 200 + 300 = 900 ROWS) SI 1 VIEW
TEST 2 - 3 SECUNDE - 1 TABEL (500 ROWS) SI 3 VIEWS
TEST 3 - 3 SECUNDE - 2 TABELE (100 + 200 = 300 ROWS) SI 1 VIEW*/

