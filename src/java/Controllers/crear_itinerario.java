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
public class crear_itinerario {
    private Conexion connec;
    Conexion cn = new Conexion();
    Connection con;
    PreparedStatement ps;
    ResultSet rs;
    Model.lectura_vehiculo lv = new Model.lectura_vehiculo();
    
    
    @RequestMapping("crear_itinerario.htm")
    protected org.springframework.web.servlet.ModelAndView index(HttpServletResponse response, HttpServletRequest request) throws IOException {
        HttpSession session = request.getSession(false);
        org.springframework.web.servlet.ModelAndView mav = new org.springframework.web.servlet.ModelAndView();

         mav.setViewName("crear_itinerario"); 
        
        return mav;
    }
    
    
    @RequestMapping(value = "registrar_itinerario.htm", method = RequestMethod.POST)
    public void registrar_itinerario(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException, ParseException, JSONException {
        
        response.setContentType("application/json");
        PrintWriter out = response.getWriter();
           
        String nombre = request.getParameter("nombre");
        String id_ruta = request.getParameter("id_ruta"); 
        String id_unidad = request.getParameter("id_unidad");
        String kmz = request.getParameter("kmz");
        String statusItinerario = request.getParameter("statusItinerario");
        String fecha_registro = request.getParameter("fecha_registro");
                       
        System.out.println(kmz);
        JSONObject datos = new JSONObject();
         
        try {
            rs = Conexion.query("INSERT INTO cat_itinerario(nombre,\"statusItinerario\",fecha_registro,\"KMZ\",id_ruta,id_unidad) VALUES('"+nombre+"','"+statusItinerario+"','"+fecha_registro+"','"+kmz+"',"+id_ruta+","+id_unidad+") RETURNING id_itinerario, nombre;");
            
            while(rs.next()){
                datos.put("id_itinerario", rs.getString(1));
                datos.put("nombre", rs.getString(2));
            }
            
        } catch (SQLException e) {
            System.err.print(e);
        }
         
        out.println(datos);
    }
    
    @RequestMapping(value = "validar_itinerario.htm", method = RequestMethod.POST)
    public void validar_itinerario(HttpServletRequest request, HttpSession session, HttpServletResponse response) throws ServletException, IOException {
        
        response.setContentType("application/json");
        PrintWriter out = response.getWriter();
        
        String nombre = request.getParameter("nombre");
        System.out.println(nombre);
         
        org.json.simple.JSONObject datos = new org.json.simple.JSONObject();
        
        try {
            rs = Conexion.query("SELECT nombre FROM cat_itinerario WHERE UPPER(nombre) = UPPER('"+nombre+"')");
            
            while(rs.next()){
                datos.put("nombre",rs.getString(1)); 
            } 
            
        } catch (SQLException e) {
            System.err.print(e);
        }
                
        out.println(datos); 
    }
}
