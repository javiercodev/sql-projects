DROP DATABASE IF EXISTS invoice_details;

CREATE DATABASE IF NOT EXISTS invoice_details
	CHARACTER SET utf8mb4
	COLLATE utf8mb4_unicode_ci;

USE invoice_details;

-- Table: customer
CREATE TABLE customer(
	id           INT          NOT NULL AUTO_INCREMENT,
	first_name   VARCHAR(50)  NOT NULL,
	last_name    VARCHAR(50)  NOT NULL,
	address      VARCHAR(100) NOT NULL,
	birth_date   DATE         NOT NULL,
	phone_number VARCHAR(15)  NOT NULL,
	email        VARCHAR(50)  NOT NULL,
	category     VARCHAR(50)  NOT NULL,
	CONSTRAINT pk_customer PRIMARY KEY (id)
) ENGINE = InnoDB;

-- Table: invoice
CREATE TABLE invoice(
	num          INT  NOT NULL AUTO_INCREMENT,
	customer_id  INT  NOT NULL,
	invoice_date DATE NOT NULL,
	
	CONSTRAINT pk_invoice PRIMARY KEY (num),
	CONSTRAINT fk_invoice_customer
		FOREIGN KEY (customer_id) REFERENCES customer (id)
		ON UPDATE CASCADE
		ON DELETE RESTRICT
) ENGINE = InnoDB;

-- Table: product
CREATE TABLE product(
	id    INT           NOT NULL AUTO_INCREMENT,
	name  VARCHAR(50)   NOT NULL,
	price DECIMAL(10,2) NOT NULL,
	stock INT           NOT NULL,
	CONSTRAINT pk_product PRIMARY KEY (id),
	CONSTRAINT chk_product_price CHECK (price >= 0),
	CONSTRAINT chk_product_stock CHECK (stock >= 0)
) ENGINE = InnoDB;

-- Table: detail
CREATE TABLE detail(
	num         INT NOT NULL AUTO_INCREMENT,
	invoice_num INT NOT NULL,
	product_id  INT NOT NULL,
	quantity    INT NOT NULL,
	
	CONSTRAINT pk_detail PRIMARY KEY (num, invoice_num),
	CONSTRAINT fk_detail_invoice
		FOREIGN KEY (invoice_num) REFERENCES invoice (num)
		ON UPDATE CASCADE
		ON DELETE RESTRICT,
	CONSTRAINT fk_detail_product
		FOREIGN KEY (product_id) REFERENCES product (id)
		ON UPDATE CASCADE
		ON DELETE RESTRICT,
	CONSTRAINT chk_detail_quantity CHECK (quantity > 0)
) ENGINE = InnoDB;

-- Data: sample rows
INSERT INTO customer (first_name, last_name, address, birth_date, phone_number, email, category) VALUES
	('Antonio', 'García',  'Calle Sierpes 1, Sevilla',      '1990-05-14', '600111222', 'antonio@mail.com', 'standard'),
	('María',   'López',   'Avenida de la Constitución 8, Sevilla', '1985-11-02', '611222333', 'maria@mail.com',   'premium'),
	('Lucía',   'Romero',  'Calle Betis 15, Sevilla',       '1998-03-27', '622333444', 'lucia@mail.com',   'standard');

INSERT INTO product (name, price, stock) VALUES
	('Pixel 8 Pro', 799.99,  4),
	('Xiaomi 14T',  499.50, 12),
	('iPhone 13',   649.00,  3);

INSERT INTO invoice (customer_id, invoice_date) VALUES
	(1, '2024-09-01'),
	(2, '2024-09-02'),
	(1, '2024-09-12');

INSERT INTO detail (invoice_num, product_id, quantity) VALUES
	(1, 1, 1),
	(2, 3, 1),
	(3, 2, 2);




