USE MASTER
GO
DROP DATABASE IF EXISTS IGraph
GO
CREATE DATABASE IGraph
GO
USE IGraph
GO

-- Создание таблицы учителей (Teachers)
CREATE TABLE Teachers (
    ID INT PRIMARY KEY,
    Name VARCHAR(50),
    LastName VARCHAR(50),
    Email VARCHAR(100)
) AS NODE;

-- Создание таблицы курсов (Courses)
CREATE TABLE Courses (
    ID INT PRIMARY KEY,
    Name VARCHAR(100)
) AS NODE;

-- Создание таблицы студентов (Students)
CREATE TABLE Students (
    ID INT PRIMARY KEY,
    Name VARCHAR(50),
    LastName VARCHAR(50),
    Email VARCHAR(100)
) AS NODE;


CREATE TABLE Includes AS EDGE;
CREATE TABLE Teaches AS EDGE;
CREATE TABLE Visits AS EDGE;

INSERT INTO Teachers (ID, Name, LastName, Email) VALUES
(1, 'Иван', 'Иванов', 'ivan@example.com'),
(2, 'Петр', 'Петров', 'petr@example.com'),
(3, 'Мария', 'Сидорова', 'maria@example.com'),
(4, 'Анна', 'Козлова', 'anna@example.com'),
(5, 'Алексей', 'Смирнов', 'alex@example.com'),
(6, 'Елена', 'Николаева', 'elena@example.com'),
(7, 'Сергей', 'Кузнецов', 'sergey@example.com'),
(8, 'Ольга', 'Иванова', 'olga@example.com'),
(9, 'Дмитрий', 'Попов', 'dmitry@example.com'),
(10, 'Наталья', 'Морозова', 'natalya@example.com');

INSERT INTO Courses (ID, Name) VALUES
(1, 'Математика'),
(2, 'Физика'),
(3, 'История'),
(4, 'Литература'),
(5, 'Химия'),
(6, 'Биология'),
(7, 'География'),
(8, 'Иностранный язык'),
(9, 'Информатика'),
(10, 'Искусство');

INSERT INTO Students (ID, Name, LastName, Email) VALUES
(1, 'Александр', 'Смирнов', 'alexander@example.com'),
(2, 'Екатерина', 'Иванова', 'ekaterina@example.com'),
(3, 'Михаил', 'Кузнецов', 'mikhail@example.com'),
(4, 'Анастасия', 'Попова', 'anastasia@example.com'),
(5, 'Дарья', 'Соколова', 'darya@example.com'),
(6, 'Александра', 'Петрова', 'alexandra@example.com'),
(7, 'Илья', 'Федоров', 'ilya@example.com'),
(8, 'Елизавета', 'Морозова', 'elizaveta@example.com'),
(9, 'Максим', 'Васильев', 'maxim@example.com'),
(10, 'Арина', 'Сидорова', 'arina@example.com');


INSERT INTO Includes ($from_id, $to_id)
VALUES ((SELECT $node_id FROM Courses WHERE id = 1),
 (SELECT $node_id FROM Courses WHERE id = 2)),
 ((SELECT $node_id FROM Courses WHERE id = 10),
 (SELECT $node_id FROM Courses WHERE id = 5)),
 ((SELECT $node_id FROM Courses WHERE id = 2),
 (SELECT $node_id FROM Courses WHERE id = 9)),
 ((SELECT $node_id FROM Courses WHERE id = 3),
 (SELECT $node_id FROM Courses WHERE id = 1)),
 ((SELECT $node_id FROM Courses WHERE id = 3),
 (SELECT $node_id FROM Courses WHERE id = 6)),
 ((SELECT $node_id FROM Courses WHERE id = 4),
 (SELECT $node_id FROM Courses WHERE id = 2)),
 ((SELECT $node_id FROM Courses WHERE id = 5),
 (SELECT $node_id FROM Courses WHERE id = 4)),
 ((SELECT $node_id FROM Courses WHERE id = 6),
 (SELECT $node_id FROM Courses WHERE id = 7)),
 ((SELECT $node_id FROM Courses WHERE id = 6),
 (SELECT $node_id FROM Courses WHERE id = 8)),
 ((SELECT $node_id FROM Courses WHERE id = 8),
 (SELECT $node_id FROM Courses WHERE id = 3));

 
INSERT INTO Teaches ($from_id, $to_id)
VALUES ((SELECT $node_id FROM Teachers WHERE ID = 1),
 (SELECT $node_id FROM Courses WHERE ID = 1)),
 ((SELECT $node_id FROM Teachers WHERE ID = 5),
 (SELECT $node_id FROM Courses WHERE ID = 1)),
 ((SELECT $node_id FROM Teachers WHERE ID = 8),
 (SELECT $node_id FROM Courses WHERE ID = 1)),
 ((SELECT $node_id FROM Teachers WHERE ID = 2),
 (SELECT $node_id FROM Courses WHERE ID = 2)),
 ((SELECT $node_id FROM Teachers WHERE ID = 3),
 (SELECT $node_id FROM Courses WHERE ID = 3)),
 ((SELECT $node_id FROM Teachers WHERE ID = 4),
 (SELECT $node_id FROM Courses WHERE ID = 3)),
 ((SELECT $node_id FROM Teachers WHERE ID = 6),
 (SELECT $node_id FROM Courses WHERE ID = 4)),
 ((SELECT $node_id FROM Teachers WHERE ID = 7),
 (SELECT $node_id FROM Courses WHERE ID = 4)),
 ((SELECT $node_id FROM Teachers WHERE ID = 1),
 (SELECT $node_id FROM Courses WHERE ID = 9)),
 ((SELECT $node_id FROM Teachers WHERE ID = 9),
 (SELECT $node_id FROM Courses WHERE ID = 4)),
 ((SELECT $node_id FROM Teachers WHERE ID = 10),
 (SELECT $node_id FROM Courses WHERE ID = 9));
 
