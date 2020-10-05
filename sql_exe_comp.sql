-- Задания взяты с сайта sql-exe.ru
-- Описание бд: 
-- 4 таблицы:
-- Product(maker, model, type)
-- PC(code, model, speed, ram, hd, cd, price)
-- Laptop(code, model, speed, ram, hd, price, screen)
-- Printer(code, model, color, type, price)
-- Таблица Product представляет производителя (maker), номер модели (model) и тип ('PC' - ПК, 'Laptop' - ПК-блокнот или 'Printer' - принтер).
-- Предполагается, что номера моделей в таблице Product уникальны для всех производителей и типов продуктов. 
-- В таблице PC для каждого ПК, однозначно определяемого уникальным кодом – code, указаны модель – model (внешний ключ к таблице Product), 
-- скорость - speed (процессора в мегагерцах), объем памяти - ram (в мегабайтах), размер диска - hd (в гигабайтах), 
-- скорость считывающего устройства - cd (например, '4x') и цена - price. 
-- Таблица Laptop аналогична таблице РС за исключением того, что вместо скорости CD содержит размер экрана -screen (в дюймах). 
-- В таблице Printer для каждой модели принтера указывается, является ли он цветным - color ('y', если цветной), 
-- тип принтера - type (лазерный – 'Laser', струйный – 'Jet' или матричный – 'Matrix') и цена - price
CREATE DATABASE forSqlExe
USE forSqlExe

CREATE TABLE Product(
maker NVARCHAR(10), 
model NVARCHAR(50) PRIMARY KEY,
type NVARCHAR(50))

CREATE TABLE PC(
code INT IDENTITY PRIMARY KEY,
model NVARCHAR(50) FOREIGN KEY REFERENCES Product(model),
speed SMALLINT,
ram SMALLINT,
hd REAL,
cd VARCHAR(10),
price MONEY)

CREATE TABLE Laptop(
code INT IDENTITY PRIMARY KEY,
model NVARCHAR(50) FOREIGN KEY REFERENCES Product(model),
speed SMALLINT, 
ram SMALLINT,
hd REAL,
screen TINYINT,
price MONEY)

CREATE TABLE Printer(
code INT IDENTITY PRIMARY KEY,
model NVARCHAR(50) FOREIGN KEY REFERENCES Product(model), 
color CHAR(1),
type VARCHAR(10), 
price MONEY)

INSERT INTO Product VALUES
('A', 2121, 'Laptop'),
('B', 1158, 'PC'),
('B', 1157, 'PC'),
('B', 1189, 'PC'),
('B', 1197, 'PC'),
('B', 1001, 'Laptop'),
('B', 1002, 'Printer'),
('C', 2190, 'Laptop'),
('C', 2171, 'Laptop'),
('C', 2178, 'Laptop'),
('C', 2198, 'Laptop'),
('D', 4219, 'Printer'),
('D', 8519, 'Printer'),
('D', 3975, 'Printer'),
('D', 3010, 'Printer')
--drop table PC
INSERT INTO PC(model, speed, ram, hd, cd, price) VALUES
(1158, 2, 32000, 701, '4x', 70000),
(1157, 1, 3200, 70, '4x', 70),
(1189, 2, 16000, 40, '4x', 540),
(1197, 2, 24000, 300, '4x', 1000)

INSERT INTO Laptop(model, speed, ram, hd, screen, price) VALUES 
(2121, 3, 32000, 500, 17, 60000),
(1001, 2, 24000, 300, 17, 45999),
(2190, 2, 16000, 300, 15, 40999),
(2171, 1, 16000, 200, 17, 25999),
(2178, 1, 8000, 50, 15, 5999),
(2198, 2, 8000, 200, 15, 12999)

INSERT INTO Printer(model, color, type, price) VALUES
(1002, 'y', 'Jet', 7599),
(4219, 'y', 'Laser', 12999),
(8519, 'n', 'Matrix', 1299),
(3975, 'n', 'Jet', 399),
(3010, 'y', 'Jet', 4500)

SELECT * FROM PC

-- 1 Найдите номер модели, скорость и размер жесткого диска для всех ПК стоимостью менее 500 дол. 
-- Вывести: model, speed и hd
SELECT model, speed, hd FROM PC WHERE price < 500

-- 2 Найдите производителей принтеров. Вывести: maker
SELECT DISTINCT maker FROM Product WHERE type = 'Printer'

-- 3 Найдите номер модели, объем памяти и размеры экранов ПК-блокнотов, цена которых превышает 1000 дол.
SELECT model, ram, screen FROM Laptop WHERE price > 1000

-- 4 Найдите все записи таблицы Printer для цветных принтеров
SELECT code, model, color, type, price FROM Printer WHERE color IN('y')

-- 5 Найдите номер модели, скорость и размер жесткого диска ПК, имеющих 12x или 24x CD и цену менее 600 дол
SELECT model, speed, hd FROM PC WHERE (cd = '12x' OR cd = '24x') AND price < 600

-- 6 Для каждого производителя, выпускающего ПК-блокноты c объёмом жесткого диска не менее 10 Гбайт, найти скорости таких ПК-блокнотов
-- Вывод: производитель, скорость
SELECT DISTINCT maker, speed FROM Product LEFT JOIN laptop ON Product.model=Laptop.model WHERE Laptop.hd>=10

-- 7 Найдите номера моделей и цены всех имеющихся в продаже продуктов (любого типа) производителя B (латинская буква)

SELECT p.model, price FROM Product p
INNER JOIN PC ON p.model = PC.model
WHERE p.maker = 'B'
UNION
SELECT p.model, price FROM Product p
INNER JOIN Laptop l ON p.model = l.model
WHERE p.maker='B'
UNION
SELECT p.model, price FROM Product p
INNER JOIN Printer  ON p.model = Printer.model
WHERE p.maker = 'B'

