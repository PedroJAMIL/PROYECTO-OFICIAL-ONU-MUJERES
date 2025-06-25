public List<Map<String, Object>> obtenerFormulariosCompletadosPorEncuestadorYMes(int idCoordinador) {
    List<Map<String, Object>> resultados = new ArrayList<>();

    String sql = """
        SELECT 
            CONCAT(u.nombre, ' ', u.apellidopaterno) as encuestador,
            MONTH(sr.fechaenvio) as mes,
            COUNT(*) as formularios_completados
        FROM sesionrespuesta sr
        JOIN asignacionformulario af ON sr.idasignacionformulario = af.idasignacionformulario
        JOIN usuario u ON af.idencuestador = u.idusuario
        JOIN distrito d ON u.iddistrito = d.iddistrito
        WHERE sr.fechaenvio IS NOT NULL
            AND sr.estadoterminado = 1
            AND d.idzona = (
                SELECT dz.idzona
                FROM usuario uc
                JOIN distrito dz ON uc.idDistritoTrabajo = dz.iddistrito
                WHERE uc.idUsuario = ?
            )
            AND sr.fechaenvio >= DATE_SUB(CURDATE(), INTERVAL 6 MONTH)
        GROUP BY u.idusuario, MONTH(sr.fechaenvio)
        ORDER BY encuestador, mes
    """;

    try (Connection conn = DriverManager.getConnection(url, user, pass);
         PreparedStatement stmt = conn.prepareStatement(sql)) {

        stmt.setInt(1, idCoordinador);
        ResultSet rs = stmt.executeQuery();

        while (rs.next()) {
            Map<String, Object> fila = new HashMap<>();
            fila.put("encuestador", rs.getString("encuestador"));
            fila.put("mes", rs.getInt("mes"));
            fila.put("formularios_completados", rs.getInt("formularios_completados"));
            resultados.add(fila);
        }
    } catch (SQLException e) {
        e.printStackTrace();
    }

    return resultados;
}