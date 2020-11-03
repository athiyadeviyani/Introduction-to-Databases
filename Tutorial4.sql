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
SELECT SG.student, SG.min, SG.max, SG.count
From (SELECT E.student, AVG(E.grade), MAX(E.grade), MIN(E.grade), COUNT(E.grade)
FROM Exams E
GROUP BY E.student) AS SG
WHERE SG.avg >= 75;

/* Question 4: Students who failed more than 30% of their exams.
Return the UUN of each student that satisfies this requirement, without repetitions. An exam is failed when the grade is below 40.
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

/* Combine the two counts: Fail.fail_count, Total.total_count */
SELECT Fail.student
FROM (SELECT E.student, COUNT(E.grade) AS fail_count 
FROM Exams E 
WHERE E.grade < 40
GROUP BY E.student) AS Fail 
JOIN
(SELECT E.student, COUNT(E.grade) AS total_count 
FROM Exams E 
GROUP BY E.student) AS Total 
ON Fail.student = Total.student
WHERE CAST(Fail.fail_count AS float) / CAST (Total.total_count AS float) > 0.3;

/* Question 5: Total number of credits in the programme of each degree.
For each degree, calculate the total number of credits of the courses listed in its programme. 
Return the code of the degree and the corresponding total (in this order). Degrees
with no mandatory courses will be in the output with a total of 0.
The output table will have two columns: the first one consists of degree codes, the second consists of non-negative integers. The number of rows is always the same as the number of rows in the Degrees table.
*/

/* Courses and credits for each degree */
SELECT P.degree, P.course, C.credits
FROM Programmes P 
JOIN Courses C ON P.course = C.code;

/* Sum of credits from courses for each degree */
SELECT DC.degree, SUM(DC.credits) 
FROM (SELECT P.degree, P.course, C.credits
        FROM Programmes P 
        JOIN Courses C ON P.course = C.code
    ) AS DC
GROUP BY DC.degree;

/* Question 6: Number of A, B, C and D exam grades of each student.
Return the student’s UUN, followed by columns A, B, C, D (in this order) with the total number of
exam grades in each of the following categories:
• A is a grade of 80 or above,
• B is a grade between 60 and 79,
• C is a grade between 40 and 59,
• D is a grade below 40.
For each row, A + B + C + D = total number of exams taken by the student. Students without exams
do not appear in the output.
The number of rows will always be the same as the number of distinct UUNs in the first column of the
Exams table. */

/* Displays student letter grades */
SELECT S.uun, 
    (case when E.grade >= 80 then 'A'
          when E.grade >= 60 then 'B'
          when E.grade >= 40 then 'C'
          else 'D'
          end) as LetterGrade
FROM Students S
JOIN Exams E ON S.uun = E.student;

/* Display counts of each letter grade for each student */
SELECT S.uun, 
    COALESCE(SUM(A.count), 0) as A,
    COALESCE(SUM(B.count), 0) as B, 
    COALESCE(SUM(C.count), 0) as C, 
    COALESCE(SUM(D.count), 0) as D
FROM Students S 
    LEFT JOIN (
        SELECT S.uun, COUNT(E.grade)
        FROM Students S
        JOIN Exams E ON S.uun = E.student
        WHERE E.grade >= 80
        GROUP BY S.uun
    ) AS A ON S.uun = A.uun
    LEFT JOIN (
        SELECT S.uun, COUNT(S.uun)
        FROM Students S
        JOIN Exams E ON S.uun = E.student
        WHERE E.grade <= 79 AND E.grade >= 60
        GROUP BY S.uun
    ) AS B ON S.uun = B.uun
    LEFT JOIN (
        SELECT S.uun, COUNT(S.uun)
        FROM Students S
        JOIN Exams E ON S.uun = E.student
        WHERE E.grade <= 59 AND E.grade >= 40
        GROUP BY S.uun
    ) AS C ON S.uun = C.uun
    LEFT JOIN (
        SELECT S.uun, COUNT(S.uun)
        FROM Students S
        JOIN Exams E ON S.uun = E.student
        WHERE E.grade < 40
        GROUP BY S.uun
    ) AS D ON S.uun = D.uun
GROUP BY S.uun;
