-- ========================================================================================
/*
    1. Retrieve the names and job start dates of all employees who work for
  department number 5.
  We need to use the Inner join operation with the EMPLOYEES table
  as the left table and the JOB_HISTORY table as the right table.
  The join will be made over employee ID, and the query response
  will be filtered for the Department ID value 5.
*/

SELECT E.F_NAME,E.L_NAME, JH.START_DATE 
FROM EMPLOYEES as E
INNER JOIN JOB_HISTORY as JH 
ON E.EMP_ID=JH.EMPL_ID
WHERE E.DEP_ID ='5';
-- ========================================================================================

-- ========================================================================================
/*
    2. Retrieve employee ID, last name, department ID, and department name
  for all employees.

  For this, you must use the Left Outer Join operation with the EMPLOYEES table
  as the left table and the DEPARTMENTS table as the right table. The join will happen
  on the Department ID.

  Left join query retrieves all employees, including their department details
  if available. If an employee does not belong to any department, the department
  fields will be NULL.
*/

SELECT E.EMP_ID, E.L_NAME, E.DEP_ID, D.DEP_NAME
FROM EMPLOYEES AS E 
LEFT OUTER JOIN DEPARTMENTS AS D 
ON E.DEP_ID=D.DEPT_ID_DEP;
-- ========================================================================================

-- ========================================================================================
/*
    3. Retrieve the First name, Last name, and Department name of all employees.
  For this, you will use the Full Outer Join operation with the EMPLOYEES
  table as the left table and the DEPARTMENTS table as the right table.
  A full outer join in MySQL is implemented as a UNION of left and right outer joins.

  Full Outer Join query retrieves all employees and departments, showing all combinations.
  If an employee is not associated with a department, or a department has no employees,
  the missing fields will be NULL.
*/

SELECT E.F_NAME, E.L_NAME, D.DEP_NAME
FROM EMPLOYEES AS E
LEFT OUTER JOIN DEPARTMENTS AS D
ON E.DEP_ID = D.DEPT_ID_DEP

UNION

SELECT E.F_NAME, E.L_NAME, D.DEP_NAME
FROM EMPLOYEES AS E
RIGHT OUTER JOIN DEPARTMENTS AS D
ON E.DEP_ID=D.DEPT_ID_DEP
-- ========================================================================================

-- ========================================================================================
/*
    4. Retrieve the names, job start dates, and job titles of all employees
  who work for department number 5.
*/

select E.F_NAME,E.L_NAME, JH.START_DATE, J.JOB_TITLE 
from EMPLOYEES as E 
INNER JOIN JOB_HISTORY as JH on E.EMP_ID=JH.EMPL_ID 
INNER JOIN JOBS as J on E.JOB_ID=J.JOB_IDENT
where E.DEP_ID ='5';
-- ========================================================================================

-- ========================================================================================
/*
    5. Retrieve employee ID, last name, and department ID for all employees
  but department names for only those born before 1980.
*/

-- MySQL syntax
SELECT E.EMP_ID, E.L_NAME, E.DEP_ID, D.DEP_NAME
FROM EMPLOYEES AS E
LEFT OUTER JOIN DEPARTMENTS AS D
ON E.DEP_ID = D.DEPT_ID_DEP
AND YEAR(E.B_DATE) < 1980;

-- PostgreSQL syntax
SELECT E.EMP_ID, E.L_NAME, E.DEP_ID, D.DEP_NAME
FROM EMPLOYEES AS E
LEFT OUTER JOIN DEPARTMENTS AS D
ON E.DEP_ID = D.DEPT_ID_DEP
EXTRACT(YEAR FROM e.b_date) < 1980;
-- ========================================================================================

-- ========================================================================================
/*
    6. Retrieve the first name and last name of all employees but department ID
  and department names only for male employees.
*/

SELECT E.F_NAME, E.L_NAME, D.DEPT_ID_DEP, D.DEP_NAME
FROM EMPLOYEES AS E
LEFT OUTER JOIN DEPARTMENTS AS D
ON E.DEP_ID=D.DEPT_ID_DEP AND E.SEX = 'M'

UNION

SELECT E.F_NAME, E.L_NAME, D.DEPT_ID_DEP, D.DEP_NAME
from EMPLOYEES AS E
RIGHT OUTER JOIN DEPARTMENTS AS D
ON E.DEP_ID=D.DEPT_ID_DEP AND E.SEX = 'M';
-- ========================================================================================