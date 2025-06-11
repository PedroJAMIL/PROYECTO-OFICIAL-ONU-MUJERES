package com.example.webproyecto.dtos;

public class EstadoFormularioDTO {
    private int totalCompletados;
    private int totalBorradores;

    public EstadoFormularioDTO(int totalCompletados, int totalBorradores) {
        this.totalCompletados = totalCompletados;
        this.totalBorradores = totalBorradores;
    }

    public int getTotalCompletados() {
        return totalCompletados;
    }

    public int getTotalBorradores() {
        return totalBorradores;
    }
}

