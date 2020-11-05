SELECT DISTINCT(UG.course)
FROM (
    SELECT P.course
    FROM Programmes P 
    JOIN Degrees D ON P.degree = D.code 
    WHERE D.type = 'UG') AS UG 
INNER JOIN (
    SELECT P.course
    FROM Programmes P 
    JOIN Degrees D ON P.degree = D.code 
    WHERE D.type = 'PG') AS PG 
ON UG.course = PG.course;