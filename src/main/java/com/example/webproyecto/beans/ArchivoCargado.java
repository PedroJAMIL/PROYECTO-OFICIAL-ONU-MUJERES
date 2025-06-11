package com.example.webproyecto.beans;

import java.time.LocalDateTime;

public class ArchivoCargado {
    private int idArchivoCargado;
    private String nombreArchivoOriginal;
    private String rutaGuardado; // Ruta en el servidor donde se guardó el archivo
    private LocalDateTime fechaCarga;
    private int idUsuarioQueCargo; // Foreign Key a Usuario
    private String estadoProcesamiento; // Ej: "EXITOSO", "CON_ERRORES", "PENDIENTE"
    private String mensajeProcesamiento; // Detalles del procesamiento (ej: errores)
    private Integer idFormularioAsociado; // Opcional: si la carga crea/modifica un Formulario

    // Constructor vacío (necesario para frameworks/mapeos)
    public ArchivoCargado() {
    }

    // Constructor con los campos más importantes
    public ArchivoCargado(String nombreArchivoOriginal, String rutaGuardado, LocalDateTime fechaCarga, int idUsuarioQueCargo, String estadoProcesamiento, String mensajeProcesamiento, Integer idFormularioAsociado) {
        this.nombreArchivoOriginal = nombreArchivoOriginal;
        this.rutaGuardado = rutaGuardado;
        this.fechaCarga = fechaCarga;
        this.idUsuarioQueCargo = idUsuarioQueCargo;
        this.estadoProcesamiento = estadoProcesamiento;
        this.mensajeProcesamiento = mensajeProcesamiento;
        this.idFormularioAsociado = idFormularioAsociado;
    }

    // Getters y Setters
    public int getIdArchivoCargado() {
        return idArchivoCargado;
    }

    public void setIdArchivoCargado(int idArchivoCargado) {
        this.idArchivoCargado = idArchivoCargado;
    }

    public String getNombreArchivoOriginal() {
        return nombreArchivoOriginal;
    }

    public void setNombreArchivoOriginal(String nombreArchivoOriginal) {
        this.nombreArchivoOriginal = nombreArchivoOriginal;
    }

    public String getRutaGuardado() {
        return rutaGuardado;
    }

    public void setRutaGuardado(String rutaGuardado) {
        this.rutaGuardado = rutaGuardado;
    }

    public LocalDateTime getFechaCarga() {
        return fechaCarga;
    }

    public void setFechaCarga(LocalDateTime fechaCarga) {
        this.fechaCarga = fechaCarga;
    }

    public int getIdUsuarioQueCargo() {
        return idUsuarioQueCargo;
    }

    public void setIdUsuarioQueCargo(int idUsuarioQueCargo) {
        this.idUsuarioQueCargo = idUsuarioQueCargo;
    }

    public String getEstadoProcesamiento() {
        return estadoProcesamiento;
    }

    public void setEstadoProcesamiento(String estadoProcesamiento) {
        this.estadoProcesamiento = estadoProcesamiento;
    }

    public String getMensajeProcesamiento() {
        return mensajeProcesamiento;
    }

    public void setMensajeProcesamiento(String mensajeProcesamiento) {
        this.mensajeProcesamiento = mensajeProcesamiento;
    }

    public Integer getIdFormularioAsociado() {
        return idFormularioAsociado;
    }

    public void setIdFormularioAsociado(Integer idFormularioAsociado) {
        this.idFormularioAsociado = idFormularioAsociado;
    }
}