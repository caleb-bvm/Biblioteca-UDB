<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<c:set var="tituloPagina" value="Registro completado"/>
<%@ include file="/WEB-INF/jspf/header.jspf" %>
<div class="panel confirmation">
<span class="empty-icon" aria-hidden="true">✓</span>
<span class="eyebrow">TODO LISTO</span>
<h1>
<c:out value="${mensaje}"/>
</h1>
<p class="mt-3">
<c:out value="${detalle}"/>
</p>
<a class="btn btn-primary" href="${pageContext.request.contextPath}/${fn:escapeXml(destino)}">Volver al listado →</a>
</div>
<%@ include file="/WEB-INF/jspf/footer.jspf" %>
