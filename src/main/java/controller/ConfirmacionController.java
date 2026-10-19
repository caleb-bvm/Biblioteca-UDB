package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet("/confirmacion")
public class ConfirmacionController extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        if (session.getAttribute("mensaje") == null) {
            response.sendRedirect(request.getContextPath() + "/");
            return;
        }
        // El mensaje se consume una sola vez; recargar no repite el registro.
        for (String atributo : new String[]{"mensaje", "detalle", "destino"}) {
            request.setAttribute(atributo, session.getAttribute(atributo));
            session.removeAttribute(atributo);
        }
        request.getRequestDispatcher("/WEB-INF/views/confirmacion.jsp").forward(request, response);
    }
}
