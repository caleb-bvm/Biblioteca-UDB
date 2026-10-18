# Acuerdo para integrar préstamos

## Responsabilidad del segundo integrante

Crear `models.PrestamoBean`, `dao.PrestamoDAO`, `controller.PrestamoController` y una clase de servicio para las reglas del préstamo. Las JSP ya están preparadas.

Al agregar `PrestamoController`, eliminar `PrestamoVistaController.java`: no pueden existir dos Servlets con la ruta `/prestamos`. No mantener `integracionPendiente=true` en el controlador definitivo.

## JavaBean esperado por las vistas

| Propiedad | Tipo recomendado |
|---|---|
| idPrestamo | int |
| estudiante | EstudianteBean |
| libro | LibroBean |
| fechaPrestamo | java.time.LocalDate |
| fechaDevolucion | java.time.LocalDate |
| estado | String |

Usar atributos privados, constructor sin argumentos y getters/setters. Las fechas se muestran como `AAAA-MM-DD`; se puede usar `java.sql.Date` al leer JDBC y convertir a `LocalDate`.

Estados acordados para la interfaz: `Activo`, `Devuelto` y, si se implementa, `Vencido`. Confirmar con el docente si exige actualizar automáticamente los vencidos. Un préstamo vencido también debe poder devolverse.

## Rutas y parámetros

| Petición | Uso |
|---|---|
| GET `/prestamos` | Listado |
| GET `/prestamos?accion=nuevo` | Formulario |
| POST `/prestamos`, accion=registrar | Nuevo préstamo |
| POST `/prestamos`, accion=devolver | Devolución |

Formulario de registro: `idEstudiante`, `idLibro`, `fechaPrestamo`, `fechaDevolucion`. Devolución: `idPrestamo`. Los identificadores deben ser enteros positivos; rechazar acciones desconocidas con un error claro.

## Datos que el controlador debe enviar

En ambas vistas: `seccion="prestamos"`.

Para `/WEB-INF/views/registroPrestamo.jsp`:

- `estudiantes`: resultado de `new EstudianteDAO().listar()`.
- `libros`: resultado de `new LibroDAO().listar()`.
- `hoy`: fecha actual (`LocalDate`) para el valor inicial.
- `error`: mensaje opcional de validación.

Para `/WEB-INF/views/listaPrestamos.jsp`:

- `prestamos`: `List<PrestamoBean>` con libro y estudiante completos.
- `error`: mensaje opcional cuando no se pudo consultar.

Los libros sin existencias aparecen deshabilitados en el selector. El servidor debe volver a comprobar existencias: el HTML no reemplaza esa validación.

Si hay errores en el POST, cargar nuevamente las listas y hacer `forward` al formulario con el mismo request. Así las JSP conservan `param.idLibro`, `param.idEstudiante` y las fechas.

## Confirmación compartida

Después de guardar correctamente:

```java
request.getSession().setAttribute("mensaje", "El préstamo se registró correctamente.");
request.getSession().setAttribute("detalle", "Título del libro · Nombre del estudiante");
request.getSession().setAttribute("destino", "prestamos");
response.sendRedirect(request.getContextPath() + "/confirmacion");
```

El valor de `destino` es una constante del controlador, nunca una URL recibida del usuario. Para devolver se usa el mismo mecanismo con el mensaje correspondiente.

## Reglas y transacciones

1. Validar estudiante y libro existentes, fechas completas y devolución no anterior al préstamo.
2. Abrir una conexión desde el servicio y desactivar `autoCommit`.
3. Invocar DAO con esa misma conexión para guardar préstamo y modificar existencias.
4. Confirmar con `commit` cuando ambas operaciones terminen; usar `rollback` si falla alguna.
5. Cerrar la conexión con `try-with-resources`.

`LibroDAO.actualizarCantidadDisponible(Connection cn, int id, int cambio)` ya está disponible:

- `cambio=-1` descuenta un ejemplar si queda disponibilidad.
- `cambio=1` repone un ejemplar.
- Retorna `false` si no se modificó el libro. El servicio debe cancelar la operación.
- El método no cierra la conexión recibida ni hace commit.

La consulta de disponibilidad es informativa. Para evitar prestar el último ejemplar dos veces, usar el resultado del UPDATE condicional dentro de la transacción.

Al devolver, el DAO debe cambiar el estado solo si todavía es `Activo` o `Vencido`. Reponer el ejemplar únicamente si esa actualización afectó una fila. Así, dos devoluciones simultáneas no incrementan dos veces las existencias.

Todo el SQL va en los DAO. Los Servlets reciben datos y coordinan llamadas; la lógica de préstamo y devolución va en el servicio.

## Prueba conjunta final

Registrar estudiante → registrar libro con cantidad 1 → prestar → comprobar cantidad 0 → rechazar otro préstamo → devolver → comprobar cantidad 1 → rechazar segunda devolución. Probar también un fallo intermedio para verificar rollback y dos préstamos simultáneos sobre el último ejemplar.
