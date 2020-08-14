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
import java.util.LinkedHashMap;
import java.util.Map;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import org.json.JSONException;
import org.json.simple.JSONArray;
import org.json.JSONObject;
import org.json.simple.parser.JSONParser;
import org.json.simple.parser.ParseException;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;


/**
 *
 * @author Carlos Larios
 */
public class crear_ruta {
    
    private Conexion connec;
    Conexion cn = new Conexion();
    Connection con;
    PreparedStatement ps;
    ResultSet rs;
    Model.lectura_vehiculo lv = new Model.lectura_vehiculo();
    
    
    @RequestMapping("crear_ruta.htm")
    protected org.springframework.web.servlet.ModelAndView index(HttpServletResponse response, HttpServletRequest request) throws IOException {
        HttpSession session = request.getSession(false);
        org.springframework.web.servlet.ModelAndView mav = new org.springframework.web.servlet.ModelAndView();

         mav.setViewName("crear_ruta");
        
        return mav;
    }
    
    @RequestMapping(value = "registrar_ruta.htm", method = RequestMethod.POST)
    public void registrar_ruta(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException, ParseException, JSONException {
        
        response.setContentType("application/json");
        PrintWriter out = response.getWriter(); 
           
        String nombre = request.getParameter("nombre");
        String numero = request.getParameter("numero");
        String id_capa = request.getParameter("id_capa");
        String kmz = request.getParameter("kmz");
        String unidades = request.getParameter("unidades");
        String statusRuta = request.getParameter("statusRuta");
        String fecha_registro = request.getParameter("fecha_registro");         
        String id_ruta = "";
        String variable = "";
        
        JSONParser parser = new JSONParser();
        JSONArray json = (JSONArray) parser.parse(unidades);
        System.out.println(json);
        
        
        JSONObject datos = new JSONObject(); 
         
        try {
            //rs = Conexion.queryPS(query, unidad);
            rs = Conexion.query("INSERT INTO cat_ruta(id_capa,nombre,\"statusRuta\",numero,\"KMZ\",fecha_registro) VALUES("+id_capa+",'"+nombre+"','"+statusRuta+"',"+numero+",'"+kmz+"','"+fecha_registro+"') RETURNING id_ruta, nombre;");
            while(rs.next()){
                datos.put("id_ruta",rs.getString(1));
                datos.put("nombre",rs.getString(2));
                id_ruta =  rs.getString(1); 
            }
            
        } catch (SQLException e) {
            System.err.print(e);
        }
        
        
        for (int i=0; i < json.size(); i++) {
            variable += "("+id_ruta+","+json.get(i)+"),";
            //System.out.println(json.get(i));
        }
        
        String var = variable.substring(0, variable.length() - 1);
        
        try {
            //rs = Conexion.queryPS(query, unidad);
            rs = Conexion.query("INSERT INTO ruta_unidad(id_ruta,id_unidad) VALUES "+var+" RETURNING 0;");
            
            while(rs.next()){   
                datos.put("exito",1);
            }
            
        } catch (SQLException | JSONException e) {
            System.err.print(e);
        }
  
        out.println(datos);
    }
    
    @RequestMapping(value = "validar_ruta.htm", method = RequestMethod.POST)
    public void validar_ruta(HttpServletRequest request, HttpSession session, HttpServletResponse response) throws ServletException, IOException {
        
        response.setContentType("application/json");
        PrintWriter out = response.getWriter();
        
        String nombre = request.getParameter("nombre");
        System.out.println(nombre);
         
        org.json.simple.JSONObject datos = new org.json.simple.JSONObject();
        
        try {
            rs = Conexion.query("SELECT nombre FROM cat_ruta WHERE UPPER(nombre) = UPPER('"+nombre+"')");
             
            while(rs.next()){
                datos.put("nombre",rs.getString(1)); 
            } 
            
        } catch (SQLException e) {
            System.err.print(e);
        }
                
        out.println(datos); 
    }
    
    @RequestMapping(value = "buscar_unidad.htm", method = RequestMethod.GET)
    public void buscar_unidad(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        
        response.setContentType("application/json");
        PrintWriter out = response.getWriter();
        
        String unidad = request.getParameter("unidad");
                 
        JSONArray unidades = new JSONArray(); 
        
        try {
            rs = Conexion.query("SELECT id_unidad, no_unidad, \"NIV\" FROM cat_unidad WHERE no_unidad::text LIKE '%"+unidad+"%'");
            
            while(rs.next()){
                Map m = new LinkedHashMap(2);
                m.put("id_unidad", rs.getString(1));
                m.put("no_unidad", rs.getString(2));  
                m.put("niv", rs.getString(3));
                unidades.add(m);
            }
            
        } catch (Exception e) {
            System.err.print(e);
        }
        
        out.println(unidades);
    } 
    
}
