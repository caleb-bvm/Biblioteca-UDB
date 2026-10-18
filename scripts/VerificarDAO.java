import dao.*;
import java.sql.*;

public class VerificarDAO {
    public static void main(String[] args) throws Exception {
        LibroDAO dao = new LibroDAO();
        if (dao.obtenerPorId(1) == null || !dao.validarDisponibilidad(1)) throw new AssertionError("Libro disponible");
        if (dao.validarDisponibilidad(3) || dao.obtenerPorId(99999) != null) throw new AssertionError("Sin disponibilidad");
        int cantidad = dao.obtenerPorId(1).getCantidadDisponible();
        try (Connection cn = Conexion.obtener()) {
            cn.setAutoCommit(false);
            if (!dao.actualizarCantidadDisponible(cn, 1, -cantidad)) throw new AssertionError("Descontar");
            if (dao.actualizarCantidadDisponible(cn, 1, -1)) throw new AssertionError("No debe quedar negativo");
            if (!dao.actualizarCantidadDisponible(cn, 1, 1)) throw new AssertionError("Reponer");
            cn.rollback();
        }
        if (dao.obtenerPorId(1).getCantidadDisponible() != cantidad) throw new AssertionError("Rollback");
        System.out.println("PASS: consulta por ID, disponibilidad, actualización condicional y rollback");
    }
}
