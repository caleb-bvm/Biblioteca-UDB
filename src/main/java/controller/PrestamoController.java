package controller;

import dao.EstudianteDAO;
import dao.LibroDAO;
import dao.PrestamoDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import models.EstudianteBean;
import models.LibroBean;
import models.PrestamoBean;

import java.io.IOException;
import java.sql.SQLException;
import java.time.LocalDate;
import java.time.format.DateTimeParseException;

@WebServlet("/prestamos")
public class PrestamoController extends HttpServlet {
    private static final long MAX_DIAS_PRESTAMO = 14;

    private final PrestamoDAO prestamoDAO = new PrestamoDAO();
    private final EstudianteDAO estudianteDAO = new EstudianteDAO();
    private final LibroDAO libroDAO = new LibroDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setAttribute("seccion", "prestamos");

        if ("nuevo".equals(request.getParameter("accion"))) {
            cargarFormulario(request, response);
            return;
        }

        try {
            request.setAttribute("prestamos", prestamoDAO.listar());
            request.getRequestDispatcher("/WEB-INF/views/listaPrestamos.jsp")
                    .forward(request, response);
        } catch (SQLException e) {
            log("Error al consultar préstamos", e);
            mostrarError(request, response,
                    "No pudimos cargar los préstamos. Revisa la conexión a MySQL.");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        String accion = request.getParameter("accion");

        if ("devolver".equals(accion)) {
            devolver(request, response);
            return;
        }

        registrar(request, response);
    }

    private void registrar(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            int idEstudiante = Formulario.entero(
                    Formulario.texto(request, "idEstudiante"), 1, "El estudiante");
            int idLibro = Formulario.entero(
                    Formulario.texto(request, "idLibro"), 1, "El libro");
            LocalDate fechaPrestamo = fecha(request, "fechaPrestamo", "La fecha del préstamo");
            LocalDate fechaDevolucion = fecha(request, "fechaDevolucion", "La fecha de devolución");

            if (fechaDevolucion.isBefore(fechaPrestamo)) {
                throw new IllegalArgumentException(
                        "La fecha de devolución no puede ser anterior a la fecha del préstamo.");
            }
            if (fechaDevolucion.isAfter(fechaPrestamo.plusDays(MAX_DIAS_PRESTAMO))) {
                throw new IllegalArgumentException(
                        "Un libro no se puede prestar por más de 2 semanas (14 días).");
            }

            EstudianteBean estudiante = new EstudianteBean();
            estudiante.setIdEstudiante(idEstudiante);
            LibroBean libro = new LibroBean();
            libro.setIdLibro(idLibro);

            PrestamoBean prestamo = new PrestamoBean();
            prestamo.setEstudiante(estudiante);
            prestamo.setLibro(libro);
            prestamo.setFechaPrestamo(fechaPrestamo);
            prestamo.setFechaDevolucion(fechaDevolucion);
            prestamoDAO.registrar(prestamo);

            request.getSession().setAttribute("mensaje", "El préstamo se registró correctamente.");
            request.getSession().setAttribute("detalle",
                    "La fecha de devolución es " + fechaDevolucion + ".");
            request.getSession().setAttribute("destino", "prestamos");
            response.sendRedirect(request.getContextPath() + "/confirmacion");
        } catch (IllegalArgumentException e) {
            mostrarErrorFormulario(request, response, e.getMessage());
        } catch (SQLException e) {
            log("Error al registrar préstamo", e);
            mostrarErrorFormulario(request, response,
                    "No se pudo registrar el préstamo. Verifica que el libro tenga disponibilidad.");
        }
    }

    private void devolver(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            int idPrestamo = Formulario.entero(
                    Formulario.texto(request, "idPrestamo"), 1, "El préstamo");

            if (!prestamoDAO.devolver(idPrestamo)) {
                throw new IllegalArgumentException(
                        "El préstamo no existe o ya fue devuelto.");
            }

            request.getSession().setAttribute("mensaje", "La devolución se registró correctamente.");
            request.getSession().setAttribute("detalle", "El libro volvió a estar disponible.");
            request.getSession().setAttribute("destino", "prestamos");
            response.sendRedirect(request.getContextPath() + "/confirmacion");
        } catch (IllegalArgumentException e) {
            request.setAttribute("error", e.getMessage());
            listarPrestamos(request, response, 400);
        } catch (SQLException e) {
            log("Error al registrar devolución", e);
            request.setAttribute("error", "No se pudo registrar la devolución. Intenta de nuevo.");
            listarPrestamos(request, response, 503);
        }
    }

    private void cargarFormulario(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setAttribute("hoy", LocalDate.now());
        try {
            request.setAttribute("estudiantes", estudianteDAO.listar());
            request.setAttribute("libros", libroDAO.listar());
            request.getRequestDispatcher("/WEB-INF/views/registroPrestamo.jsp")
                    .forward(request, response);
        } catch (SQLException e) {
            log("Error al cargar formulario de préstamos", e);
            mostrarError(request, response,
                    "No pudimos cargar los libros y estudiantes. Revisa la conexión a MySQL.");
        }
    }

    private LocalDate fecha(HttpServletRequest request, String nombre, String etiqueta) {
        String valor = Formulario.texto(request, nombre);
        try {
            return LocalDate.parse(valor);
        } catch (DateTimeParseException e) {
            throw new IllegalArgumentException(etiqueta + " es obligatoria y debe ser válida.");
        }
    }

    private void mostrarErrorFormulario(HttpServletRequest request, HttpServletResponse response,
                                        String mensaje) throws ServletException, IOException {
        request.setAttribute("error", mensaje);
        response.setStatus(400);
        request.setAttribute("hoy", LocalDate.now());
        try {
            request.setAttribute("estudiantes", estudianteDAO.listar());
            request.setAttribute("libros", libroDAO.listar());
        } catch (SQLException e) {
            log("Error al recargar formulario de préstamos", e);
        }
        request.getRequestDispatcher("/WEB-INF/views/registroPrestamo.jsp")
                .forward(request, response);
    }

    private void listarPrestamos(HttpServletRequest request, HttpServletResponse response,
                                 int estado) throws ServletException, IOException {
        response.setStatus(estado);
        try {
            request.setAttribute("prestamos", prestamoDAO.listar());
        } catch (SQLException e) {
            log("Error al recargar préstamos", e);
        }
        request.getRequestDispatcher("/WEB-INF/views/listaPrestamos.jsp")
                .forward(request, response);
    }

    private void mostrarError(HttpServletRequest request, HttpServletResponse response,
                              String mensaje) throws ServletException, IOException {
        request.setAttribute("error", mensaje);
        response.setStatus(503);
        request.getRequestDispatcher("/WEB-INF/views/error.jsp").forward(request, response);
    }
}
