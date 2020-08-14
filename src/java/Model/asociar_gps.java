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
public class asociar_gps {
    
    public asociar_gps(Integer no_serie, Integer id_modelo_gps, Integer id_unidad, String niv, Integer kilometraje, Date fecha_registro) {
        this.no_serie = no_serie;
        this.id_modelo_gps = id_modelo_gps;
        this.id_unidad = id_unidad;
        this.niv = niv;
        this.kilometraje = kilometraje;
        this.fecha_registro = fecha_registro;
    }
    
    private Integer no_serie;
    private Integer id_modelo_gps;
    private Integer id_unidad;
    private String niv;
    private Integer kilometraje;
    private Date fecha_registro;

    public Integer getNo_serie() {
        return no_serie;
    }

    public void setNo_serie(Integer no_serie) {
        this.no_serie = no_serie;
    }

    public Integer getId_modelo_gps() {
        return id_modelo_gps;
    }

    public void setId_modelo_gps(Integer id_modelo_gps) {
        this.id_modelo_gps = id_modelo_gps;
    }

    public Integer getId_unidad() {
        return id_unidad;
    }

    public void setId_unidad(Integer id_unidad) {
        this.id_unidad = id_unidad;
    }

    public String getNiv() {
        return niv;
    }

    public void setNiv(String niv) {
        this.niv = niv;
    }

    public Integer getKilometraje() {
        return kilometraje;
    }

    public void setKilometraje(Integer kilometraje) {
        this.kilometraje = kilometraje;
    }

    public Date getFecha_registro() {
        return fecha_registro;
    }

    public void setFecha_registro(Date fecha_registro) {
        this.fecha_registro = fecha_registro;
    }
    
    
    
}
