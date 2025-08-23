-- =========================
-- Aggregate functions (practice)
-- =========================

-- ================================================================================
/*
 1. Find the average account balance for each account type.
Only include account types where the average balance is greater than 10,000.
Order the results by average balance in descending order.
*/
SELECT
	account_type,
	avg(balance) AS avg_acc_balance
FROM data_engineering.bank
GROUP BY account_type
HAVING avg(balance) > 10000
ORDER BY avg_acc_balance DESC;
-- ================================================================================

-- ================================================================================
/*
 2. Calculate the total number of transactions for each branch city,
but only consider customers whose credit score is above 650.
Display only the top 5 cities with the highest total transactions.
*/
SELECT
	branch_city,
	sum(transaction_count) AS transaction_sum
FROM data_engineering.bank
WHERE credit_score > 650
GROUP BY branch_city
ORDER BY transaction_sum DESC
LIMIT 5;
-- ================================================================================

-- ================================================================================
/*
 3. Count how many customers fall under each loan status category (Approved, Rejected, Pending).
Only include categories with at least 10 customers. Sort results alphabetically by loan status.
*/
SELECT
	count(account_id) AS customers,
	loan_status
FROM data_engineering.bank
GROUP BY loan_status
HAVING count(account_id) >= 10
ORDER BY loan_status ASC;
-- ================================================================================

-- ================================================================================
-- ================================================================================
/*
 4. For each account type, find the maximum and minimum balance.
Exclude account types where the maximum balance is below 20,000.
Order the results by maximum balance in descending order.
*/
SELECT 
	account_type,
	min(balance) AS min_balance,
	max(balance) AS max_balance
FROM data_engineering.bank
GROUP BY account_type 
HAVING max(balance) > 20000
ORDER BY max_balance DESC;
-- ================================================================================

-- ================================================================================
/*
 5. Group customers by age ranges:
 		<30 = "Young"
 		30–50 = "Middle-aged"
 		>50 = "Senior"
 	Calculate the average credit score for each age group.
 Only include groups with an average score above 600.
*/
SELECT
	CASE
		WHEN age < 30 THEN 'Young'
		WHEN age BETWEEN 30 AND 50 THEN 'Middle-aged'
		WHEN age > 50 THEN  'Senior'
		ELSE 'Unknown'
	END AS age_group,
	avg(credit_score) AS avg_credit_score
FROM data_engineering.bank
GROUP BY 
	CASE
		WHEN age < 30 THEN 'Young'
		WHEN age BETWEEN 30 AND 50 THEN 'Middle-aged'
		WHEN age > 50 THEN  'Senior'
		ELSE 'Unknown'
	END
HAVING avg(credit_score) > 600
ORDER BY avg_credit_score DESC;
-- ================================================================================

-- ================================================================================
/*
 6. Count the number of customers per branch city who are considered high risk (credit score < 600).
Only include cities where there are at least 5 such customers. Order results by count in descending order.
*/
SELECT 
	count(account_id) num_of_customers,
	branch_city
FROM data_engineering.bank
WHERE credit_score < 600
GROUP BY branch_city
HAVING count(account_id) >= 5 
ORDER BY num_of_customers DESC;
-- ================================================================================

-- ================================================================================
/*
 7. For each account type, find the account with the highest balance.
Display the account ID, customer name, and balance.
Order the final result by balance in descending order. Limit the output to 10 rows.
*/
SELECT 
	b.account_id,
	b.customer_name,
	b.account_type,
	b.balance AS highest_balance
FROM data_engineering.bank b
INNER JOIN (
	SELECT
		account_type,
		max(balance) AS max_balance
	FROM data_engineering.bank
	GROUP BY account_type
) m ON b.account_type = m.account_type
	AND b.balance = m.max_balance
ORDER BY highest_balance DESC
LIMIT 10;
-- ================================================================================

-- ================================================================================
/*
 8. For each branch city, calculate the percentage of customers with Approved loans relative
to the total number of customers in that branch. Only include cities with at least 15 customers.
Order results by approval rate in descending order.
*/
SELECT
	branch_city,
	count(account_id) AS total_customers,
	sum(CASE WHEN loan_status = 'Approved' THEN 1 ELSE 0 END) AS approved_customers,
	(sum(CASE WHEN loan_status = 'Approved' THEN 1 ELSE 0 END) * 100 / count(account_id)) AS approval_rate
FROM data_engineering.bank
GROUP BY branch_city
HAVING count(account_id) >= 15
ORDER BY approval_rate DESC;
-- ================================================================================

-- ================================================================================

































	