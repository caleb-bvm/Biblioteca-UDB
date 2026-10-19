package com.mycompany.poo.jsp.biblioteca.dao;

import models.LibroBean;
import models.CategoriaBean;
import com.mycompany.poo.jsp.biblioteca.util.Conexion;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class LibroDAO {
    private static final String CONSULTA = "SELECT l.*, c.nombre_categoria FROM libros l JOIN categorias c ON l.id_categoria = c.id_categoria";

    public List<LibroBean> listar() throws SQLException {
        List<LibroBean> libros = new ArrayList<>();
        try (Connection cn = Conexion.obtener(); PreparedStatement ps = cn.prepareStatement(CONSULTA + " ORDER BY l.titulo"); ResultSet rs = ps.executeQuery()) {
            while (rs.next()) libros.add(leer(rs));
        }
        return libros;
    }

    public void registrar(LibroBean libro) throws SQLException {
        String sql = "INSERT INTO libros (titulo, autor, isbn, id_categoria, cantidad_disponible) VALUES (?, ?, ?, ?, ?)";
        try (Connection cn = Conexion.obtener(); PreparedStatement ps = cn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setString(1, libro.getTitulo());
            ps.setString(2, libro.getAutor());
            ps.setString(3, libro.getIsbn().isBlank() ? null : libro.getIsbn());
            ps.setInt(4, libro.getCategoria().getIdCategoria());
            ps.setInt(5, libro.getCantidadDisponible());
            ps.executeUpdate();
            try (ResultSet rs = ps.getGeneratedKeys()) {
                if (rs.next()) libro.setIdLibro(rs.getInt(1));
            }
        }
    }

    private LibroBean leer(ResultSet rs) throws SQLException {
        CategoriaBean categoria = new CategoriaBean();
        categoria.setIdCategoria(rs.getInt("id_categoria"));
        categoria.setNombreCategoria(rs.getString("nombre_categoria"));
        LibroBean libro = new LibroBean();
        libro.setIdLibro(rs.getInt("id_libro"));
        libro.setTitulo(rs.getString("titulo"));
        libro.setAutor(rs.getString("autor"));
        libro.setIsbn(rs.getString("isbn"));
        libro.setCantidadDisponible(rs.getInt("cantidad_disponible"));
        libro.setCategoria(categoria);
        return libro;
    }
}