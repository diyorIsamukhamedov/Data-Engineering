-- =====================
-- SECTION 1: Scalar Subquery (returns a single value)
-- =====================

-- ================================================================================
/*
 1. Find all customers whose balance is greater than the average balance of all accounts.
*/
SELECT 
	b.account_id,
	b.customer_name,
	b.balance
FROM data_engineering.bank b
WHERE b.balance >
		(SELECT avg(balance) FROM data_engineering.bank);
-- ================================================================================

-- ================================================================================
/*
 2. List customers who are older than the youngest customer in the dataset.
*/
SELECT b.customer_name, b.age
FROM data_engineering.bank b
WHERE b.age >
		(SELECT min(age) FROM data_engineering.bank);
-- ================================================================================

-- ================================================================================
/*
 3. Retrieve customers from the branch with the highest average credit score.
*/
SELECT 
	customer_name,
	avg(credit_score) AS avg_score
FROM data_engineering.bank
GROUP BY customer_name
HAVING avg(credit_score) = (
	SELECT max(avg_score) 
	FROM (
		SELECT AVG(credit_score) AS avg_score
        FROM data_engineering.bank
        GROUP BY branch_city
	)
);
-- ================================================================================

-- ================================================================================
/*
 4. Show customers whose transaction count is above the maximum transaction count
 in the "Savings" account type.
*/
SELECT 
	b.customer_name,
	b.account_type,
	b.transaction_count
FROM data_engineering.bank b
WHERE b.transaction_count > (
	SELECT 
		max(transaction_count)
	FROM data_engineering.bank
	WHERE account_type = 'Savings'
);
-- ================================================================================

-- ================================================================================
/*
 5. Get all accounts where the balance is lower than the average balance
 of customers with Approved loans.
*/
SELECT 
	b.account_id,
	b.customer_name,
	b.balance,
	b.loan_status
FROM data_engineering.bank b
WHERE b.balance < (
	SELECT 
		avg(balance)
	FROM data_engineering.bank
	WHERE loan_status = 'Approved'
);
-- ================================================================================

-- ================================================================================

-- =====================
-- SECTION 2: Row Subquery (returns a single row of multiple columns)
-- =====================

-- ================================================================================
/*
 1. Find the customer(s) who has the same age and credit score as the customer with account_id = 5.
*/
SELECT 
    b.customer_name,
    b.age,
    b.credit_score,
    b.account_id
FROM data_engineering.bank b
WHERE (age, credit_score) = (
    SELECT 
        age, 
        credit_score
    FROM data_engineering.bank
    WHERE account_id = 5
);
-- ================================================================================

-- ================================================================================
/*
 2. Retrieve customers whose balance and transaction count match exactly
 with any customer from the "Business" account type.
*/
SELECT
	b.customer_name,
	b.balance,
	b.transaction_count,
	b.account_type
FROM data_engineering.bank b
WHERE (balance, transaction_count) IN (
	SELECT
		balance,
		transaction_count
	FROM data_engineering.bank
	WHERE account_type = 'Business'
);
-- ================================================================================

-- ================================================================================
/*
 3. Select customers who have the same age and
 loan_status as the customer with the smallest balance.
*/
SELECT
	b.customer_name,
	b.age,
	b.loan_status
FROM data_engineering.bank b
WHERE (b.age, b.loan_status) = (
	SELECT age, loan_status
	FROM data_engineering.bank
	ORDER BY balance ASC
	LIMIT 1
);
-- ================================================================================

-- ================================================================================
/*
 4. Find all accounts that share both the branch_city and
 account_type with the account having the maximum credit_score.
*/
SELECT
	b.customer_name,
	b.account_type,
	b.credit_score,
	b.branch_city
FROM data_engineering.bank b
WHERE (b.branch_city, b.account_type) = (
	SELECT 
		branch_city, 
		account_type
	FROM data_engineering.bank
	ORDER BY credit_score DESC
	LIMIT 1
);
-- ================================================================================

-- ================================================================================
/*
 5. Return customers who have identical credit_score and age
 as the customer named "Sarah Garcia".
*/
SELECT
	b.customer_name,
	b.credit_score,
	b.age
FROM data_engineering.bank b
WHERE (b.credit_score, b.age) = (
	SELECT
		credit_score, 
		age
	FROM data_engineering.bank 
	WHERE customer_name = 'Sarah Garcia'
	LIMIT 1
);
-- ================================================================================

-- ================================================================================

