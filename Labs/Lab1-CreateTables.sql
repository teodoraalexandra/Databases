/*COMPETITION*/
create table Competition
(
	CompetitionId int Primary Key identity(1,1),
	CompetitionDate date,
	Country varchar(50)
)

/*CATEGORY*/
create table Category
(
	CategoryId int Primary Key identity(1,1),
	CompetitionId int foreign key references Competition(CompetitionId),
	AthleteId int foreign key references Athlete(AthleteId)
)

/*ATHLETE*/
create table Athlete
(
	AthleteId int Primary Key identity(1,1),
	FirstName varchar(50),
	LastName varchar(50),
	Age int, 
	HeightA int, 
	WeightA int, 
)

/*DIETICIAN*/
create table Dietician
(
	DieticianId int Primary Key identity(1,1),
	FirstName varchar(50),
	LastName varchar(50),
	Username int foreign key references Account(Username)
)

/*ARTICLE*/
create table Article
(
	ArticleId int Primary Key identity(1,1),
	Title varchar(50),
	About varchar(50), 
	ArticleDate date,
	DieticianId int foreign key references Dietician(DieticianId)
)

/*ACCOUNT*/
create table Account
(
	Username int Primary Key,
	PasswordA varchar(50),
	Question varchar(50),
	Answer varchar(50)
)

/*CERTIFICATE*/
create table Certificat
(
	CertificateId int Primary Key identity(1,1),
	DateReceived date,
	Domain varchar(50),
	CoachId int foreign key references Coach(CoachId)
)

/*COACH*/
create table Coach
(
	CoachId int Primary Key identity(1,1),
	FirstName varchar(50),
	LastName varchar(50),
	Username int foreign key references Account(Username)
)

/*CLIENT*/
create table Client
(
	ClientId int Primary Key identity(1,1),
	FirstName varchar(50),
	LastName varchar(50),
	Goal varchar(50),
	Username int foreign key references Account(Username),
	CoachId int foreign key references Coach(CoachId)
)

/*ORDERS*/
create table Orders
(
	OrderId int Primary Key identity(1,1),
	OrdersDate date,
	ClientId int foreign key references Client(ClientId)
)

/*PROTEIN*/
create table Protein
(
	ProteinId int Primary Key identity(1,1),
	ProteinName varchar(50),
	Price int
)

/*NUTRITION*/
create table Nutrition
(
	NutritionId int Primary Key identity(1,1),
	NutritionName varchar(50),
	Price int
)

/*OrderItem*/
create table OrderItem
(
	OrderItemId int Primary Key identity(1,1),
	OrderId int foreign key references Orders(OrderId),
	ProteinId int foreign key references Protein(ProteinId),
	NutritionId int foreign key references Nutrition(NutritionId)
)

/*CREATE CONECTION BETWEEN COACH AND ATHLETE*/
ALTER TABLE Athlete
ADD FOREIGN KEY (CoachID) REFERENCES Coach(CoachID);    
/*END CREATION*/