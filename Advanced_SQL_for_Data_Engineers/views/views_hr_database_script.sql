DROP TABLE IF EXISTS employees;
DROP TABLE IF EXISTS job_history;
DROP TABLE IF EXISTS jobs;
DROP TABLE IF EXISTS departments;
DROP TABLE IF EXISTS locations;

-- =========================
-- SECTION 1: Schema
-- =========================
CREATE TABLE employees (
    EMP_ID CHAR(9) NOT NULL,
    F_NAME VARCHAR(15) NOT NULL,
    L_NAME VARCHAR(15) NOT NULL,
    SSN CHAR(9),
    B_DATE DATE,
    SEX CHAR,
    ADDRESS VARCHAR(30),
    JOB_ID CHAR(9),
    SALARY DECIMAL(10,2),
    MANAGER_ID CHAR(9),
    DEP_ID CHAR(9) NOT NULL,
    PRIMARY KEY (EMP_ID)
);

CREATE TABLE job_history (
    EMPL_ID CHAR(9) NOT NULL,
    START_DATE DATE,
    JOBS_ID CHAR(9) NOT NULL,
    DEPT_ID CHAR(9),
    PRIMARY KEY (EMPL_ID,JOBS_ID)
);

CREATE TABLE jobs (
    JOB_IDENT CHAR(9) NOT NULL,
    JOB_TITLE VARCHAR(30) ,
    MIN_SALARY DECIMAL(10,2),
    MAX_SALARY DECIMAL(10,2),
    PRIMARY KEY (JOB_IDENT)
);

CREATE TABLE departments (
    DEPT_ID_DEP CHAR(9) NOT NULL,
    DEP_NAME VARCHAR(15) ,
    MANAGER_ID CHAR(9),
    LOC_ID CHAR(9),
    PRIMARY KEY (DEPT_ID_DEP)
);

CREATE TABLE locations (
    LOCT_ID CHAR(9) NOT NULL,
    DEP_ID_LOC CHAR(9) NOT NULL,
    PRIMARY KEY (LOCT_ID,DEP_ID_LOC)
);
-- ================================================================================

-- =========================
-- SECTION 2: Cheking tables (select * from table_name)
-- =========================
SELECT * FROM employees;
SELECT * FROM job_history;
SELECT * FROM jobs;
SELECT * FROM departments;
SELECT * FROM locations;
-- ================================================================================

-- =========================
-- SECTION 3: Insert Data via built-in Data Transfer feature of DBeaver
-- =========================
-- ================================================================================

-- =========================
-- SECTION 4: Working with views (practice)
-- =========================
-- 1. create a view called empsalry to display salary along with some basic sensitive data of employees from the HR database.
CREATE VIEW empsalary AS
SELECT EMP_ID, F_NAME, L_NAME, B_DATE, SEX, SALARY
FROM employees;

-- 2. Using SELECT, query the EMPSALARY view to retrieve all the records.
SELECT * FROM empsalary;

-- 3. Assume that the empsalary view we created in Task 1 doesn't contain enough salary information,
-- such as max/min salary and the job title of the employees. 
-- For this, we need to get information from other tables in the database. 
-- You need all columns from EMPLOYEES table used above, except for SALARY.
--You also need the columns JOB_TITLE, MIN_SALARY, MAX_SALARY of the JOBS table.

-- MySQL syntax
CREATE OR REPLACE VIEW EMPSALARY AS
SELECT EMP_ID, F_NAME, L_NAME, B_DATE, SEX, JOB_TITLE,
MIN_SALARY, MAX_SALARY
FROM EMPLOYEES, JOBS
WHERE EMPLOYEES.JOB_ID = JOBS.JOB_IDENT;
-- =========================

-- PostgreSQL syntax
DROP VIEW IF EXISTS empsalary;

CREATE VIEW empsalary AS
SELECT 
    e.EMP_ID, 
    e.F_NAME, 
    e.L_NAME, 
    e.B_DATE, 
    e.SEX, 
    j.JOB_TITLE,
    j.MIN_SALARY, 
    j.MAX_SALARY
FROM employees e
JOIN jobs j ON e.JOB_ID = j.JOB_IDENT;

-- 4. Using SELECT, query the EMPSALARY view to retrieve all the records.
SELECT * FROM empsalary;
-- ================================================================================

/*
  
 1. Create a view “EMP_DEPT” which has the following information.
	EMP_ID, F_NAME, L_NAME and DEP_ID from EMPLOYEES table 
  
*/
CREATE VIEW EMP_DEPT AS
SELECT EMP_ID, F_NAME, L_NAME, DEP_ID
FROM employees;
-- =========================

/*
  
 2. Modify “EMP_DEPT” such that it displays Department names instead of Department IDs.
 	For this, we need to combine information from EMPLOYEES and DEPARTMENTS as follows.

	EMP_ID, FNAME, LNAME from EMPLOYEES table and
	DEP_NAME from DEPARTMENTS table, combined over the columns DEP_ID and DEPT_ID_DEP. 
  
*/
-- MySQL syntax
CREATE OR REPLACE VIEW EMP_DEPT AS
SELECT EMP_ID, F_NAME, L_NAME, DEP_NAME
FROM EMPLOYEES, DEPARTMENTS
WHERE EMPLOYEES.DEP_ID = DEPARTMENTS.DEPT_ID_DEP;
-- =========================

-- PostgreSQL syntax
DROP VIEW IF EXISTS emp_dept;

CREATE VIEW emp_dept AS
SELECT
	d.DEP_NAME,
	e.EMP_ID,
	e.F_NAME,
	e.L_NAME
FROM departments d
INNER JOIN employees e ON e.DEP_ID = d.DEPT_ID_DEP;

SELECT * FROM emp_dept;
-- ================================================================================

/*
  
 2. Drop the view “emp_dept”.
  
*/
DROP VIEW IF EXISTS emp_dept;
-- ================================================================================






















