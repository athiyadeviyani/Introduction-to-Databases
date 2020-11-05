SELECT S.uun FROM students S
WHERE S.uun NOT IN (
    SELECT E.student
    FROM Exams E
);