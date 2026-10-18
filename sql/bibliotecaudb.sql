-- Ejecutar una vez sobre una base nueva. No elimina información existente.
CREATE DATABASE IF NOT EXISTS bibliotecaudb CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE bibliotecaudb;

CREATE TABLE categorias (
    id_categoria INT AUTO_INCREMENT PRIMARY KEY,
    nombre_categoria VARCHAR(80) NOT NULL
) ENGINE=InnoDB;

CREATE TABLE libros (
    id_libro INT AUTO_INCREMENT PRIMARY KEY,
    titulo VARCHAR(150) NOT NULL,
    autor VARCHAR(100) NOT NULL,
    isbn VARCHAR(20) UNIQUE,
    id_categoria INT NOT NULL,
    cantidad_disponible INT NOT NULL DEFAULT 1,
    FOREIGN KEY (id_categoria) REFERENCES categorias(id_categoria),
    CHECK (cantidad_disponible >= 0)
) ENGINE=InnoDB;

CREATE TABLE estudiantes (
    id_estudiante INT AUTO_INCREMENT PRIMARY KEY,
    carnet VARCHAR(10) UNIQUE NOT NULL,
    nombre_estudiante VARCHAR(100) NOT NULL,
    carrera VARCHAR(80) NOT NULL,
    telefono VARCHAR(9)
) ENGINE=InnoDB;

CREATE TABLE prestamos (
    id_prestamo INT AUTO_INCREMENT PRIMARY KEY,
    id_estudiante INT NOT NULL,
    id_libro INT NOT NULL,
    fecha_prestamo DATE NOT NULL,
    fecha_devolucion DATE NOT NULL,
    estado VARCHAR(20) NOT NULL DEFAULT 'Activo',
    FOREIGN KEY (id_estudiante) REFERENCES estudiantes(id_estudiante),
    FOREIGN KEY (id_libro) REFERENCES libros(id_libro),
    CHECK (fecha_devolucion >= fecha_prestamo)
) ENGINE=InnoDB;

INSERT INTO categorias (nombre_categoria) VALUES ('Programación'), ('Literatura'), ('Ciencias'), ('Historia');
INSERT INTO libros (titulo, autor, isbn, id_categoria, cantidad_disponible) VALUES
('Fundamentos de programación', 'Luis Joyanes Aguilar', '9788448156459', 1, 3),
('El principito', 'Antoine de Saint-Exupéry', '9788478887194', 2, 2),
('Breve historia del tiempo', 'Stephen Hawking', '9788498926696', 3, 0);
INSERT INTO estudiantes (carnet, nombre_estudiante, carrera, telefono) VALUES
('AB2026001', 'Ana Beltrán', 'Ingeniería en Computación', '2222-3333'),
('CR2026002', 'Carlos Rivera', 'Técnico en Computación', NULL);
-- La cantidad del tercer libro ya refleja este préstamo activo.
INSERT INTO prestamos (id_estudiante, id_libro, fecha_prestamo, fecha_devolucion) VALUES
(1, 3, CURRENT_DATE, DATE_ADD(CURRENT_DATE, INTERVAL 7 DAY));
