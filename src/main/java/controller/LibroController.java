package controller;

import dao.CategoriaDAO;
import dao.LibroDAO;
import models.CategoriaBean;
import models.LibroBean;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

@WebServlet("/libros")
public class LibroController extends HttpServlet {
    private final LibroDAO libroDAO = new LibroDAO();
    private final CategoriaDAO categoriaDAO = new CategoriaDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setAttribute("seccion", "libros");
        String vista = "nuevo".equals(request.getParameter("accion")) ? "registroLibro" : "listaLibros";
        try {
            if (vista.equals("registroLibro")) request.setAttribute("categorias", categoriaDAO.listar());
            else request.setAttribute("libros", libroDAO.listar());
        } catch (SQLException e) {
            log("Error al consultar libros", e);
            request.setAttribute("error", "No pudimos cargar los datos. Revisa la conexión a MySQL e intenta de nuevo.");
            response.setStatus(503);
        }
        request.getRequestDispatcher("/WEB-INF/views/" + vista + ".jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        try {
            LibroBean libro = new LibroBean();
            libro.setTitulo(Formulario.texto(request, "titulo"));
            libro.setAutor(Formulario.texto(request, "autor"));
            libro.setIsbn(Formulario.texto(request, "isbn"));
            Formulario.requerido(libro.getTitulo(), 150, "El título");
            Formulario.requerido(libro.getAutor(), 100, "El autor");
            if (libro.getIsbn().length() > 20) throw new IllegalArgumentException("El ISBN admite hasta 20 caracteres.");
            libro.setCantidadDisponible(Formulario.entero(Formulario.texto(request, "cantidadDisponible"), 0, "La cantidad"));
            int idCategoria = Formulario.entero(Formulario.texto(request, "idCategoria"), 1, "La categoría");
            List<CategoriaBean> categorias = categoriaDAO.listar();
            CategoriaBean seleccionada = null;
            for (CategoriaBean categoria : categorias) {
                if (categoria.getIdCategoria() == idCategoria) seleccionada = categoria;
            }
            if (seleccionada == null) throw new IllegalArgumentException("Selecciona una categoría válida.");
            libro.setCategoria(seleccionada);
            libroDAO.registrar(libro);
            request.getSession().setAttribute("mensaje", "El libro se registró correctamente.");
            request.getSession().setAttribute("detalle", libro.getTitulo() + " · " + libro.getAutor());
            request.getSession().setAttribute("destino", "libros");
            response.sendRedirect(request.getContextPath() + "/confirmacion");
            return;
        } catch (IllegalArgumentException e) {
            request.setAttribute("error", e.getMessage());
            response.setStatus(400);
        } catch (SQLException e) {
            log("Error al registrar libro", e);
            request.setAttribute("error", e.getErrorCode() == 1062 ? "Ya existe un libro con ese ISBN. Revisa el catálogo." : "No se pudo guardar el libro. Intenta de nuevo.");
            response.setStatus(e.getErrorCode() == 1062 ? 409 : 503);
        }
        request.setAttribute("seccion", "libros");
        try { request.setAttribute("categorias", categoriaDAO.listar()); }
        catch (SQLException e) { log("Error al cargar categorías", e); }
        request.getRequestDispatcher("/WEB-INF/views/registroLibro.jsp").forward(request, response);
    }
}
