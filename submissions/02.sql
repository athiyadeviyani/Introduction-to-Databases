SELECT COUNT(D.type)
FROM Students S
JOIN Degrees D ON S.degree = D.code
WHERE D.type = 'PG';