<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<c:set var="tituloPagina" value="Registrar un libro"/>
<%@ include file="/WEB-INF/jspf/header.jspf" %>
<a class="back-link" href="${pageContext.request.contextPath}/libros">← Volver a libros</a>
<div class="page-heading">
<div>
<span class="eyebrow">NUEVO REGISTRO</span>
<h1>Registrar un libro</h1>
<p>Dale un lugar en nuestro catálogo.</p>
</div>
</div>
<%@ include file="/WEB-INF/jspf/messages.jspf" %>
<div class="form-layout">
<form class="panel" method="post" action="${pageContext.request.contextPath}/libros">
<input type="hidden" name="accion" value="registrar">
<p class="muted mb-4">Los campos con * son obligatorios.</p>
<div class="row g-4">
<div class="col-md-6">
<label class="form-label" for="titulo">Título *</label>
<input class="form-control" id="titulo" name="titulo" type="text" maxlength="150" value="${fn:escapeXml(param.titulo)}" required  aria-describedby="tituloAyuda">
<div class="form-text" id="tituloAyuda">Escribe el título completo del libro.</div>
</div>
<div class="col-md-6">
<label class="form-label" for="autor">Autor *</label>
<input class="form-control" id="autor" name="autor" type="text" maxlength="100" value="${fn:escapeXml(param.autor)}" required  aria-describedby="autorAyuda">
<div class="form-text" id="autorAyuda">
</div>
</div>
<div class="col-md-6">
<label class="form-label" for="isbn">ISBN (opcional)</label>
<input class="form-control" id="isbn" name="isbn" type="text" maxlength="20" value="${fn:escapeXml(param.isbn)}"   aria-describedby="isbnAyuda">
<div class="form-text" id="isbnAyuda">Si lo incluyes, debe ser único en el catálogo.</div>
</div>
<div class="col-md-6">
<label class="form-label" for="idCategoria">Categoría *</label>
<select class="form-select" id="idCategoria" name="idCategoria" required>
<option value="">Selecciona una categoría</option>
<c:forEach var="categoria" items="${categorias}">
<option value="${categoria.idCategoria}" ${param.idCategoria == categoria.idCategoria ? 'selected' : ''}>
<c:out value="${categoria.nombreCategoria}"/>
</option>
</c:forEach>
</select>
<c:if test="${empty categorias}">
<div class="form-text">No hay categorías disponibles. Carga los datos iniciales para continuar.</div>
</c:if>
</div>
<div class="col-md-6">
<label class="form-label" for="cantidadDisponible">Ejemplares disponibles *</label>
<input class="form-control" type="number" id="cantidadDisponible" name="cantidadDisponible" min="0" max="2147483647" step="1" required value="${empty param.cantidadDisponible ? '1' : fn:escapeXml(param.cantidadDisponible)}">
<div class="form-text">Cantidad de ejemplares que se pueden prestar.</div>
</div>
</div>
<div class="form-actions">
<a class="btn btn-outline-secondary" href="${pageContext.request.contextPath}/libros">Cancelar</a>
<button class="btn btn-primary" type="submit" ${empty categorias ? 'disabled' : ''}>Guardar libro</button>
</div>
</form>
<aside class="panel help-panel">
<span class="eyebrow">ANTES DE GUARDAR</span>
<h2>Un catálogo fácil de consultar</h2>
<p>Revisa el título y el autor antes de registrar el libro.</p>
<p>La categoría ayuda a identificar su temática. Puedes registrar cero ejemplares si el libro aún no está disponible.</p>
</aside>
</div>
<%@ include file="/WEB-INF/jspf/footer.jspf" %>
