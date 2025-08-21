-- =========================
-- SECTION 1: Select (practice)
-- =========================

/*
 1. Query all columns for all American cities in the CITY table
 with populations larger than 100000. The CountryCode for America is USA.
*/

SELECT * 
FROM data_engineering.city
WHERE population > 100000 AND country_code = 'USA';

-- Expected output
/*
3815 El Paso USA Texas 563662
3878 Scottsdale USA Arizona 202705 
3965 Corona USA California 124966 
3973 Concord USA California 121780 
3977 Cedar Rapids USA Iowa 120758 
3982 Coral Springs USA Florida 117549
*/
-- ================================================================================

-- ================================================================================
/*
 2. Query the NAME field for all American cities in the CITY table
 with populations larger than 120000. The CountryCode for America is USA.
*/
SELECT name
FROM data_engineering.city
WHERE population > 120000 AND country_code = 'USA';

-- Expected output
/*
Scottsdale
Corona
Concord
Cedar Rapids
*/
-- ================================================================================

-- ================================================================================
/*
 3. Query all columns (attributes) for every row in the CITY table.
*/
SELECT * FROM data_engineering.city;
-- ================================================================================

-- ================================================================================
/*
 4. Query all columns for a city in CITY with the ID 1661.
*/
SELECT * 
FROM data_engineering.city
WHERE id = 1661;
-- ================================================================================

-- ================================================================================
/*
 5. Query all attributes of every Japanese city in the CITY table. 
 The COUNTRYCODE for Japan is JPN.
*/
SELECT *
FROM data_engineering.city
WHERE country_code = 'JPN';

-- Expected output
/*
1613 Neyagawa JPN Osaka 257315 
1630 Ageo JPN Saitama 209442 
1661 Sayama JPN Saitama 162472 
1681 Omuta JPN Fukuoka 142889 
1739 Tokuyama JPN Yamaguchi 107078
*/
-- ================================================================================

-- ================================================================================
/*
 6. Query the names of all the Japanese cities in the CITY table. 
 The COUNTRYCODE for Japan is JPN.
*/
SELECT name 
FROM data_engineering.city
WHERE country_code = 'JPN';

-- Expected output
/*
Neyagawa
Ageo
Sayama
Omuta
Tokuyama
*/
-- ================================================================================

-- ================================================================================
/*
 7. Query a list of CITY and STATE from the STATION table.
*/
SELECT city, state
FROM station;
-- ================================================================================
/*
 8. Query a list of CITY names from STATION for cities that have an even ID number.
 Print the results in any order, but exclude duplicates from the answer.
*/
SELECT DISTINCT city
FROM data_engineering.station
WHERE id % 2 = 0;
-- ================================================================================



























