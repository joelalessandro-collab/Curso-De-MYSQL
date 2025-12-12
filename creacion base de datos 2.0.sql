CREATE DATABASE SaludTotal;
SHOW DATABASES;
USE SaludTotal;

------------------------------------------------------------
-- TABLA MEDICINAS
------------------------------------------------------------
CREATE TABLE Medicinas
(
    id INT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(100),
    tipo CHAR(3),
    precio DECIMAL(15,2),
    stock INT,
    fecha_caducidad DATETIME
);
DESC Medicinas;

------------------------------------------------------------
-- TABLA CLIENTES
------------------------------------------------------------
CREATE TABLE Clientes
(
    cedula CHAR(10) PRIMARY KEY,
    nombre VARCHAR(100),
    fecha_nacimiento DATE,
    persona_tipo CHAR(3)   -- NAT o JUR
);

------------------------------------------------------------
-- INSERTS CLIENTES (corrección de cédulas y fechas)
------------------------------------------------------------

INSERT INTO Clientes 
VALUES ('1546454655', 'Jose', '1985-06-14', 'NAT');

INSERT INTO Clientes 
VALUES ('5150550505', 'Mario', '1995-08-04', 'NAT');

INSERT INTO Clientes 
VALUES ('1800000002', 'Paul', '2005-06-22', 'NAT');

INSERT INTO Clientes 
VALUES ('1758412369', 'antonio', '1986-06-22', 'JUR');

INSERT INTO Clientes 
VALUES ('1536478920', 'fernando', '1960-05-22', 'JUR');

SELECT * FROM Clientes;
SHOW TABLES;

------------------------------------------------------------
-- INSERTS MEDICINAS
------------------------------------------------------------
INSERT INTO Medicinas 
VALUES (NULL, 'Paracetamol', 'GEN', 1.50, 12, '2026-12-24 00:00:00');

INSERT INTO Medicinas 
VALUES (NULL, 'Amoxicilina', 'GEN', 2.60, 30, '2026-11-24 00:00:00');

INSERT INTO Medicinas 
VALUES (NULL, 'Penicilina', 'GEN', 3.50, 12, '2026-08-24 00:00:00');

INSERT INTO Medicinas 
VALUES ('7', 'omeprasol', 'GEN', 4.50, 50, '2027-08-28 00:00:00');

INSERT INTO Medicinas 
VALUES ('4', 'buprex', 'GEN', 5.50, 10, '2025-08-28 00:00:00');

SELECT * FROM Medicinas;

------------------------------------------------------------
-- TABLA DESCUENTOS
------------------------------------------------------------
CREATE TABLE Descuentos
(
    id INT PRIMARY KEY AUTO_INCREMENT,
    tipo_cliente CHAR(3),        
    tipo_medicina CHAR(3),       
    descuento_porcentaje DECIMAL(5,2),
    descripcion VARCHAR(200)
);

INSERT INTO Descuentos (tipo_cliente, tipo_medicina, descuento_porcentaje, descripcion)
VALUES ('NAT', 'DBT', 8.00, 'Descuento para diabetes tipo 2 - Metformina');

INSERT INTO Descuentos (tipo_cliente, tipo_medicina, descuento_porcentaje, descripcion)
VALUES ('JUR', 'DBT', 12.00, 'Descuento para diabetes tipo 1 - Insulina');

INSERT INTO Descuentos (tipo_cliente, tipo_medicina, descuento_porcentaje, descripcion)
VALUES ('NAT', 'DBT', 6.00, 'Descuento para diabetes - Glibenclamida');

INSERT INTO Descuentos (tipo_cliente, tipo_medicina, descuento_porcentaje, descripcion)
VALUES ('NAT', 'DBT', 7.00, 'Descuento para hipertencion - Glibenclamida');

SELECT * FROM Descuentos;

------------------------------------------------------------
-- TABLA CLIENTE_MEDICINA
------------------------------------------------------------
CREATE TABLE Cliente_Medicina
(
    cliente_cedula CHAR(10),
    medicina_id INT,
    condicion VARCHAR(100),
    frecuencia CHAR(3),            -- SEM, MEN, CRI
    descuento DECIMAL(5,2),


    PRIMARY KEY (cliente_cedula, medicina_id),

    CONSTRAINT cliente_cedula_fk FOREIGN KEY (cliente_cedula)
        REFERENCES Clientes(cedula),

    CONSTRAINT medicina_id_fk FOREIGN KEY (medicina_id)
        REFERENCES Medicinas(id)
);

DESC Cliente_Medicina;

------------------------------------------------------------
-- INSERT CLIENTE_MEDICINA
------------------------------------------------------------
INSERT INTO Cliente_Medicina 
VALUES ('1800000002', 1, 'Diabetes', 'SEM', 0.25);

SELECT * FROM Cliente_Medicina;

------------------------------------------------------------
-- EJEMPLO DELETE
------------------------------------------------------------
DELETE FROM Cliente_Medicina;

