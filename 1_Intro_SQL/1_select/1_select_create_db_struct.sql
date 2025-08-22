-- ================================================================================
-- Drop the schema "data_engineering" if it already exists (delete all objects inside it)
DROP SCHEMA IF EXISTS data_engineering CASCADE;

-- Create a new schema called "data_engineering"
CREATE SCHEMA data_engineering
-- ================================================================================

-- ================================================================================
-- Drop the table "city" if it already exists inside the schema
DROP TABLE IF EXISTS data_engineering.city

-- Create the "city" table
CREATE TABLE data_engineering.city (
	id integer,					-- city ID (unique identifier)
	name varchar(50),			-- city name (up to 50 characters)
	country_code varchar(3),	-- country code (3 letters)
	district varchar(50),		-- administrative district
	population integer			-- population of the city
);

-- Drop the table "station" if it already exists inside the schema
DROP TABLE IF EXISTS data_engineering.station

-- Create the 'station' table
CREATE TABLE data_engineering.station (
	id integer,			-- city ID (unique identifier)
	city varchar(50),	-- city name (up to 50 characters)
	state varchar(2),	-- state
	lat_n integer, 		-- lat_n is the northern latitude
	long_w integer		-- long_w is the western longitude
);
-- ================================================================================

-- ================================================================================
-- Import data into the "city" table
COPY data_engineering.city (id, name, country_code, district, population)
FROM '/absolute/path/to/city_clean.csv'
WITH (format CSV, HEADER TRUE, DELIMITER ',');

-- Import data into the "station" table
COPY data_engineering.station (id, city, state, lat_n, long_w)
FROM '/absolute/path/to/station_clean.csv'
WITH (format CSV, HEADER TRUE, DELIMITER ',');
-- ================================================================================

-- Cheking tables (select * from table_name)
SELECT * FROM data_engineering.city;
SELECT * FROM data_engineering.station;
-- ================================================================================
-- Practical part in the 2_select_practise.sql file.


















