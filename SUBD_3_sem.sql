SET SCHEMA DB2INST1;

--############################################FIRST PART OF TASKS####################################################--
--Problem 1
/*
For employees whose salary, increased by 5 percent, is less than or equal to
$20,000, list the following:
 • Last name //+
 • Current Salary//+
 • Salary increased by 5 percent //+
 • Monthly salary increased by 5 percent //+
Use the following column names for the two generated columns:
INC-Y-SALARY and INC-M-SALARY Use the proper conversion function to display
the increased salary and monthly salary with two of the digits to the right of the
decimal point. Sort the results by annual salary. 
*/

SELECT LASTNAME, SALARY, SALARY*1.05 AS "INC-Y-SALARY", 
 ROUND(DECIMAL((SALARY/12)*1.05, 9, 4), 0) AS "INC-M-SALARY"
FROM EMP
WHERE SALARY * 1.05 <= 40000
ORDER BY SALARY;

--Problem 2
/*
All employees with an education level of 18 or 20 will receive a salary increase of
$1,200 and their bonus will be cut in half. List last name, education level, new salary,
and new bonus for these employees. Display the new bonus with two digits to the
right of the decimal point.
Use the column names NEW-SALARY and NEW-BONUS for the generated
columns.
Employees with an education level of 20 should be listed first. For employees with
the same education level, sort the list by salary. 
*/

SELECT LASTNAME, EDLEVEL, SALARY + 1200 AS "NEW-SALARY", DECIMAL(BONUS/2, 9, 2) AS "NEW-BONUS"
FROM EMP
WHERE EDLEVEL IN (18,20)
ORDER BY EDLEVEL DESC, SALARY;

--Problem 3
/*
The salary will be decreased by $1,000 for all employees matching the following
criteria:
 • They belong to department D11
 • Their salary is more than or equal to 80 percent of $20,000
 • Their salary is less than or equal to 120 percent of $20,000
Use the name DECR-SALARY for the generated column.
List department number, last name, salary, and decreased salary. Sort the result by
salary.
*/

SELECT WORKDEPT, LASTNAME, SALARY, SALARY - 1000 AS "DECR-SALARY"
FROM EMP
WHERE WORKDEPT = 'D11'
AND SALARY >= 40000*0.8
AND SALARY <= 40000*1.2
ORDER BY SALARY;

--Problem 4
/*
Produce a list of all employees in department D11 that have an income (sum of
salary, commission, and bonus) that is greater than their salary increased by 10
percent.
Name the generated column INCOME.
List department number, last name, and income. Sort the result in descending order
by income.
For this problem assume that all employees have non-null salaries, commissions,
and bonuses.
*/

-- ...

--Problem 5
/*
List all departments that have no manager assigned. List department number,
department name, and manager number. Replace unknown manager numbers with
the word UNKNOWN and name the column MGRNO.
*/

SELECT DEPTNO, DEPTNAME, COALESCE(MGRNO, 'UNKNOWN') AS MGRNO
FROM DEPT
WHERE MGRNO IS NULL;

--Problem 7
/*
List all employees who were younger than 25 when they joined the company.
List their employee number, last name, and age when they joined the company.
Name the derived column AGE.
Sort the result by age and then by employee number. 
*/

SELECT EMPNO, LASTNAME, YEAR(HIREDATE - BIRTHDATE) AS AGE
FROM EMP
WHERE YEAR(HIREDATE - BIRTHDATE) < 25
ORDER BY EMPNO;


--Problem 9
/*
List the project number and duration, in weeks, of all projects that have a project
number beginning with MA. The duration should be rounded and displayed with one
decimal position.
Name the derived column WEEKS.
Order the list by the project number.
*/

SELECT PROJNO, DECIMAL(ROUND((DAYS(PRENDATE) - DAYS(PRSTDATE))/7.0, 1), 6, 1) AS WEEKS
FROM PROJ
WHERE PROJNO LIKE 'MA%'
AND PRENDATE > PRSTDATE
ORDER BY PROJNO;

--############################################SECOND PART OF TASKS####################################################--
--Problem 5
/*
For each female employee in the company present her department, her job and her
last name with only one blank between job and last name.
*/

-- || = CONCAT
SELECT WORKDEPT || ' ' || JOB || ' ' || LASTNAME
FROM EMP
WHERE SEX = 'F';

--Problem 7
/*
Display project number, project name, project start date, and project end date of
those projects whose duration was less than 10 months. Display the project duration
in days.
*/

SELECT PROJNO, PROJNAME, PRSTDATE, PRENDATE, DAYS(PRENDATE) - DAYS(PRSTDATE) AS DAYS,
(PRSTDATE + 10 MONTHS), PRENDATE
FROM PROJ
WHERE PRENDATE > PRSTDATE
AND (PRSTDATE + 10 MONTHS) >= PRENDATE;
--CHECK WITH 14 MONTHS - WORKS!

--Problem 10
/*
Find out which employees were hired on a Saturday or a Sunday. List their last
names and their hiring dates.
*/

SELECT LASTNAME, HIREDATE, DAYNAME(HIREDATE) AS DWEEK --, DAYNAME('2018-02-01') 
FROM EMP
WHERE DAYOFWEEK_ISO(HIREDATE) IN (6,7);

--Problem 9
/*
How many weeks are between the first manned landing on the moon (July 20, 1969)
and the first day of the year 2000?
*/

SELECT DECIMAL(ROUND((DAYS(DATE('2000-01-01')) - DAYS(DATE('1969-07-20')))/7.0,1), 15, 1)
FROM SYSIBM.SYSDUMMY1;