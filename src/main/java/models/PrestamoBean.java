package models;

import java.time.LocalDate;

public class PrestamoBean {
    private int idPrestamo;
    private EstudianteBean estudiante;
    private LibroBean libro;
    private LocalDate fechaPrestamo;
    private LocalDate fechaDevolucion;
    private String estado;

    public PrestamoBean() {
    }

    public int getIdPrestamo() {
        return idPrestamo;
    }

    public void setIdPrestamo(int idPrestamo) {
        this.idPrestamo = idPrestamo;
    }

    public EstudianteBean getEstudiante() {
        return estudiante;
    }

    public void setEstudiante(EstudianteBean estudiante) {
        this.estudiante = estudiante;
    }

    public LibroBean getLibro() {
        return libro;
    }

    public void setLibro(LibroBean libro) {
        this.libro = libro;
    }

    public LocalDate getFechaPrestamo() {
        return fechaPrestamo;
    }

    public void setFechaPrestamo(LocalDate fechaPrestamo) {
        this.fechaPrestamo = fechaPrestamo;
    }

    public LocalDate getFechaDevolucion() {
        return fechaDevolucion;
    }

    public void setFechaDevolucion(LocalDate fechaDevolucion) {
        this.fechaDevolucion = fechaDevolucion;
    }

    public String getEstado() {
        return estado;
    }

    public void setEstado(String estado) {
        this.estado = estado;
    }
}
