-- ================================================================================
-- =====================
-- Part 1: Single (Ordinary) CTE (5 tasks)
-- =====================

-- ================================================================================
/*
 1. Create a CTE that selects the top 10 customers with the highest balance and
 then display their customer_name, balance, and branch_city.
*/
WITH high_balance_customers AS (
	SELECT 
		customer_name,
		balance,
		branch_city
	FROM data_engineering.bank b
	ORDER BY balance DESC
	LIMIT 10
)
SELECT 
	customer_name,
	balance,
	branch_city
FROM high_balance_customers;
-- ================================================================================

-- ================================================================================
/*
 2. Use a CTE to calculate the average balance for each account_type.
 Then, select only those account types where the average balance is greater than 50,000.
*/
WITH account_type_avg_balance AS (
	SELECT
		account_type,
		avg(balance) AS avg_balance
	FROM data_engineering.bank
	GROUP BY account_type
)
SELECT
	account_type,
	avg_balance
FROM account_type_avg_balance
WHERE avg_balance > 50000;
-- ================================================================================

-- ================================================================================
/*
 3. Create a CTE that selects all customers with a credit score above 750.
 Then, show their customer_name, credit_score, and account_type.
*/
WITH high_credit_customers AS (
	SELECT
		customer_name,
		credit_score,
		account_type
	FROM data_engineering.bank
	WHERE credit_score > 750
)
SELECT 
	customer_name,
	credit_score,
	account_type
FROM high_credit_customers;
-- ================================================================================

-- ================================================================================
/*
 4. Build a CTE that selects customers whose last_transaction_date is
 older than 1 year from today. Show their account_id, customer_name, and last_transaction_date.
*/
WITH inactive_customers AS (
	SELECT
		account_id,
		customer_name,
		last_transaction_date
	FROM data_engineering.bank
	WHERE last_transaction_date < CURRENT_DATE - INTERVAL '1 year'
)
SELECT
	account_id,
	customer_name,
	last_transaction_date
FROM inactive_customers;
-- ================================================================================

-- ================================================================================
/*
 5. Use a CTE to select customers whose transaction_count is
 higher than the average transaction_count of all customers.
 Display customer_name, transaction_count, and balance.
*/
WITH avg_transaction AS (
	SELECT avg(transaction_count) AS avg_transaction_count
	FROM data_engineering.bank
)
SELECT 
	customer_name,
	transaction_count,
	balance
FROM data_engineering.bank
WHERE transaction_count > (SELECT avg_transaction_count FROM avg_transaction);
-- ================================================================================

-- ================================================================================

-- =====================
-- Part 2: Multiple CTEs (5 tasks)
-- =====================

-- ================================================================================
/*
 1. 
    First CTE: Calculate the average balance of all customers.
    Second CTE: Select all customers whose balance is higher than this average.
    Finally, display their customer_name, balance, and credit_score.
*/
WITH avg_balance_customers AS (
	SELECT avg(balance) AS avg_balance
	FROM data_engineering.bank
),
highest_balance AS (
	SELECT 
		customer_name,
		balance,
		credit_score
	FROM data_engineering.bank
	WHERE balance > (SELECT avg_balance FROM avg_balance_customers)
)
SELECT
	customer_name,
	balance,
	credit_score
FROM highest_balance;
-- ================================================================================

-- ================================================================================
/*
 2. 
    First CTE: Count how many customers have each loan_status.
    Second CTE: Calculate the percentage of customers for each loan status.
    Output the results as: loan_status, customer_count, and percentage.
*/
WITH loan_status_counts AS (
    SELECT
        loan_status,
        count(*) AS customer_count
    FROM data_engineering.bank
    GROUP BY loan_status
),
loan_status_percentage AS (
    SELECT
        l.loan_status,
        l.customer_count,
        round((l.customer_count * 100.0 / t.total_customers), 2) AS percentage
    FROM loan_status_counts l
    CROSS JOIN (
        SELECT count(*) AS total_customers
        FROM data_engineering.bank
    ) t
)
SELECT 
    loan_status,
    customer_count,
    percentage
FROM loan_status_percentage;
-- ================================================================================

-- ================================================================================
/*
 3. 
    First CTE: Calculate the total balance of accounts per branch_city.
    Second CTE: Rank the cities by total balance using ROW_NUMBER().
    Return the top 5 cities.
*/
WITH acc_total_balance AS (
	SELECT 
		branch_city,
		sum(balance) AS total_balance
	FROM data_engineering.bank
	GROUP BY branch_city
),
ranked_city AS (
	SELECT
		branch_city,
        total_balance,
		row_number() OVER (ORDER BY total_balance DESC) AS city_rank
	FROM acc_total_balance
)
SELECT
	branch_city,
    total_balance,
    city_rank
FROM ranked_city
WHERE city_rank <= 5;
-- ================================================================================

