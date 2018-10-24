SET SCHEMA DB2INST1;


SELECT EDLEVEL, DECIMAL(AVG(SALARY), 9, 2) AS AVG_SAL
FROM EMPLOYEE
GROUP BY EDLEVEL
UNION ALL
SELECT NULL AS EDLEVEL, DECIMAL(AVG(SALARY), 9, 2) AS AVG_SAL
FROM EMPLOYEE;

SELECT EDLEVEL, DECIMAL(AVG(SALARY), 9, 2) AS AVG_SAL
FROM EMPLOYEE
GROUP BY ROLLUP(EDLEVEL);


--GROUPING DALI NESHTO E CHAST OT GRUPATA ILI NE E
SELECT EDLEVEL, JOB, DECIMAL(AVG(SALARY), 9, 2) AS AVG_SAL, GROUPING(EDLEVEL)
FROM EMPLOYEE
GROUP BY ROLLUP(EDLEVEL, JOB);

SELECT EDLEVEL, JOB, DECIMAL(AVG(SALARY), 9, 2) AS AVG_SAL, GROUPING(EDLEVEL)
FROM EMPLOYEE
GROUP BY CUBE(EDLEVEL, JOB);

--Problem 1
/*
For all departments, display department number and the sum of all salaries for each
department. Name the derived column SUM_SALARY.
*/

SELECT D.DEPTNO, SUM(E.SALARY) AS SUM_SALARY
FROM DEPARTMENT D, EMPLOYEE E
WHERE D.DEPTNO = E.WORKDEPT
GROUP BY D.DEPTNO;

SELECT WORKDEPT, SUM(SALARY) AS SUM_SALARY
FROM EMP
GROUP BY WORKDEPT;

--Problem 2
/*
For all departments, display the department number and the number of employees.
Name the derived column EMP_COUNT.
*/

SELECT WORKDEPT, COUNT(*) AS EMP_COUNT
FROM EMP
GROUP BY WORKDEPT
ORDER BY EMP_COUNT;

--Problem 3
--Display those departments which have more than 3 employees.

SELECT WORKDEPT, COUNT(*) AS EMP_COUNT
FROM EMP
GROUP BY WORKDEPT
HAVING COUNT(*) > 3
ORDER BY EMP_COUNT;

--Problem 4
/*
For all departments with at least one designer, display the number of designers and
the department number. Name the derived column DESIGNER.
*/

SELECT WORKDEPT, COUNT(*) AS DESIGNERS
FROM EMP
WHERE JOB = 'DESIGNER'
GROUP BY WORKDEPT;

--Problem 5
/*
Show the average salary for men and the average salary for women for each
department. Display the work department, the sex, the average salary, average
bonus, average commission, and the number of people in each group. Include only
those groups that have two or more people. Show only two decimal places in the
averages.
Use the following names for the derived columns: AVG-SALARY, AVG-BONUS,
AVG-COMM, and COUNT.
*/

SELECT WORKDEPT, SEX, DECIMAL(AVG(SALARY), 9, 2) AS "AVG-SALARY", 
DECIMAL(AVG(BONUS), 9, 2) AS "AVG-BONUS", DECIMAL(AVG(COMM), 9, 2) AS "AVG-COMM", COUNT(*) COUNT
FROM EMP
GROUP BY WORKDEPT, SEX
HAVING COUNT(*) >= 2;

--Problem 6
/*
Display the average bonus and average commission for all departments with an
average bonus greater than $500 and an average commission greater than $2,000.
Display all averages with two digits to the right of the decimal point. Use the column
headings AVG-BONUS and AVG-COMM for the derived columns.
*/

SELECT WORKDEPT, DECIMAL(AVG(BONUS), 9, 2) AS "AVG-BONUS", 
DECIMAL(AVG(COMM), 9, 2) AS "AVG-COMM", COUNT(*) COUNT
FROM EMP
GROUP BY WORKDEPT
HAVING AVG(BONUS) > 500 AND AVG(COMM) > 2000;

--########################SECOND PART OF TASKS##############################--
--Problem 1
/*
Joe's manager wants information about employees which match the following
criteria:
 • Their yearly salary is between 22000 and 24000.
 • They work in departments D11 or D21.
List the employee number, last name, yearly salary, and department number of the
appropriate employees.
*/

SELECT EMPNO, LASTNAME, SALARY, WORKDEPT
FROM EMP
WHERE SALARY BETWEEN 32000 AND 44000
AND WORKDEPT IN ('D11', 'D21');

--Problem 2
/*
Now, Joe's manager wants information about the yearly salary. He wants to know
the minimum, the maximum, and average yearly salary of all employees with an
education level of 16. He also wants to know how many employees have this
education level.
*/

SELECT MIN(SALARY) MIN_SAL, MAX(SALARY) MAX_SAL,
DECIMAL(AVG(SALARY), 9, 2) AVG_SAL, COUNT(*) COUNT
FROM EMP
WHERE EDLEVEL = 16;

--Problem 3
/*
Joe's manager is interested in some additional salary information. This time, he
wants information for every department that appears in the EMPLOYEE table,
provided that the department has more than five employees. The report needs to
show the department number, the minimum, maximum, and average yearly salary,
and the number of employees who work in the department.
*/

SELECT 
FROM 
WHERE ;

--Problem 4
/*
Joe's manager wants information about employees grouped by department,
grouped by sex and in addition by the combination of department and sex. List only
those who work in a department which start with the letter D.
List the department, the sex, sum of the salaries, minimum salary and maximum
salary.
Note, the solution of this and the next problem can only be used on DB2 UDB for
UNIX, Windows and OS/2.
*/

SELECT WORKDEPT, SEX, SUM(SALARY) AS SUM_SAL,
MIN(SALARY) MIN_SAL, MAX(SALARY) MAX_SAL
FROM EMP
WHERE WORKDEPT LIKE 'D%'
GROUP BY CUBE(WORKDEPT, SEX)
HAVING NOT(WORKDEPT IS NULL AND SEX IS NULL);

--Problem 5
/*
Joe's manager wants information about the average total salary for all departments.
List in department order, the department, average total salary and rank over the
average total salary.
*/

SELECT WORKDEPT, DECIMAL(AVG(SALARY), 9, 2) AVG_SAL,
RANK() OVER(ORDER BY AVG(SALARY) DESC) AS RANK_AVG_SAL
FROM EMP
GROUP BY WORKDEPT
ORDER BY WORKDEPT;