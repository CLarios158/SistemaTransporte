/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package Controllers;

import Config.Conexion;
import Model.Itinerario;
import java.io.IOException; 
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
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
public class consultar_itinerario {
    private Conexion connec;
    Conexion cn = new Conexion();
    Connection con;
    PreparedStatement ps;
    ResultSet rs;
    Model.lectura_vehiculo lv = new Model.lectura_vehiculo();
   
    
    @RequestMapping("consultar_itinerario.htm")
    protected org.springframework.web.servlet.ModelAndView index(HttpServletResponse response, HttpServletRequest request) throws IOException {
        HttpSession session = request.getSession(false);
        org.springframework.web.servlet.ModelAndView mav = new org.springframework.web.servlet.ModelAndView();
        
        mav.setViewName("consultar_itinerario");
        ArrayList<Itinerario> itinerarios = new ArrayList<>();
        
        try {
            rs = Conexion.query("SELECT id_itinerario,nombre FROM cat_itinerario;");
             
             while(rs.next()){
                itinerarios.add(new Itinerario( 
                    rs.getInt(1), 
                    rs.getString(2)    
                ));  
            }
             
            //rs.close();
            
            mav.addObject("itinerarios", itinerarios);
            
        } catch (SQLException e) {
            System.err.print(e);
        }
        
        return mav;
    }
    
    @RequestMapping(value = "obtener_datos_itinerario.htm", method = RequestMethod.POST)
    public void obtener_datos_itinerario(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        
        response.setContentType("application/json");
        PrintWriter out = response.getWriter();
        
        String id_itinerario = request.getParameter("id_itinerario");
        String kmz = "";
        JSONObject datos = new JSONObject();
        
        try {
            rs = Conexion.query("SELECT i.id_itinerario, i.nombre, i.\"KMZ\", i.id_ruta, i.id_unidad, u.no_unidad FROM cat_itinerario i INNER JOIN cat_unidad u on i.id_unidad = u.id_unidad WHERE id_itinerario = "+id_itinerario+";");
            
            while(rs.next()){
                datos.put("id_itinerario", rs.getString(1)); 
                datos.put("nombre", rs.getString(2));
                kmz = rs.getString(3);
                datos.put("id_ruta", rs.getString(4));
                datos.put("id_unidad", rs.getString(5));
                datos.put("no_unidad", rs.getString(6));   
            }
            
            rs.close();
            
            JSONParser parser = new JSONParser();
            JSONArray json = (JSONArray) parser.parse(kmz);
            datos.put("kmz",json);
            
        } catch (SQLException | JSONException | ParseException e) {
            System.err.print(e);
        }
        out.println(datos);
    }
    
    @RequestMapping(value = "deshabilitar_itinerario.htm", method = RequestMethod.POST)
    public void deshabilitar_itinerario(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        
        response.setContentType("application/json");
        PrintWriter out = response.getWriter();
        
        String id_itinerario = request.getParameter("id_itinerario");
        String statusItinerario = request.getParameter("statusItinerario");
        String fecha_actualizacion = request.getParameter("fecha_actualizacion");
        
        JSONObject datos = new JSONObject();
        
        try {
            rs = Conexion.query("UPDATE cat_itinerario SET \"statusItinerario\" = '"+statusItinerario+"', fecha_actualizacion = '"+fecha_actualizacion+"' WHERE id_itinerario = "+id_itinerario+"  RETURNING id_itinerario, nombre;");
            
            while(rs.next()){
                datos.put("id_itinerario", rs.getString(1));
                datos.put("nombre", rs.getString(2)); 
            }
            
            rs.close();  
            
        } catch (SQLException | JSONException e) {
            System.err.print(e);
        }
        out.println(datos);
    }
    
    @RequestMapping(value = "eliminar_itinerario.htm", method = RequestMethod.POST)
    public void eliminar_itinerario(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        
        response.setContentType("application/json");
        PrintWriter out = response.getWriter();
        
        String id_itinerario = request.getParameter("id_itinerario");
        
        JSONObject datos = new JSONObject();
        
        try {
            rs = Conexion.query("DELETE FROM cat_itinerario WHERE id_itinerario = "+id_itinerario+"  RETURNING 0;");
            
            while(rs.next()){
                datos.put("estado", 1);
            }
            
            rs.close();
            
        } catch (SQLException | JSONException e) {
            System.err.print(e);
        }
        
        out.println(datos);
    }
    
    @RequestMapping(value = "editar_itinerario.htm", method = RequestMethod.POST)
    public void editar_itinerario(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        
        response.setContentType("application/json");
        PrintWriter out = response.getWriter();
        
        String id_itinerario = request.getParameter("id_itinerario"); 
        String nombre = request.getParameter("nombre");
        String id_ruta = request.getParameter("id_ruta"); 
        String id_unidad = request.getParameter("id_unidad");
        String kmz = request.getParameter("kmz");
        String fecha_actualizacion = request.getParameter("fecha_actualizacion");
        
        JSONObject datos = new JSONObject(); 
        
        try {
            rs = Conexion.query("UPDATE cat_itinerario SET nombre = '"+nombre+"', id_ruta = "+id_ruta+", id_unidad = "+id_unidad+", \"KMZ\" = '"+kmz+"', fecha_actualizacion = '"+fecha_actualizacion+"' WHERE id_itinerario = "+id_itinerario+" RETURNING id_itinerario, nombre;");
            
            while(rs.next()){
                datos.put("id_itinerario", rs.getString(1));
                datos.put("nombre", rs.getString(2));
            }
            
            rs.close();
            
        } catch (SQLException | JSONException e) {
            System.err.print(e);
        }
        
        out.println(datos);
    }
}
