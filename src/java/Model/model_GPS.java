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
public class model_GPS {
    
    public model_GPS(int id_model, String nombre) {
        this.id_model = id_model;
        this.nombre = nombre;
    }
    
    public model_GPS(Integer id_model, String nombre) {
        this.id_model = id_model;
        this.nombre = nombre;
    }
    
    private Integer id_model;
    private String nombre;

    public Integer getId_model() {
        return id_model;
    }

    public void setId_model(Integer id_model) {
        this.id_model = id_model;
    }

    public String getNombre() {
        return nombre;
    }

    public void setNombre(String nombre) {
        this.nombre = nombre;
    }
    
    
    
}
