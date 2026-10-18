<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="tituloPagina" value="Inicio"/>
<%@ include file="/WEB-INF/jspf/header.jspf" %>
<section class="hero">
<div class="hero-copy">
<span class="eyebrow">BIBLIOTECA CENTRAL</span>
<h1>El próximo capítulo<br>empieza aquí.</h1>
<p>Libros, estudiantes y préstamos.<br>Todo en un mismo lugar.</p>
<a class="btn btn-primary" href="${pageContext.request.contextPath}/libros">Explorar libros <span aria-hidden="true">↗</span>
</a>
</div>
<div class="book-art" aria-hidden="true">
<div class="art-orbit">
</div>
<span class="art-star">✳</span>
<div class="book book-one">
<span>IDEAS<br>QUE<br>CRECEN</span>
<i>
</i>
</div>
<div class="book book-two">
<span>Un mundo<br>por descubrir.</span>
<i>
</i>
</div>
<span class="art-dot">
</span>
</div>
</section>
<section class="section-block" aria-labelledby="acciones">
<div class="section-heading">
<div>
<span class="eyebrow">A TU ALCANCE</span>
<h2 id="acciones">¿Qué necesitas hacer?</h2>
</div>
<span class="muted">Elige una opción para comenzar</span>
</div>
<div class="row g-3">
<div class="col-md-4">
<a class="action-card card-pink" href="${pageContext.request.contextPath}/libros?accion=nuevo">
<span class="card-symbol" aria-hidden="true">▤</span>
<h3>Registrar un libro</h3>
<p>Agrega un título al catálogo y define sus ejemplares disponibles.</p>
<span class="card-link">Nuevo libro <span aria-hidden="true">↗</span>
</span>
</a>
</div>
<div class="col-md-4">
<a class="action-card card-blue" href="${pageContext.request.contextPath}/estudiantes?accion=nuevo">
<span class="card-symbol" aria-hidden="true">♙</span>
<h3>Agregar estudiante</h3>
<p>Registra sus datos para que pueda solicitar libros de la biblioteca.</p>
<span class="card-link">Nuevo estudiante <span aria-hidden="true">↗</span>
</span>
</a>
</div>
<div class="col-md-4">
<a class="action-card card-green" href="${pageContext.request.contextPath}/prestamos?accion=nuevo">
<span class="card-symbol" aria-hidden="true">⇄</span>
<h3>Prestar un libro</h3>
<p>Selecciona un libro, un estudiante y la fecha de devolución.</p>
<span class="card-link">Nuevo préstamo <span aria-hidden="true">↗</span>
</span>
</a>
</div>
</div>
</section>
<div class="tip-strip">
<span class="tip-icon" aria-hidden="true">↺</span>
<div>
<strong>Un préstamo termina con una nueva oportunidad.</strong>
<p>Registra las devoluciones desde el listado de préstamos para liberar los ejemplares.</p>
</div>
<a class="text-link" href="${pageContext.request.contextPath}/prestamos">Ver préstamos →</a>
</div>
<%@ include file="/WEB-INF/jspf/footer.jspf" %>
