<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<c:set var="tituloPagina" value="Préstamos"/>
<%@ include file="/WEB-INF/jspf/header.jspf" %>
<div class="page-heading">
<div>
<span class="eyebrow">BIBLIOTECA CENTRAL</span>
<h1>Préstamos</h1>
<p>Consulta los préstamos y registra cada devolución.</p>
</div>
<a class="btn btn-primary" href="${pageContext.request.contextPath}/prestamos?accion=nuevo">+ Nuevo préstamo</a>
</div>
<%@ include file="/WEB-INF/jspf/messages.jspf" %>
<c:choose>
<c:when test="${not empty prestamos}">
<div class="toolbar">
<div class="search-field w-100">
<label class="visually-hidden" for="buscar">Buscar en préstamos</label>
<input class="form-control" type="search" id="buscar" placeholder="Buscar en préstamos…" data-search>
</div>
<span class="muted" role="status" data-count>${fn:length(prestamos)} registros</span>
</div>
<div class="panel table-shell">
<div class="table-responsive" role="region" aria-label="Listado de préstamos" tabindex="0">
<table class="table">
<caption class="visually-hidden">Préstamos</caption>
<thead>
<tr>
<th scope="col">Estudiante</th>
<th scope="col">Libro</th>
<th scope="col">Préstamo</th>
<th scope="col">Devolución</th>
<th scope="col">Estado</th>
<th scope="col">Acción</th>
</tr>
</thead>
<tbody>
<c:forEach var="item" items="${prestamos}">
<tr data-row>
<td>
<strong>
<c:out value="${item.estudiante.nombreEstudiante}"/>
</strong>
<small>
<c:out value="${item.estudiante.carnet}"/>
</small>
</td>
<td>
<c:out value="${item.libro.titulo}"/>
</td>
<td>
<c:out value="${item.fechaPrestamo}"/>
</td>
<td>
<c:out value="${item.fechaDevolucion}"/>
</td>
<td>
<span class="status-chip ${item.estado == 'Vencido' ? 'overdue' : (item.estado == 'Devuelto' ? 'unavailable' : '')}">
<c:out value="${item.estado}"/>
</span>
</td>
<td>
<c:choose>
<c:when test="${item.estado == 'Activo' or item.estado == 'Vencido'}">
<form method="post" action="${pageContext.request.contextPath}/prestamos" data-return-form>
<input type="hidden" name="accion" value="devolver">
<input type="hidden" name="idPrestamo" value="${item.idPrestamo}">
<button class="btn btn-outline-secondary btn-small" type="submit" ${integracionPendiente ? 'disabled' : ''} aria-label="Devolver ${fn:escapeXml(item.libro.titulo)} de ${fn:escapeXml(item.estudiante.nombreEstudiante)}">Devolver</button>
</form>
</c:when>
<c:otherwise>
<span class="muted">Completado</span>
</c:otherwise>
</c:choose>
</td>
</tr>
</c:forEach>
</tbody>
</table>
</div>
<div class="empty-state" data-no-results hidden>
<h2>No encontramos coincidencias</h2>
<p>Prueba con otro nombre o borra la búsqueda.</p>
</div>
</div>
</c:when>
<c:otherwise>
<c:if test="${empty error and not integracionPendiente}">
<div class="panel empty-state">
<span class="empty-icon" aria-hidden="true">＋</span>
<h2>Todavía no hay préstamos</h2>
<p>Los registros aparecerán aquí cuando los agregues.</p>
<a class="btn btn-primary" href="${pageContext.request.contextPath}/prestamos?accion=nuevo">Nuevo préstamo</a>
</div>
</c:if>
</c:otherwise>
</c:choose>
<%@ include file="/WEB-INF/jspf/footer.jspf" %>
