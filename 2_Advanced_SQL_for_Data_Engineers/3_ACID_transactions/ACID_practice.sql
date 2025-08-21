-- ========================================================================================
/*
    1. Scenario: Rose is buying a pair of boots from shoe_shop.
  So we have to update Rose's balance as well as
  the shoe_shop balance in the bank_accounts table.
  Then we also have to update Boots stock in the shoe_shop table.
  After Boots, let's also attempt to buy Rose a pair of Trainers.
*/

-- Once the tables are ready, create a stored procedure routine named
-- TRANSACTION_ROSE that includes TCL commands like COMMIT and ROLLBACK.

-- Now develop the routine based on the given scenario to execute a transaction.

-- MySQL syntax
DELIMITER //

CREATE PROCEDURE TRANSACTION_ROSE()
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;
    START TRANSACTION;
    UPDATE bank_accounts
    SET Balance = Balance-200
    WHERE AccountName = 'Rose';

    UPDATE bank_accounts
    SET Balance = Balance+200
    WHERE AccountName = 'Shoe Shop';

    UPDATE shoe_shop
    SET Stock = Stock-1
    WHERE Product = 'Boots';

    UPDATE bank_accounts
    SET Balance = Balance-300
    WHERE AccountName = 'Rose';

    COMMIT;
END //

DELIMITER ;

-- PostgrSQL syntax
CREATE OR REPLACE PROCEDURE transaction_rose()
LANGUAGE plpgsql
AS $$
BEGIN
    BEGIN
        PERFORM pg_advisory_xact_lock(1);

        UPDATE bank_accounts
        SET balance = balance - 200
        WHERE account_name = 'Rose';

        UPDATE bank_accounts
        SET balance = balance + 200
        WHERE account_name = 'Shoe Shop';

        UPDATE shoe_shop
        SET stock = stock - 1
        WHERE product = 'Boots';

        UPDATE bank_accounts
        SET balance = balance - 300
        WHERE account_name = 'Rose';

        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN
            ROLLBACK;
            RAISE;
    END;
END;
$$;
-- ========================================================================================

-- ========================================================================================
/*
    2. Let's now check if the transaction can successfully be committed or not.
*/
CALL TRANSACTION_ROSE;
SELECT * FROM bank_accounts;
SELECT * FROM shoe_shop;
-- ========================================================================================

-- ========================================================================================
/*
    3. Create a stored procedure TRANSACTION_JAMES to execute a transaction based on
    the following scenario: First buy James 4 pairs of Trainers from ShoeShop.
    Update his balance as well as the balance of ShoeShop.
    Also, update the stock of Trainers at ShoeShop.
    Then attempt to buy James a pair of Brogues from ShoeShop.
    If any of the UPDATE statements fail, the whole transaction fails.
    You will roll back the transaction. Commit the transaction only
    if the whole transaction is successful.
*/
-- MySQL syntax
DELIMITER //

CREATE PROCEDURE TRANSACTION_JAMES()

BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;

    START TRANSACTION;

    UPDATE BankAccounts
    SET Balance = Balance-1200
    WHERE AccountName = 'James';

    UPDATE BankAccounts
    SET Balance = Balance+1200
    WHERE AccountName = 'Shoe Shop';

    UPDATE ShoeShop
    SET Stock = Stock-4
    WHERE Product = 'Trainers';

    UPDATE BankAccounts
    SET Balance = Balance-150
    WHERE AccountName = 'James';

    COMMIT;

END //

DELIMITER ;

-- PostgreSQL syntax
CREATE OR REPLACE PROCEDURE transaction_james()
LANGUAGE plpgsql
AS $$
BEGIN
    BEGIN
        UPDATE bank_accounts
        SET balance = balance - 1200
        WHERE account_name = 'James';

        UPDATE bank_accounts
        SET balance = balance + 1200
        WHERE account_name = 'Shoe Shop';

        UPDATE shoe_shop
        SET stock = stock - 4
        WHERE product = 'Trainers';

        UPDATE bank_accounts
        SET balance = balance - 150
        WHERE account_name = 'James';

        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN
            ROLLBACK; -- откат
            RAISE;
    END;
END;
$$;
-- ========================================================================================