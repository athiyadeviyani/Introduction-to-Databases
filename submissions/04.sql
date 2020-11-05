SELECT Fail.student
FROM (
    SELECT E.student, COUNT(E.grade) AS fail_count 
    FROM Exams E 
    WHERE E.grade < 40
    GROUP BY E.student) AS Fail 
JOIN (
    SELECT E.student, COUNT(E.grade) AS total_count 
    FROM Exams E 
    GROUP BY E.student) AS Total 
ON Fail.student = Total.student
WHERE CAST(Fail.fail_count AS DECIMAL) / CAST (Total.total_count AS DECIMAL) > 0.3;