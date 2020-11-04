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
The output table will have a single column, consisting of non-negative integers, and precisely one row, independently of the instance. 
If there are no postgraduate students, the only answer will be the value 0.
*/

SELECT COUNT(D.code)
FROM DEGREES D
WHERE D.type = 'PG';

/* Question 3: Students whose average grade is greater than or equal to 75.
For each student that satisfies this requirement, return their UUN, their minimum grade, their maximum grade, and the total number of exams the student took (in this order). 
The same UUN cannot appear more than once in the output. Students without exams do not appear in the output.
The output table will have four columns: the first one consists of distinct UUNs, 
    the second and third consist of marks (non-negative integers up to 100), 
    and the fourth is the number of exams (a positive integer). 
*/

SELECT SG.student, SG.min, SG.max, SG.count
FROM (
    SELECT E.student, AVG(E.grade), MAX(E.grade), MIN(E.grade), COUNT(E.grade)
    FROM Exams E
    GROUP BY E.student) AS SG
WHERE SG.avg >= 75;

/* Question 4: Students who failed more than 30% of their exams.
Return the UUN of each student that satisfies this requirement, without repetitions. An exam is failed when the grade is below 40.
The output table will have a single column, which consists of distinct UUNs. 
*/

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
FROM (
    SELECT E.student, COUNT(E.grade) AS fail_count 
    FROM Exams E 
    WHERE E.grade < 40
    GROUP BY E.student) AS Fail 
JOIN (
    SELECT E.student, COUNT(E.grade) AS total_count 
    FROM Exams E 
    GROUP BY E.student) AS Total 
ON Fail.student = Total.student
WHERE CAST(Fail.fail_count AS float) / CAST (Total.total_count AS float) > 0.3;

/* Question 5: Total number of credits in the programme of each degree.
For each degree, calculate the total number of credits of the courses listed in its programme. 
Return the code of the degree and the corresponding total (in this order). 
Degrees with no mandatory courses will be in the output with a total of 0.
The output table will have two columns: the first one consists of degree codes, the second consists of non-negative integers. 
The number of rows is always the same as the number of rows in the Degrees table.
*/

/* Courses and credits for each degree */
SELECT P.degree, P.course, C.credits
FROM Programmes P 
JOIN Courses C ON P.course = C.code;

/* Sum of credits from courses for each degree */
SELECT DC.degree, SUM(DC.credits) 
FROM (
    SELECT P.degree, P.course, C.credits
    FROM Programmes P 
    JOIN Courses C ON P.course = C.code) AS DC
GROUP BY DC.degree;

/* Question 6: Number of A, B, C and D exam grades of each student.
Return the student’s UUN, followed by columns A, B, C, D (in this order) with the total number of exam grades in 
each of the following categories:
    • A is a grade of 80 or above,
    • B is a grade between 60 and 79,
    • C is a grade between 40 and 59,
    • D is a grade below 40.
For each row, A + B + C + D = total number of exams taken by the student. Students without exams do not appear in the output.
The number of rows will always be the same as the number of distinct UUNs in the first column of the Exams table. 
*/

/* Displays student letter grades */
SELECT S.uun, 
    (
        CASE WHEN E.grade >= 80 THEN 'A'
        WHEN E.grade >= 60 THEN 'B'
        WHEN E.grade >= 40 THEN 'C'
        ELSE 'D'
        END
    ) AS LetterGrade
FROM Students S
JOIN Exams E ON S.uun = E.student;

/* Using CASE statement */
SELECT SLG.uun,
    COUNT(CASE WHEN SLG.lettergrade = 'A' THEN 1 END) AS A,
    COUNT(CASE WHEN SLG.lettergrade = 'B' THEN 1 END) AS B,
    COUNT(CASE WHEN SLG.lettergrade = 'C' THEN 1 END) AS C,
    COUNT(CASE WHEN SLG.lettergrade = 'D' THEN 1 END) AS D
