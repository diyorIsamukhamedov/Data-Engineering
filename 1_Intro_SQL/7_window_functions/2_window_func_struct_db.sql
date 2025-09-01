-- ================================================================================
-- Drop the table "bank" if it already exists inside the schema "data_engineering"
DROP TABLE IF EXISTS data_engineering.bank;

-- Create the "bank" table
CREATE TABLE data_engineering.bank (
    account_id INT PRIMARY KEY NOT NULL,    -- account ID (unique identifier)
    customer_name VARCHAR(50) NOT NULL,     -- customer name (up to 50 characters)
    age INT NOT NULL,                       -- customer age
    account_type VARCHAR(20) NOT NULL,      -- type of account (Savings, Checking, etc.)
    balance NUMERIC(12, 2),                 -- account balance with 2 decimal places
    transaction_count INT,                  -- number of transactions
    credit_score INT,                       -- customer credit score
    branch_city VARCHAR(100),               -- branch city name
    loan_status VARCHAR(100),               -- loan status (Approved, Rejected, Pending)
    last_transaction_date DATE              -- date of the last transaction
);
-- ================================================================================

-- ================================================================================
-- Import data into the "bank" table from the CSV file
COPY data_engineering.bank (
    account_id,
    customer_name,
    age,
    account_type,
    balance,
    transaction_count,
    credit_score,
    branch_city,
    loan_status,
    last_transaction_date
)
-- Use the filepath to the CSV file
from '/absolute/path/to/1_banking_dataset.csv'
-- Specify that the file format is CSV,
-- the first row contains headers,
-- and values are separated by commas
WITH (format CSV, HEADER TRUE, DELIMITER ',');
-- ================================================================================

-- ================================================================================
-- Cheking table (select * from table_name)
SELECT * FROM data_engineering.bank;
-- ================================================================================

-- Practical part in the 3_window_func_tasks.sql