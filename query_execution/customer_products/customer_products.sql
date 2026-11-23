-- customer_products database
-- WARNING: drops the database if it already exists.

DROP DATABASE IF EXISTS customer_products;

CREATE DATABASE IF NOT EXISTS customer_products
    CHARACTER SET utf8mb4
    COLLATE utf8mb4_unicode_ci;

USE customer_products;

-- Tables:

CREATE TABLE customers(
	id           INT NOT NULL AUTO_INCREMENT,
	name         VARCHAR(80),
	contact_name VARCHAR(80),
	address      VARCHAR(120),
	city         VARCHAR(60),
	postal_code  VARCHAR(20),
	country      VARCHAR(20),

	CONSTRAINT pk_customer PRIMARY KEY (id)
) ENGINE = InnoDB;

CREATE TABLE products(
    id          INT NOT NULL AUTO_INCREMENT,
    name        VARCHAR(50),
    supplier_id INT,
    category_id INT,
    unit        VARCHAR(80),
    price       DECIMAL(10,2),
    customer_id INT,

    CONSTRAINT  pk_products PRIMARY KEY (id),
    CONSTRAINT  fk_products_customer_id
        FOREIGN KEY (customer_id) REFERENCES customers (id)
            ON UPDATE CASCADE
            ON DELETE RESTRICT
) ENGINE = InnoDB;

-- Sample data: 

LOAD DATA LOCAL INFILE <file_path>
INTO TABLE <table_name>
CHARACTER SET utf8mb4
COLUMNS TERMINATED BY ';'
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES;

-- Query exercises:

-- 1. List all customers with a NULL value in the "Address" field:
SELECT *
FROM customers
WHERE address IS NULL;

-- 2. List all customers with a non-NULL value in the "Address" field:
SELECT *
FROM customers
WHERE address IS NOT NULL;

-- 3. List the product with the lowest price:
SELECT MIN(price) AS lowest_price
FROM products;

-- 4. Find the highest product price:
SELECT MAX(price) AS higuest_price
FROM products;

-- 5. Find the total number of existing products:
SELECT COUNT(*) AS total_products
FROM products;

-- 6. Find the average price of all products:
SELECT AVG(price) AS average_price
FROM products;

-- 7. Find all customers whose names start with the character 'a':
SELECT * 
FROM customers
WHERE name LIKE 'a%';

-- 8. Find all customers whose names end with the character 'a':
SELECT * 
FROM customers
WHERE name LIKE '%a';

-- 9. Find all customers whose names containt the characters "or" in any position:
SELECT *
FROM customers
WHERE name LIKE '%or%';

-- 10. Find all customers whose names have "r" in the second position:
SELECT *
FROM customers
WHERE name LIKE '_r%';

-- 11. Select all customers whose names start with 'a' and have at least 3 characters:
SELECT *
FROM customers
WHERE name LIKE 'a__%';

-- 12. Select all customers whose names do NOT start with the letter 'a':
SELECT *
FROM customers
WHERE name NOT LIKE 'a%';

-- 13. Select all customers who are located in "Germany", "France" or "UK":
SELECT * 
FROM customers
WHERE country IN ('Germany', 'France', 'UK');

-- 14. Select all customers who are NOT located in "Germany", "France" or "UK":
SELECT *
FROM customers
WHERE country NOT IN ('Germany', 'France', 'UK');

-- 15. Select all products with a price between 10 and 20.
SELECT *
FROM products
WHERE price BETWEEN 10 AND 20;

-- 16. Select all products with a price between 10 and 20, excluding those belonging to categories 1, 2 or 3:
SELECT *
FROM products
WHERE price BETWEEN 10 AND 20
    AND category_id NOT IN (1, 2, 3);

-- 17. Select all products whose product names are between "Carnarvon Tigers" and "Mozzarella di Giovanni":
SELECT *
FROM products
WHERE name BETWEEN 'Carnarvon Tigers' AND 'Mozzarella di Giovanni';

-- 18. Create a query with 2 aliases, one for the customer_id column and another for the customer_name column:
SELECT 
    id      AS customer_id,
    name    AS customer_name
FROM customers;

-- 19. Find the number of customers in each country:
SELECT
    country,
    COUNT(*) AS total_customers
FROM customers
GROUP BY country;