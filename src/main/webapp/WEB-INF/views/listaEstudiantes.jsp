<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<c:set var="tituloPagina" value="Estudiantes"/>
<%@ include file="/WEB-INF/jspf/header.jspf" %>
<div class="page-heading">
<div>
<span class="eyebrow">BIBLIOTECA UDB</span>
<h1>Estudiantes</h1>
<p>La comunidad que da vida a nuestra biblioteca.</p>
</div>
<a class="btn btn-primary" href="${pageContext.request.contextPath}/estudiantes?accion=nuevo">+ Registrar estudiante</a>
</div>
<%@ include file="/WEB-INF/jspf/messages.jspf" %>
<c:choose>
<c:when test="${not empty estudiantes}">
<div class="toolbar">
<div class="search-field w-100">
<label class="visually-hidden" for="buscar">Buscar en estudiantes</label>
<input class="form-control" type="search" id="buscar" placeholder="Buscar en estudiantes…" data-search>
</div>
<span class="muted" role="status" data-count>${fn:length(estudiantes)} registros</span>
</div>
<div class="panel table-shell">
<div class="table-responsive" role="region" aria-label="Listado de estudiantes" tabindex="0">
<table class="table">
<caption class="visually-hidden">Estudiantes</caption>
<thead>
<tr>
<th scope="col">Estudiante</th>
<th scope="col">Carné</th>
<th scope="col">Carrera</th>
<th scope="col">Teléfono</th>
</tr>
</thead>
<tbody>
<c:forEach var="item" items="${estudiantes}">
<tr data-row>
<td>
<strong>
<c:out value="${item.nombreEstudiante}"/>
</strong>
</td>
<td>
<c:out value="${item.carnet}"/>
</td>
<td>
<c:out value="${item.carrera}"/>
</td>
<td>
<c:out value="${empty item.telefono ? 'No registrado' : item.telefono}"/>
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
<c:if test="${empty error}">
<div class="panel empty-state">
<span class="empty-icon" aria-hidden="true">＋</span>
<h2>Registra al primer estudiante</h2>
<p>Los registros aparecerán aquí cuando los agregues.</p>
<a class="btn btn-primary" href="${pageContext.request.contextPath}/estudiantes?accion=nuevo">Registrar estudiante</a>
</div>
</c:if>
</c:otherwise>
</c:choose>
<%@ include file="/WEB-INF/jspf/footer.jspf" %>
