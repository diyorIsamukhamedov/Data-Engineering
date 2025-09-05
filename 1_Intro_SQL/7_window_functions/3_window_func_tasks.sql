-- ================================================================================
-- =====================
-- Part 1: Aggregate Window Functions (AVG, COUNT, MAX, MIN, SUM) - 5 tasks.
-- =====================

-- ================================================================================
/*
 1. Find the average balance of accounts for each branch city, and display it alongside each customer’s balance.
*/
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
SELECT
	account_id,
	customer_name,
	balance,
	branch_city,
	sum(balance) OVER (PARTITION BY branch_city ORDER BY last_transaction_date) AS cumulative_sum
FROM data_engineering.bank;
-- ================================================================================

-- ================================================================================
/*
 5. Find the number of accounts in each loan status category, and show this number alongside each customer.
*/
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

-- ================================================================================

-- ================================================================================
/*
 3. Use dense_rank to assign ranking of customers by transaction_count within each account_type.
*/

-- ================================================================================

-- ================================================================================
/*
 4. Rank customers globally (all branches) by their balance in descending order.
*/

-- ================================================================================

-- ================================================================================
/*
 5. For each account_type, assign row numbers to customers ordered by their last_transaction_date (most recent first).
*/

-- ================================================================================

-- ================================================================================

-- =====================
-- Part 3: Value Window Functions (LAG, LEAD, FIRST_VALUE, LAST_VALUE) - 5 tasks.
-- =====================

-- ================================================================================
/*
 1. For each customer, use LAG to find the previous customer’s balance in the same branch city when ordered by last_transaction_date.
*/

-- ================================================================================

-- ================================================================================
/*
 2. For each customer, use LEAD to find the next customer’s credit_score in the same account_type when ordered by balance.
*/

-- ================================================================================

-- ================================================================================
/*
 3. For each branch city, find the first account balance (by earliest transaction date) and show it next to each customer.
*/

-- ================================================================================

-- ================================================================================
/*
 4. For each branch city, find the last loan_status (by most recent transaction date) and show it for every customer in that branch.
*/

-- ================================================================================

-- ================================================================================
/*
 5. For each account_type, calculate the difference between a customer’s balance and the previous balance using LAG.
*/

-- ================================================================================

-- ================================================================================


























