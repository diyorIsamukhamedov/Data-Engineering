-- =========================
-- CASE WHEN (practice)
-- =========================

-- ================================================================================
/*
 1. Create a new column that classifies customers based on their age:
    If age < 25, then the category should be 'Young'.
    If age BETWEEN 25 AND 50, then the category should be 'Middle-aged'.
    If age > 50, then the category should be 'Senior'.
*/
SELECT age,
    CASE
        WHEN age < 25 THEN 'Young'
        WHEN age BETWEEN 25 AND 50 THEN 'Middle-aged'
        ELSE 'Senior'
    END AS age_classification
FROM data_engineering.bank;
-- ================================================================================

-- ================================================================================
/*
 2. Create a new column that groups customers based on their account balance ranges
(such as low, medium, and high balances).
*/
SELECT customer_name, balance,
    CASE
        WHEN balance < 0 THEN 'Overdraft'
        WHEN balance < 1000 THEN 'Low Balance'
        WHEN balance BETWEEN 1000 AND 10000 THEN 'Medium Balance'
        ELSE 'High Balance'
    END AS account_classification
FROM data_engineering.bank;
-- ================================================================================

-- ================================================================================
/*
 3. Create a new column that evaluates the customer’s credit score
and assigns them a rating according to financial standards (e.g., from very low to excellent).
*/
SELECT customer_name, credit_score,
    CASE
        WHEN credit_score < 580 THEN 'Poor'
        WHEN credit_score BETWEEN 580 AND 669 THEN'Fair'
        WHEN credit_score BETWEEN 670 AND 739 THEN'Good'
        WHEN credit_score BETWEEN 740 AND 850 THEN'Excellent'
        ELSE 'No data'
    END AS credit_score_rating
FROM data_engineering.bank;
-- ================================================================================

-- ================================================================================
/*
 4. Create a new column that shows the level of activity
of a customer depending on how many transactions they made.
*/
SELECT customer_name, transaction_count,
    CASE
        WHEN transaction_count = 0 THEN 'Inactive'
        WHEN transaction_count BETWEEN 1 AND 50 THEN 'Low Activity'
        WHEN transaction_count BETWEEN 51 AND 150 THEN 'Medium Activity'
        WHEN transaction_count > 150 THEN 'High Activity'
    END AS transaction_activity_status
FROM data_engineering.bank;
-- ================================================================================

-- ================================================================================
/*
 5. Create a new column called risk_level that indicates whether a customer
should be considered high risk, medium risk, or low risk, based on loan status and credit score.
*/
SELECT customer_name, loan_status, credit_score,
    CASE
        WHEN loan_status = 'Rejected' OR credit_score < 600 THEN 'High Risk'
        WHEN loan_status = 'Approved' AND credit_score >= 700 THEN 'Low Risk'
        ELSE 'Medium Risk'
    END AS risk_level
FROM data_engineering.bank;
-- ================================================================================

-- ================================================================================
/*
 6. Create a new column that simplifies the existing account types
into two main categories (hint: personal vs. non-personal accounts).
*/
SELECT customer_name, account_type,
    CASE
        WHEN account_type = 'Savings' OR account_type = 'Checking' THEN 'Personal'
        WHEN account_type = 'Business' OR account_type = 'Loan' THEN 'Corporate'
        ELSE 'No data'
    END AS account_type_simplified
FROM data_engineering.bank;  
-- ================================================================================

-- ================================================================================
/*
 7. Create a new column that checks if a customer is still active or inactive,
depending on how recent their last transaction was within 90 days.
*/
SELECT customer_name, last_transaction_date,
	CASE
		WHEN last_transaction_date > CURRENT_DATE - INTERVAL '90 days' THEN 'Active'
		ELSE 'Inactive'
	END AS customer_activity
FROM data_engineering.bank;
-- ================================================================================

-- ================================================================================
/*
 8. Create a new column called priority_client that identifies whether a customer should be
treated as a priority client, based on their financial profile.
*/
SELECT
	customer_name,
	balance,
	credit_score,
		CASE
            WHEN balance < 0 THEN 'Overdraft'
			WHEN balance > 20000 AND credit_score > 700 THEN 'Yes'
			ELSE 'No'
		END AS priority_client
FROM data_engineering.bank;
-- ================================================================================

-- ================================================================================