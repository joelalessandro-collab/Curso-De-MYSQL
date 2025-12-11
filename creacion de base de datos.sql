create DATABASE SaludTotal;
show databases;
use SaludTotal;

create table Medicinas
(
    id int primary key,
    nombre VARCHAR(100),
    tipo char(3), 
    precio decimal (15,2),
    stock int,
    fechacaducidad DATETIME
);

desc medicinas;
-----
CREATE TABLE Clientes
(
    cedula CHAR(10) PRIMARY KEY,
    nombre VARCHAR(100),
    fecha_nacimiento CHAR(100),
    persona_tipo CHAR(3)   -- NAT o JUR
);

DESC clientes;
---CLIENTES
insert into clientes 
values ('15464546553', 'Jose', '14-06-1985', 'NAT');

insert into clientes 
values ('51505505', 'Mario', '04-08-1995', 'NAT');

insert into clientes 
values ('1800000002', 'Paul', '22-06-2005', 'NAT');

select * FROM clientes;

show tables;

----MEDICINAS
insert into medicinas 
values (1, 'paracetamol', 'GEN', 1.50, 12, '2026-12-24 00:00:00');

insert into medicinas 
values (2, 'amoxixilina ', 'GEN', 2.60, 30, '2026-11-24 00:00:00');

insert into medicinas 
values (3, 'penicilina ', 'GEN', 3.50, 12, '2026-08-24 00:00:00');

SELECT * FROM medicinas;

-- Crear tabla de descuentos
CREATE TABLE Descuentos
(
    id INT PRIMARY KEY AUTO_INCREMENT,
    tipo_cliente CHAR(3),           -- NAT = Natural, JUR = Jurídica
    tipo_medicina CHAR(3),          -- GEN, ETC
    descuento_porcentaje DECIMAL(5,2),  -- Ej: 10 = 10%
    descripcion VARCHAR(200)
);

-- 10% de descuento para clientes naturales en medicinas genéricas
INSERT INTO Descuentos (tipo_cliente, tipo_medicina, descuento_porcentaje, descripcion)
VALUES ('NAT', 'GEN', 10.00, 'Descuento para clientes naturales en medicinas genéricas');

-- 15% para clientes jurídicos en medicinas genéricas
INSERT INTO Descuentos (tipo_cliente, tipo_medicina, descuento_porcentaje, descripcion)
VALUES ('JUR', 'GEN', 15.00, 'Descuento especial para clientes jurídicos');

-- 5% de descuento general para todo NAT en cualquier medicina
INSERT INTO Descuentos (tipo_cliente, tipo_medicina, descuento_porcentaje, descripcion)
VALUES ('NAT', NULL, 5.00, 'Descuento general');

SELECT * FROM Descuentos;