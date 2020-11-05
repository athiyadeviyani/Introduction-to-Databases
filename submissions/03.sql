SELECT SG.student, SG.min, SG.max, SG.count
FROM (
    SELECT E.student, AVG(E.grade), MAX(E.grade), MIN(E.grade), COUNT(E.grade)
    FROM Exams E
    GROUP BY E.student) AS SG
WHERE SG.avg >= 75;