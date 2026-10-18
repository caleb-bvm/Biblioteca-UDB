-- Ejecutar una vez sobre una base nueva. No elimina información existente.
SET NAMES utf8mb4;
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

-- Más datos ficticios para probar los listados y las búsquedas.

INSERT INTO libros (titulo, autor, isbn, id_categoria, cantidad_disponible) VALUES
('Programación en Java', 'Laura Méndez', 'DEMO-JAVA-001', 1, 5),
('Introducción a bases de datos', 'Andrés López', 'DEMO-BD-002', 1, 4),
('Algoritmos paso a paso', 'Sofía Ramírez', 'DEMO-ALG-003', 1, 2),
('Diseño de aplicaciones web', 'Diego Hernández', 'DEMO-WEB-004', 1, 3),
('Cuentos de nuestra región', 'María José Pérez', 'DEMO-LIT-005', 2, 6),
('Poesía para días de lluvia', 'Óscar Martínez', 'DEMO-LIT-006', 2, 1),
('Física en la vida cotidiana', 'Lucía Vásquez', 'DEMO-CIE-007', 3, 4),
('Matemática para informática', 'Raúl Núñez', 'DEMO-CIE-008', 3, 2),
('Historia de Centroamérica', 'Ángela Rodríguez', 'DEMO-HIS-009', 4, 3)
ON DUPLICATE KEY UPDATE id_libro = id_libro;

INSERT INTO estudiantes (carnet, nombre_estudiante, carrera, telefono) VALUES
('LM2026003', 'Lucía Méndez', 'Ingeniería en Computación', '2200-1003'),
('DH2026004', 'Diego Hernández', 'Técnico en Computación', '2200-1004'),
('SR2026005', 'Sofía Ramírez', 'Ingeniería Electrónica', '2200-1005'),
('AN2026006', 'Andrés Núñez', 'Ingeniería Mecánica', NULL),
('MP2026007', 'María José Pérez', 'Diseño Gráfico', '2200-1007'),
('OM2026008', 'Óscar Martínez', 'Ingeniería Industrial', '2200-1008'),
('VR2026009', 'Valeria Rodríguez', 'Técnico en Telecomunicaciones', NULL),
('JC2026010', 'José Cáceres', 'Ingeniería en Computación', '2200-1010'),
('AG2026011', 'Ángela García', 'Licenciatura en Idiomas', '2200-1011'),
('RV2026012', 'Raúl Vásquez', 'Ingeniería Eléctrica', '2200-1012')
ON DUPLICATE KEY UPDATE id_estudiante = id_estudiante;
