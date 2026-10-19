package controller;

import dao.EstudianteDAO;
<<<<<<< HEAD
import com.mycompany.poo.jsp.biblioteca.dao.LibroDAO;
=======
import dao.LibroDAO;
>>>>>>> d1259d620c13065e653c83f6010ffc046a27af41
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.SQLException;
import java.time.LocalDate;

// Puente temporal para revisar las vistas. Sustituir por PrestamoController al integrar.
@WebServlet("/prestamos")
public class PrestamoVistaController extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setAttribute("seccion", "prestamos");
        request.setAttribute("integracionPendiente", true);
        request.setAttribute("hoy", LocalDate.now());
        boolean nuevo = "nuevo".equals(request.getParameter("accion"));
        if (nuevo) {
            try {
                request.setAttribute("estudiantes", new EstudianteDAO().listar());
                request.setAttribute("libros", new LibroDAO().listar());
            } catch (SQLException e) {
                log("Error al cargar formulario de préstamos", e);
                request.setAttribute("error", "No pudimos cargar los libros y estudiantes. Revisa la conexión a MySQL.");
                response.setStatus(503);
            }
        }
        request.getRequestDispatcher("/WEB-INF/views/" + (nuevo ? "registroPrestamo" : "listaPrestamos") + ".jsp").forward(request, response);
    }
}
