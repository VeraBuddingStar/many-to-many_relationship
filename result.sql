--- 1-й ВАРИАНТ РЕАЛИЗАЦИИ ----------
/*
	Реализация класической связи "многие ко многим". 
	Создаем дополнительную таблицу ProductCategories.
	+: возможность встроенной проверки уникальности
	-: создание доп таблицы
*/
CREATE TABLE Products (
	Id INT PRIMARY KEY,
	Name NVARCHAR(128)
);

INSERT INTO Products
VALUES
	(1, 'НИ СЫ'),
	(2, 'Грокаем алгоритмы'),
	(3, 'Паттерны'),
	(4, 'Война и Мир'),
	(5, 'Азбука');

CREATE TABLE Categories (
	Id INT PRIMARY KEY,
	Name NVARCHAR(128)
);

INSERT INTO Categories
VALUES
	(1, 'It'),
	(2, 'Мотивашки'),
	(3, 'Детские');

CREATE TABLE ProductCategories (
	ProductId INT FOREIGN KEY REFERENCES Products(Id),
	CategoryId INT FOREIGN KEY REFERENCES Categories(Id),
	PRIMARY KEY (ProductId, CategoryId) -- Нужен для уникальности комбинаций в таблице.
);

INSERT INTO ProductCategories
VALUES
	(1, 2),
	(2, 1),
	(2, 2),
	(3, 1),
	(5, 3);

-------- ВАРИАНТЫ ЗАПРОСА: ---------
-- 1 
SELECT product.Name, category.Name
FROM Products AS product
	LEFT JOIN ProductCategories AS productXCategory ON productXCategory.ProductId = product.Id
	LEFT JOIN Categories AS category ON category.Id = productXCategory.CategoryId;

-- 2 
SELECT product.Name, category.Name
FROM Products AS product
  LEFT JOIN ProductCategories AS productXCategory 
    JOIN Categories AS category ON category.Id = productXCategory.CategoryId
  ON product.Id = productXCategory.ProductId;

-- 3
SELECT product.Name, category.Name
FROM ProductCategories AS productXCategory
  JOIN Categories AS category ON productXCategory.CategoryId = category.Id
  RIGHT JOIN Products AS product ON product.Id = productXCategory.ProductId
------------------------------------


--- 2-й ВАРИАНТ РЕАЛИЗАЦИИ ----------
/*
	Создаем дополительное поле в таблице Product.
	+: Отсутствие доп.таблицы
	-: Отсутствует встроенная проверка уникальности, нужна доп. реализация
*/

CREATE TABLE Products (
	Id INT PRIMARY KEY,
	Name NVARCHAR(128),
	Categories NVARCHAR(MAX) -- массив JSON
);

INSERT INTO Products (Id, Name, Categories)
VALUES
	(1, 'НИ СЫ', '[2]'),
	(2, 'Грокаем алгоритмы', '[1,3]'),
	(3, 'Паттерны', '[1]'),
	(4, 'Война и Мир', '[]'),
	(5, 'Азбука', '[3]');

CREATE TABLE Categories (
	Id INT PRIMARY KEY,
	Name NVARCHAR(128)
);

INSERT INTO Categories
VALUES
	(1, 'It'),
	(2, 'Мотивашки'),
	(3, 'Детские');

SELECT 
	product.Name, categories.Name
FROM Products AS product
	OUTER APPLY OPENJSON(product.Categories) AS categoriesList
	LEFT JOIN Categories AS categories ON categories.Id = categoriesList.value
