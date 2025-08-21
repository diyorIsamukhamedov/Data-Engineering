/*
  1. You will create a stored procedure routine named RETRIEVE_ALL.
  This RETRIEVE_ALL routine will contain an SQL query to retrieve all the records
  from the PETSALE table, so you don't need to write the same query over and over again.
  You just call the stored procedure routine to execute the query everytime.
*/

-- ========================================================================================
-- MySQL syntax 
-- Change the statement delimiter from ";" to "//"
-- This is needed because inside stored procedures we use ";" to separate SQL statements,
-- and MySQL would otherwise think the procedure ends too early.
DELIMITER //

-- Create a stored procedure named RETRIEVE_ALL
CREATE PROCEDURE RETRIEVE_ALL()
BEGIN
    -- Select all records from the PETSALE table
    SELECT * FROM PETSALE;
END //

-- Restore the default delimiter back to ";"
DELIMITER ;

CALL RETRIEVE_ALL();
-- ========================================================================================

-- ========================================================================================
-- PostgreSQL syntax
-- Create or replace a stored procedure named retrieve_all
-- Note: Procedures in PostgreSQL were introduced starting from version 11.
CREATE OR REPLACE PROCEDURE retrieve_all()
-- Define the language for the procedure body (PL/pgSQL is the procedural extension of SQL in Postgres)
LANGUAGE plpgsql
AS $$
BEGIN
    -- Select all records from the petsale table
    -- IMPORTANT: In PostgreSQL, procedures cannot directly return result sets to the caller like in MySQL.
    -- This SELECT will execute, but its output will not be automatically shown to the client.
    -- To return data, a FUNCTION with RETURNS TABLE(...) is usually used instead.
    SELECT * FROM PETSALE;
END;
$$

CALL retrieve_all();
-- ========================================================================================

-- ========================================================================================
-- Create or replace a function named retrieve_all
-- Unlike procedures, functions can return values or even entire tables.
CREATE OR REPLACE FUNCTION retrieve_all()
RETURNS TABLE (id INT, product TEXT, price NUMERIC, quantity INT, sale_date DATE) -- Define output structure
LANGUAGE plpgsql
AS $$
BEGIN
   -- Return all rows from petsale
   RETURN QUERY
   SELECT id, product, price, quantity, sale_date
   FROM petsale;
END;
$$;

-- Call the function like this (returns a result set to the client)
SELECT * FROM retrieve_all();
-- ========================================================================================

/*
 2. Drop the stored procedure routine RETRIEVE_ALL and call it again.
*/

DROP PROCEDURE RETRIEVE_ALL;

CALL RETRIEVE_ALL;
-- ========================================================================================

-- ========================================================================================
/*
 3. You will create a stored procedure routine named UPDATE_SALEPRICE with parameters Animal_ID and Animal_Health.

 This UPDATE_SALEPRICE routine will contain SQL queries to update the sale price of the animals in the PETSALE table depending on their health conditions, BAD or WORSE.

 This procedure routine will take animal ID and health conditon as parameters which will be used to update the sale price of animal in the PETSALE table by an amount depending on their health condition. Suppose that:

 For animal with ID XX having BAD health condition, the sale price will be reduced further by 25%.
 For animal with ID YY having WORSE health condition, the sale price will be reduced further by 50%.
 For animal with ID ZZ having other health condition, the sale price won't change.
*/
-- MySQL syntax
DELIMITER @
CREATE PROCEDURE UPDATE_SALEPRICE (IN Animal_ID INTEGER, IN Animal_Health VARCHAR(5))
BEGIN
    IF Animal_Health = 'BAD' THEN
        UPDATE PETSALE
        SET SALEPRICE = SALEPRICE - (SALEPRICE * 0.25)
        WHERE ID = Animal_ID;
    ELSEIF Animal_Health = 'WORSE' THEN
        UPDATE PETSALE
        SET SALEPRICE = SALEPRICE - (SALEPRICE * 0.5)
        WHERE ID = Animal_ID;
    ELSE
        UPDATE PETSALE
        SET SALEPRICE = SALEPRICE
        WHERE ID = Animal_ID;
    END IF;
END @

DELIMITER ;

CALL RETRIEVE_ALL;

CALL UPDATE_SALEPRICE(1, 'BAD');

CALL RETRIEVE_ALL;
-- ========================================================================================

-- ========================================================================================
-- Create or replace a stored procedure named update_saleprice
-- Procedures in PostgreSQL can have IN parameters (input only)
CREATE OR REPLACE PROCEDURE update_saleprice(animal_id INTEGER, animal_health VARCHAR(5))
LANGUAGE plpgsql
AS $$
BEGIN
    -- Check the animal_health parameter
    IF animal_health = 'BAD' THEN
        -- Reduce saleprice by 25% for this animal
        UPDATE petsale
        SET saleprice = saleprice - (saleprice * 0.25)
        WHERE id = animal_id;

    ELSIF animal_health = 'WORSE' THEN
        -- Reduce saleprice by 50% for this animal
        UPDATE petsale
        SET saleprice = saleprice - (saleprice * 0.50)
        WHERE id = animal_id;

    ELSE
        -- If health is neither BAD nor WORSE, keep the saleprice unchanged
        UPDATE petsale
        SET saleprice = saleprice
        WHERE id = animal_id;
    END IF;
END;
$$;

-- Call the procedure in PostgreSQL
CALL update_saleprice(3, 'BAD');

/*
 4. Let's call the UPDATE_SALEPRICE routine once again.
We want to update the sale price of animal with ID 3 having
WORSE health condition in the PETSALE table.
*/
CALL RETRIEVE_ALL;

CALL UPDATE_SALEPRICE(3, 'WORSE');

CALL RETRIEVE_ALL;
-- ========================================================================================

-- ========================================================================================
/*
 5. Drop the stored procedure routine UPDATE_SALEPRICE and call it again
*/
DROP PROCEDURE UPDATE_SALEPRICE;

CALL UPDATE_SALEPRICE;
-- ========================================================================================