<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<c:set var="tituloPagina" value="Libros"/>
<%@ include file="/WEB-INF/jspf/header.jspf" %>
<div class="page-heading">
<div>
<span class="eyebrow">BIBLIOTECA CENTRAL</span>
<h1>Libros</h1>
<p>Encuentra una lectura y consulta su disponibilidad.</p>
</div>
<a class="btn btn-primary" href="${pageContext.request.contextPath}/libros?accion=nuevo">+ Registrar libro</a>
</div>
<%@ include file="/WEB-INF/jspf/messages.jspf" %>
<c:choose>
<c:when test="${not empty libros}">
<div class="toolbar">
<div class="search-field w-100">
<label class="visually-hidden" for="buscar">Buscar en libros</label>
<input class="form-control" type="search" id="buscar" placeholder="Buscar en libros…" data-search>
</div>
<span class="muted" role="status" data-count>${fn:length(libros)} registros</span>
</div>
<div class="panel table-shell">
<div class="table-responsive" role="region" aria-label="Listado de libros" tabindex="0">
<table class="table">
<caption class="visually-hidden">Libros</caption>
<thead>
<tr>
<th scope="col">Libro / autor</th>
<th scope="col">Categoría</th>
<th scope="col">ISBN</th>
<th scope="col">Disponibilidad</th>
</tr>
</thead>
<tbody>
<c:forEach var="item" items="${libros}">
<tr data-row>
<td>
<strong>
<c:out value="${item.titulo}"/>
</strong>
<small>
<c:out value="${item.autor}"/>
</small>
</td>
<td>
<c:out value="${item.categoria.nombreCategoria}"/>
</td>
<td>
<c:out value="${empty item.isbn ? 'Sin ISBN' : item.isbn}"/>
</td>
<td>
<span class="status-chip ${item.cantidadDisponible == 0 ? 'unavailable' : ''}">
<c:choose>
<c:when test="${item.cantidadDisponible == 0}">Sin existencias</c:when>
<c:otherwise>${item.cantidadDisponible} disponibles</c:otherwise>
</c:choose>
</span>
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
<h2>Tu catálogo empieza con un libro</h2>
<p>Los registros aparecerán aquí cuando los agregues.</p>
<a class="btn btn-primary" href="${pageContext.request.contextPath}/libros?accion=nuevo">Registrar libro</a>
</div>
</c:if>
</c:otherwise>
</c:choose>
<%@ include file="/WEB-INF/jspf/footer.jspf" %>
