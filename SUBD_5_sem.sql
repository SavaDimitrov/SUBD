SET SCHEMA DB2INST1;

--############################# CAST #######################--
--Problem 1
/*
For all employees in department D11, display their employee number, last name and
text specifying if the employee's salary is low, high or normal.
 SALARY INCOME
-------- --------
less than 25000 LOW
between 25000 and 30000 NORMAL
higher than 30000 HIGH 
*/

SELECT EMPNO, LASTNAME,
	CASE WHEN SALARY < 45000 THEN 'LOW'
		 WHEN SALARY >= 45000 AND SALARY <= 60000 THEN 'NORMAL'
		 ELSE 'HIGH'
	END AS "SALARY INCOME"
FROM EMP
WHERE WORKDEPT = 'D11';

--Problem 2
/*
For all employees in department D11, display their last name, salary and the
difference between their salary and 30000. Sort the list in order by the difference
with the lowest difference first.
*/

SELECT LASTNAME, SALARY,
		CASE WHEN SALARY < 50000 THEN 0
			 ELSE (SALARY - 50000) 
		END AS DIFF
FROM EMP
WHERE WORKDEPT = 'D11'
ORDER BY DIFF ASC;

--Problem 3
/*
For each department, list the percentage of the bonus paid to the employees relative
to the total income (salary + bonus + commission) of the employees in that
department. Take into account that some departments might not pay a bonus.
*/

SELECT WORKDEPT, SUM(COALESCE(BONUS,0)) AS BONUSES, SUM(SALARY + COALESCE(BONUS,0) + COALESCE(COMM,0)) AS INCOME, 
	CAST(CASE WHEN SUM(SALARY + BONUS + COMM) IS NULL THEN 0 
		 ELSE CAST(SUM(BONUS) AS DECIMAL(9,1))/SUM(SALARY + BONUS + COMM) * 100
	END AS DECIMAL(9,1)) AS BONUS_PERC
FROM EMP
GROUP BY WORKDEPT;

--Problem 4
/*
List the employees who have a commission of at least 8 percent of the salary.
Protect from division by 0 in case someone has 0 salary. List the last name and use
CAST to list percentage with three decimals.
*/

SELECT LASTNAME, CAST(CASE WHEN SALARY = 0 THEN NULL
			ELSE CAST(COMM AS DECIMAL(9,1))/SALARY * 100
			END AS DECIMAL(9,1)) AS PERC
FROM EMP
WHERE (CASE WHEN SALARY = 0 THEN NULL
			ELSE CAST(COMM AS DECIMAL(9,1))/SALARY * 100 --??
			END > 0.08);


--############################# UNION #######################--

--Problem 3
/*
For departments A00, B01, and C01, list the projects assigned to them and the
employees in each department. The output should consist of up to three types of
lines for each department as follows:
See expected results for clarification of the following instructions.
First line (one per department):
 • Department number
 • Text: DEPARTMENT
 • Department name
Second line(s) (if data available - one line per project):
 • Department number
 • Project number
 • Project name
Subsequent line(s) (if data available - one line per employee):
 • Department number
 • Employee number
 • Last name
 */
 
SELECT DEPTNO, 'DEPARTMENT' AS INFO, '' AS "NUM", DEPTNAME
FROM DEPT
WHERE DEPTNO IN ('A00','B01','C01')
UNION ALL
SELECT DEPTNO, 'PROJECT', PROJNO, PROJNAME
FROM PROJ
WHERE DEPTNO IN ('A00','B01','C01')
UNION ALL
SELECT WORKDEPT, 'EMPLOYEE', EMPNO, LASTNAME
FROM EMP
WHERE WORKDEPT IN ('A00','B01','C01')
ORDER BY 1;

--Problem 4
/*
For all projects that have a project number that begins with IF, display the following:
First line:
 • Text: PROJECT
 • Project number
 • The employee number of the employee responsible for the project
 • Estimated starting date
 • Estimated ending date

Subsequent line(s) (one per employee working on the project):
 • Project number
 • The employee number of the employee performing the activity
 • Activity starting date
 • Activity ending date
Sequence the results by the project number, then by employee number, and finally
by the starting date.
*/

SELECT 'PROJECT' AS TEXT, PROJNO, RESPEMP, PRSTDATE, PRENDATE 
FROM PROJ
WHERE PROJNO LIKE 'IF%'
UNION ALL
SELECT 'EMPLOYEE', PROJNO, EMPNO, EMSTDATE, EMENDATE
FROM EMPACT
WHERE PROJNO LIKE 'IF%'
ORDER BY 2, 3, 4;