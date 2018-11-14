SET SCHEMA DB2INST1;

--#################### FIRST TASKS ####################--

--Problem 1
/*
List those employees that have a salary which is greater than or equal to the
average salary of all employees plus $5,000.
Display department number, employee number, last name, and salary. Sort the list
by the department number and employee number.
*/

SELECT WORKDEPT, EMPNO, LASTNAME, SALARY
FROM EMP
WHERE SALARY >= (SELECT AVG(SALARY) + 5000
				 FROM EMP)
ORDER BY WORKDEPT, EMPNO;


--Problem 2
/*
List employee number and last name of all employees not assigned to any projects.
This means that table EMP_ACT does not contain a row with their employee
number.
*/
--3 WAYS

--1ST(LEFT JOIN)
SELECT E.EMPNO, E.LASTNAME
FROM EMP E LEFT JOIN EMP_ACT EA ON EA.EMPNO = E.EMPNO
WHERE EA.EMPNO IS NULL;
--2ND(NOT IN SUBQUERY)
SELECT EMPNO, LASTNAME
FROM EMP
WHERE EMPNO NOT IN (SELECT EMPNO FROM EMP_ACT);
--3RD(EXCEPT)
SELECT EMPNO, LASTNAME
FROM EMP
EXCEPT
SELECT EA.EMPNO, E.LASTNAME
FROM EMP_ACT EA, EMP E
WHERE EA.EMPNO = E.EMPNO;

--Problem 3
/*
List project number and duration (in days) of the project with the shortest duration.
Name the derived column DAYS.
*/

SELECT PROJNO, (DAYS(PRENDATE) - DAYS(PRSTDATE)) AS DAYS 
FROM PROJ
WHERE PRENDATE > PRSTDATE
AND (DAYS(PRENDATE) - DAYS(PRSTDATE)) <= ALL(SELECT DAYS(PRENDATE) - DAYS(PRSTDATE) 
											   FROM PROJ
											   WHERE PRENDATE > PRSTDATE);


--Problem 4
/*
List department number, department name, last name, and first name of all those
employees in departments that have only male employees.
*/

--1ST WAY
SELECT WORKDEPT, DEPTNAME, LASTNAME, FIRSTNME
FROM EMP, DEPT
WHERE DEPTNO = WORKDEPT
AND SEX = 'M'
AND WORKDEPT NOT IN (SELECT WORKDEPT
					FROM EMP
					WHERE SEX = 'F')
ORDER BY WORKDEPT;

--2ND WAY
SELECT E.WORKDEPT, D.DEPTNAME, E.LASTNAME, E.FIRSTNME
FROM EMP E JOIN DEPT D ON E.WORKDEPT = D.DEPTNO
JOIN (SELECT WORKDEPT, COUNT(*) CNTE
	  FROM EMP 
	  GROUP BY WORKDEPT
	  INTERSECT
	  SELECT WORKDEPT, COUNT(*) CNTE
	  FROM EMP
	  WHERE SEX = 'M'
	  GROUP BY WORKDEPT) T ON D.DEPTNO = T.WORKDEPT;


--Problem 5
/*
We want to do a salary analysis for people that have the same job and education
level as the employee Stern. Show the last name, job, edlevel, the number of years
they've worked as of January 1, 2000, and their salary.
Name the derived column YEARS.
Sort the listing by highest salary first.
*/

SELECT LASTNAME, JOB, EDLEVEL, YEAR(CURRENT_DATE - DATE('2000-01-01')) AS YEARS, SALARY
FROM EMP
WHERE (JOB, EDLEVEL) IN (SELECT JOB, EDLEVEL FROM EMP WHERE LASTNAME = 'STERN')
ORDER BY SALARY DESC;

--#################### SECOND TASKS ####################--

--Problem 2
/*
Retrieve all employees whose yearly salary is more than the average salary of the
employees in their department. For example, if the average yearly salary for
department E11 is 20998, show all people in department E11 whose individual
salary is higher than 20998. Display department number, employee number, and
yearly salary. Sort the result by department number and employee number.
*/

--1ST WAY
SELECT WORKDEPT, EMPNO, SALARY
FROM EMP E
WHERE SALARY > (SELECT AVG(SALARY) 
				FROM EMP
				WHERE WORKDEPT = E.WORKDEPT)
ORDER BY WORKDEPT, EMPNO;

--2ND WAY
SELECT E.WORKDEPT, E.EMPNO, E.SALARY
FROM EMP E, (SELECT WORKDEPT, AVG(SALARY) AS AVGS FROM EMP GROUP BY WORKDEPT) T
WHERE E.WORKDEPT = T.WORKDEPT
AND E.SALARY > T.AVGS

--Problem 3
/*
Retrieve all departments having the same number of employees as department
A00. List department number and number of employees. Department A00 should
not be part of the result. (A00 has 5 emps but no other department has 5 emps, so we use D21)
*/

SELECT WORKDEPT, COUNT(*) AS CNTE
FROM EMP
WHERE WORKDEPT != 'D21'
GROUP BY WORKDEPT
HAVING COUNT(*) = (SELECT COUNT(*) FROM EMP WHERE WORKDEPT = 'D21');

--Problem 4
/*
Display employee number, last name, salary, and department number of employees
who earn more than at least one employee in department D11. Employees in
department D11 should not be included in the result. In other words, report on any
employees in departments other than D11 whose individual yearly salary is higher
than that of at least one employee of department D11. List the employees in
employee number sequence.
*/

SELECT EMPNO, LASTNAME, SALARY, WORKDEPT
FROM EMP
WHERE WORKDEPT != 'D11'
AND SALARY > ANY (SELECT SALARY FROM EMP WHERE WORKDEPT = 'D11')
ORDER BY EMPNO;


--Problem 5
/*
Display employee number, last name, salary, and department number of all
employees who earn more than everybody belonging to department D11.
Employees in department D11 should not be included in the result. In other words,
report on all employees in departments other than D11 whose individual yearly
salary is higher than that of every employee in department D11. List the employees
in employee number sequence.
*/

SELECT EMPNO, LASTNAME, SALARY, WORKDEPT
FROM EMP
WHERE SALARY > ALL (SELECT SALARY FROM EMP WHERE WORKDEPT = 'D11')
ORDER BY EMPNO;


--Problem 6
/*
Display employee number, last name, and number of activities of the employee with
the largest number of activities. Each activity is stored as one row in the EMP_ACT
table.
*/

SELECT E.EMPNO, E.LASTNAME, COUNT(DISTINCT ACTNO)
FROM EMP_ACT EA, EMP E
WHERE EA.EMPNO = E.EMPNO
GROUP BY E.EMPNO, LASTNAME
HAVING COUNT(DISTINCT ACTNO) >= ALL (SELECT COUNT(DISTINCT ACTNO) 
								 FROM EMP_ACT
								 GROUP BY EMPNO);


--Problem 7
/*
Display employee number, last name, and activity number of all activities in the
EMP_ACT table. However, the list should only be produced if there were any
activities in 1982.
Note: The EMP_ACT table in the Sample database of Windows has a duplicate row for
employee number ‘000020’. This may effect the result.
*/

SELECT E.EMPNO, E.LASTNAME, EA.ACTNO
FROM EMP E, EMP_ACT EA
WHERE E.EMPNO = EA.EMPNO
AND EXISTS (SELECT * 
			FROM EMP_ACT E
			WHERE YEAR(EMSTDATE) = 1982
			OR YEAR(EMENDATE) = 1982);