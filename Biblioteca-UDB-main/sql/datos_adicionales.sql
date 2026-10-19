-- Datos ficticios para practicar. Puede ejecutarse varias veces sin duplicar registros.
SET NAMES utf8mb4;
USE bibliotecaudb;

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