FROM (
    SELECT S.uun, 
    (
        CASE WHEN E.grade >= 80 THEN 'A'
        WHEN E.grade >= 60 THEN 'B'
        WHEN E.grade >= 40 THEN 'C'
        ELSE 'D'
        END
    ) AS LetterGrade
FROM Students S
JOIN Exams E ON S.uun = E.student) AS SLG
GROUP BY SLG.uun;

/* EVEN SHORTER using CASE statement */
SELECT S.uun,
    COUNT(CASE WHEN (E.grade >= 80) THEN 1 END) AS A,
    COUNT(CASE WHEN (E.grade >= 60 AND E.grade <= 79) THEN 1 END) AS B,
    COUNT(CASE WHEN (E.grade >= 50 AND E.grade <= 59)  THEN 1 END) AS C,
    COUNT(CASE WHEN E.grade < 40 THEN 1 END) AS D
FROM Students S
JOIN Exams E ON S.uun = E.student
GROUP BY S.uun;

/* Question 7: Courses that are part of an undergraduate and a postgraduate degree programme.
That is, courses that are in the programme of some undergraduate degree and also in the programme of some postgraduate degree. 
Return the code of each course that satisfies these requirements, without repetitions.
The output table will have one column, which consists of distinct course codes.
*/

/* UG courses */
SELECT P.course
FROM Programmes P 
JOIN Degrees D ON P.degree = D.code 
WHERE D.type = 'UG';

/* PG courses */
SELECT P.course
FROM Programmes P 
JOIN Degrees D ON P.degree = D.code 
WHERE D.type = 'PG';

/* UG and PG courses */
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

/* Question 8: Courses included in one and only one postgraduate degree programme.
That is, courses that are in the programme of some postgraduate degree and not in the programme of any other postgraduate degree. Return the code of each course that satisfies this requirement, without repetitions.
The output table will have one column, which consists of distinct course codes.
*/

/* PG courses count */
SELECT P.course, COUNT(P.course)
FROM Programmes P 
JOIN Degrees D ON P.degree = D.code 
WHERE D.type = 'PG'
GROUP BY P.course;

/* Courses in only one PG programme */
SELECT PCount.course
FROM (
    SELECT P.course, COUNT(P.course)
    FROM Programmes P 
    JOIN Degrees D ON P.degree = D.code 
    WHERE D.type = 'PG'
    GROUP BY P.course) AS PCount
WHERE PCount.count = 1;

/* Question 9: Students who took more than one exam on the date of their most recent exam.
For each student, return their UUN and the date of their most recent exam, if on that same date they have taken at least another (different) exam.
The output table will have two columns: the first consists of distinct UUNs, the second of dates.
*/

/* Most recent exam date per student */
SELECT E.student, MAX(E.date)
FROM Exams E 
GROUP BY E.student;

/* Number of exams on the most recent exam date per student */
SELECT E.student, Recent.max, COUNT(E.student)
FROM Exams E 
JOIN (
    SELECT E.student, MAX(E.date)
    FROM Exams E 
    GROUP BY E.student) AS Recent 
ON Recent.student = E.student
WHERE Recent.max = E.date
GROUP BY E.student, Recent.max

/* Students who took more than one exam on most recent exam date */
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

/* Question 10: Students who have taken the exam for every course in their degree programme.
For each student that satisfies this requirement, return their UUN and their name (in this order). Students in degrees without mandatory courses (listed in the Programmes table satisfy the requirement and must appear in the output.
The output table will have two columns: the first one consists of UUNs, the second consists of student names. There are no duplicate rows. 
*/

/* Students who have NOT taken the exam for every course in their degree programme */
SELECT DISTINCT(S.uun)
FROM Programmes P 
    INNER JOIN Students S ON S.degree = P.degree 
    LEFT OUTER JOIN Exams E ON E.course = P.course AND E.student = S.uun
WHERE E.course IS NULL;

/* Students that are not included in the query above */
SELECT S.uun, S.name 
FROM Students S 
WHERE S.uun NOT IN (
    SELECT DISTINCT(S.uun)
    FROM Programmes P 
        INNER JOIN Students S ON S.degree = P.degree 
        LEFT OUTER JOIN Exams E ON E.course = P.course AND E.student = S.uun
    WHERE E.course IS NULL
);
