# Verificación de nuestra parte

Realizada el 17 de octubre de 2026.

## Entorno utilizado

- JDK 27 compilando con `release=17`.
- Maven 3.9.9 y Tomcat 10.1.61.
- Instancia aislada de MariaDB de XAMPP, puerto 13306, con datos dentro de `.tools/db-data`.
- Driver MySQL Connector/J 8.4.0.
- Aplicación de prueba: `http://localhost:18080/biblioteca/`.

La compilación y las pruebas sobre MariaDB pasaron. Falta confirmar el despliegue con MySQL 8 en el entorno final. No se utilizó ni modificó la base habitual de XAMPP.

## Comprobaciones realizadas

- Generación del WAR con Maven.
- Respuesta y compilación de todas las rutas de inicio, libros, estudiantes y vistas temporales de préstamos.
- Registro correcto de un estudiante y un libro, seguido de redirección y confirmación.
- Rechazo de carné e ISBN duplicados, conservando el formulario.
- Rechazo de teléfono incorrecto y nombre vacío.
- Rechazo de cantidades negativas, decimales, texto y números que exceden `int`.
- Rechazo de categoría inexistente.
- Registro de libros con cero existencias y con ISBN opcional, incluyendo varios ISBN vacíos.
- Escape de texto con etiquetas HTML en la confirmación y el listado.
- El controlador temporal de préstamos rechaza POST; no simula operaciones exitosas.
- Listados muestran los registros y distinguen los libros sin existencias.
- Búsqueda en navegador sin tildes y estado sin coincidencias.
- Consulta de libro por ID, disponibilidad, descuento condicional sin cantidades negativas, reposición y rollback con JDBC.

La comprobación HTTP automatizada está en `scripts/verificar_http.py`. **Usarla solamente con una base de prueba**, porque agrega estudiantes y libros. Con el servidor iniciado:

```powershell
$env:APP_TEST_URL = 'http://localhost:18080/biblioteca'
python scripts/verificar_http.py
```

La prueba JDBC está en `scripts/VerificarDAO.java`. Después de compilar y con la base de prueba disponible:

```powershell
$env:DB_URL = 'jdbc:mysql://127.0.0.1:13306/bibliotecaudb'
java --class-path 'target/classes;target/biblioteca/WEB-INF/lib/*' scripts/VerificarDAO.java
```

Esta última prueba usa los libros 1 y 3 del script inicial y revierte sus cambios con rollback.

## Pendiente al integrar el segundo módulo

- Registrar y devolver préstamos reales.
- Probar rollback y disponibilidad con operaciones concurrentes.
- Mostrar préstamos con sus objetos libro/estudiante y verificar botones de devolución.
- Confirmar manejo de vencimientos con el docente.
- Repetir la prueba completa sobre MySQL y preparar la exposición entre ambos.
