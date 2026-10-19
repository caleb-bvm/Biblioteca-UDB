package dao;

import com.mycompany.poo.jsp.biblioteca.util.Conexion;
import models.EstudianteBean;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class EstudianteDAO {
    public List<EstudianteBean> listar() throws SQLException {
        List<EstudianteBean> estudiantes = new ArrayList<>();
        String sql = "SELECT * FROM estudiantes ORDER BY nombre_estudiante";
        try (Connection cn = Conexion.obtener(); PreparedStatement ps = cn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                EstudianteBean estudiante = new EstudianteBean();
                estudiante.setIdEstudiante(rs.getInt("id_estudiante"));
                estudiante.setCarnet(rs.getString("carnet"));
                estudiante.setNombreEstudiante(rs.getString("nombre_estudiante"));
                estudiante.setCarrera(rs.getString("carrera"));
                estudiante.setTelefono(rs.getString("telefono"));
                estudiantes.add(estudiante);
            }
        }
        return estudiantes;
    }

    public void registrar(EstudianteBean estudiante) throws SQLException {
        String sql = "INSERT INTO estudiantes (carnet, nombre_estudiante, carrera, telefono) VALUES (?, ?, ?, ?)";
        try (Connection cn = Conexion.obtener(); PreparedStatement ps = cn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setString(1, estudiante.getCarnet());
            ps.setString(2, estudiante.getNombreEstudiante());
            ps.setString(3, estudiante.getCarrera());
            ps.setString(4, estudiante.getTelefono().isBlank() ? null : estudiante.getTelefono());
            ps.executeUpdate();
            try (ResultSet rs = ps.getGeneratedKeys()) {
                if (rs.next()) estudiante.setIdEstudiante(rs.getInt(1));
            }
        }
    }
}
