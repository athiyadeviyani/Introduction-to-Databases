/* Question 1: Students who have not taken any exams. 
Return the UUN of each student that satisifes this requirement, without repetitions.
The output table will have a single column, which consists of distinct UUNs.
*/

SELECT S.uun FROM students S
WHERE S.uun NOT IN (
    SELECT E.student
    FROM Exams E
);

/* Question 2: Total number of postgraduate students.
The output table will have a single column, consisting of non-negative integers, and precisely one row, independently of the instance. If there are no postgraduate students, the only answer will be the value 0.
*/
SELECT Count(D.code)
FROM Degrees D
WHERE D.type = 'PG';

/* Question 3: Students whose average grade is greater than or equal to 75.
For each student that satisfies this requirement, return their UUN, their minimum grade, their maximum grade, and the total number of exams the student took (in this order). The same UUN cannot
appear more than once in the output. Students without exams do not appear in the output.
The output table will have four columns: the first one consists of distinct UUNs, the second and third
consist of marks (non-negative integers up to 100), and the fourth is the number of exams (a positive
integer). */
SELECT E.student, AVG(E.grade), MAX(E.grade), MIN(E.grade), COUNT(E.grade)
FROM Exams E
GROUP BY E.student;

SELECT SG.student, SG.min, SG.max, SG.count
From (SELECT E.student, AVG(E.grade), MAX(E.grade), MIN(E.grade), COUNT(E.grade)
FROM Exams E
GROUP BY E.student) AS SG
WHERE SG.avg >= 75;

/* Question 4: Students who failed more than 30% of their exams.
Return the UUN of each student that satisfies this requirement, without repetitions. An exam is failed
when the grade is below 40.
The output table will have a single column, which consists of distinct UUNs. */

/* Failing marks per student */
SELECT E.student, COUNT(E.grade) 
FROM Exams E 
WHERE E.grade <= 40
GROUP BY E.student;

/* Total exams per student */
SELECT E.student, COUNT(E.grade) 
FROM Exams E 
GROUP BY E.student;

/* Combine the two counts */
SELECT Fail.student, Fail.fail_count, Total.total_count
FROM (SELECT E.student, COUNT(E.grade) AS fail_count 
FROM Exams E 
WHERE E.grade <= 40
GROUP BY E.student) AS Fail 
JOIN
(SELECT E.student, COUNT(E.grade) AS total_count 
FROM Exams E 
GROUP BY E.student) AS Total 
ON Fail.student = Total.student
WHERE CAST(Fail.fail_count AS float) / CAST (Total.total_count AS float) > 0.3;
