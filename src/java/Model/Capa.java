/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package Model;

/**
 *
 * @author Carlos Larios
 */
public class Capa {
    
    private int id;
    private int estatus;
    private String nombre, icon, kmz;

    public Capa(int id, String nombre, String icon, String kmz, int estatus) {
        this.id = id;
        this.nombre = nombre;
        this.icon = icon;
        this.estatus = estatus;
        this.kmz = kmz;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getEstatus() {
        return estatus;
    }

    public void setEstatus(int estatus) {
        this.estatus = estatus;
    }

    public String getNombre() {
        return nombre;
    }

    public void setNombre(String nombre) {
        this.nombre = nombre;
    }

    public String getIcon() {
        return icon;
    }

    public void setIcon(String icon) {
        this.icon = icon;
    }

    public String getKmz() {
        return kmz;
    }

    public void setKmz(String kmz) {
        this.kmz = kmz;
    }



   
    
}
