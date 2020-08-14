/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package Model;

import java.sql.Date;

/**
 *
 * @author Carlos Larios
 */
public class consultar_ramal {
    public consultar_ramal(Integer id_ramal, String nombre, Integer numero, Boolean statusRamal, String KMZ, Date fecha_registro, Date fecha_actualizacion) {
        this.id_ramal = id_ramal;
        this.nombre = nombre;
        this.numero = numero;
        this.statusRamal = statusRamal;
        this.KMZ = KMZ;
        this.fecha_registro = fecha_registro;
        this.fecha_actualizacion = fecha_actualizacion;
    }
    
    private Integer id_ramal;
    private String nombre;
    private Integer numero;
    private Boolean statusRamal;
    private String KMZ;
    private Date fecha_registro;
    private Date fecha_actualizacion;

    public Integer getId_ramal() {
        return id_ramal;
    }

    public void setId_ramal(Integer id_ramal) {
        this.id_ramal = id_ramal;
    }

    public String getNombre() {
        return nombre;
    }

    public void setNombre(String nombre) {
        this.nombre = nombre;
    }

    public Integer getNumero() {
        return numero;
    }

    public void setNumero(Integer numero) {
        this.numero = numero;
    }

    public Boolean getStatusRamal() {
        return statusRamal;
    }

    public void setStatusRamal(Boolean statusRamal) {
        this.statusRamal = statusRamal;
    }

    public String getKMZ() {
        return KMZ;
    }

    public void setKMZ(String KMZ) {
        this.KMZ = KMZ;
    }

    public Date getFecha_registro() {
        return fecha_registro;
    }

    public void setFecha_registro(Date fecha_registro) {
        this.fecha_registro = fecha_registro;
    }

    public Date getFecha_actualizacion() {
        return fecha_actualizacion;
    }

    public void setFecha_actualizacion(Date fecha_actualizacion) {
        this.fecha_actualizacion = fecha_actualizacion;
    }
    
    
}
