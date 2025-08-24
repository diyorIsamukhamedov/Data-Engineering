-- =====================
-- SECTION 1: INNER JOIN (3 tasks)
-- =====================

-- ================================================================================
/*
 1. Find all customers along with their branch manager’s name (match on branch_city).
*/
SELECT DISTINCT
	b.customer_name, 
	br.branch_manager
FROM data_engineering.bank b
INNER JOIN data_engineering.branches br
	ON b.branch_city = br.branch_city;
-- ================================================================================

-- ================================================================================
/*
 2. List customer names and account types together with the established year of their branch.
*/
SELECT DISTINCT
	b.customer_name,
	b.account_type,
	br.established_year AS established_year_of_branch
FROM data_engineering.bank b
INNER JOIN data_engineering.branches br
	ON b.branch_city = br.branch_city;
-- ================================================================================

-- ================================================================================
/*
 3. Show all customers who belong to branches with more than 40 employees.
*/
SELECT DISTINCT
    b.account_id,
    b.customer_name,
    br.branch_city,
    br.total_employees AS total_employees_of_branch
FROM data_engineering.bank AS b
INNER JOIN data_engineering.branches AS br
    ON b.branch_city = br.branch_city
WHERE br.total_employees > 40;
-- ================================================================================

-- ================================================================================

-- =====================
-- SECTION 2: LEFT OUTER JOIN (3 tasks)
-- =====================

-- ================================================================================
/*
 1. List all customers and include their branch manager’s name, even if the branch is missing in branches.
*/
SELECT 
	b.customer_name,
	b.branch_city,
	br.branch_manager
FROM data_engineering.bank b
LEFT OUTER JOIN data_engineering.branches br
	ON b.branch_city = br.branch_city;
-- ================================================================================

-- ================================================================================
/*
 2. Show all customers with their branch established year, but still display customers even if their branch year is unknown.
*/
SELECT 
	b.customer_name,
	b.branch_city,
	br.established_year AS branch_established_year
FROM data_engineering.bank b
LEFT OUTER JOIN data_engineering.branches br
	ON b.branch_city = br.branch_city;
-- ================================================================================

-- ================================================================================
/*
 3. Find all customers whose branch has fewer than 40 employees (if no branch data - still show customer).
*/
SELECT
	b.customer_name,
	b.branch_city,
	br.total_employees
FROM data_engineering.bank b
LEFT OUTER JOIN data_engineering.branches br
	ON b.branch_city = br.branch_city 
WHERE br.total_employees < 40 OR br.total_employees IS NULL;
-- ================================================================================

-- ================================================================================

-- =====================
-- SECTION 3: RIGHT OUTER JOIN (3 tasks)
-- =====================

-- ================================================================================
/*
 1. List all branches and their customers, showing all branches even if no customers are assigned.
*/
SELECT
	b.customer_name,
	br.branch_city
FROM data_engineering.bank b
RIGHT OUTER JOIN data_engineering.branches br
	ON b.branch_city = br.branch_city;
-- ================================================================================

-- ================================================================================
/*
 2. Find branch managers who currently have no customers linked.
*/
SELECT 
	b.customer_name,
	br.branch_manager,
	br.branch_city 
FROM data_engineering.bank b
RIGHT OUTER JOIN data_engineering.branches br
	ON b.branch_city = br.branch_city
WHERE b.customer_name IS NULL;
-- ================================================================================

-- ================================================================================
/*
 3. Show all branches with their customers’ balances (include branches with no customers).
*/
SELECT
	b.customer_name,
	b.balance,
	br.branch_city
FROM data_engineering.bank b
RIGHT OUTER JOIN data_engineering.branches br
	ON b.branch_city = br.branch_city;
-- ================================================================================

-- ================================================================================

-- =====================
-- SECTION 4: FULL OUTER JOIN (3 tasks)
-- =====================

-- ================================================================================
/*
 1. List all customers and branches (all possible matches on branch_city).
*/
SELECT
	b.customer_name,
	br.branch_city
FROM data_engineering.bank b
FULL OUTER JOIN data_engineering.branches br
	ON b.branch_city = br.branch_city;
