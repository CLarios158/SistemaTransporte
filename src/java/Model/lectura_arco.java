/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package Model;

import java.sql.Date;

/**
 *
 * @author oswal
 */
public class lectura_arco {

    public lectura_arco(Long tipo_registro, Date fecha_hora, String nombre_arco, String descripcion) {
        this.tipo_registro = tipo_registro;
        this.fecha_hora = fecha_hora;
        this.nombre_arco = nombre_arco;
        this.descripcion = descripcion;
    }

    public lectura_arco() {
    }
    
    private Long tipo_registro;
    private Date fecha_hora;
    private String nombre_arco;
    private String descripcion;

    public Long getTipo_registro() {
        return tipo_registro;
    }

    public void setTipo_registro(Long tipo_registro) {
        this.tipo_registro = tipo_registro;
    }

    public Date getFecha_hora() {
        return fecha_hora;
    }

    public void setFecha_hora(Date fecha_hora) {
        this.fecha_hora = fecha_hora;
    }

    public String getNombre_arco() {
        return nombre_arco;
    }

    public void setNombre_arco(String nombre_arco) {
        this.nombre_arco = nombre_arco;
    }

    public String getDescripcion() {
        return descripcion;
    }

    public void setDescripcion(String descripcion) {
        this.descripcion = descripcion;
    }

   
    
}
