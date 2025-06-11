package com.example.webproyecto.dtos;

public class ResumenEncuestadorDTO {
    private String nombreEncuestador;
    private int cantidadRespuestas;

    public ResumenEncuestadorDTO(String nombreEncuestador, int cantidadRespuestas) {
        this.nombreEncuestador = nombreEncuestador;
        this.cantidadRespuestas = cantidadRespuestas;
    }

    public String getNombreEncuestador() {
        return nombreEncuestador;
    }

    public int getCantidadRespuestas() {
        return cantidadRespuestas;
    }
}

