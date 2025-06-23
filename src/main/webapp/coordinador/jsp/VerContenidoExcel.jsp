<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <title>Contenido del archivo Excel</title>
    <style>
        table { border-collapse: collapse; width: 100%; background: #f8fafc; }
        th, td { border: 1px solid #b3ccff; padding: 8px; text-align: left; }
        th { background: #b3ccff; }
        .error { color: #dc3545; font-weight: bold; margin: 20px 0; }
    </style>
</head>
<body>
    <h2>Contenido de: <c:out value="${nombreArchivo}" /></h2>
    <c:if test="${not empty mensajeError}">
        <div class="error">${mensajeError}</div>
    </c:if>
    <c:if test="${not empty filasExcel}">
        <table>
            <c:forEach var="fila" items="${filasExcel}">
                <tr>
                    <c:forEach var="celda" items="${fila}">
                        <td
                            <c:if test="${celda.rowspan > 1}">rowspan="${celda.rowspan}"</c:if>
                            <c:if test="${celda.colspan > 1}">colspan="${celda.colspan}"</c:if>
                        >${celda.valor}</td>
                    </c:forEach>
                </tr>
            </c:forEach>
        </table>
    </c:if>
</body>
</html>