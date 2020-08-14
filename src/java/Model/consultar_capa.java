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
public class consultar_capa {
    public consultar_capa(Integer id_capa, String nombre, String Icon,Boolean statusCapa, String descripcion, Date fecha_registro, Date fecha_actualizacion) {
        this.id_capa = id_capa;
        this.nombre = nombre;
        this.Icon = Icon;
        this.statusCapa = statusCapa;
        this.fecha_registro = fecha_registro;
        this.fecha_actualizacion = fecha_actualizacion;
    }

    private Integer id_capa;
    private String nombre;
    private String Icon;
    private Boolean statusCapa;
    private Date fecha_registro;
    private Date fecha_actualizacion;

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
    
    public String getIcon() {
        return Icon;
    }

    public void setIcon(String Icon) {
        this.Icon = Icon;
    }

    public Boolean getStatusCapa() {
        return statusCapa;
    }

    public void setStatusCapa(Boolean statusCapa) {
        this.statusCapa = statusCapa;
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
