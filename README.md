# Biblioteca UDB

Proyecto académico de Programación Orientada a Objetos. Permite registrar y consultar libros y estudiantes. Incluye todas las pantallas de préstamos para integrar el módulo del segundo integrante.

## Estado del trabajo

- Terminados: base de datos, conexión JDBC, categorías, libros y estudiantes.
- Terminadas: interfaz de inicio, formularios, listados, confirmación y error.
- Pendiente del segundo integrante: `PrestamoBean`, `PrestamoDAO`, `PrestamoController` y lógica de préstamos y devoluciones.
- `PrestamoVistaController` es un puente temporal de solo lectura. Muestra las pantallas y carga los selectores reales, pero no registra préstamos ni consulta el historial.

## Requisitos

- JDK 17 o superior (el proyecto compila para Java 17).
- Maven 3.9 o el Maven incluido en el IDE.
- Apache Tomcat 10.1. No usar Tomcat 9: este proyecto utiliza `jakarta.servlet`.
- MySQL 8.0 o superior.

## Ejecutar

1. Abre esta carpeta como proyecto Maven en NetBeans, IntelliJ IDEA o Eclipse.
2. Ejecuta `sql/bibliotecaudb.sql` en MySQL Workbench o desde el cliente MySQL. Se usa una base nueva: el script no borra tablas y debe ejecutarse una sola vez.
3. Copia `src/main/resources/db.properties.example` como `src/main/resources/db.properties` y ajusta usuario, contraseña y URL. El archivo con credenciales está excluido de Git.
4. Configura Tomcat 10.1 como servidor del proyecto.
5. Ejecuta `mvn clean package`. El archivo generado es `target/biblioteca.war`.
6. Despliega el WAR en Tomcat, o ejecuta el proyecto desde el IDE.
7. Abre `http://localhost:8080/biblioteca/` (ajusta el puerto según tu servidor).

También se pueden usar las variables de entorno `DB_URL`, `DB_USER` y `DB_PASSWORD`. Tienen prioridad sobre el archivo de propiedades. Reinicia Tomcat después de cambiarlas.

Bootstrap está incluido localmente; las pantallas no necesitan Internet para cargar su diseño.

## Organización

```text
sql/                         Tablas y datos de prueba
src/main/java/models/        JavaBeans
src/main/java/dao/           Conexión y consultas con PreparedStatement
src/main/java/controller/    Recepción y validación de formularios
src/main/resources/         Configuración de conexión
src/main/webapp/index.jsp    Inicio
src/main/webapp/WEB-INF/views/   Formularios y listados
src/main/webapp/WEB-INF/jspf/    Encabezado, mensajes y pie compartidos
src/main/webapp/assets/         CSS y JavaScript
docs/                       Acuerdo de integración y pruebas
```

En Maven, `src/main/webapp` corresponde a **Web Pages**. Las vistas están dentro de `WEB-INF` para que se abran a través del controlador y reciban sus datos. Las JSP usan JSTL y EL, sin scriptlets. `web.xml` también prohíbe scriptlets.

Flujo: formulario → Servlet → DAO → MySQL → Servlet → JSP. Después de guardar, el controlador redirige a una confirmación; recargar esa página no repite la inserción.

## Diseño

Estética inspirada en Material Design 3: superficies suaves, esquinas redondeadas, botones amplios y navegación visible. Se conserva Bootstrap 5, como pide la tarea.

- Rosa `#efcfe3`: navegación y portada.
- Rosa `#e27396`: ilustración y marca.
- Celeste `#b3dee2` y verde `#eaf2d7`: acentos y ayuda.
- Ciruela `#843c58`: botones y enlaces con texto legible.

Los formularios tienen etiquetas visibles, campos obligatorios identificados, errores con foco y conservación de valores. Las tablas incluyen búsqueda que ignora tildes y mayúsculas. El diseño se adapta a pantallas estrechas; las tablas amplias tienen desplazamiento horizontal.

Referencias: [Material Design 3](https://m3.material.io/styles/color/roles), [Bootstrap 5](https://getbootstrap.com/docs/5.3/getting-started/introduction/) y [Tomcat 10.1](https://tomcat.apache.org/tomcat-10.1-doc/index.html).

## Integración y pruebas

Leer `docs/INTEGRACION_PRESTAMOS.md` antes de comenzar el módulo de préstamos. El resultado de las comprobaciones y los pasos para repetirlas están en `docs/PRUEBAS.md`.

Es un prototipo académico para ejecución local. No incluye autenticación ni roles porque no forman parte del alcance solicitado.
