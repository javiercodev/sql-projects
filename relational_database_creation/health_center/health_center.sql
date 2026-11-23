-- Health center database
-- WARNING: drops the database if it already exists.

DROP DATABASE IF EXISTS health_center;

CREATE DATABASE IF NOT EXISTS health_center
	CHARACTER SET utf8mb4
	COLLATE utf8mb4_unicode_ci;

USE health_center;

-- Tables:

CREATE TABLE doctors(
	id						INT 			NOT NULL AUTO_INCREMENT,
	name					VARCHAR(100)	NOT NULL,
	phone_number			VARCHAR(20) 	NOT NULL,
	national_id_number		VARCHAR(20) 	NOT NULL,
	medical_license_number	VARCHAR(30) 	NOT NULL,
	doctor_type				VARCHAR(20)		NOT NULL,
	
	CONSTRAINT	pk_doctors 				PRIMARY KEY (id),
	CONSTRAINT	uq_doctors_national_id	UNIQUE (national_id_number),
	CONSTRAINT	uq_doctors_license		UNIQUE (medical_license_number),
	-- Permanent, interim or substitute doctor.
	CONSTRAINT	chk_doctor_type			CHECK (doctor_type IN ('titular', 'interino', 'sustituto')) 
) ENGINE = InnoDB;

-- Non-medical staff:
CREATE TABLE employees(
	id					INT 		 	NOT NULL AUTO_INCREMENT,
	name 				VARCHAR(100)	NOT NULL,
	phone_number 		VARCHAR(20)  	NOT NULL,
	national_id_number	VARCHAR(20)  	NOT NULL,
	employee_type 		VARCHAR(30)		NOT NULL,
	
	CONSTRAINT	pk_employees				PRIMARY KEY (id),
	CONSTRAINT	uq_employees_national_id	UNIQUE (national_id_number),
	CONSTRAINT 	chk_employees_type			CHECK (employee_type IN ('ATS', 'ATS de zona', 'auxiliar de enfermería', 'celador', 'administrativo'))
) ENGINE = InnoDB;

CREATE TABLE patients(
	id						INT				NOT NULL AUTO_INCREMENT,
	name					VARCHAR(100)	NOT NULL,
	national_id_number		VARCHAR(20) 	NOT NULL,
	social_security_number	VARCHAR(20)		NOT NULL,
	doctor_id				INT 			NOT NULL,	-- Assigned doctor.
	
	CONSTRAINT	pk_patients PRIMARY KEY (id),
	CONSTRAINT	uq_patients_national_id		UNIQUE (national_id_number),
	CONSTRAINT	uq_patients_social_security	UNIQUE (social_security_number),
	CONSTRAINT	fk_patients_doctor
		FOREIGN KEY (doctor_id)	REFERENCES doctors (id)
			ON UPDATE RESTRICT
			ON DELETE RESTRICT
) ENGINE = InnoDB;

-- Employment periods of substitute doctors, one row per start/end:
CREATE TABLE substitute_periods(
	id						INT		NOT NULL AUTO_INCREMENT,
	doctor_id				INT		NOT NULL,
	start_date				DATE	NOT NULL,	-- Hiring date.
	end_date 				DATE	NULL,		-- Termination date, NULL if still active.
	
	CONSTRAINT pk_substitute_periods PRIMARY KEY (id),
	CONSTRAINT fk_substitute_periods_doctor
		FOREIGN KEY (doctor_id) REFERENCES doctors (id)
		ON UPDATE RESTRICT
		ON DELETE RESTRICT,
	CONSTRAINT	chk_substitute_dates CHECK (end_date IS NULL OR end_date >= start_date)
) ENGINE = InnoDB;

-- Sample data: 

INSERT INTO doctors (name, phone_number, national_id_number, medical_license_number, doctor_type) VALUES
('Ana López Ruiz',      '600111222', '11111111A', 'COL-0001', 'titular'),
('Carlos Pérez Gil',    '600222333', '22222222B', 'COL-0002', 'titular'),
('Marta Sánchez Mora',  '600333444', '33333333C', 'COL-0003', 'interino'),
('Luis Ortega Vela',    '600444555', '44444444D', 'COL-0004', 'sustituto'),
('Elena Navarro Cruz',  '600555666', '55555555E', 'COL-0005', 'sustituto');

INSERT INTO employees (name, phone_number, national_id_number, employee_type) VALUES
('Laura Díaz Ferrer',    '611111111', '66666666F', 'ATS'),
('Pedro Gómez Lara',     '611222222', '77777777G', 'ATS de zona'),
('Sofía Romero Pino',    '611333333', '88888888H', 'auxiliar de enfermería'),
('Javier Molina Soto',   '611444444', '99999999J', 'celador'),
('Isabel Cano Rubio',    '611555555', '10101010K', 'administrativo');

INSERT INTO patients (name, national_id_number, social_security_number, doctor_id) VALUES
('Juan Martín Vega',     '12121212L', '281234567801', 1),
('Rosa Herrera Gil',     '13131313M', '281234567802', 1),
('Pablo Ruiz Casas',     '14141414N', '281234567803', 2),
('Lucía Prieto Mena',    '15151515P', '281234567804', 2),
('Diego Arias Lozano',   '16161616Q', '281234567805', 3);

INSERT INTO substitute_periods (doctor_id, start_date, end_date) VALUES
(4, '2025-01-07', '2025-02-15'),
(4, '2025-06-01', '2025-06-30'),
(4, '2026-03-10', NULL),
(5, '2025-08-01', '2025-08-31'),
(5, '2026-01-12', '2026-02-12');
