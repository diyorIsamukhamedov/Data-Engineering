-- ================================================================================
-- =====================
-- Part 1: Aggregate Window Functions (AVG, COUNT, MAX, MIN, SUM) - 5 tasks.
-- =====================

-- ================================================================================
/*
 1. Find the average balance of accounts for each branch city, and display it alongside each customer’s balance.
*/
-- Implementation of the task with INNER JOIN
SELECT
	b.account_id,
	b.branch_city,
	b.balance,
	avg_table.avg_balance 
FROM data_engineering.bank b
INNER JOIN (
	SELECT branch_city, avg(balance) AS avg_balance
	FROM data_engineering.bank
	GROUP BY branch_city
) AS avg_table
	ON b.branch_city = avg_table.branch_city
ORDER BY b.branch_city;
-- ====================================================

-- Implementation of the task with correlated subquery
SELECT 
	b.account_id,
	b.branch_city,
	b.balance,
	(
		SELECT avg(b2.balance)
		FROM data_engineering.bank b2 
		WHERE b2.branch_city = b.branch_city 
	) AS avg_balance
FROM data_engineering.bank b
ORDER BY b.branch_city;
-- ====================================================

-- -- Implementation of the task with Window Functions
SELECT
	account_id,
	branch_city,
	balance,
	avg(balance) OVER (PARTITION BY branch_city) AS avg_balance
FROM data_engineering.bank;
-- ================================================================================

-- ================================================================================
/*
 2. For each customer, calculate the total transaction count in their branch city.
*/
-- Implementation of the task with INNER JOIN
SELECT
	b.account_id,
	b.customer_name,
	b.transaction_count,
	b.branch_city,
	total_transactions_table.total_transactions
FROM data_engineering.bank b
INNER JOIN (
	SELECT branch_city, sum(transaction_count) AS total_transactions
	FROM data_engineering.bank
	GROUP BY branch_city
) AS total_transactions_table
	ON b.branch_city = total_transactions_table.branch_city
ORDER BY branch_city;
-- ====================================================

-- Implementation of the task with correlated subquery
SELECT 
	b.account_id,
	b.customer_name,
	b.transaction_count,
	b.branch_city,
	(
		SELECT sum(transaction_count)
		FROM data_engineering.bank b2
		WHERE b2.branch_city = b.branch_city
	) AS total_transactions
FROM data_engineering.bank b
ORDER BY b.branch_city;
-- ====================================================

-- -- Implementation of the task with Window Functions
SELECT
	account_id,
	customer_name,
	transaction_count,
	branch_city,
	sum(transaction_count) OVER (PARTITION BY branch_city) AS total_transactions
FROM data_engineering.bank;
-- ================================================================================

-- ================================================================================
/*
 3. Show the maximum and minimum balance in each account type, next to every customer of that type.
*/
-- Implementation of the task with INNER JOIN
SELECT 
	b.customer_name,
	b.balance,
	b.account_type,
	min_max_table.min_balance,
	min_max_table.max_balance
FROM data_engineering.bank b 
INNER JOIN (
	SELECT 
		account_type,
		min(balance) AS min_balance,
		max(balance) AS max_balance
	FROM data_engineering.bank
	GROUP BY account_type
) AS min_max_table
	ON b.account_type = min_max_table.account_type
ORDER BY b.account_type;
-- ====================================================

-- Implementation of the task with correlated subquery
SELECT 
	b.customer_name,
	b.balance,
	b.account_type,
	(
		SELECT min(b2.balance)
		FROM data_engineering.bank b2
		WHERE b2.account_type = b.account_type
	) AS min_balance,
	(
		SELECT max(balance)
		FROM data_engineering.bank b2
		WHERE b2.account_type = b.account_type
	) AS max_balance
FROM data_engineering.bank b 
ORDER BY b.account_type;
-- ====================================================

-- -- Implementation of the task with Window Functions
SELECT
	customer_name,
	balance,
	account_type,
	min(balance) OVER (PARTITION BY account_type) AS min_balance,
	max(balance) OVER (PARTITION BY account_type) AS max_balance
FROM data_engineering.bank;
-- ================================================================================

-- ================================================================================
/*
 4. For each customer, calculate the cumulative sum of balances ordered by their last transaction date within their branch city.
*/
-- Implementation of the task with INNER JOIN
SELECT 
	b.account_id,
	b.customer_name,
	b.balance,
	b.branch_city,
	b.last_transaction_date,
	sum(b2.balance) AS cumulative_sum
FROM data_engineering.bank b 
INNER JOIN data_engineering.bank b2 
	ON b.branch_city = b2.branch_city 
	AND b.last_transaction_date >= b2.last_transaction_date
GROUP BY
	b.account_id, 
    b.customer_name, 
    b.balance, 
    b.branch_city, 
    b.last_transaction_date
ORDER BY 
	b.branch_city,
	b.last_transaction_date;
-- ====================================================

-- Implementation of the task with correlated subquery
SELECT 
	b.account_id,
	b.customer_name,
	b.balance,
	b.branch_city,
	b.last_transaction_date,
	(
		SELECT sum(balance)
		FROM data_engineering.bank b2
		WHERE b.branch_city = b2.branch_city 
		  AND b.last_transaction_date >= b2.last_transaction_date
	) AS cumulative_sum
FROM data_engineering.bank b
ORDER BY 
	b.branch_city,
	b.last_transaction_date;
-- ====================================================

