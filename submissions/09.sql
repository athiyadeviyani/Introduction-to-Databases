SELECT ExamCounts.student, ExamCounts.max as date
FROM (SELECT E.student, Recent.max, COUNT(E.student)
    FROM Exams E 
    JOIN (
        SELECT E.student, MAX(E.date)
        FROM Exams E 
        GROUP BY E.student) AS Recent 
    ON Recent.student = E.student
    WHERE Recent.max = E.date
    GROUP BY E.student, Recent.max) AS ExamCounts 
WHERE ExamCounts.count > 1;