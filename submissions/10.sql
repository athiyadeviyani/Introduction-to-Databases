SELECT S.uun, S.name 
FROM Students S 
JOIN Programmes P ON P.degree = S.degree 
JOIN Exams E ON E.student = S.uun AND E.course = P.course 
GROUP BY S.uun, S.name, P.degree
HAVING COUNT(DISTINCT E.course) = (
    SELECT COUNT(*)
    FROM Programmes P2 
    WHERE P2.degree = P.degree
)
UNION
SELECT S.uun, S.name 
FROM Students S 
WHERE S.degree NOT IN (
    SELECT P.degree FROM Programmes P
);