--####################################### CREATE OBJECTS #######################################--
SET SCHEMA FN71737;

--####################################### COPY AND INSERT TABLE #######################################--
SELECT * FROM DB2INST1.DEPARTMENT;

--COPYING THE TABLE
CREATE TABLE DEPT1 LIKE DB2INST1.DEPARTMENT;
--SHOWING THE TABLE. ITS EMPTY
SELECT * FROM DEPT1;
--INSERTING DATA IN THE TABLE. THE SAME DATA AS IN DB2INST1.DEPARTMENT
INSERT INTO DEPT1 SELECT * FROM DB2INST1.DEPARTMENT;
--CHECKING IF ALL IS COPIED
SELECT * FROM DEPT1;


CREATE TABLE PROJ1 LIKE DB2INST1.PROJECT;
SELECT * FROM PROJ1;
INSERT INTO PROJ1 SELECT * FROM DB2INST1.PROJECT;
SELECT * FROM PROJ1;

--####################################### VIEWS #######################################--
-- VIEW FOR ADMRDEPT = 'A00'
CREATE VIEW V_DEPT_A00
AS
	SELECT * FROM DEPT1
	WHERE ADMRDEPT = 'A00'
	WITH CHECK OPTION;

--ITS UPDATABLE, ONLY ONE TABLE WITH NO FUNCTIONS AND STUFF
SELECT * FROM V_DEPT_A00;

--CHANGING THE MANAGERS NUMBER FROM THE VIEW
UPDATE V_DEPT_A00
SET MGRNO = '000010'
WHERE DEPTNO = 'D01';

--SEE IF ITS CHANGED IN THE ORIGINAL TABLE DEPT1
SELECT * FROM DEPT1;

UPDATE V_DEPT_A00
SET ADMRDEPT = 'B01'
WHERE DEPTNO = 'D01';

--ITS CHANGED IN THE MAIN TABLE
SELECT * FROM DEPT1;
--ITS NOT EXISTING IN THE VIEW
SELECT * FROM V_DEPT_A00;

--CREATING VIEW WITH CHECK OPTION
DROP VIEW V_DEPT_A00;
CREATE VIEW V_DEPT_A00
AS
	SELECT * FROM DEPT1
	WHERE ADMRDEPT = 'A00'
	WITH CHECK OPTION;

--GIVES AN ERROR IF YOU TRY TO UPDATE IT
UPDATE V_DEPT_A00
SET ADMRDEPT = 'B01'
WHERE DEPTNO = 'C01';

SELECT * FROM V_DEPT_A00;

--####################################### TRIGERS #######################################--
--Problem 1
/*
Create the table EMPDEPT with these columns:
 • EMPNO
 • LASTNAME
 • SALARY
 • DEPTNO
 • DEP_NAME
The data types and null characteristics for these columns should be the same as for
the columns with the same names in the EMPLOYEE and DEPARTMENT tables. 
*/

CREATE TABLE EMPDEPT AS 
				  (SELECT EMPNO, LASTNAME, SALARY, DEPTNO, DEPTNAME AS DEP_NAME
				   FROM DB2INST1.EMPLOYEE, DB2INST1.DEPARTMENT
				   WHERE WORKDEPT = DEPTNO)
				   DEFINITION ONLY;

SELECT * FROM EMPDEPT;

INSERT INTO EMPDEPT
	SELECT EMPNO, LASTNAME, SALARY, DEPTNO, DEPTNAME AS DEP_NAME
				   FROM DB2INST1.EMPLOYEE, DB2INST1.DEPARTMENT
				   WHERE WORKDEPT = DEPTNO;

SELECT * FROM EMPDEPT;

/*
The definition of the table should limit the values for the yearly salary (SALARY)
column to ensure that:
*/
-- • The yearly salary for employees in department E11 (operations) must not exceed 28000.
UPDATE EMPDEPT SET SALARY = 22000
WHERE DEPTNO = 'E11';

ALTER TABLE EMPDEPT
DROP CONSTRAINT CK_SAL;

