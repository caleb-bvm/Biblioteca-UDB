package dao;

import com.mycompany.poo.jsp.biblioteca.util.Conexion;
import models.CategoriaBean;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class CategoriaDAO {
    private static final String CONSULTA = "SELECT * FROM categorias";

    public List<CategoriaBean> listar() throws SQLException {
        List<CategoriaBean> categorias = new ArrayList<>();
        // Aquí es donde usa Conexion.obtener()
        try (Connection cn = Conexion.obtener(); 
             PreparedStatement ps = cn.prepareStatement(CONSULTA); 
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                CategoriaBean categoria = new CategoriaBean();
                categoria.setIdCategoria(rs.getInt("id_categoria"));
                categoria.setNombreCategoria(rs.getString("nombre_categoria"));
                categorias.add(categoria);
            }
        }
        return categorias;
    }
}