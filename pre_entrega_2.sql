-- Autor: Yazmin Trucido

-- PARTE 1. CREACIÓN DE LA BASE DE DATOS
CREATE DATABASE retail_project;

-- PARTE 2. CREACIÓN DE TABLAS
CREATE TABLE clientes (
    id_cliente SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    email VARCHAR(150) UNIQUE NOT NULL,
    telefono VARCHAR(20),
    -- Restricción 1: La edad del cliente debe ser mayor o igual a 18 años
    edad INT CHECK (edad >= 18) 
);

CREATE TABLE productos (
    id_producto SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    categoria VARCHAR(50),
    -- Restricción 2: El precio debe ser mayor a 0
    precio DECIMAL(10, 2) NOT NULL CHECK (precio > 0),
    -- Restricción 3: El stock no puede ser negativo
    stock INT NOT NULL CHECK (stock >= 0)
);

-- Crear al final la tabla dependiente para evitar errores de FK
CREATE TABLE ventas (
    id_venta SERIAL PRIMARY KEY,
    id_cliente INT NOT NULL,
    id_producto INT NOT NULL,
    -- Restricción 4: Se debe vender al menos 1 artículo
    cantidad INT NOT NULL CHECK (cantidad > 0),
    fecha_venta TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (id_cliente) REFERENCES clientes(id_cliente),
    FOREIGN KEY (id_producto) REFERENCES productos(id_producto)
);

-- PARTE 3. DML - CARGA INICIAL
BEGIN; -- Inicio de la transacción

-- Insertar 6 registros en clientes
INSERT INTO clientes (nombre, email, telefono, edad) VALUES
('Ana Martinez', 'ana.martinez@email.com', '099123456', 28),
('Carlos Silva', 'carlos.silva@email.com', '098765432', 35),
('Lucia Fernandez', 'lucia.fer@email.com', '091112233', 42),
('Jorge Castro', 'jorge.c@email.com', '092223344', 21),
('Mariana Gomez', 'mgomez@email.com', '093334455', 30),
('Cliente Prueba', 'prueba_borrar@email.com', '000000000', 99);

-- Insertar 5 registros en productos 
INSERT INTO productos (nombre, categoria, precio, stock) VALUES
('Ración Perro Adulto 15kg', 'Alimentos', 2500.00, 20),
('Ración Gato Premium 3kg', 'Alimentos', 1200.50, 15),
('Collar Antitirones Talla M', 'Accesorios', 450.00, 30),
('Juguete Mordillo Goma', 'Accesorios', 250.75, 50),
('Shampoo Hipoalergénico 500ml', 'Higiene', 320.00, 10);

-- Insertar 6 registros en ventas
INSERT INTO ventas (id_cliente, id_producto, cantidad) VALUES
(1, 1, 2), -- Ana compra 2 raciones de perro
(2, 3, 1), -- Carlos compra 1 collar
(3, 2, 3), -- Lucia compra 3 raciones de gato
(4, 5, 1), -- Jorge compra 1 shampoo
(5, 4, 2), -- Mariana compra 2 juguetes
(6, 4, 1); -- Venta de prueba que eliminaremos luego

COMMIT; -- Confirmación de la transacción

-- PAERTE 4. DML - MODIFICACIÓN Y ELIMINACIÓN DE DATOS
-- UPDATE MASIVO CON WHERE: Aumentar un 10% el precio de todos los productos de la categoría 'Accesorios'
UPDATE productos
SET precio = precio * 1.10
WHERE categoria = 'Accesorios';

-- DELETE CON WHERE: Eliminar la venta de prueba (asumiendo que es id_venta = 6)
DELETE FROM ventas
WHERE id_venta = 6;