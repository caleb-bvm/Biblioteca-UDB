package controller;

import dao.EstudianteDAO;
import models.EstudianteBean;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.SQLException;

@WebServlet("/estudiantes")
public class EstudianteController extends HttpServlet {
    private final EstudianteDAO estudianteDAO = new EstudianteDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setAttribute("seccion", "estudiantes");
        String vista = "nuevo".equals(request.getParameter("accion")) ? "registroEstudiante" : "listaEstudiantes";
        if (vista.equals("listaEstudiantes")) {
            try { request.setAttribute("estudiantes", estudianteDAO.listar()); }
            catch (SQLException e) {
                log("Error al consultar estudiantes", e);
                request.setAttribute("error", "No pudimos cargar los estudiantes. Revisa la conexión a MySQL e intenta de nuevo.");
                response.setStatus(503);
            }
        }
        request.getRequestDispatcher("/WEB-INF/views/" + vista + ".jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        try {
            EstudianteBean estudiante = new EstudianteBean();
            estudiante.setCarnet(Formulario.texto(request, "carnet"));
            estudiante.setNombreEstudiante(Formulario.texto(request, "nombreEstudiante"));
            estudiante.setCarrera(Formulario.texto(request, "carrera"));
            estudiante.setTelefono(Formulario.texto(request, "telefono"));
            Formulario.requerido(estudiante.getCarnet(), 10, "El carné");
            Formulario.requerido(estudiante.getNombreEstudiante(), 100, "El nombre");
            Formulario.requerido(estudiante.getCarrera(), 80, "La carrera");
            if (!estudiante.getTelefono().isEmpty() && !estudiante.getTelefono().matches("[0-9]{4}-?[0-9]{4}")) {
                throw new IllegalArgumentException("Escribe un teléfono de 8 dígitos, con guion opcional: 2222-3333.");
            }
            estudianteDAO.registrar(estudiante);
            request.getSession().setAttribute("mensaje", "El estudiante se registró correctamente.");
            request.getSession().setAttribute("detalle", estudiante.getNombreEstudiante() + " · " + estudiante.getCarnet());
            request.getSession().setAttribute("destino", "estudiantes");
            response.sendRedirect(request.getContextPath() + "/confirmacion");
            return;
        } catch (IllegalArgumentException e) {
            request.setAttribute("error", e.getMessage());
            response.setStatus(400);
        } catch (SQLException e) {
            log("Error al registrar estudiante", e);
            request.setAttribute("error", e.getErrorCode() == 1062 ? "Ya existe un estudiante con ese carné. Revisa el listado." : "No se pudo guardar el estudiante. Intenta de nuevo.");
            response.setStatus(e.getErrorCode() == 1062 ? 409 : 503);
        }
        request.setAttribute("seccion", "estudiantes");
        request.getRequestDispatcher("/WEB-INF/views/registroEstudiante.jsp").forward(request, response);
    }
}