-- Implementation of the task with Window Functions
SELECT
	account_id,
	customer_name,
	balance,
	branch_city,
	last_transaction_date,
	sum(balance) OVER (
		PARTITION BY branch_city
		ORDER BY last_transaction_date
	) AS cumulative_sum
FROM data_engineering.bank;
-- ================================================================================

-- ================================================================================
/*
 5. Find the number of accounts in each loan status category, and show this number alongside each customer.
*/
-- Implementation of the task with INNER JOIN
SELECT
	b.account_id,
	b.loan_status,
	total_accounts_table.total_accounts
FROM data_engineering.bank b
INNER JOIN (
	SELECT 
		loan_status,
		count(account_id) AS total_accounts
	FROM data_engineering.bank
	GROUP BY loan_status
) AS total_accounts_table
	ON b.loan_status = total_accounts_table.loan_status
ORDER BY b.loan_status;
-- ====================================================

-- Implementation of the task with correlated subquery
SELECT
	b.account_id,
	b.loan_status,
	(
		SELECT count(*)
		FROM data_engineering.bank b2
		WHERE b2.loan_status  = b.loan_status 
	) AS total_accounts
FROM data_engineering.bank b
ORDER BY b.loan_status;
-- ====================================================

-- Implementation of the task with Window Functions
SELECT
	account_id,
	loan_status,
	count(account_id) OVER (PARTITION BY loan_status) AS total_accounts 
FROM data_engineering.bank;
-- ================================================================================

-- ================================================================================

-- =====================
-- Part 2: Ranking Window Functions (ROW_NUMBER, RANK, DENSE_RANK) - 5 tasks.
-- =====================

-- ================================================================================
/*
 1. Assign a row number to each customer ordered by balance (descending) within their branch city.
*/
SELECT
	customer_name,
	balance,
	branch_city,
	row_number() OVER (
		PARTITION BY branch_city 
		ORDER BY balance DESC
	) AS row_balance
FROM data_engineering.bank;
-- ================================================================================

-- ================================================================================
/*
 2. Rank customers by credit score within their branch city.
*/
SELECT 
	customer_name,
	credit_score,
	branch_city,
	rank() OVER (
		PARTITION BY branch_city
		ORDER BY credit_score DESC
	) AS rank_score
FROM data_engineering.bank;
-- ================================================================================

-- ================================================================================
/*
 3. Use dense_rank to assign ranking of customers by transaction_count within each account_type.
*/
SELECT
	account_id,
	customer_name,
	transaction_count,
	account_type,
	dense_rank() OVER (
		PARTITION BY account_type
		ORDER BY transaction_count DESC
	) AS dense_rank
FROM data_engineering.bank;
-- ================================================================================

-- ================================================================================
/*
 4. Rank customers globally (all branches) by their balance in descending order.
*/
SELECT 
	customer_name,
	balance,
	branch_city,
	rank() OVER (ORDER BY balance DESC) AS global_rank
FROM data_engineering.bank;
-- ================================================================================

-- ================================================================================
/*
 5. For each account_type, assign row numbers to customers ordered by their last_transaction_date (most recent first).
*/
SELECT
	customer_name,
	account_type,
	last_transaction_date,
	row_number() OVER (
		PARTITION BY account_type
		ORDER BY last_transaction_date DESC
	) AS row_num_by_date
FROM data_engineering.bank;
-- ================================================================================

-- ================================================================================

-- =====================
-- Part 3: Value Window Functions (LAG, LEAD, FIRST_VALUE, LAST_VALUE) - 5 tasks.
-- =====================

-- ================================================================================
/*
 1. For each customer, use LAG to find the previous customer’s balance in the same branch city when ordered by last_transaction_date.
*/
SELECT
	customer_name,
	balance,
	lag(balance) OVER (
		PARTITION BY branch_city 
		ORDER BY last_transaction_date
	) AS prev_balance_in_branch,
	branch_city,
	last_transaction_date
FROM data_engineering.bank;
-- ================================================================================

-- ================================================================================
/*
 2. For each customer, use LEAD to find the next customer’s credit_score in the same account_type when ordered by balance.
*/
SELECT
	customer_name,
	credit_score,
	lead(credit_score) OVER (
		PARTITION BY account_type
		ORDER BY balance DESC
	) AS next_credit_score,
	account_type,
	balance
FROM data_engineering.bank;
-- ================================================================================

-- ================================================================================
/*
 3. For each branch city, find the first account balance (by earliest transaction date) and show it next to each customer.
*/
SELECT
	account_id,
	customer_name,
	balance,
	branch_city,
	last_transaction_date,
	first_value(balance) OVER (
		PARTITION BY branch_city
		ORDER BY last_transaction_date
	) AS first_acc_balance
FROM data_engineering.bank;
-- ================================================================================

-- ================================================================================
/*
 4. For each branch city, find the last loan_status (by most recent transaction date) and show it for every customer in that branch.
*/
SELECT 
	account_id,
	customer_name,
	loan_status,
	branch_city,
	last_transaction_date,
	last_value(loan_status) OVER (
		PARTITION BY branch_city
		ORDER BY last_transaction_date
		ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING 
	) AS last_loan_status
FROM data_engineering.bank;
-- ================================================================================

-- ================================================================================
/*
 5. For each account_type, calculate the difference between a customer’s balance and the previous balance using LAG.
*/
SELECT
	customer_name,
	account_type,
	balance,
	balance - lag(balance) OVER (
		PARTITION BY account_type
		ORDER BY balance
	) AS diff_from_prev_balance
FROM data_engineering.bank;
-- ================================================================================

-- ================================================================================


























