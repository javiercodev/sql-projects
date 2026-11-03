DROP DATABASE IF EXISTS customer_queries;

CREATE DATABASE IF NOT EXISTS customer_queries
	CHARACTER SET utf8mb4
	COLLATE utf8mb4_unicode_ci;

USE customer_queries;

-- Table: customer
CREATE TABLE customer(
	id           INT NOT NULL,
	name         VARCHAR(80),
	contact_name VARCHAR(80),
	address      VARCHAR(120),
	city         VARCHAR(60),
	postal_code  VARCHAR(20),
	country      VARCHAR(20),
	CONSTRAINT pk_customer PRIMARY KEY (id)
) ENGINE = InnoDB;

-- Data: load customers.csv (copy it to /tmp in the container first; needs --local-infile=1)
LOAD DATA LOCAL INFILE '/tmp/customers.csv'
INTO TABLE customer
CHARACTER SET utf8mb4
COLUMNS TERMINATED BY ';'
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES;

-- Queries
-- 1) Customers whose city is Berlin or Stuttgart
SELECT * FROM customer WHERE city = 'Berlin' OR city = 'Stuttgart';

-- 2) Customers whose country is Germany or Spain
SELECT * FROM customer WHERE country = 'Germany' OR country = 'Spain';

-- 3) Customers whose country is not Germany
SELECT * FROM customer WHERE NOT country = 'Germany';

-- 4) Customers in Germany, in the city of Berlin or Stuttgart
SELECT * FROM customer WHERE country = 'Germany' AND (city = 'Berlin' OR city = 'Stuttgart');

-- 5) Customers whose country is neither Germany nor USA
SELECT * FROM customer WHERE NOT (country = 'Germany' OR country = 'USA');

-- 6) Customers ordered by country
SELECT * FROM customer ORDER BY country;

-- 7) Customers ordered by country, descending
SELECT * FROM customer ORDER BY country DESC;

-- 8) Customers ordered by country, then by name
SELECT * FROM customer ORDER BY country, name;

-- 9) Customers ordered by country ascending and by name descending
SELECT * FROM customer ORDER BY country ASC, name DESC;