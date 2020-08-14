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
public class lectura_vehiculo_detalle {
    //Alerta
    int tipo_registro;
    String fecha_hora;
    String nombre_arco;
    String descripcion;
    String placa_niv;
    String fuente_informacion;
    // Vehiculo
    String tipo_vehiculo;
    String marca;
    String color;
    String placa;
    String niv;

    public lectura_vehiculo_detalle(int tipo_registro, String fecha_hora, String nombre_arco, String descripcion, String placa_niv, String fuente_informacion, String tipo_vehiculo, String marca, String color, String placa, String niv) {
        this.tipo_registro = tipo_registro;
        this.fecha_hora = fecha_hora;
        this.nombre_arco = nombre_arco;
        this.descripcion = descripcion;
        this.placa_niv = placa_niv;
        this.fuente_informacion = fuente_informacion;
        this.tipo_vehiculo = tipo_vehiculo;
        this.marca = marca;
        this.color = color;
        this.placa = placa;
        this.niv = niv;
    }

    public lectura_vehiculo_detalle() {
    }

    public int getTipo_registro() {
        return tipo_registro;
    }

    public void setTipo_registro(int tipo_registro) {
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

    public String getTipo_vehiculo() {
        return tipo_vehiculo;
    }

    public void setTipo_vehiculo(String tipo_vehiculo) {
        this.tipo_vehiculo = tipo_vehiculo;
    }

    public String getMarca() {
        return marca;
    }

    public void setMarca(String marca) {
        this.marca = marca;
    }

    public String getColor() {
        return color;
    }

    public void setColor(String color) {
        this.color = color;
    }

    public String getPlaca() {
        return placa;
    }

    public void setPlaca(String placa) {
        this.placa = placa;
    }

    public String getNiv() {
        return niv;
    }

    public void setNiv(String niv) {
        this.niv = niv;
    }
}
