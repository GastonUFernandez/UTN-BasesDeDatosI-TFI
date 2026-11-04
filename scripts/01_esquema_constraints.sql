-- 1. Crear DB si no existe

CREATE DATABASE IF NOT EXISTS TFI;

USE TFI;

-- 2. Crear tabla CATEGORIA

CREATE TABLE IF NOT EXISTS CATEGORIA (
  id_categoria INT AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(100) NOT NULL UNIQUE,
  descripcion TEXT
);


-- 3. Crear tabla PRODUCTOS

CREATE TABLE IF NOT EXISTS PRODUCTOS (
  id_producto INT AUTO_INCREMENT PRIMARY KEY,
  categoria_id INT NOT NULL,
  nombre VARCHAR(150) NOT NULL,
  precio DECIMAL(12,2) NOT NULL CHECK (precio > 0),
  descripcion TEXT,
  stock INT NOT NULL,
  disponible BOOLEAN NOT NULL,
  CONSTRAINT fk_categoria FOREIGN KEY (categoria_id)
    REFERENCES CATEGORIA(id_categoria)
);


-- 4. Crear tabla USUARIO

CREATE TABLE IF NOT EXISTS USUARIO (
  id_usuario INT AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(100) NOT NULL,
  apellido VARCHAR(100) NOT NULL,
  email VARCHAR(255) NOT NULL UNIQUE,
  celular VARCHAR(30),
  contraseña VARCHAR(255) NOT NULL,
  rol VARCHAR(50) NOT NULL CHECK (rol IN ('CLIENTE', 'ADMINISTRADOR'))
);

-- 5. Crear tabla PEDIDO

CREATE TABLE IF NOT EXISTS PEDIDO (
  id_pedido INT AUTO_INCREMENT PRIMARY KEY,
  usuario_id INT,
  fecha DATETIME NOT NULL,
  estado VARCHAR(50) NOT NULL,
  total DECIMAL(12,2) NOT NULL CHECK (total > 0),
  forma_de_pago VARCHAR(50) NOT NULL,
  CONSTRAINT fk_usuario FOREIGN KEY (usuario_id)
    REFERENCES USUARIO(id_usuario)
);


-- 6. Crear tabla DETALLE_PEDIDO

CREATE TABLE IF NOT EXISTS DETALLE_PEDIDO (
  id_detalle INT AUTO_INCREMENT PRIMARY KEY,
  pedido_id INT NOT NULL,
  producto_id INT NOT NULL,
  cantidad INT NOT NULL CHECK (cantidad > 0),
  subtotal DECIMAL(12,2) NOT NULL CHECK (subtotal > 0),
  CONSTRAINT fk_pedido FOREIGN KEY (pedido_id)
    REFERENCES PEDIDO(id_pedido),
  CONSTRAINT fk_producto FOREIGN KEY (producto_id)
    REFERENCES PRODUCTOS(id_producto)
);
