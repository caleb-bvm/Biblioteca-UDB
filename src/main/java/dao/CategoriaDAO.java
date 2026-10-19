package dao;

<<<<<<< HEAD
import com.mycompany.poo.jsp.biblioteca.util.Conexion;
=======
>>>>>>> d1259d620c13065e653c83f6010ffc046a27af41
import models.CategoriaBean;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class CategoriaDAO {
<<<<<<< HEAD
    private static final String CONSULTA = "SELECT * FROM categorias";

    public List<CategoriaBean> listar() throws SQLException {
        List<CategoriaBean> categorias = new ArrayList<>();
        // Aquí es donde usa Conexion.obtener()
        try (Connection cn = Conexion.obtener(); 
             PreparedStatement ps = cn.prepareStatement(CONSULTA); 
             ResultSet rs = ps.executeQuery()) {
=======
    public List<CategoriaBean> listar() throws SQLException {
        List<CategoriaBean> categorias = new ArrayList<>();
        String sql = "SELECT id_categoria, nombre_categoria FROM categorias ORDER BY nombre_categoria";
        try (Connection cn = Conexion.obtener(); PreparedStatement ps = cn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
>>>>>>> d1259d620c13065e653c83f6010ffc046a27af41
            while (rs.next()) {
                CategoriaBean categoria = new CategoriaBean();
                categoria.setIdCategoria(rs.getInt("id_categoria"));
                categoria.setNombreCategoria(rs.getString("nombre_categoria"));
                categorias.add(categoria);
            }
        }
        return categorias;
    }
<<<<<<< HEAD
}
=======
}
>>>>>>> d1259d620c13065e653c83f6010ffc046a27af41
