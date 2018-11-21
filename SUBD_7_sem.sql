SET SCHEMA DB2INST1;

--Problem 1
/*
Prepare a report giving information about the average total earnings of all
employees hired in the same year. The report should include employees hired from
the beginning of 1970 till the end of 1980.
*/

SELECT YEAR(HIREDATE) AS YEAR, DECIMAL(AVG(SALARY), 9, 2) AS AVG_SAL
FROM EMP
WHERE YEAR(HIREDATE) BETWEEN 1970 AND 1980
GROUP BY YEAR(HIREDATE);


--Problem 2
/*
Now, find out the highest average from the list produced during Problem 1. You can
use your query from Problem1 and modify it to solve the problem. If you want, try to
list the respective hiring year in addition to the highest average. This is a little bit
more complex.
*/

SELECT MAX(T.AVG_SAL) AS MAX_AVG_SAL
FROM (SELECT YEAR(HIREDATE) AS YEAR, DECIMAL(AVG(SALARY), 9, 2) AS AVG_SAL
	  FROM EMP
	  WHERE YEAR(HIREDATE) BETWEEN 1970 AND 1980
	  GROUP BY YEAR(HIREDATE)) T;

SELECT T.YEAR, T.AVG_SAL AS MAX_AVG_SAL
FROM (SELECT YEAR(HIREDATE) AS YEAR, DECIMAL(AVG(SALARY), 9, 2) AS AVG_SAL
	  FROM EMP
	  WHERE YEAR(HIREDATE) BETWEEN 1970 AND 1980
	  GROUP BY YEAR(HIREDATE)) T
WHERE T.AVG_SAL >= ALL (SELECT DECIMAL(AVG(SALARY), 9, 2) AS AVG_SAL
	  					FROM EMP
	  					WHERE YEAR(HIREDATE) BETWEEN 1970 AND 1980
	  					GROUP BY YEAR(HIREDATE));

--Problem 3
/*
For each employee, display employee number, salary, and average salary and
department number. The list should be sorted by department number and employee
number.
*/

SELECT E.EMPNO, E.SALARY, T.AVG_SAL, E.WORKDEPT
FROM EMP E, (SELECT WORKDEPT, AVG(SALARY) AVG_SAL
			FROM EMPLOYEE
			GROUP BY WORKDEPT) T
WHERE E.WORKDEPT = T.WORKDEPT
ORDER BY WORKDEPT, EMPNO;

--Problem 4
/*
This problem can not be done on DB2 for OS/390.
A table named CARS contains the bill-of-materials for making a specific model of a
Honda Accord. You created the CARS table when you executed the CRTABS
member at the beginning of the labs. Determine all the major parts necessary to
construct the Passenger Compartment of the car. In other words, do not take the
recursion to the maximum possible depth:, control the recursion so that it does not
iterate more than once after the initialization.
You can determine the contents of the CARS table with the following SELECT
statement.
*/

SELECT * FROM CARS
ORDER BY 1, 2, 3, 4;

WITH RCARS(LEVEL, ASSEMBLY, COMPONENT, QUANTITY)
AS 
	(
	  SELECT LEVEL, ASSEMBLY, COMPONENT, QUANTITY
	  FROM CARS ROOT
	  WHERE ROOT.ASSEMBLY = 'PASSENGER COMPARTMENT'
	  UNION ALL
	  SELECT CHILD.LEVEL, CHILD.ASSEMBLY, CHILD.COMPONENT, CHILD.QUANTITY
	  FROM RCARS PARENT, CARS CHILD
	  WHERE PARENT.COMPONENT = CHILD.ASSEMBLY
	--AND CHILD.LEVEL < 4
	)
SELECT * FROM RCARS
WHERE LEVEL < 4;


/*
Зад 1. Като използвате схемата DB2INST1 и таблицата CARS напишете заявка, 
която за частта - 'PASSENGER COMPARTMENT' извежда от колко компонента се състои 
тя и съставящите я компоненти, както и сумата на количеството на съставните й части.
*/
WITH RCARS(LEVEL, ASSEMBLY, COMPONENT, QUANTITY)
AS 
	(
	  SELECT LEVEL, ASSEMBLY, COMPONENT, QUANTITY
	  FROM CARS ROOT
	  WHERE ROOT.ASSEMBLY = 'PASSENGER COMPARTMENT'
	  UNION ALL
	  SELECT CHILD.LEVEL, CHILD.ASSEMBLY, CHILD.COMPONENT, CHILD.QUANTITY
	  FROM RCARS PARENT, CARS CHILD
	  WHERE PARENT.COMPONENT = CHILD.ASSEMBLY
	)
SELECT LEVEL, ASSEMBLY, SUM(QUANTITY) AS SUM
FROM RCARS
GROUP BY LEVEL, ASSEMBLY;

/*
Зад 2. Като използвате схемата DB2INST1 и изгледа 
EMPM напишете заявка, която извежда всички подчинени служители на 'STERN'.
*/

SELECT * FROM EMPM
ORDER BY MANAGER;

WITH REMP(LEVEL, MANAGER, EMPLOYEE) --(?,?, ...)
AS
	(
		--INIT
		SELECT 1, MANAGER, EMPLOYEE
		FROM EMPM
		WHERE MANAGER = 'STERN'
		UNION ALL
		-- ITER
		SELECT PARENT.LEVEL + 1, CHILD.MANAGER, CHILD.EMPLOYEE
		FROM REMP PARENT, EMPM CHILD
		WHERE PARENT.EMPLOYEE = CHILD.MANAGER
	)
--MAIN
SELECT LEVEL, MANAGER, EMPLOYEE
FROM REMP
ORDER BY LEVEL;

/*
Зад 3. Като използвате схемата DB2INST1 и таблиците Flights и Trains напишете 
заявка, която извежда как може да се стигне от 'NEW YORK' до 'SOFIA' 
(с колко прекачвания) и за каква цена на билета.
*/

--'NEW YORK' -> 'SOFIA'

WITH PATH_TO(DEPARTURE, ARRIVAL, PRICE, FLIGHTS , TRAIN, LINKS)
AS
	(
	  SELECT DEPARTURE, ARRIVAL, PRICE, 1, 0, 0
	  FROM FLIGHTS
	  WHERE DEPARTURE = 'NEW YORK'
	  UNION ALL
	   SELECT DEPARTURE, ARRIVAL, PRICE, 0, 1, 0
	  FROM TRAINS
	  WHERE DEPARTURE = 'NEW YORK'
	  UNION ALL
	  SELECT C.DEPARTURE, C.ARRIVAL, (P.PRICE + C.PRICE), P.FLIGHTS + 1, P.TRAIN, P.LINKS + 1
	  FROM PATH_TO P, FLIGHTS C
	  WHERE P.ARRIVAL = C.DEPARTURE
	  UNION ALL
	  SELECT C.DEPARTURE, C.ARRIVAL, (P.PRICE + C.PRICE), P.FLIGHTS, P.TRAIN + 1, P.LINKS + 1
	  FROM PATH_TO P, TRAINS C
	  WHERE P.ARRIVAL = C.DEPARTURE
	)
SELECT 'NEW YORK - ' || ARRIVAL, PRICE, FLIGHTS , TRAIN, LINKS
FROM PATH_TO
WHERE ARRIVAL = 'SOFIA';