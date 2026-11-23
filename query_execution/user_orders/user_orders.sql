-- Health center database
-- WARNING: drops the database if it already exists.

DROP DATABASE IF EXISTS user_orders;

CREATE DATABASE IF NOT EXISTS user_orders
	CHARACTER SET utf8mb4
	COLLATE utf8mb4_unicode_ci;

USE user_orders;

-- Tables:

CREATE TABLE users(
	id	 	INT				NOT NULL	AUTO_INCREMENT,
	name 	VARCHAR(50)		NOT NULL,
	email	VARCHAR(100)	NOT NULL,
	
	CONSTRAINT pk_users			PRIMARY KEY (id),
	CONSTRAINT uq_users_email	UNIQUE (email)
) ENGINE = InnoDB;

CREATE TABLE orders(
	id			INT	AUTO_INCREMENT,
	user_id		INT,
	product		VARCHAR(255),
	quantity	INT,
	
	CONSTRAINT pk_orders	PRIMARY KEY (id),
	CONSTRAINT fk_orders_user_id
		FOREIGN KEY (user_id)	REFERENCES	users (id)
			ON UPDATE CASCADE
			ON DELETE RESTRICT
) ENGINE = InnoDB;

-- Sample data:

INSERT INTO users(name, email) VALUES
("Juana", "ju@jk.com"),
("Paola", "qwe@df.com"),
("Esteban","op@op.com");

INSERT INTO orders(user_id, product, quantity) VALUES
(1, 'Laptop', 1),
(2, 'Smartphone', 2),
(3, 'Tablet', 1),
(1, 'Monitor', 2),
( 2, 'Teclado', 1),
(NULL, "PS5", 0);

INSERT INTO orders(user_id, product, quantity) VALUES
(null, "Zapatillas Nike", 3),
(2, "Estrella Ninja", NULL),
(3, NULL, NULL);

INSERT INTO users(name, email) VALUES
("tacaño", "tac@taca.com");

INSERT INTO orders(user_id, product, quantity) VALUES
(1,"Laptop",1);

-- Join exercises:

-- 1. Get all users and their orders:
SELECT u.id, u.name, o.product, o.quantity
FROM users u
LEFT JOIN orders o ON o.user_id = u.id;

-- 2. Get all orders and their associated users:
SELECT o.id, o.user_id, u.name, o.product, o.quantity
FROM orders o
LEFT JOIN users u ON u.id = o.user_id;

-- 3. Get the users who placed orders:
SELECT DISTINCT u.id, u.name
FROM users u
JOIN orders o ON o.user_id = u.id;

-- 4. Count the number of orders per user:
SELECT u.id, u.name, COUNT(o.id) AS total_orders
FROM users u
LEFT JOIN orders o ON o.user_id = u.id
GROUP BY u.id, u.name;

-- 5 && 6. List products and quantity ordered by each user:
SELECT u.name, o.product, o.quantity
FROM users u
LEFT JOIN orders o ON o.user_id = u.id;

-- 7. Show users without orders:
SELECT u.id, u.name 
FROM users u
LEFT JOIN orders o ON o.user_id = u.id
WHERE o.id IS NULL;

-- 8. Show orders without an associated user:
SELECT o.id, o.product 
FROM orders o
LEFT JOIN users u ON u.id = o.user_id
WHERE u.id IS NULL;

-- 9. Get users and the sum of ordered quantities:
SELECT u.id, u.name, SUM(o.quantity) AS sum_quantity
FROM users u
LEFT JOIN orders o ON o.user_id = u.id
GROUP BY u.id, u.name;

-- 10. Check duplicate products ordered by user:
SELECT u.id, u.name, o.product, COUNT(*) AS times_ordered
FROM users u
JOIN orders o ON o.user_id = u.id
GROUP BY u.id, u.name, o.product
HAVING COUNT(*) > 1;

-- 10b. Show users and their 'Laptop' orders:
SELECT u.id, u.name, o.id AS order_id, o.product, o.quantity
FROM users u
JOIN orders o ON o.user_id = u.id
WHERE o.product = 'Laptop'
ORDER BY u.id, o.id;