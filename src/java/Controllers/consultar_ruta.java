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
public class consultar_ruta {
    private Conexion connec;
    Conexion cn = new Conexion();
    Connection con;
    PreparedStatement ps;
    ResultSet rs;
    Model.lectura_vehiculo lv = new Model.lectura_vehiculo();
    
    
    @RequestMapping("consultar_ruta.htm")
    protected org.springframework.web.servlet.ModelAndView index(HttpServletResponse response, HttpServletRequest request) throws IOException {
        HttpSession session = request.getSession(false);
        org.springframework.web.servlet.ModelAndView mav = new org.springframework.web.servlet.ModelAndView();

         mav.setViewName("consultar_ruta");
        
        return mav;      
    }
    
    @RequestMapping(value = "buscar_ruta.htm", method = RequestMethod.GET)
    public void buscar_ruta(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        
        response.setContentType("application/json"); 
        PrintWriter out = response.getWriter(); 
        
        String ruta = request.getParameter("ruta"); 
                 
        JSONArray unidades = new JSONArray();
        
        try {
            rs = Conexion.query("SELECT id_ruta,nombre FROM cat_ruta WHERE nombre::text iLIKE '%"+ruta+"%'");          
            
            while(rs.next()){
                Map m = new LinkedHashMap(2);
                m.put("id_ruta", rs.getString(1));
                m.put("nombre", rs.getString(2));
                unidades.add(m); 
            }
            
        } catch (SQLException e) {
            System.err.print(e);
        }
        
        out.println(unidades);
    }
    
    @RequestMapping(value = "obtener_datos_ruta.htm", method = RequestMethod.POST)
    public void obtener_datos_ruta(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException, JSONException {
        
        response.setContentType("application/json");
        PrintWriter out = response.getWriter();
        
        String id_ruta = request.getParameter("id_ruta");
        System.out.println(id_ruta);
        String kmz = "";
        
        JSONArray unidades = new JSONArray();
        JSONObject datos = new JSONObject();
        
        try {
            rs = Conexion.query("SELECT id_ruta,id_capa,nombre,numero,\"KMZ\" FROM cat_ruta WHERE id_ruta = "+id_ruta+";");
            
            while(rs.next()){
                datos.put("id_ruta", rs.getString(1));
                datos.put("id_capa", rs.getString(2));
                datos.put("nombre", rs.getString(3));
                datos.put("numero", rs.getString(4));  
                kmz = rs.getString(5); 
            }
            
            rs.close();
            
            JSONParser parser = new JSONParser();
            JSONArray json = (JSONArray) parser.parse(kmz);
            datos.put("kmz",json);
            
        } catch (SQLException | JSONException | ParseException e) {
            System.err.print(e);
        }
        
        try {
            rs = Conexion.query("SELECT u.id_unidad, u.no_unidad\n" +
            "FROM ruta_unidad ru INNER JOIN cat_unidad u on ru.id_unidad = u.id_unidad\n" +
            "WHERE ru.id_ruta =  "+id_ruta+";");

            while(rs.next()){
                Map m = new LinkedHashMap(2);
                m.put("id_unidad", rs.getString(1));
                m.put("no_unidad", rs.getString(2));
                unidades.add(m);
            }
            
            datos.put("unidades",unidades);

            rs.close();
            
        } catch (SQLException e) {
            System.err.print(e);
        }
        
        out.println(datos);
    }
    
    @RequestMapping(value = "editar_ruta.htm", method = RequestMethod.POST)
    public void editar_ruta(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        
        response.setContentType("application/json");
        PrintWriter out = response.getWriter();
        
        String id_ruta = request.getParameter("id_ruta");
        String nombre = request.getParameter("nombre");
        String numero = request.getParameter("numero");
        String kmz = request.getParameter("kmz");
        String id_capa = request.getParameter("id_capa");
        String fecha_actualizacion = request.getParameter("fecha_actualizacion");
        
        JSONObject datos = new JSONObject();
        
        try {
            
            rs = Conexion.query("UPDATE cat_ruta SET id_capa = "+id_capa+", nombre = '"+nombre+"', numero = "+numero+", \"KMZ\" = '"+kmz+"' ,fecha_actualizacion = '"+fecha_actualizacion+"' WHERE id_ruta = "+id_ruta+"  RETURNING id_ruta, nombre;"); 
            
            while(rs.next()){
                datos.put("id_ruta", rs.getString(1));
                datos.put("nombre", rs.getString(2));   
            }
            
            rs.close();
            
        } catch (SQLException | JSONException e) {
            System.err.print(e);
        }
        
        out.println(datos);
    }
    
    @RequestMapping(value = "deshabilitar_ruta.htm", method = RequestMethod.POST)
    public void deshabilitar_ramal(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        
        response.setContentType("application/json");
        PrintWriter out = response.getWriter();
        
        String id_ruta = request.getParameter("id_ruta");
        String statusRuta = request.getParameter("statusRuta");
        String fecha_actualizacion = request.getParameter("fecha_actualizacion"); 
        
        JSONObject datos = new JSONObject();
        
        try {
            rs = Conexion.query("UPDATE cat_ruta SET \"statusRuta\" = '"+statusRuta+"', fecha_actualizacion = '"+fecha_actualizacion+"' WHERE id_ruta = "+id_ruta+"  RETURNING id_ruta,nombre;");
            
            while(rs.next()){
                datos.put("id_ruta", rs.getString(1)); 
                datos.put("nombre", rs.getString(2));
            }
            
            rs.close();
            
        } catch (SQLException | JSONException e) {
            System.err.print(e);
        }
        out.println(datos);
    }
    
    @RequestMapping(value = "eliminar_ruta.htm", method = RequestMethod.POST)
    public void eliminar_ramal(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        
        response.setContentType("application/json");
        PrintWriter out = response.getWriter();
        
        String id_ruta = request.getParameter("id_ruta"); 
        
        JSONObject datos = new JSONObject();
        
        try {
            
            rs = 
                Conexion.query("DELETE FROM cat_itinerario WHERE id_ruta = "+id_ruta+"  RETURNING 'Delete cat_itinerario';");
                Conexion.query("DELETE FROM cat_ramal WHERE id_ramal IN (SELECT rr.id_ramal FROM cat_ruta r INNER JOIN ruta_ramal rr on r.id_ruta = rr.id_ruta WHERE r.id_ruta = "+id_ruta+") RETURNING 'Delete cat_ramal';");
                Conexion.query("DELETE FROM ruta_ramal WHERE id_ruta = "+id_ruta+"  RETURNING 'Delete ruta_ramal';");
                Conexion.query("DELETE FROM ruta_unidad WHERE id_ruta = "+id_ruta+"  RETURNING 'Delete ruta_unidad';");
                Conexion.query("DELETE FROM cat_ruta WHERE id_ruta = "+id_ruta+"  RETURNING 'Delete cat_ruta';");  
            
            while(rs.next()){
                datos.put("exito", 1);  
            }
            
            rs.close();
            
        } catch (SQLException | JSONException e) {
            System.err.print(e);
        }
        out.println(datos);
    }
}