ALTER TABLE EMPDEPT
ADD CONSTRAINT CK_SAL CHECK(DEPTNO <> 'E11' OR (DEPTNO = 'E11' AND SALARY < 28000));

-- • No employee in any department may have a yearly salary that exceeds 50000.
/*
The values in the EMPNO column should be unique. The uniqueness should be
guaranteed via a unique index. 
*/


/*
Create the table HIGH_SALARY_RAISE with the following columns:
 • EMPNO
 • PREV_SAL
 • NEW_SAL
The data type for column EMPNO is CHAR(6). The other columns should be defined
as DECIMAL(9,2). All columns in this table should be defined with NOT NULL. 
*/

CREATE TABLE HIGH_SALARY_RAISE (
	EMPNO CHAR(6) NOT NULL,
	PREV_SAL DECIMAL(9,2) NOT NULL,
	NEW_SAL DECIMAL(9,2) NOT NULL
);

--Problem 3
/*
Klaus must update the yearly salaries for the employees of the EMPDEPT table. If
the new value for a salary exceeds the previous value by 10 percent or more,
Harvey wants to insert a row into the HIGH_SALARY_RAISE table. The values in
this row should be the employee number, the previous salary, and the new salary.
Create something in DB2 that will ensure that a row is inserted into the
HIGH_SALARY_RAISE table whenever an employee of the EMPDEPT table gets a
raise of 10 percent or more. 
*/

--CREATING THE TRIGGER
CREATE TRIGGER TRIG_SAL
	AFTER UPDATE OF SALARY ON EMPDEPT
	REFERENCING OLD AS O NEW AS N
	FOR EACH ROW
	WHEN (N.SALARY > O.SALARY*1.1)
		INSERT INTO HIGH_SALARY_RAISE
		VALUES (O.EMPNO, O.SALARY, N.SALARY);

--ACTIVATING THE TRIGGER
UPDATE EMPDEPT
SET SALARY = 1.2*SALARY
WHERE DEPTNO = 'D11';

--THE TABLE ITSELF
SELECT * FROM EMPDEPT WHERE DEPTNO = 'D11';
--WITH THE TRIGGER
SELECT * FROM HIGH_SALARY_RAISE;

--Problem 7
/*
Create a view named VEMPPAY that contains one row for each employee in the
company. Each row should contain employee number, last name, department
number, and total earnings for the corresponding employee. Total earnings means
salary plus bonus plus commission for the employee. Then, determine the average
of the earnings for the departments by using the view you just created. 
*/

CREATE VIEW EMPPAY
AS
	SELECT EMPNO, LASTNAME, WORKDEPT, (COALESCE(SALARY,0) + COALESCE(BONUS,0) + COALESCE(COMM,0)) AS TOT_EARN
	FROM DB2INST1.EMPLOYEE;

SELECT WORKDEPT, DECIMAL(AVG(TOT_EARN), 9, 2) AS AVG_EARN
FROM EMPPAY
GROUP BY WORKDEPT;

--Problem 8
/*
Create a view named VEMP1 containing employee number, last name, yearly
salary, and work department based on your TESTEMP table. Only employees with a
yearly salary less than 50000 should be displayed when you use the view.
					Note: It is very important that you base this view on the TESTEMP table that was
					created for you or you created with the CRTABS member. Otherwise, you may get
					incorrect results in a later lab.
Display the rows in the view in employee number sequence.
Our employee with the employee number 000020 (Thompson) changed jobs and
will get a new salary of 51000. Update the data for employee number 000020 using
the view VEMP1.
Display the view again, arranging the rows in employee number sequence. 
*/

DROP VIEW EMPEMP;

CREATE VIEW EMPEMP
AS
	SELECT *
	FROM EMPDEPT
	WHERE SALARY < 25000
	WITH CHECK OPTION;

SELECT * FROM EMPEMP;

UPDATE EMPEMP
SET SALARY = 26000
WHERE SALARY < 50000;