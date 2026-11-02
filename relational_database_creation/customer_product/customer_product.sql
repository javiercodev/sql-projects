DROP DATABASE IF EXISTS customer_product;

CREATE DATABASE IF NOT EXISTS customer_product
	CHARACTER SET utf8mb4
	COLLATE utf8mb4_unicode_ci;

USE customer_product;

CREATE TABLE customer(
	dni	 CHAR(9)	 NOT NULL,
	name VARCHAR(50) NOT NULL,
	CONSTRAINT pk_customer PRIMARY KEY (dni)
) ENGINE = InnoDB;

CREATE TABLE product(
	id           INT         NOT NULL AUTO_INCREMENT,
	manufacturer VARCHAR(50) NOT NULL,
	model        VARCHAR(50) NOT NULL,
	stock        INT         NOT NULL,
	CONSTRAINT pk_product PRIMARY KEY (id),
	CONSTRAINT chk_product_stock CHECK (stock >= 0)
) ENGINE = InnoDB;

CREATE TABLE purchase(
	dni           CHAR(9) NOT NULL,
	product_id    INT     NOT NULL,
	purchase_date DATE    NOT NULL,
	units         INT     NOT NULL,
	
	CONSTRAINT pk_purchase PRIMARY KEY (dni, product_id, purchase_date),
	CONSTRAINT fk_purchase_customer
		FOREIGN KEY (dni) REFERENCES customer (dni)
		ON UPDATE CASCADE
		ON DELETE RESTRICT,
	CONSTRAINT fk_purchase_product
		FOREIGN KEY (product_id) REFERENCES product (id)
		ON UPDATE CASCADE
		ON DELETE RESTRICT,
	CONSTRAINT chk_purchase_units CHECK (units > 0)
) ENGINE = InnoDB;

INSERT INTO customer (dni, name) VALUES
    ('32657845K', 'Antonio'),
    ('12234543Q', 'María');

INSERT INTO product (manufacturer, model, stock) VALUES
    ('Google', 'Pixel 8 Pro', 4),
    ('Xiaomi', '14T',        12),
    ('Apple',  'iPhone 13',   3);

INSERT INTO purchase (dni, product_id, units, purchase_date) VALUES
    ('32657845K', 1, 1, '2024-09-01'),
    ('32657845K', 2, 2, '2024-09-12'),
    ('12234543Q', 1, 1, '2024-09-02');