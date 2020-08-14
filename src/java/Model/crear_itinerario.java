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
public class crear_itinerario {
    
    public crear_itinerario(Integer id_itinerario, Integer id_ruta, String nombre, Boolean statusItinerario, String KMZ, Date fecha_registro) {
        this.id_itinerario = id_itinerario;
        this.id_ruta = id_ruta;
        this.nombre = nombre;
        this.statusItinerario = statusItinerario;
        this.KMZ = KMZ;
        this.fecha_registro = fecha_registro;
    }
    
    private Integer id_itinerario;
    private Integer id_ruta;
    private String nombre;
    private Boolean statusItinerario;
    private String KMZ;
    private Date fecha_registro;

    public Integer getId_itinerario() {
        return id_itinerario;
    }

    public void setId_itinerario(Integer id_itinerario) {
        this.id_itinerario = id_itinerario;
    }

    public Integer getId_ruta() {
        return id_ruta;
    }

    public void setId_ruta(Integer id_ruta) {
        this.id_ruta = id_ruta;
    }

    public String getNombre() {
        return nombre;
    }

    public void setNombre(String nombre) {
        this.nombre = nombre;
    }

    public Boolean getStatusItinerario() {
        return statusItinerario;
    }

    public void setStatusItinerario(Boolean statusItinerario) {
        this.statusItinerario = statusItinerario;
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
    
    
}