-- Medicamento base (principio activo)
CREATE TABLE MedicamentoBase
(
    id INT PRIMARY KEY AUTO_INCREMENT,
    nombre_generico VARCHAR(100) NOT NULL
);

-- Laboratorios (marca comercial)
CREATE TABLE Laboratorios
(
    id INT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(100) NOT NULL
);

--  Medicinas finales (producto)
CREATE TABLE Medicamentos
(
    id INT PRIMARY KEY AUTO_INCREMENT,
    base_id INT NOT NULL,
    laboratorio_id INT NULL,       -- NULL = genérico
    tipo CHAR(3),                  -- GEN o BRA
    precio DECIMAL(15,2),
    stock INT,
    fecha_caducidad DATETIME,

    FOREIGN KEY (base_id) REFERENCES MedicamentoBase(id),
    FOREIGN KEY (laboratorio_id) REFERENCES Laboratorios(id)
);
INSERT INTO MedicamentoBase (nombre_generico)
VALUES ('Paracetamol'), ('Amoxicilina'), ('Ibuprofeno');
INSERT INTO Laboratorios (nombre)
VALUES ('MK'), ('Bayer'), ('GSK');
INSERT INTO Medicamentos (base_id, laboratorio_id, tipo, precio, stock, fecha_caducidad)
VALUES (1, NULL, 'GEN', 1.50, 50, '2026-12-24');
INSERT INTO Medicamentos (base_id, laboratorio_id, tipo, precio, stock, fecha_caducidad)
VALUES (1, 2, 'BRA', 2.80, 35, '2026-12-24');
INSERT INTO Medicamentos (base_id, laboratorio_id, tipo, precio, stock, fecha_caducidad)
VALUES (1, 2, 'BRA', 2.80, 35, '2026-12-24');

SELECT * FROM MedicamentoBase;
SELECT * FROM Laboratorios;
SELECT * FROM Medicamentos;

---------------------------------------------------------------
--creacion de traba para facturacion
--------------------------------------------------------------
create table Empresa
(
    ruc CHAR(13),
    rezon_social VARCHAR(100),
    direccion VARCHAR(100),
    telefono VARCHAR(14),
    email VARCHAR(25)
);

insert into Empresa values('1452637890478', 'slaud total SA', 'Av 10 de agosto ', '096154544', 'jose@gmail.com');

select * FROM Empresa;


 CREATE TABLE Facturas
(
    id INT PRIMARY KEY AUTO_INCREMENT,
    cliente_cedula CHAR(10) NOT NULL,
    fecha DATETIME NOT NULL DEFAULT NOW(),
    subtotal DECIMAL(15,2) NOT NULL,
    descuento_total DECIMAL(15,2) NOT NULL,
    total_pagar DECIMAL(15,2) NOT NULL,

    CONSTRAINT fk_factura_cliente 
        FOREIGN KEY (cliente_cedula) REFERENCES Clientes(cedula)
);

select * FROM Facturas;


CREATE TABLE Factura_Detalle
(
    id INT PRIMARY KEY AUTO_INCREMENT,
    factura_id INT NOT NULL,
    medicamento_id INT NOT NULL,
    cantidad INT NOT NULL,
    precio_unitario DECIMAL(15,2) NOT NULL,
    descuento_item DECIMAL(15,2) NOT NULL,
    total_item DECIMAL(15,2) NOT NULL,

    CONSTRAINT fk_detalle_factura 
        FOREIGN KEY (factura_id) REFERENCES Facturas(id),

    CONSTRAINT fk_detalle_medicamento 
        FOREIGN KEY (medicamento_id) REFERENCES Medicamentos(id)
);

select * FROM Factura_Detalle;

CREATE TABLE Pagos_Factura
(
    id INT PRIMARY KEY AUTO_INCREMENT,
    factura_id INT NOT NULL,
    metodo_pago VARCHAR(50) NOT NULL,    -- EFECTIVO, TARJETA, TRANSFERENCIA
    monto_pagado DECIMAL(15,2) NOT NULL,
    fecha_pago DATETIME NOT NULL DEFAULT NOW(),

    CONSTRAINT fk_pago_factura 
        FOREIGN KEY (factura_id) REFERENCES Facturas(id)
);

select * FROM Pagos_Factura;

INSERT INTO Facturas (cliente_cedula, subtotal, descuento_total, total_pagar)
VALUES ('1800000002', 10.50, 1.50, 9.00);

INSERT INTO Factura_Detalle 
(factura_id, medicamento_id, cantidad, precio_unitario, descuento_item, total_item)
VALUES (1, 1, 2, 1.50, 0.30, 2.70);

INSERT INTO Pagos_Factura (factura_id, metodo_pago, monto_pagado)
VALUES (1, 'EFECTIVO', 9.00);

INSERT INTO Facturas (cliente_cedula, subtotal, descuento_total, total_pagar)
VALUES ('5150550505', 10.50, 1.50, 9.00);


