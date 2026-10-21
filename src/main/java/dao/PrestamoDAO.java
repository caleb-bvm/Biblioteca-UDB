package dao;

import models.EstudianteBean;
import models.CategoriaBean;
import models.LibroBean;
import models.PrestamoBean;

import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

public class PrestamoDAO {
    private static final String CONSULTA_LISTADO = """
            SELECT p.id_prestamo, p.fecha_prestamo, p.fecha_devolucion,
                   CASE
                       WHEN p.estado = 'Activo' AND p.fecha_devolucion < CURRENT_DATE THEN 'Vencido'
                       ELSE p.estado
                   END AS estado,
                   e.id_estudiante, e.carnet, e.nombre_estudiante, e.carrera, e.telefono,
                   l.id_libro, l.titulo, l.autor, l.isbn, l.cantidad_disponible,
                   c.id_categoria, c.nombre_categoria
            FROM prestamos p
            JOIN estudiantes e ON p.id_estudiante = e.id_estudiante
            JOIN libros l ON p.id_libro = l.id_libro
            JOIN categorias c ON l.id_categoria = c.id_categoria
            ORDER BY p.fecha_prestamo DESC, p.id_prestamo DESC
            """;

    public List<PrestamoBean> listar() throws SQLException {
        List<PrestamoBean> prestamos = new ArrayList<>();

        try (Connection conexion = Conexion.obtener();
             PreparedStatement consulta = conexion.prepareStatement(CONSULTA_LISTADO);
             ResultSet resultado = consulta.executeQuery()) {
            while (resultado.next()) {
                prestamos.add(leer(resultado));
            }
        }

        return prestamos;
    }

    public void registrar(PrestamoBean prestamo) throws SQLException {
        String sql = """
                INSERT INTO prestamos
                    (id_estudiante, id_libro, fecha_prestamo, fecha_devolucion, estado)
                VALUES (?, ?, ?, ?, 'Activo')
                """;

        try (Connection conexion = Conexion.obtener()) {
            conexion.setAutoCommit(false);
            try {
                LibroDAO libroDAO = new LibroDAO();
                boolean disponible = libroDAO.actualizarCantidadDisponible(
                        conexion, prestamo.getLibro().getIdLibro(), -1);

                if (!disponible) {
                    throw new SQLException("El libro seleccionado no tiene ejemplares disponibles.");
                }

                try (PreparedStatement consulta = conexion.prepareStatement(
                        sql, Statement.RETURN_GENERATED_KEYS)) {
                    consulta.setInt(1, prestamo.getEstudiante().getIdEstudiante());
                    consulta.setInt(2, prestamo.getLibro().getIdLibro());
                    consulta.setDate(3, Date.valueOf(prestamo.getFechaPrestamo()));
                    consulta.setDate(4, Date.valueOf(prestamo.getFechaDevolucion()));
                    consulta.executeUpdate();

                    try (ResultSet claves = consulta.getGeneratedKeys()) {
                        if (claves.next()) {
                            prestamo.setIdPrestamo(claves.getInt(1));
                        }
                    }
                }

                conexion.commit();
            } catch (SQLException e) {
                conexion.rollback();
                throw e;
            } finally {
                conexion.setAutoCommit(true);
            }
        }
    }

    public boolean devolver(int idPrestamo) throws SQLException {
        String actualizarPrestamo = """
                UPDATE prestamos
                SET estado = 'Devuelto'
                WHERE id_prestamo = ? AND estado = 'Activo'
                """;
        String obtenerLibro = "SELECT id_libro FROM prestamos WHERE id_prestamo = ?";

        try (Connection conexion = Conexion.obtener()) {
            conexion.setAutoCommit(false);
            try {
                int idLibro;
                try (PreparedStatement consulta = conexion.prepareStatement(obtenerLibro)) {
                    consulta.setInt(1, idPrestamo);
                    try (ResultSet resultado = consulta.executeQuery()) {
                        if (!resultado.next()) {
                            conexion.rollback();
                            return false;
                        }
                        idLibro = resultado.getInt("id_libro");
                    }
                }

                int actualizados;
                try (PreparedStatement consulta = conexion.prepareStatement(actualizarPrestamo)) {
                    consulta.setInt(1, idPrestamo);
                    actualizados = consulta.executeUpdate();
                }

                if (actualizados != 1) {
                    conexion.rollback();
                    return false;
                }

                if (!new LibroDAO().actualizarCantidadDisponible(conexion, idLibro, 1)) {
                    conexion.rollback();
                    return false;
                }

                conexion.commit();
                return true;
            } catch (SQLException e) {
                conexion.rollback();
                throw e;
            } finally {
                conexion.setAutoCommit(true);
            }
        }
    }

    private PrestamoBean leer(ResultSet resultado) throws SQLException {
        EstudianteBean estudiante = new EstudianteBean();
        estudiante.setIdEstudiante(resultado.getInt("id_estudiante"));
        estudiante.setCarnet(resultado.getString("carnet"));
        estudiante.setNombreEstudiante(resultado.getString("nombre_estudiante"));
        estudiante.setCarrera(resultado.getString("carrera"));
        estudiante.setTelefono(resultado.getString("telefono"));

        CategoriaBean categoria = new CategoriaBean();
        categoria.setIdCategoria(resultado.getInt("id_categoria"));
        categoria.setNombreCategoria(resultado.getString("nombre_categoria"));

        LibroBean libro = new LibroBean();
        libro.setIdLibro(resultado.getInt("id_libro"));
        libro.setTitulo(resultado.getString("titulo"));
        libro.setAutor(resultado.getString("autor"));
        libro.setIsbn(resultado.getString("isbn"));
        libro.setCantidadDisponible(resultado.getInt("cantidad_disponible"));
        libro.setCategoria(categoria);

        PrestamoBean prestamo = new PrestamoBean();
        prestamo.setIdPrestamo(resultado.getInt("id_prestamo"));
        prestamo.setEstudiante(estudiante);
        prestamo.setLibro(libro);
        prestamo.setFechaPrestamo(resultado.getDate("fecha_prestamo").toLocalDate());
        prestamo.setFechaDevolucion(resultado.getDate("fecha_devolucion").toLocalDate());
        prestamo.setEstado(resultado.getString("estado"));
        return prestamo;
    }
}
