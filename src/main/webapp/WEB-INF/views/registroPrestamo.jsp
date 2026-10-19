<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<c:set var="tituloPagina" value="Registrar préstamo"/>
<%@ include file="/WEB-INF/jspf/header.jspf" %>
<a class="back-link" href="${pageContext.request.contextPath}/prestamos">← Volver a prestamos</a>
<div class="page-heading">
<div>
<span class="eyebrow">NUEVO REGISTRO</span>
<h1>Registrar préstamo</h1>
<p>Un libro en las manos de quien lo necesita.</p>
</div>
</div>
<%@ include file="/WEB-INF/jspf/messages.jspf" %>
<div class="form-layout">
<form class="panel" method="post" action="${pageContext.request.contextPath}/prestamos">
<input type="hidden" name="accion" value="registrar">
<p class="muted mb-4">Los campos con * son obligatorios.</p>
<div class="row g-4">
<div class="col-12">
<label class="form-label" for="idEstudiante">Estudiante *</label>
<select class="form-select" id="idEstudiante" name="idEstudiante" required>
<option value="">Selecciona un estudiante</option>
<c:forEach var="estudiante" items="${estudiantes}">
<option value="${estudiante.idEstudiante}" ${param.idEstudiante == estudiante.idEstudiante ? 'selected' : ''}>
<c:out value="${estudiante.nombreEstudiante}"/> · <c:out value="${estudiante.carnet}"/>
</option>
</c:forEach>
</select>
<c:if test="${empty estudiantes}">
<div class="form-text">Primero registra un estudiante.</div>
</c:if>
</div>
<div class="col-12">
<label class="form-label" for="idLibro">Libro *</label>
<select class="form-select" id="idLibro" name="idLibro" required>
<option value="">Selecciona un libro disponible</option>
<c:forEach var="libro" items="${libros}">
<option value="${libro.idLibro}" ${param.idLibro == libro.idLibro ? 'selected' : ''} ${libro.cantidadDisponible == 0 ? 'disabled' : ''}>
<c:out value="${libro.titulo}"/> · ${libro.cantidadDisponible} disponibles</option>
</c:forEach>
</select>
<div class="form-text">Los libros sin existencias no se pueden seleccionar.</div>
</div>
<div class="col-md-6">
<label class="form-label" for="fechaPrestamo">Fecha del préstamo *</label>
<input class="form-control" type="date" id="fechaPrestamo" name="fechaPrestamo" required value="${empty param.fechaPrestamo ? hoy : fn:escapeXml(param.fechaPrestamo)}">
</div>
<div class="col-md-6">
<label class="form-label" for="fechaDevolucion">Fecha de devolución *</label>
<input class="form-control" type="date" id="fechaDevolucion" name="fechaDevolucion" required value="${fn:escapeXml(param.fechaDevolucion)}">
<div class="form-text">No puede ser anterior a la fecha del préstamo.</div>
</div>
</div>
<div class="form-actions">
<a class="btn btn-outline-secondary" href="${pageContext.request.contextPath}/prestamos">Cancelar</a>
<button class="btn btn-primary" type="submit" ${integracionPendiente or empty estudiantes or empty libros ? 'disabled' : ''}>Registrar préstamo</button>
</div>
</form>
<aside class="panel help-panel">
<span class="eyebrow">ANTES DE GUARDAR</span>
<h2>Antes de entregar el libro</h2>
<ol>
<li>Confirma el carné del estudiante.</li>
<li>Verifica el título seleccionado.</li>
<li>Acuerda la fecha de devolución.</li>
</ol>
<p>Al registrar el préstamo se descontará un ejemplar disponible.</p>
</aside>
</div>
<%@ include file="/WEB-INF/jspf/footer.jspf" %>
