package com.example.webproyecto.daos.encuestador;

import com.example.webproyecto.beans.SesionRespuesta;

import java.sql.*;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class SesionRespuestaDao {

    private final String url = "jdbc:mysql://localhost:3306/proyecto";
    private final String user = "root";
    private final String pass = "root";

    public int crearSesionRespuesta(SesionRespuesta sesion) {
        int idGenerado = -1;

        String sql = """
            INSERT INTO sesionrespuesta (fechainicio, fechaenvio, estadoterminado, idasignacionformulario, idencuestado)
            VALUES (?, ?, ?, ?, ?)
        """;

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");

            try (Connection conn = DriverManager.getConnection(url, user, pass);
                 PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

                stmt.setTimestamp(1, Timestamp.valueOf(sesion.getFechaInicio()));

                if (sesion.getFechaEnvio() != null) {
                    stmt.setTimestamp(2, Timestamp.valueOf(sesion.getFechaEnvio()));
                } else {
                    stmt.setNull(2, Types.TIMESTAMP);
                }

                stmt.setInt(3, sesion.getEstadoTerminado());
                stmt.setInt(4, sesion.getIdAsignacionFormulario());

                if (sesion.getIdEncuestado() != null) {
                    stmt.setString(5, sesion.getIdEncuestado());
                } else {
                    stmt.setNull(5, Types.VARCHAR);
                }

                int filasAfectadas = stmt.executeUpdate();

                if (filasAfectadas > 0) {
                    try (ResultSet rs = stmt.getGeneratedKeys()) {
                        if (rs.next()) {
                            idGenerado = rs.getInt(1);
                        }
                    }
                }

            }

        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
        }

        return idGenerado;
    }

    public void actualizarNumeroSesion(int idSesion, int numeroSesion) {
        String sql = "UPDATE sesionrespuesta SET numerosesion = ? WHERE idsesion = ?";
        try (Connection conn = DriverManager.getConnection(url, user, pass);
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, numeroSesion);
            stmt.setInt(2, idSesion);
            stmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public int contarSesionesPorEncuestadorYAño(int idEncuestador, int anio) {
        int contador = 0;

        String sql = """
            SELECT COUNT(*) AS total
            FROM sesionrespuesta sr
            INNER JOIN asignacionformulario af ON sr.idasignacionformulario = af.idasignacionformulario
            WHERE af.idencuestador = ? AND YEAR(sr.fechainicio) = ?
        """;

        try (Connection conn = DriverManager.getConnection(url, user, pass);
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, idEncuestador);
            stmt.setInt(2, anio);

            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    contador = rs.getInt("total");
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return contador;
    }

    public int obtenerIdEncuestadorPorSesion(int idSesion) {
        int idEncuestador = -1;

        String sql = """
            SELECT af.idEncuestador
            FROM sesionrespuesta sr
            INNER JOIN asignacionformulario af ON sr.idasignacionformulario = af.idasignacionformulario
            WHERE sr.idsesion = ?
        """;

        try (Connection conn = DriverManager.getConnection(url, user, pass);
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, idSesion);

            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    idEncuestador = rs.getInt("idEncuestador");
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return idEncuestador;
    }

    public List<Map<String, Object>> obtenerSesionesPorEncuestador(int idEncuestador) {
        List<Map<String, Object>> sesiones = new ArrayList<>();

        String sql = """
            SELECT sr.idsesion, sr.fechainicio, sr.fechaenvio, sr.estadoterminado,
                   f.idformulario, f.titulo, sr.numerosesion
            FROM sesionrespuesta sr
            INNER JOIN asignacionformulario af ON sr.idasignacionformulario = af.idasignacionformulario
            INNER JOIN formulario f ON af.idformulario = f.idformulario
            WHERE af.idencuestador = ?
            ORDER BY sr.fechainicio DESC
        """;

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");

            try (Connection conn = DriverManager.getConnection(url, user, pass);
                 PreparedStatement stmt = conn.prepareStatement(sql)) {

                stmt.setInt(1, idEncuestador);
                try (ResultSet rs = stmt.executeQuery()) {
                    while (rs.next()) {
                        Map<String, Object> fila = new HashMap<>();
                        fila.put("idsesion", rs.getInt("idsesion"));
                        fila.put("fechainicio", rs.getTimestamp("fechainicio"));
                        fila.put("fechaenvio", rs.getTimestamp("fechaenvio"));
                        fila.put("estadoTerminado", rs.getInt("estadoterminado"));
                        fila.put("idformulario", rs.getInt("idformulario"));
                        fila.put("titulo", rs.getString("titulo"));
                        fila.put("numeroSesion", rs.getInt("numerosesion"));
                        sesiones.add(fila);
                    }
                }

            }
        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
        }

        return sesiones;
    }

    public Map<String, Object> obtenerInfoSesion(int idSesion) {
        Map<String, Object> datos = null;

        String sql = """
            SELECT sr.idasignacionformulario, af.idformulario
            FROM sesionrespuesta sr
            INNER JOIN asignacionformulario af ON sr.idasignacionformulario = af.idasignacionformulario
            WHERE sr.idsesion = ?
        """;

        try (Connection conn = DriverManager.getConnection(url, user, pass);
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, idSesion);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    datos = new HashMap<>();
                    datos.put("idasignacionformulario", rs.getInt("idasignacionformulario"));
                    datos.put("idformulario", rs.getInt("idformulario"));
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return datos;
    }

    public void actualizarEstadoYFechaEnvio(int idSesion, int estadoTerminado, Timestamp fechaEnvio) {
        String sql = """
            UPDATE sesionrespuesta
            SET estadoterminado = ?, fechaenvio = ?
            WHERE idsesion = ?
        """;

        try (Connection conn = DriverManager.getConnection(url, user, pass);
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, estadoTerminado);

            if (fechaEnvio != null) {
                stmt.setTimestamp(2, fechaEnvio);
            } else {
                stmt.setNull(2, Types.TIMESTAMP);
            }

            stmt.setInt(3, idSesion);
            stmt.executeUpdate();

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
    public List<Map<String, Object>> obtenerResumenSesionesPorEncuestador(int idEncuestador) {
        List<Map<String, Object>> resumen = new ArrayList<>();

        String sql = """
        SELECT DATE(sr.fechainicio) AS fecha, 
               CASE WHEN sr.estadoterminado = 1 THEN 'registrada' ELSE 'borrador' END AS estado
        FROM sesionrespuesta sr
        INNER JOIN asignacionformulario af ON sr.idasignacionformulario = af.idasignacionformulario
        WHERE af.idencuestador = ?
        AND sr.fechainicio >= DATE_SUB(CURDATE(), INTERVAL 6 DAY)
    """;

        try (Connection conn = DriverManager.getConnection(url, user, pass);
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, idEncuestador);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Map<String, Object> fila = new HashMap<>();
                    fila.put("fecha", rs.getDate("fecha").toString());
                    fila.put("estado", rs.getString("estado"));
                    resumen.add(fila);
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return resumen;
    }
    public List<Map<String, Object>> obtenerFormulariosCompletadosPorZonaYMes() {
        List<Map<String, Object>> resultados = new ArrayList<>();

        String sql = """
            SELECT 
                z.nombrezona as zona,
                YEAR(sr.fechaenvio) as año,
                MONTH(sr.fechaenvio) as mes,
                CASE MONTH(sr.fechaenvio)
                    WHEN 1 THEN 'Enero'
                    WHEN 2 THEN 'Febrero'
                    WHEN 3 THEN 'Marzo'
                    WHEN 4 THEN 'Abril'
                    WHEN 5 THEN 'Mayo'
                    WHEN 6 THEN 'Junio'
                    WHEN 7 THEN 'Julio'
                    WHEN 8 THEN 'Agosto'
                    WHEN 9 THEN 'Septiembre'
                    WHEN 10 THEN 'Octubre'
                    WHEN 11 THEN 'Noviembre'
                    WHEN 12 THEN 'Diciembre'
                    ELSE CONCAT('Mes ', MONTH(sr.fechaenvio))
                END as nombre_mes,
                COUNT(*) as formularios_completados
            FROM sesionrespuesta sr
            JOIN asignacionformulario af ON sr.idasignacionformulario = af.idasignacionformulario
            JOIN usuario u ON af.idencuestador = u.idusuario
            JOIN distrito d ON u.iddistrito = d.iddistrito
            JOIN zona z ON d.idzona = z.idzona
            WHERE sr.fechaenvio IS NOT NULL
                AND sr.estadoterminado = 1
                AND sr.fechaenvio >= DATE_SUB(CURDATE(), INTERVAL 6 MONTH)
            GROUP BY z.nombrezona, YEAR(sr.fechaenvio), MONTH(sr.fechaenvio)
            ORDER BY año DESC, mes DESC, zona
        """;

        try (Connection conn = DriverManager.getConnection(url, user, pass);
            PreparedStatement stmt = conn.prepareStatement(sql);
            ResultSet rs = stmt.executeQuery()) {

            System.out.println("[DEBUG] Ejecutando consulta de formularios por zona y mes");
            while (rs.next()) {
                Map<String, Object> fila = new HashMap<>();
                fila.put("zona", rs.getString("zona"));
                fila.put("año", rs.getInt("año"));
                fila.put("mes", rs.getInt("mes"));
                fila.put("nombre_mes", rs.getString("nombre_mes"));
                fila.put("formularios_completados", rs.getInt("formularios_completados"));
                System.out.println("[DEBUG] Fila: " + fila);
                resultados.add(fila);
            }
            System.out.println("[DEBUG] Total filas: " + resultados.size());
            return resultados;

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return resultados;
    }
}