-- 8 Найдите производителя, выпускающего ПК, но не ПК-блокноты
INSERT INTO Product VALUES ('E', 9090, 'PC')
INSERT INTO PC(model, speed, ram, hd, cd, price) VALUES (9090, 3, 32000, 600, '4x', 45000)


SELECT maker FROM Product
WHERE type = 'PC'
EXCEPT  -- для исключения, еще есть INTERSECT
SELECT maker FROM Product
WHERE type = 'Laptop'

-- 9 Найдите производителей ПК с процессором не менее 2. Вывести: Maker
SELECT DISTINCT maker FROM Product p
INNER JOIN PC ON p.model = PC.model
WHERE speed >= 2

-- 10 Найдите модели принтеров, имеющих самую высокую цену. Вывести: model, price
select * from Printer;
insert into Product values ('E', 7756, 'Printer');
insert into Printer(model, color, type, price) values (7756, 'y', 'Matrix', 12999);
-- + создание и использование представления
CREATE VIEW most_expensive_printer AS 
SELECT model, price FROM Printer
WHERE price = (SELECT MAX(price) FROM Printer)

SELECT * FROM most_expensive_printer

-- 11 Найдите среднюю скорость ПК
SELECT AVG(speed) FROM PC

-- 12 Найдите среднюю скорость ПК-блокнотов, цена которых превышает 1000 дол
SELECT AVG(speed) FROM Laptop
WHERE price > 1000

-- 13 Найдите среднюю скорость ПК, выпущенных производителем A
SELECT AVG(speed) FROM Product p
INNER JOIN PC ON p.model = PC.model
WHERE maker = 'A'

-- 14 запрос к другой бд

-- 15 Найдите размеры жестких дисков, совпадающих у двух и более PC. Вывести: HD
SELECT hd FROM pc GROUP BY hd HAVING COUNT(model) >= 2

-- 17 Найдите модели ПК-блокнотов, скорость которых меньше скорости каждого из ПК.
-- Вывести: type, model, speed
SELECT DISTINCT type, laptop.model, speed 
FROM laptop INNER JOIN product ON product.model = laptop.model
WHERE speed < (SELECT MIN(speed) FROM pc)

-- 18 Найдите производителей самых дешевых цветных принтеров. Вывести: maker, price
SELECT DISTINCT maker, price
FROM product INNER JOIN printer ON product.model = printer.model
WHERE price = (SELECT MIN(price) FROM printer WHERE color = 'y') AND color = 'y'

-- 19 Для каждого производителя, имеющего модели в таблице Laptop, найдите средний размер экрана выпускаемых им ПК-блокнотов.
-- Вывести: maker, средний размер экрана.
SELECT maker, AVG(screen) AS avg_screen
FROM product INNER JOIN laptop ON product.model = laptop.model
GROUP BY maker

-- 20 Найдите производителей, выпускающих по меньшей мере три различных модели ПК. Вывести: Maker, число моделей ПК.
SELECT maker, COUNT(model) AS Count_Model
FROM product 
WHERE type = 'PC'
GROUP BY maker
HAVING COUNT(model) >= 3

-- 21 Найдите максимальную цену ПК, выпускаемых каждым производителем, у которого есть модели в таблице PC.
-- Вывести: maker, максимальная цена
SELECT maker, MAX(price) AS Max_price
FROM pc LEFT JOIN product ON pc.model = product.model
GROUP BY maker

-- 22 Для каждого значения скорости ПК, превышающего 600 МГц, определите среднюю цену ПК с такой же скоростью
-- Вывести: speed, средняя цена
SELECT speed, AVG(price) AS Avg_price
FROM pc INNER JOIN product ON pc.model = product.model
WHERE speed > 600
GROUP BY speed

-- 23 Найдите производителей, которые производили бы как ПК со скоростью не менее 750 МГц, 
-- так и ПК-блокноты со скоростью не менее 750 МГц. Вывести: Maker
SELECT maker 
FROM pc INNER JOIN product ON pc.model = product.model
WHERE speed >= 750
INTERSECT 
SELECT maker 
FROM laptop INNER JOIN product ON laptop.model = product.model
WHERE speed >= 750

-- 25 Найдите производителей принтеров, которые производят ПК с наименьшим объемом RAM 
-- и с самым быстрым процессором среди всех ПК, имеющих наименьший объем RAM. Вывести: Maker
SELECT DISTINCT maker 
FROM product INNER JOIN pc ON product.model = pc.model
WHERE ram = (SELECT MIN(ram) FROM pc)
AND speed = (SELECT MAX(speed) FROM pc WHERE ram = (SELECT MIN(ram) FROM pc))
INTERSECT
SELECT DISTINCT maker 
FROM product
WHERE type = 'Printer'
-- другой способ: select .. where type = 'Printer' and maker in (подзапрос)

-- 26 Найдите среднюю цену ПК и ПК-блокнотов, выпущенных производителем A (латинская буква). 
-- Вывести: одна общая средняя цена
SELECT AVG(price)
FROM 
(SELECT code, model, price FROM pc
WHERE model IN (SELECT model FROM product WHERE type = 'PC' AND maker = 'A')
UNION 
SELECT code, model, price FROM laptop
WHERE model IN (SELECT model FROM product WHERE type = 'Laptop' AND maker = 'A')) 
AS prod
-- Не обойтись только моделью и ценой в запросах к pc и laptop, потому что UNION удаляет дубликаты
-- в таком случае, может получиться неверное кол-во записей, в случае если пары {модель, цена} не уникальны

