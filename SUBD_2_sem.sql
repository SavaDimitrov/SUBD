SET SCHEMA DB2INST1;

--WHICH EMPLOYEES ARE OLDER THAN THEIR MANAGER?

SELECT E.LASTNAME AS EMP_NAME, E.BIRTHDATE AS EMP_DATE, M.LASTNAME AS MNG_NAME, M.BIRTHDATE AS MNG_DATE, D.DEPTNAME
FROM DEPARTMENT D, EMPLOYEE M, EMPLOYEE E
WHERE M.EMPNO = D.MGRNO
AND E.WORKDEPT = D.DEPTNO
AND E.BIRTHDATE < M.BIRTHDATE;

--Problem 1
/*
Produce a report that lists employees' last names, first names, and department
names. Sequence the report on first name within last name, within department
name.
*/

SELECT D.DEPTNAME, E.LASTNAME, E.FIRSTNME
FROM EMPLOYEE E, DEPARTMENT D
WHERE E.WORKDEPT = D.DEPTNO
ORDER BY D.DEPTNAME, E.LASTNAME, E.FIRSTNME;

--Problem 2
/*
Modify the previous query to include job. Also, list data for only departments
between A02 and D22, and exclude managers from the list. Sequence the report on
first name within last name, within job, within department name.
*/

SELECT D.DEPTNAME, E.LASTNAME, E.FIRSTNME, E.JOB
FROM EMPLOYEE E, DEPARTMENT D
WHERE E.WORKDEPT = D.DEPTNO
AND E.WORKDEPT BETWEEN 'A02' AND 'D22'
AND E.JOB <> 'MANAGER'
ORDER BY E.FIRSTNME, E.LASTNAME, E.JOB, D.DEPTNAME;

--Problem 3
/*
List the name of each department and the lastname and first name of its manager.
Sequence the list by department name. Use the EMPNO and MGRNO columns to
relate the two tables. Sequence the result rows by department name.
*/


SELECT D.DEPTNAME, E.LASTNAME, E.FIRSTNME
FROM EMPLOYEE E, DEPARTMENT D
WHERE E.EMPNO = D.MGRNO
ORDER BY D.DEPTNAME;