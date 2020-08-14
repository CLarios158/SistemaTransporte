/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package Controllers;

import Config.Conexion;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import org.json.JSONException;
import org.json.JSONObject;
import org.json.simple.JSONArray;
import org.json.simple.parser.JSONParser;
import org.json.simple.parser.ParseException;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

/**
 *
 * @author Carlos Larios
 */
public class crear_ramal {
    
    private Conexion connec;
    Conexion cn = new Conexion();
    Connection con;
    PreparedStatement ps;
    ResultSet rs;
    Model.lectura_vehiculo lv = new Model.lectura_vehiculo();
    
    
    @RequestMapping("crear_ramal.htm")
    protected org.springframework.web.servlet.ModelAndView index(HttpServletResponse response, HttpServletRequest request) throws IOException {
        HttpSession session = request.getSession(false);
        org.springframework.web.servlet.ModelAndView mav = new org.springframework.web.servlet.ModelAndView();

         mav.setViewName("crear_ramal");
        
        return mav;
    }
    
    @RequestMapping(value = "registrar_ramal.htm", method = RequestMethod.POST)
    public void registrar_ramal(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException, ParseException, JSONException {
        
        response.setContentType("application/json");
        PrintWriter out = response.getWriter();
           
        String nombre = request.getParameter("nombre");
        String numero = request.getParameter("numero");
        String id_ruta = request.getParameter("id_ruta");
        String kmz = request.getParameter("kmz");
        String unidades = request.getParameter("unidades");
        String statusRamal = request.getParameter("statusRamal");
        String fecha_registro = request.getParameter("fecha_registro");
        String id_ramal = "";
        String variable = "";
        
        JSONParser parser = new JSONParser();
        JSONArray json = (JSONArray) parser.parse(unidades);
        
        
        JSONObject datos = new JSONObject();
         
        try {
            rs = Conexion.query("INSERT INTO cat_ramal(nombre,numero,\"statusRamal\",\"KMZ\",fecha_registro) VALUES('"+nombre+"',"+numero+",'"+statusRamal+"','"+kmz+"','"+fecha_registro+"') RETURNING id_ramal, nombre;");
            
            while(rs.next()){
                id_ramal =  rs.getString(1);
                datos.put("id_ramal",rs.getString(1)); 
                datos.put("nombre",rs.getString(2));   
            }
            
        } catch (SQLException e) {
            System.err.print(e);
        }
        
        try {
            rs = Conexion.query("INSERT INTO ruta_ramal(id_ruta,id_ramal) VALUES("+id_ruta+","+id_ramal+") RETURNING 0;");
            
            while(rs.next()){ 
            }
            
        } catch (SQLException e) {
            System.err.print(e);
        }
        
        for (int i=0; i < json.size(); i++) {
            variable += "("+id_ramal+","+json.get(i)+"),";
            //System.out.println(json.get(i));
        }
        
        String var = variable.substring(0, variable.length() - 1);
        
        try {
            rs = Conexion.query("INSERT INTO ramal_unidad(id_ramal,id_unidad) VALUES "+var+" RETURNING 0;");
            
            while(rs.next()){       
            }
            
        } catch (SQLException e) {
            System.err.print(e);
        }
  
        out.println(datos);
    }
    
    @RequestMapping(value = "obtener_kmz_ruta.htm", method = RequestMethod.POST)
    public void deshabilitar_ramal(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException, ParseException {
        
        response.setContentType("application/json");
        PrintWriter out = response.getWriter();
        
        String id_ruta = request.getParameter("id_ruta");
        String kmz = "";
        
        JSONObject datos = new JSONObject();
        
        try {
            rs = Conexion.query("SELECT \"KMZ\" FROM cat_ruta WHERE id_ruta = "+id_ruta+" ");
            
            while(rs.next()){
                kmz = rs.getString(1);  
            }
            
            rs.close();
            
            JSONParser parser = new JSONParser();
            JSONArray json = (JSONArray) parser.parse(kmz);
            datos.put("kmz",json);
            
        } catch (SQLException | JSONException e) {
            System.err.print(e);
        }
        out.println(datos);
    }
    
    @RequestMapping(value = "validar_ramal.htm", method = RequestMethod.POST)
    public void validar_ramal(HttpServletRequest request, HttpSession session, HttpServletResponse response) throws ServletException, IOException {
        
        response.setContentType("application/json");
        PrintWriter out = response.getWriter();
        
        String nombre = request.getParameter("nombre");
        System.out.println(nombre);
         
        org.json.simple.JSONObject datos = new org.json.simple.JSONObject();
        
        try {
            rs = Conexion.query("SELECT nombre FROM cat_ramal WHERE UPPER(nombre) = UPPER('"+nombre+"')");
            
            while(rs.next()){
                datos.put("nombre",rs.getString(1)); 
            } 
            
        } catch (SQLException e) {
            System.err.print(e);
        }
                
        out.println(datos); 
    }
    
}
