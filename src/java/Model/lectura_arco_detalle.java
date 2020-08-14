/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package Model;


/**
 *
 * @author oswal
 */
public class lectura_arco_detalle {
    private Long tipo_registro;
    private String fecha_hora;
    private String nombre_arco;
    private String descripcion;
    private String placa_niv;
    private String fuente_informacion;

    public lectura_arco_detalle() {
    }

    public lectura_arco_detalle(Long tipo_registro, String fecha_hora, String nombre_arco, String descripcion, String placa_niv, String fuente_informacion) {
        this.tipo_registro = tipo_registro;
        this.fecha_hora = fecha_hora;
        this.nombre_arco = nombre_arco;
        this.descripcion = descripcion;
        this.placa_niv = placa_niv;
        this.fuente_informacion = fuente_informacion;
    }

    public Long getTipo_registro() {
        return tipo_registro;
    }

    public void setTipo_registro(Long tipo_registro) {
        this.tipo_registro = tipo_registro;
    }

    public String getFecha_hora() {
        return fecha_hora;
    }

    public void setFecha_hora(String fecha_hora) {
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

    public String getPlaca_niv() {
        return placa_niv;
    }

    public void setPlaca_niv(String placa_niv) {
        this.placa_niv = placa_niv;
    }

    public String getFuente_informacion() {
        return fuente_informacion;
    }

    public void setFuente_informacion(String fuente_informacion) {
        this.fuente_informacion = fuente_informacion;
    }
    
}
