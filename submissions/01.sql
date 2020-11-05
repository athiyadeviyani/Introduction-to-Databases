SELECT S.uun FROM Students S
WHERE S.uun NOT IN (
    SELECT E.student
    FROM Exams E
);
