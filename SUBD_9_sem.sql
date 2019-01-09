SET SCHEMA FN71737@

--INFO FOR THE HOMEWORK

--SYSCAT.TABLES - INFO FOR THE TABLES
--SYSCAT.VIEWS - INFOR FOR THE VIEWS

--TABLES
SELECT * FROM SYSCAT.COLUMNS
WHERE TABSCHEMA = 'FN71737'@

SELECT 'CREATE TABLE ' || TABNAME || '(' || COLNAME || ' ' || TYPENAME || '(' || LENGTH || '),' 
FROM SYSCAT.COLUMNS
WHERE TABSCHEMA = 'FN71737'@

SELECT * FROM SYSCAT.TABLES
WHERE TABSCHEMA = 'FN71737'@

--VIEWS
SELECT * FROM SYSCAT.VIEWS
WHERE VIEWSCHEMA = 'FN71737'@

--TRIGGERS
SELECT * FROM SYSCAT.TRIGGERS
WHERE TRIGSCHEMA = 'FN71737'@

--FUNCTIONS
SELECT * FROM SYSCAT.FUNCTIONS
WHERE FUNCSCHEMA = 'FN71737'@

--PROCEDURES
SELECT * FROM SYSCAT.PROCEDURES
WHERE PROCSCHEMA = 'FN71737'@

--PROCEDURES & FUNCTIONS
SELECT * FROM SYSCAT.ROUTINES
WHERE ROUTINESCHEMA = 'FN71737'@

--FOR THE TASKS THEMSELVES
--1
SELECT 'CREATE TABLE ' || TABNAME || '(' || COLNAME || ' ' || TYPENAME || '(' || LENGTH || '),'
FROM SYSCAT.COLUMNS
WHERE TABSCHEMA = 'DB2MOVIES' AND TABNAME = 'STARSIN'@

--2
SELECT * FROM SYSCAT.TABLES
WHERE TABSCHEMA = 'FN71737'@

SELECT * FROM SYSCAT.VIEWS
WHERE VIEWSCHEMA = 'FN71737'@

--TEMPLATE
SELECT 'DROP TRIGGER ' ||  TRIGSCHEMA || '.' || TRIGNAME || ';'
FROM SYSCAT.TRIGGERS
WHERE TRIGSCHEMA = 'DB2MOVIES'@

--###################### LECTURE & TASKS ######################--
--1 STATEMENT
CREATE PROCEDURE Sample1 (OUT Parm1 CHAR(10))
LANGUAGE SQL
 SET Parm1 = 'value1'@
--2 STATEMENT
CREATE PROCEDURE Sample2 (OUT Parm1 CHAR(10),
						  OUT Parm2 CHAR(10))
LANGUAGE SQL
BEGIN
SET Parm1 = 'value1' ;
SET Parm2 = 'value2';
END @

--OBLAST NA VIDIMOST
DROP PROCEDURE PROC1@
CREATE PROCEDURE PROC1 (out p1_a integer, out p2_a integer)
RESULT SETS 2 --VRUSHTA DVE REZULTATNI MNOJESTVA !!!ZADULJITELNO
LANGUAGE SQL
P1: BEGIN
	declare a integer default 5;
	declare c1 cursor with return for select * from DB2INST1.staff; --VRUSHTA REZULTATNO MNOJESTVO
	P2: BEGIN
		declare a integer default 7;
		declare c1 cursor with return for select * from DB2INST1.department;
		open c1; -- IZPULNI ZAQVKATA NA C1 
		--!!!ZADULJITELNO I SE OSTAWQ OTVOREN, AKO SE POLZVA VLOJENO
		--CLOSE C1;
		set p2_a = a;
	END P2;
open c1;
set p1_a = a;
END P1@

--CURSORS
CREATE PROCEDURE foo ( out day_Of_Year int )
LANGUAGE SQL
P1: BEGIN
	DECLARE c_Date DATE;
	SET c_Date = CURRENT DATE;
	SET day_of_Year = dayofyear(c_Date);
END P1@

CREATE PROCEDURE Cur_Samp
(IN v_name VARCHAR(254), OUT v_job VARCHAR(5))
LANGUAGE SQL
P1: BEGIN
DECLARE c1 CURSOR FOR SELECT JOB FROM DB2INST1.STAFF WHERE NAME = v_name;
OPEN c1;
FETCH c1 INTO v_job;
END P1@

SELECT * FROM DB2INST1.STAFF@

CALL FN71737.CUR_SAMP('Sanders', ?)@


--Procedure Language
CREATE PROCEDURE Sample3 ( IN in_Dept INT )
RESULT SETS 1
LANGUAGE SQL
------------------------------------------------------------------------
-- SQL Stored Procedure
------------------------------------------------------------------------
P1: BEGIN
DECLARE r_error int default 0;
DECLARE SQLCODE int default 0;
DECLARE CONTINUE HANDLER FOR SQLWARNING, SQLEXCEPTION, NOT FOUND
BEGIN
	SET r_error = SQLCODE;
END;
BEGIN
	DECLARE cursor1 CURSOR WITH RETURN FOR SELECT DEPTNAME, MANAGER, LOCATION
											FROM DB2INST1.ORG
WHERE
DEPTNUMB = in_Dept;
-- Cursor left open for client application
OPEN cursor1;
END;
END P1@


CREATE PROCEDURE divide ( IN numerator INTEGER,
IN denominator INTEGER, OUT result INTEGER)
LANGUAGE SQL
BEGIN
DECLARE divzero CONDITION FOR SQLSTATE '22003';
DECLARE CONTINUE HANDLER FOR divzero
	RESIGNAL SQLSTATE '22375'
	SET MESSAGE_TEXT = 'DIVISION BY ZERO';
	
IF denominator = 0 THEN
	SIGNAL divzero;
ELSE
	SET result = numerator / denominator;
END IF;
END @


CREATE PROCEDURE ITERATOR() 
LANGUAGE SQL
BEGIN
DECLARE at_end INTEGER DEFAULT 0;
DECLARE v_NAME VARCHAR(50);
DECLARE v_DEPT INT;
declare v_YEARS INT;
DECLARE not_found CONDITION FOR SQLSTATE '02000';
DECLARE c1 CURSOR FOR SELECT NAME, DEPT, YEARS FROM DB2INST1.STAFF;
DECLARE CONTINUE HANDLER FOR not_found
					SET at_end = 1;
OPEN c1;
ftch_loop1: LOOP
	FETCH c1 INTO v_NAME, v_DEPT, v_YEARS;
	
	IF at_end = 1 THEN LEAVE ftch_loop1;
	ELSEIF v_dept = '20' THEN ITERATE ftch_loop1;
	END IF;

	INSERT INTO DB2INST1.STAFF (ID, NAME, DEPT, YEARS)
	VALUES ( 400, v_NAME, v_DEPT, V_YEARS);
END LOOP;
CLOSE c1;
END @

SELECT * FROM DB2INST1.STAFF@


--#######################################################################
CREATE PROCEDURE TEST(IN V_SCHEMANAME VARCHAR(50))
RESULT SETS 1
P1: BEGIN
	DECLARE C1 CURSOR WITH RETURN FOR SELECT 'DROP SPECIFIC PROCEDURE ' || SPECIFICNAME || ';'
									  FROM SYSCAT.PROCEDURES
									  WHERE PROCSCHEMA = V_SCHEMANAME;
	OPEN C1;
END @