INSERT INTO Visits ($from_id, $to_id)
VALUES ((SELECT $node_id FROM Students WHERE ID = 1),
 (SELECT $node_id FROM Courses WHERE ID = 6)),
 ((SELECT $node_id FROM Students WHERE ID = 5),
 (SELECT $node_id FROM Courses WHERE ID = 1)),
 ((SELECT $node_id FROM Students WHERE ID = 8),
 (SELECT $node_id FROM Courses WHERE ID = 7)),
 ((SELECT $node_id FROM Students WHERE ID = 2),
 (SELECT $node_id FROM Courses WHERE ID = 2)),
 ((SELECT $node_id FROM Students WHERE ID = 3),
 (SELECT $node_id FROM Courses WHERE ID = 5)),
 ((SELECT $node_id FROM Students WHERE ID = 4),
 (SELECT $node_id FROM Courses WHERE ID = 3)),
 ((SELECT $node_id FROM Students WHERE ID = 6),
 (SELECT $node_id FROM Courses WHERE ID = 4)),
 ((SELECT $node_id FROM Students WHERE ID = 7),
 (SELECT $node_id FROM Courses WHERE ID = 2)),
 ((SELECT $node_id FROM Students WHERE ID = 1),
 (SELECT $node_id FROM Courses WHERE ID = 9)),
 ((SELECT $node_id FROM Students WHERE ID = 9),
 (SELECT $node_id FROM Courses WHERE ID = 8)),
 ((SELECT $node_id FROM Students WHERE ID = 10),
 (SELECT $node_id FROM Courses WHERE ID = 9));

SELECT C.name, S.name
FROM Courses AS C
	, Visits AS V
	, Students AS S
WHERE MATCH(S-(V)->C)
	AND C.name = 'Физика';

SELECT C.name, T.name
FROM Courses AS C
	, Teaches AS Ts
	, Teachers AS T
WHERE MATCH(T-(Ts)->C)
AND C.name = 'Математика';

SELECT C.name, T.name
FROM Courses AS C
	, Teaches AS Ts
	, Teachers AS T
WHERE MATCH(T-(Ts)->C)
AND T.name = 'Иван';

SELECT C.name, S.name
FROM Courses AS C
	, Visits AS V
	, Students AS S
WHERE MATCH(S-(V)->C)
AND S.name = 'Александр';

SELECT c1.name, c2.name
FROM Courses c1
	, Includes i
	, Courses c2
WHERE MATCH(c1-(i)->c2)
AND c1.name = 'Биология';

SELECT C1.name
 , STRING_AGG(C2.name, '->') WITHIN GROUP (GRAPH PATH)
AS Includes
FROM Courses AS C1
 , Includes FOR PATH AS i
 , Courses FOR PATH AS C2
WHERE MATCH(SHORTEST_PATH(C1(-(i)->C2)+))
 AND C1.name = 'Биология';

SELECT C1.name
 , STRING_AGG(C2.name, '->') WITHIN GROUP (GRAPH PATH)
AS Includes
FROM Courses AS C1
 , Includes FOR PATH AS i
 , Courses FOR PATH AS C2
WHERE MATCH(SHORTEST_PATH(C1(-(i)->C2){1,3}))
 AND C1.name = 'Биология';

 SELECT C1.id AS IdFirst
	, C1.name AS First
	, CONCAT(N'course (', C1.id, ')') AS [First image name]
	, C2.id AS IdSecond
	, C2.name AS Second
	, CONCAT(N'course (', C2.id, ')') AS [Second image name]
FROM Courses AS C1
 , Includes AS i
 , Courses AS C2
WHERE MATCH(C1-(i)->C2);

 SELECT C.id AS IdFirst
	, C.name AS First
	, CONCAT(N'course (', C.id, ')') AS [First image name]
	, T.id AS IdSecond
	, T.name AS Second
	, CONCAT(N'teacher (', T.id, ')') AS [Second image name]
FROM Courses AS C
 , Teaches AS TS
 , Teachers AS T
WHERE MATCH(T-(TS)->C);

 SELECT C.id AS IdFirst
	, C.name AS First
	, CONCAT(N'course (', C.id, ')') AS [First image name]
	, S.id AS IdSecond
	, S.name AS Second
	, CONCAT(N'student (', S.id, ')') AS [Second image name]
FROM Courses AS C
 , Visits AS V
 , Students AS S
WHERE MATCH(S-(V)->C);

select @@servername