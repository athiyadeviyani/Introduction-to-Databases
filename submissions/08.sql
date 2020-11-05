SELECT PCount.course
FROM (
    SELECT P.course, COUNT(P.course)
    FROM Programmes P 
    JOIN Degrees D ON P.degree = D.code 
    WHERE D.type = 'PG'
    GROUP BY P.course) AS PCount
WHERE PCount.count = 1;