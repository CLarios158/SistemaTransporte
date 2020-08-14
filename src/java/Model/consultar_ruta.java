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
public class consultar_ruta {
    public consultar_ruta(Integer id_ruta, Integer id_capa, String nombre, Integer numero, Boolean statusRuta, String KMZ, Date fecha_registro, Date fecha_actualizacion) {
        this.id_ruta = id_ruta;
        this.id_capa = id_capa;
        this.nombre = nombre;
        this.numero = numero;
        this.statusRuta = statusRuta;
        this.KMZ = KMZ;
        this.fecha_registro = fecha_registro;
        this.fecha_actualizacion = fecha_actualizacion;
    }
    
    private Integer id_ruta;
    private Integer id_capa;
    private String nombre;
    private Integer numero;
    private Boolean statusRuta;
    private String KMZ;
    private Date fecha_registro;
    private Date fecha_actualizacion;

    public Integer getId_ruta() {
        return id_ruta;
    }

    public void setId_ruta(Integer id_ruta) {
        this.id_ruta = id_ruta;
    }

    public Integer getId_capa() {
        return id_capa;
    }

    public void setId_capa(Integer id_capa) {
        this.id_capa = id_capa;
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

    public Boolean getStatusRuta() {
        return statusRuta;
    }

    public void setStatusRuta(Boolean statusRuta) {
        this.statusRuta = statusRuta;
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
