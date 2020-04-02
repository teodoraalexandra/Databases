/*COMPETITION*/
insert into Competition
	(CompetitionDate, Country) values
		(GETDATE(), 'Romania');
insert into Competition
	(CompetitionDate, Country) values
		(GETDATE(), 'France');
insert into Competition
	(CompetitionDate, Country) values
		(GETDATE(), 'Hungary');
insert into Competition
	(CompetitionDate, Country) values
		(GETDATE(), 'USA');
insert into Competition
	(CompetitionDate, Country) values
		(GETDATE(), 'Poland');

/*ATHLETE*/
insert into Athlete
	(FirstName, LastName, Age, HeightA, WeightA) values
		('Jen', 'Selter',25,165,55);
insert into Athlete
	(FirstName, LastName, Age, HeightA, WeightA) values
		('Tammy', 'Hembrow',35,164,60);
insert into Athlete
	(FirstName, LastName, Age, HeightA, WeightA) values
		('Laura', 'Henshaw',26,165,56);
insert into Athlete
	(FirstName, LastName, Age, HeightA, WeightA) values
		('Ray', 'Shawn',54,170,110);
insert into Athlete
	(FirstName, LastName, Age, HeightA, WeightA) values
		('Ronnie', 'Coleman',55,180,136);


/*DIETICIAN*/
insert into Dietician
	(FirstName, LastName) values
		('Jerry','Nevada');
insert into Dietician
	(FirstName, LastName) values
		('Marry','Smith');
insert into Dietician
	(FirstName, LastName) values
		('Joey','Brown');
insert into Dietician
	(FirstName, LastName) values
		('Louise','Blue');
insert into Dietician
	(FirstName, LastName) values
		('Anthony','Gray');

/*DIETETICIAN HAS DieteticianId from 1 to 5*/
/*Article has Dietetician as foreign key*/

select * from Article;
/*ARTICLE*/
insert into Article
	(Title, About, ArticleDate) values
		('How to lose fat?', 'Weight loss', GETDATE());
insert into Article
	(Title, About, ArticleDate) values
		('How to gain muscle?', 'Muscle gain', GETDATE());
insert into Article
	(Title, About, ArticleDate) values
		('Proteic pancakes', 'Nutrition', GETDATE());
insert into Article
	(Title, About, ArticleDate) values
		('More about good fats', 'Weight loss', GETDATE());
insert into Article
	(Title, About, ArticleDate) values
		('Why is water important?', 'Healthy lifestyle', GETDATE());
/*So, inserting an DieteticianId-6 in Article, will give an error*/
insert into Article 
	(Title, About, ArticleDate, DieticianId) values 
		('More about Omega 3', 'Nutrition', GETDATE(), 6);


/*ACCOUNT*/
insert into Account
	(Username, PasswordA, Question, Answer) values
		(2518, 'yNDNBE', 'Favourite animal', 'Dog');
insert into Account
	(Username, PasswordA, Question, Answer) values
		(1932, 'hIBNbb', 'Mother name', 'Marry');
insert into Account
	(Username, PasswordA, Question, Answer) values
		(9283, '8HnRtt', 'Birth year', '1988');
insert into Account
	(Username, PasswordA, Question, Answer) values
		(2943, 'Insn88', 'Favourite cousin', 'Louie');
insert into Account
	(Username, PasswordA, Question, Answer) values
		(1924, '9SNdgT', 'Year you first swim', '2004');

insert into Account
	(Username, PasswordA, Question, Answer) values
		(5544, '9SNdgT', 'Year you first swim', '2004');
insert into Account
	(Username, PasswordA, Question, Answer) values
		(0239, '9SNdgT', 'Year you first swim', '2004');
insert into Account
	(Username, PasswordA, Question, Answer) values
		(9202, '9SNdgT', 'Year you first swim', '2004');
insert into Account
	(Username, PasswordA, Question, Answer) values
		(0019, '9SNdgT', 'Year you first swim', '2004');
insert into Account
	(Username, PasswordA, Question, Answer) values
		(8273, '9SNdgT', 'Year you first swim', '2004');

insert into Account
	(Username, PasswordA, Question, Answer) values
		(0192, '9SNdgT', 'Year you first swim', '2004');
insert into Account
	(Username, PasswordA, Question, Answer) values
		(1939, '9SNdgT', 'Year you first swim', '2004');
insert into Account
	(Username, PasswordA, Question, Answer) values
		(2000, '9SNdgT', 'Year you first swim', '2004');
insert into Account
	(Username, PasswordA, Question, Answer) values
		(8374, '9SNdgT', 'Year you first swim', '2004');
insert into Account
	(Username, PasswordA, Question, Answer) values
		(2847, '9SNdgT', 'Year you first swim', '2004');


/*COACH*/
insert into Coach
	(FirstName, LastName) values
		('Mike','Borrow');
insert into Coach
	(FirstName, LastName) values
		('Rachel','Green');
insert into Coach
	(FirstName, LastName) values
		('Julie','Mathew');
insert into Coach
	(FirstName, LastName) values
		('Lauen','Oliver');
insert into Coach
	(FirstName, LastName) values
		('Michael','Smith');
insert into Coach 
	(FirstName, LastName) values
		('Emily', 'Brown');


/*CERTIFICAT*/
insert into Certificat
	(DateReceived, Domain) values
		(GETDATE(), 'Circuit Training');
insert into Certificat
	(DateReceived, Domain) values
		(GETDATE(), 'Crossfit');
insert into Certificat
	(DateReceived, Domain) values
		(GETDATE(), 'Dance');
insert into Certificat
	(DateReceived, Domain) values
		(GETDATE(), 'Gymnastics');
insert into Certificat
	(DateReceived, Domain) values
		(GETDATE(), 'Martial Arts');


/*CLIENT*/
insert into Client
	(FirstName, LastName, Goal) values
		('Marry', 'Smith','Weight Loss');
insert into Client
	(FirstName, LastName, Goal) values
		('Louie','Humble','Muscle Gain');
insert into Client
	(FirstName, LastName, Goal) values
		('Christian','Kolin','Fit Aspect');
insert into Client
	(FirstName, LastName, Goal) values
		('Eveline','Viscent','Muscle Gain');
insert into Client
	(FirstName, LastName, Goal) values
		('Karla','Gray','Healthy Lifestyle');


/*ORDERS*/
insert into Orders
	(OrdersDate) values
		(GETDATE());
insert into Orders
	(OrdersDate) values
		(GETDATE());
insert into Orders
	(OrdersDate) values
		(GETDATE());
insert into Orders
	(OrdersDate) values
		(GETDATE());
insert into Orders
	(OrdersDate) values
		(GETDATE());


/*PROTEIN*/
insert into Protein
	(ProteinName, Price) values
		('Just Whey', 100);
insert into Protein
	(ProteinName, Price) values
		('Gold Whey', 150);
insert into Protein
	(ProteinName, Price) values
		('True Whey', 80);
insert into Protein
	(ProteinName, Price) values
		('Whey Professional', 90);
insert into Protein
	(ProteinName, Price) values
		('Vegan Blend', 85);


/*NUTRITION*/
insert into Nutrition
	(NutritionName, Price) values
		('L-Carnitine', 60);
insert into Nutrition
	(NutritionName, Price) values
		('BCAAs', 50);
insert into Nutrition
	(NutritionName, Price) values
		('Pre-Workout', 35);
insert into Nutrition
	(NutritionName, Price) values
		('Post-Workout', 90);
insert into Nutrition
	(NutritionName, Price) values
		('Creatine', 45);