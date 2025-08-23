-- ================================================================================
-- Drop the table "bank" if it already exists inside the schema
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
-- Set a variable "bank_data" with the value of the environment variable BANK_DATA_PATH
\SET bank_data :'BANK_DATA_PATH'

-- Import data into the "bank" table from the CSV file specified in the variable "bank_data"
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
-- Use the variable as the path to the CSV file
FROM :'bank_data'

-- Specify that the file format is CSV,
-- the first row contains headers,
-- and values are separated by commas
WITH (format CSV, HEADER TRUE, DELIMITER ',');
-- ================================================================================

-- ================================================================================
-- Cheking table (select * from table_name)
SELECT * FROM data_engineering.bank;
-- ================================================================================

-- Practical part in the 3_agg_func_tasks.sql file