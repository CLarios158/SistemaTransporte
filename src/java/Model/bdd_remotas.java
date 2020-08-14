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


public class bdd_remotas {
    
    private String nombre;
    private Long accesodatos;

    public bdd_remotas(String nombre, Long accesodatos) {
        this.nombre = nombre;
        this.accesodatos = accesodatos;
    }
    
    public String getNombre() {
        return nombre;
    }

    public void setNombre(String nombre) {
        this.nombre = nombre;
    }

    public Long getAccesodatos() {
        return accesodatos;
    }

    public void setAccesodatos(Long accesodatos) {
        this.accesodatos = accesodatos;
    }
    
    
    
}
