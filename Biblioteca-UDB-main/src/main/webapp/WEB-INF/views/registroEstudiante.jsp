<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<c:set var="tituloPagina" value="Registrar estudiante"/>
<%@ include file="/WEB-INF/jspf/header.jspf" %>
<a class="back-link" href="${pageContext.request.contextPath}/estudiantes">← Volver a estudiantes</a>
<div class="page-heading">
<div>
<span class="eyebrow">NUEVO REGISTRO</span>
<h1>Registrar estudiante</h1>
<p>Sus datos, listos para el próximo préstamo.</p>
</div>
</div>
<%@ include file="/WEB-INF/jspf/messages.jspf" %>
<div class="form-layout">
<form class="panel" method="post" action="${pageContext.request.contextPath}/estudiantes">
<input type="hidden" name="accion" value="registrar">
<p class="muted mb-4">Los campos con * son obligatorios.</p>
<div class="row g-4">
<div class="col-md-6">
<label class="form-label" for="carnet">Carné *</label>
<input class="form-control" id="carnet" name="carnet" type="text" maxlength="10" value="${fn:escapeXml(param.carnet)}" required  aria-describedby="carnetAyuda">
<div class="form-text" id="carnetAyuda">Identificador único del estudiante.</div>
</div>
<div class="col-md-6">
<label class="form-label" for="nombreEstudiante">Nombre completo *</label>
<input class="form-control" id="nombreEstudiante" name="nombreEstudiante" type="text" maxlength="100" value="${fn:escapeXml(param.nombreEstudiante)}" required autocomplete="name" aria-describedby="nombreEstudianteAyuda">
<div class="form-text" id="nombreEstudianteAyuda">
</div>
</div>
<div class="col-md-6">
<label class="form-label" for="carrera">Carrera *</label>
<input class="form-control" id="carrera" name="carrera" type="text" maxlength="80" value="${fn:escapeXml(param.carrera)}" required  aria-describedby="carreraAyuda">
<div class="form-text" id="carreraAyuda">
</div>
</div>
<div class="col-md-6">
<label class="form-label" for="telefono">Teléfono (opcional)</label>
<input class="form-control" id="telefono" name="telefono" type="tel" maxlength="9" value="${fn:escapeXml(param.telefono)}"  pattern="[0-9]{4}-?[0-9]{4}" autocomplete="tel" aria-describedby="telefonoAyuda">
<div class="form-text" id="telefonoAyuda">8 dígitos. Ejemplo: 2222-3333.</div>
</div>
</div>
<div class="form-actions">
<a class="btn btn-outline-secondary" href="${pageContext.request.contextPath}/estudiantes">Cancelar</a>
<button class="btn btn-primary" type="submit" >Guardar estudiante</button>
</div>
</form>
<aside class="panel help-panel">
<span class="eyebrow">ANTES DE GUARDAR</span>
<h2>Lo esencial para comenzar</h2>
<p>Verifica el carné para evitar registros duplicados.</p>
<p>El teléfono es opcional. Si lo agregas, facilitará el contacto con el estudiante.</p>
</aside>
</div>
<%@ include file="/WEB-INF/jspf/footer.jspf" %>
