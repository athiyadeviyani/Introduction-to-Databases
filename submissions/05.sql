SELECT DC.degree, SUM(DC.credits) 
FROM (
    SELECT P.degree, P.course, C.credits
    FROM Programmes P 
    JOIN Courses C ON P.course = C.code) AS DC
GROUP BY DC.degree
UNION
SELECT D.code, 0
FROM Degrees D 
WHERE D.code NOT IN (
    SELECT P.degree
    FROM Programmes P
);