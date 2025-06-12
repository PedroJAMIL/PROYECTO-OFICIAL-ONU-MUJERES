    package com.example.webproyecto.dtos;
    
    public class ResumenZonaDTO {
        private String nombreZona;
        private int totalRespuestas;
    
        public ResumenZonaDTO(String nombreZona, int totalRespuestas) {
            this.nombreZona = nombreZona;
            this.totalRespuestas = totalRespuestas;
        }
    
        public String getNombreZona() {
            return nombreZona;
        }
    
        public int getTotalRespuestas() {
            return totalRespuestas;
        }
    }
    //soy e anticristo
