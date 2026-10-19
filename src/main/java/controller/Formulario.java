package controller;

import jakarta.servlet.http.HttpServletRequest;

public class Formulario {
    public static String texto(HttpServletRequest request, String nombre) {
        String valor = request.getParameter(nombre);
        return valor == null ? "" : valor.trim();
    }

    public static void requerido(String valor, int maximo, String nombre) {
        if (valor.isBlank() || valor.length() > maximo) {
            throw new IllegalArgumentException(nombre + " es obligatorio y admite hasta " + maximo + " caracteres.");
        }
    }

    public static int entero(String valor, int minimo, String nombre) {
        try {
            int numero = Integer.parseInt(valor);
            if (numero < minimo) throw new NumberFormatException();
            return numero;
        } catch (NumberFormatException e) {
            throw new IllegalArgumentException(nombre + " debe ser un número entero mayor o igual a " + minimo + ".");
        }
    }
}
