# Biblioteca UDB

Proyecto académico de Programación Orientada a Objetos. Permite registrar y consultar libros y estudiantes. Incluye todas las pantallas de préstamos para integrar el módulo del segundo integrante.

## Estado del trabajo

- Terminados: base de datos, conexión JDBC, categorías, libros, estudiantes y préstamos.
- Terminadas: interfaz de inicio, formularios, listados, confirmación, devolución y error.
- El módulo de préstamos registra préstamos, descuenta existencias, lista préstamos y registra devoluciones.
- La duración de cada préstamo está limitada a 14 días (dos semanas), validada en el formulario, el servidor y la base de datos.

## Requisitos

- JDK 17 o superior (el proyecto compila para Java 17).
- Maven 3.9 o el Maven incluido en el IDE.
- Apache Tomcat 10.1. No usar Tomcat 9: este proyecto utiliza `jakarta.servlet`.
- MySQL 8.0 o superior.

## Ejecutar

1. Abre esta carpeta como proyecto Maven en NetBeans, IntelliJ IDEA o Eclipse.
2. Ejecuta `sql/bibliotecaudb.sql` en MySQL Workbench o desde el cliente MySQL. Se usa una base nueva: el script no borra tablas y debe ejecutarse una sola vez.
   Si ya tienes la base creada, ejecuta únicamente `sql/datos_adicionales.sql` para agregar las 12 categorías nuevas y los ejemplos sin duplicarlos ni modificar tus registros. El script inicial incluye estas categorías y los mismos datos. Los ejemplos adicionales son ficticios.
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
```

En Maven, `src/main/webapp` corresponde a **Web Pages**. Las vistas están dentro de `WEB-INF` para que se abran a través del controlador y reciban sus datos. Las JSP usan JSTL y EL, sin scriptlets. `web.xml` también prohíbe scriptlets.

Flujo: formulario → Servlet → DAO → MySQL → Servlet → JSP. Después de guardar, el controlador redirige a una confirmación; recargar esa página no repite la inserción.

## Diseño

Estética inspirada en Material Design 3: superficies suaves, esquinas redondeadas, botones amplios y navegación visible. Se conserva Bootstrap 5, como pide la tarea.

- Azul `#2155a3`: botones, enlaces y acentos.
- Azul claro `#dce8ff`: portada y navegación seleccionada.
- Amarillo `#f4c542`: marca e ilustración.
- Amarillo suave `#fff2bf`: tarjetas y paneles de ayuda.

Las páginas comienzan en la parte superior del área de contenido. Los fragmentos JSP compartidos declaran UTF-8 para conservar tildes y eñes.

Los formularios tienen etiquetas visibles, campos obligatorios identificados, errores con foco y conservación de valores. Las tablas incluyen búsqueda que ignora tildes y mayúsculas. El diseño se adapta a pantallas estrechas; las tablas amplias tienen desplazamiento horizontal.

Referencias: [Material Design 3](https://m3.material.io/styles/color/roles), [Bootstrap 5](https://getbootstrap.com/docs/5.3/getting-started/introduction/) y [Tomcat 10.1](https://tomcat.apache.org/tomcat-10.1-doc/index.html).

## Integración y pruebas

Es un prototipo académico para ejecución local. No incluye autenticación ni roles porque no forman parte del alcance solicitado.