-- ================================================================================
/*
 4. 
    First CTE: Divide customers into age groups (<30, 30-50, >50).
    Second CTE: Calculate the average credit score for each group.
    Output age_group and avg_credit_score.
*/
WITH age_group AS (
	SELECT
		credit_score,
		CASE 
			WHEN age < 30 THEN 'Young adults'
			WHEN age BETWEEN 30 AND 50 THEN 'Middle-aged'
			WHEN age > 50 THEN 'Senior'
			ELSE 'No data'
		END AS age_classification
	FROM data_engineering.bank		
),
avg_credit_score AS (
	SELECT
		age_classification,
		avg(credit_score) AS avg_score
	FROM age_group
	GROUP BY age_classification
)
SELECT
	age_classification,
	avg_score
FROM avg_credit_score;
-- ================================================================================

-- ================================================================================
/*
 5. 
    First CTE: Customers with balance greater than 50,000.
    Second CTE: Customers with transaction_count greater than 400.
    Final Query: Find the intersection (customers that satisfy both conditions).
*/
WITH highest_balance AS (
	SELECT 
		account_id,
		customer_name,
		balance
	FROM data_engineering.bank
	WHERE balance > 50000
),
highest_transaction_count AS (
	SELECT
		account_id,
		customer_name,
		transaction_count
	FROM data_engineering.bank
	WHERE transaction_count > 400
)
SELECT
	b.account_id,
	b.customer_name,
	b.balance,
	t.transaction_count
FROM highest_balance b
INNER JOIN highest_transaction_count t
	ON b.account_id = t.account_id;
-- ================================================================================

-- ================================================================================

-- =====================
-- Part 3: Recursive CTEs (5 tasks)
-- =====================

-- ================================================================================
/*
 1. Starting with a balance of 1000, recursively increase the balance by 10%
 each step until it exceeds 5000.
 Return all intermediate values.
*/
WITH RECURSIVE increase_balance AS (  		 -- Define a recursive CTE named "increase_balance"
	SELECT 1000.0::NUMERIC AS balance 		 -- Anchor member: starting point, balance = 1000 (cast to NUMERIC for decimal precision)
	UNION ALL								 -- Combine the anchor member with the recursive member
	SELECT (balance * 0.1) + balance		 -- Recursive member: increase balance by 10% each step
	FROM increase_balance					 -- Get the previous value from the same CTE (self-reference)
	WHERE (balance * 0.1) + balance <= 5000	 -- Stop recursion once balance exceeds 5000
)
SELECT 
	balance 			-- Final query: return all generated balances
FROM increase_balance;	-- Select results from the recursive CTE
-- ================================================================================

-- ================================================================================
/*
 2. Write a recursive CTE that, given a starting age of 65,
 generates a countdown of ages until 18. Show all values.
*/
WITH RECURSIVE age_countdown AS (
	SELECT 65 AS age
	UNION ALL
	SELECT age - 1
	FROM age_countdown
	WHERE age > 18
)
SELECT age FROM age_countdown;
-- ================================================================================

-- ================================================================================
/*
 3. Suppose you want to simulate savings growth:
        Start with a customer’s current balance.
        Recursively add 2000 each step until the balance exceeds 50,000.
        Show all intermediate steps for each customer with account_id = 101.
*/
WITH RECURSIVE saving_growth AS (
	SELECT 
		balance::NUMERIC
	FROM data_engineering.bank
	WHERE account_id = 101
	UNION ALL 
	SELECT balance + 2000.0
	FROM saving_growth
	WHERE balance <= 50000
)
SELECT balance FROM saving_growth;
-- ================================================================================

-- ================================================================================
/*
 4. Create a recursive CTE that starts from the maximum credit_score
 in the table and decreases by 50 until it reaches 300. Show all values.
*/
WITH RECURSIVE max_credit_score AS (
	SELECT max(credit_score) AS max_score  -- Anchor
	FROM data_engineering.bank
	UNION ALL 
	SELECT max_score - 50  				   -- Recursive member
	FROM max_credit_score
	WHERE max_score - 50 >= 300
)
SELECT max_score FROM max_credit_score;
-- ================================================================================

-- ================================================================================
/*
 5. Write a recursive CTE that starts with status "Pending",
 then changes it step by step into "Approved". For example:
 Pending -> Under Review -> Final Review -> Approved. Display all steps.
*/
WITH RECURSIVE status_transitions AS (
	SELECT 'Pending'::TEXT AS status, 1 AS step_num
	UNION ALL
	SELECT t.next_status, status_transitions.step_num + 1
	FROM status_transitions
	INNER JOIN (
		VALUES 
			('Pending','Under Review'),
            ('Under Review','Final Review'),
            ('Final Review','Approved')
	) AS t(current_status, next_status)
	ON t.current_status = status_transitions.status
	WHERE status_transitions.status != 'Approved'
)
SELECT * FROM status_transitions ORDER BY step_num ASC;
-- ================================================================================

-- ================================================================================