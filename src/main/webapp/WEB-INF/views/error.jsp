<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<c:set var="tituloPagina" value="No pudimos completar la acción"/>
<%@ include file="/WEB-INF/jspf/header.jspf" %>
<div class="panel confirmation">
<span class="empty-icon" aria-hidden="true">!</span>
<h1>No pudimos completar la acción</h1>
<p>Intenta de nuevo en unos momentos. Si el problema continúa, revisa la conexión de la aplicación.</p>
<a class="btn btn-primary" href="${pageContext.request.contextPath}/">Volver al inicio</a>
</div>
<%@ include file="/WEB-INF/jspf/footer.jspf" %>
