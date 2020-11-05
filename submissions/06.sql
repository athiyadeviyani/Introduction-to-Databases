SELECT S.uun,
    COUNT(CASE WHEN (E.grade >= 80) THEN 1 END) AS A,
    COUNT(CASE WHEN (E.grade >= 60 AND E.grade <= 79) THEN 1 END) AS B,
    COUNT(CASE WHEN (E.grade >= 40 AND E.grade <= 59)  THEN 1 END) AS C,
    COUNT(CASE WHEN E.grade < 40 THEN 1 END) AS D
FROM Students S
JOIN Exams E ON S.uun = E.student
GROUP BY S.uun;