-- =====================
-- SECTION 3: Table Subquery (returns a set of rows/columns)
-- =====================

-- ================================================================================
/*
 1. Find all customers whose balance is higher than every balance of customers from Seattle.
*/
SELECT 
	b.customer_name,
	b.balance,
	b.branch_city
FROM data_engineering.bank b
WHERE b.balance > ALL (
	SELECT
		balance
	FROM data_engineering.bank
	WHERE branch_city = 'Seattle'
);
-- ================================================================================

-- ================================================================================
/*
 2. List customers who belong to the same cities as those customers who have Rejected loans.
*/
SELECT 
	b.customer_name,
	b.branch_city,
	b.loan_status
FROM data_engineering.bank b
WHERE b.branch_city IN (
	SELECT DISTINCT branch_city
	FROM data_engineering.bank
	WHERE loan_status = 'Rejected'
);
-- ================================================================================

-- ================================================================================
/*
 3. Show accounts whose credit_score is greater than any customer with age below 25.
*/
SELECT
	b.customer_name,
	b.age,
	b.credit_score
FROM data_engineering.bank b
WHERE b.credit_score > ANY (
	SELECT
		credit_score
	FROM data_engineering.bank
	WHERE age < 25
)
ORDER BY age;
-- ================================================================================

-- ================================================================================
/*
 4. Retrieve all customers who have the same account_type as customers with balance above 50,000.
*/
SELECT 
	b.customer_name,
	b.account_type,
	b.balance
FROM data_engineering.bank b
WHERE account_type IN (
	SELECT 
		account_type
	FROM data_engineering.bank
	WHERE balance > 50000
)
ORDER BY b.balance DESC;
-- ================================================================================

-- ================================================================================
/*
 5. Get all customers who made more transactions than any customer with a Pending loan.
*/
SELECT
	b.customer_name,
	b.transaction_count,
	b.loan_status
FROM data_engineering.bank b
WHERE b.transaction_count > ANY (
	SELECT
		transaction_count
	FROM data_engineering.bank
	WHERE loan_status = 'Pending'
);	
-- ================================================================================

-- ================================================================================

-- =====================
-- SECTION 4: Correlated Subquery (dependent subquery)
-- =====================

-- ================================================================================
/*
 1. Find all customers whose balance is greater than the average balance of their branch_city.
*/
SELECT
	b1.customer_name,
	b1.balance,
	b1.branch_city
FROM data_engineering.bank b1
WHERE b1.balance > (
	SELECT
		avg(b2.balance)
	FROM data_engineering.bank b2
	WHERE b1.branch_city = b2.branch_city
);
-- ================================================================================

-- ================================================================================
/*
 2. Select customers who have more transactions than
 the average transaction count of their account_type.
*/
SELECT
	b1.customer_name,
	b1.transaction_count,
	b1.account_type
FROM data_engineering.bank b1
WHERE b1.transaction_count > (
	SELECT
		avg(b2.transaction_count)
	FROM data_engineering.bank b2
	WHERE b1.account_type = b2.account_type
);
-- ================================================================================

-- ================================================================================
/*
 3. Show customers whose credit_score is higher than
 the average credit_score of customers of the same age group.
*/
SELECT
	b1.customer_name,
	b1.credit_score,
	b1.age
FROM data_engineering.bank b1
WHERE b1.credit_score > (
	SELECT
		avg(b2.credit_score)
	FROM data_engineering.bank b2
	WHERE b1.age = b2.age
);
-- ================================================================================

-- ================================================================================
/*
 4. Find all accounts where the balance is greater
 than the average balance of other customers in the same loan_status.
*/
SELECT 
	b1.account_id,
	b1.balance,
	b1.loan_status
FROM data_engineering.bank b1
WHERE b1.balance > (
	SELECT
		avg(b2.balance) 
	FROM data_engineering.bank b2
	WHERE b1.loan_status = b2.loan_status
);
-- ================================================================================

-- ================================================================================
/*
 5. List customers who made more transactions than the
 maximum transactions of other customers in their branch_city.
*/
SELECT
	b1.customer_name,
	b1.transaction_count,
	b1.branch_city
FROM data_engineering.bank b1
WHERE b1.transaction_count > (
	SELECT
		max(b2.transaction_count)
	FROM data_engineering.bank b2
	WHERE b1.branch_city = b2.branch_city AND b1.account_id != b2.account_id
);
-- ================================================================================

-- ================================================================================