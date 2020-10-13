CREATE DATABASE lab4;
USE lab4

SELECT TOP 5 * FROM Pupils;
SELECT TOP 5 * FROM Subjects;
SELECT TOP 5 * FROM Score;

-- Видим, что заполнение таблиц страдает: кто-то оставил перву строку для трёх столбцов пустой в таблице Subject
-- Исправляем ошибки заполнения уже в бд с помощью ALTER TABLE

ALTER TABLE Subjects DROP COLUMN F3, F4, F5;

-- З-1. Создать функцию, которая принимает на вход 3 числа - индексы дисциплин
-- Возвращает одно число - количество участников, набравших более 200б в сумме по этим трём предметам
-- Используем скалярную ф-цию
go
CREATE FUNCTION top_summ(@score INT, @idSub1 INT, @idSub2 INT, @idSub3 INT)
RETURNS INT 
AS
BEGIN
	DECLARE @count INT = 0
	DECLARE @id_pupil INT
	DECLARE @sum INT = 0
	-- добавляем курсор
	DECLARE pupilCursor CURSOR FOR SELECT Номер FROM Pupils
	OPEN pupilCursor
	FETCH NEXT FROM pupilCursor INTO @id_pupil
	-- пока курсор работает:
	WHILE @@FETCH_STATUS = 0
	BEGIN
		SELECT @sum = SUM(Баллы) FROM Score WHERE [Номер участника] = @id_pupil AND Дисциплина IN (@idSub1, @idSub2, @idSub3)

		IF @sum >= @score
			SET @count = @count + 1
		
		FETCH NEXT FROM pupilCursor INTO @id_pupil
	END
	RETURN @count
END
go
SELECT lab4.dbo.top_summ(200, 2, 3, 4) AS Количество

-- то же самое запросом
SELECT COUNT(id.[Номер участника]) FROM 
(	SELECT [Номер участника] FROM Score 
	WHERE Дисциплина IN (2, 3, 4)
	GROUP BY [Номер участника]
	HAVING (SUM(Баллы) >= 200)
) AS id


-- Для второго задания нужно посчитать среднее баллов по предмету idTargetSub, при условии, что по по предмету idSub участник набрал баллов больше, чем score
-- т.е. сохранить сумму и количество и вернуть их отношение
GO
CREATE FUNCTION avg_score(@idSub INT, @score INT, @idTargetSub INT)
RETURNS REAL
AS
BEGIN 
	DECLARE @sum INT = 0
	DECLARE @count INT = 0
	DECLARE @idPupil INT
	DECLARE @scoreTarget INT
	
	DECLARE idPupilCursor CURSOR FOR SELECT Номер FROM Pupils
	OPEN idPupilCursor

	FETCH NEXT FROM idPupilCursor INTO @idPupil

	WHILE @@FETCH_STATUS = 0
	BEGIN
		SELECT @scoreTarget = (SELECT Баллы FROM Score s WHERE [Номер участника]  = @idPupil AND Дисциплина = @idTargetSub AND 
								(SELECT Баллы FROM Score sc WHERE sc.[Номер участника] = @idPupil AND Дисциплина = @idSub) > @score)

		
		IF @scoreTarget > 0
		BEGIN
			SET @sum = @sum + @scoreTarget
			SET @count = @count + 1
		END
		FETCH NEXT FROM idPupilCursor INTO @idPupil
	END
	RETURN @sum/@count
END
go
 
SELECT lab4.dbo.avg_score(2, 60, 3) AS [Среднее]
-- drop function avg_score

-- то же самое запросом
SELECT SUM(Баллы)/COUNT(Баллы) AS [Средний балл] FROM Score s WHERE Дисциплина = 3 AND 
(SELECT Баллы FROM Score sc WHERE sc.[] = s.[Номер участника] AND Дисциплина = 2) > 60

