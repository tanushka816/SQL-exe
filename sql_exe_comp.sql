--CREATE DATABASE forSqlExe
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

-- 7 ������� ������ ������� � ���� ���� ��������� � ������� ��������� (������ ����) ������������� B (��������� �����)

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

-- 8 ������� �������������, ������������ ��, �� �� ��-��������
INSERT INTO Product VALUES ('E', 9090, 'PC')
INSERT INTO PC(model, speed, ram, hd, cd, price) VALUES (9090, 3, 32000, 600, '4x', 45000)
-- �������� �����, ����� ��� ����� ������

SELECT maker FROM Product
WHERE type = 'PC'
EXCEPT  -- ��������� �������� ������ �����, ����������������� ��� - INTERSECT
SELECT maker FROM Product
WHERE type = 'Laptop'
-- ����� �������� ����� ALL, ���� ��� ���, ��������� ���������

-- 9 ������� �������������� �� � ����������� �� ����� 2 ���. �������: Maker
select * from PC
-- ��������� ����� ������� ����� ��������: ����� ���� ��� �������� �� ����� �������
SELECT * FROM Product p
LEFT JOIN PC ON p.model = PC.model
-- inner ���� �����������
SELECT * FROM Product p
INNER JOIN PC ON p.model = PC.model
--
SELECT DISTINCT maker FROM Product p
INNER JOIN PC ON p.model = PC.model
WHERE speed >= 1

-- 10 ������� ������ ���������, ������� ����� ������� ����. �������: model, price
select * from Printer;
insert into Product values ('E', 7756, 'Printer');
insert into Printer(model, color, type, price) values (7756, 'y', 'Matrix', 12999);

CREATE VIEW most_expensive_printer AS 
SELECT model, price FROM Printer
WHERE price = (SELECT MAX(price) FROM Printer)

SELECT * FROM most_expensive_printer

-- �� �� ����� ���� ���������� ������ ������ ���� ������� �� �������� ����������� �������

-- 11 ������� ������� �������� ��
SELECT AVG(speed) FROM PC

-- 12 ������� ������� �������� ��-���������, ���� ������� ��������� 1000 ���
SELECT AVG(speed) FROM Laptop
WHERE price > 1000

-- 13 ������� ������� �������� ��, ���������� �������������� A
SELECT AVG(speed) FROM Product p
INNER JOIN PC ON p.model = PC.model
WHERE maker = 'A'


