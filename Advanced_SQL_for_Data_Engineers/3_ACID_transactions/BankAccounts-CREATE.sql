CREATE schema banks;
DROP TABLE if EXISTS banks.bank_accounts;

CREATE TABLE banks.bank_accounts (
    account_number VARCHAR(5) NOT NULL,
    account_name VARCHAR(25) NOT NULL,
    balance DECIMAL(8,2) NOT NULL CHECK(balance >= 0),
    PRIMARY KEY (account_number)
);

INSERT INTO banks.bank_accounts VALUES
('B001','Rose',300),
('B002','James',1345),
('B003','Shoe Shop',124200),
('B004','Corner Shop',76000);

-- Retrieve all records from the table

SELECT * FROM banks.bank_accounts;