-- ================================================================================

-- ================================================================================
/*
 2. Find all branches or customers located in the same city, even if there is no match.
*/
SELECT
	b.customer_name,
	br.branch_city
FROM data_engineering.bank b
FULL OUTER JOIN data_engineering.branches br
ON b.branch_city = br.branch_city;
-- ================================================================================

-- ================================================================================
/*
 3. Show customers and branch managers side by side (include cases where either is missing).
*/
SELECT 
	b.customer_name,
	br.branch_manager
FROM data_engineering.bank b
FULL OUTER JOIN data_engineering.branches br
	ON b.branch_city = br.branch_city;
-- ================================================================================

-- ================================================================================

-- =====================
-- SECTION 5: CROSS JOIN (3 tasks)
-- cross join - returns the Cartesian creation of two tables, i.e. all possible possible rows.
-- =====================

-- ================================================================================
/*
 1. Create all possible combinations of customers and branches.
*/
SELECT
	b.customer_name,
	br.branch_city
FROM data_engineering.bank b
CROSS JOIN data_engineering.branches br;
-- If you add a WHERE clause (if table1 and table2 has a relationship),
-- the CROSS JOIN will produce the same result as the INNER JOIN clause
-- ================================================================================

-- ================================================================================
/*
 2. List all pairs of customer names and branch managers.
*/
SELECT
	b.customer_name,
	br.branch_manager
FROM data_engineering.bank b
CROSS JOIN data_engineering.branches br;
-- ================================================================================

-- ================================================================================
/*
 3. Count how many total combinations exist between bank and branches.
*/
SELECT
	count(*) AS total_combinations
FROM DATA_engineering.bank
CROSS JOIN data_engineering.branches;
-- ================================================================================

-- ================================================================================

-- =====================
-- SECTION 6: UNION (3 tasks)
-- =====================

-- ================================================================================
/*
 1. Return a list of all unique cities from both bank and branches.
*/
SELECT
	b.branch_city
FROM data_engineering.bank b
UNION 
SELECT 
	br.branch_city
FROM data_engineering.branches br;
-- ================================================================================

-- ================================================================================
/*
 2. Get all unique names (customer names and branch managers).
*/
SELECT 
	b.customer_name AS name,
	'Customer' AS ROLE
FROM data_engineering.bank b
UNION
SELECT
	br.branch_manager AS name,
	'Manager' AS ROLE
FROM data_engineering.branches br;
-- ================================================================================

-- ================================================================================
/*
 3. Show all unique years (customer birth year = 2025 - age vs. branch established year).
*/
SELECT
	2025 - b.age AS year,
	'customer_birth_year' AS ROLE
FROM data_engineering.bank b
UNION 
SELECT 
	br.established_year AS year,
	'branch_established_year' AS ROLE
FROM data_engineering.branches br;
-- ================================================================================

-- ================================================================================

-- =====================
-- SECTION 7: UNION ALL (3 tasks)
-- =====================

-- ================================================================================
/*
 1. Return a list of all cities (with duplicates allowed) from bank and branches.
*/
SELECT 
	b.branch_city AS city_name,
	'customer_branches' AS ROLE
FROM data_engineering.bank b
UNION ALL
SELECT
	br.branch_city AS city_name,
	'manager_branches' AS ROLE
FROM data_engineering.branches br;
-- ================================================================================

-- ================================================================================
/*
 2. Get all names (customers + managers), including duplicates.
*/
SELECT 
	b.customer_name AS names,
	'customer_name' AS name_classification
FROM data_engineering.bank b
UNION ALL
SELECT
	br.branch_manager AS names,
	'manager_name' AS name_classification
FROM data_engineering.branches br;
-- ================================================================================

-- ================================================================================
/*
 3. List all years (customer birth years + branch established years), keeping duplicates.
*/
SELECT
	2025 - b.age AS YEAR,
	'customer_year' AS year_classification
FROM data_engineering.bank b
UNION ALL
SELECT
	br.established_year AS YEAR,
	'branch_established_year'
FROM data_engineering.branches br;
-- ================================================================================