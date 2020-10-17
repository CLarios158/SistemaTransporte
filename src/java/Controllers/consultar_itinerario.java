/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package Controllers;

import Config.Conexion;
import java.io.IOException; 
import java.io.PrintWriter;
import java.sql.Statement;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
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
public class consultar_itinerario {
    
    PreparedStatement ps;
    ResultSet rs;
    Statement s;
    
    @RequestMapping("consultar_itinerario.htm")
    protected org.springframework.web.servlet.ModelAndView index(HttpServletResponse response, HttpServletRequest request) throws IOException, SQLException {
        
        Conexion Conexion = new Conexion();
        
        HttpSession session = request.getSession(false);
        org.springframework.web.servlet.ModelAndView mav = new org.springframework.web.servlet.ModelAndView();

        mav.setViewName("consultar_itinerario");
         
        ArrayList<Model.consultar_ruta> rutas_option;
        rutas_option = new ArrayList<>();
        
        try {
            rs = Conexion.query("SELECT id_ruta, nombre FROM cat_ruta;");
            
            while(rs.next()){ 
                rutas_option.add(new Model.consultar_ruta(
                    rs.getInt("id_ruta"),
                    rs.getString("nombre")
                ));
            }
            
            mav.addObject("rutas_option", rutas_option);
            
        } catch (SQLException e) {
            System.err.print(e);
        } finally {
            if (Conexion != null) { Conexion.executeQueryClose(); System.out.println("close conexion"); }
            if (rs != null) { rs.close(); System.out.println("close rs"); }  
        }
        
        return mav;
    }
   
    @RequestMapping(value = "buscar_itinerario.htm", method = RequestMethod.GET)
    public void buscar_itinerario(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException, SQLException {
        
        Conexion Conexion = new Conexion();
        
        response.setContentType("application/json");
        PrintWriter out = response.getWriter();
        
        String itinerario = request.getParameter("itinerario");
                 
        JSONArray unidades = new JSONArray();
        
        try {
            rs = Conexion.query("SELECT id_itinerario,nombre,\"statusItinerario\" FROM cat_itinerario WHERE nombre::text iLIKE '%"+itinerario+"%'");
            
            while(rs.next()){ 
                Map m = new LinkedHashMap(2);
                m.put("id_itinerario", rs.getString(1));
                m.put("nombre", rs.getString(2)); 
                m.put("estatus", rs.getString(3)); 
                unidades.add(m);
            }
            
        } catch (SQLException e) {
            System.err.print(e);
        } finally {
            if (Conexion != null) { Conexion.executeQueryClose(); System.out.println("close conexion"); }
            if (rs != null) { rs.close(); System.out.println("close rs"); }  
        }
        
        out.println(unidades);
    }
    
    @RequestMapping(value = "obtener_datos_itinerario.htm", method = RequestMethod.POST)
    public void obtener_datos_itinerario(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException, SQLException {
        
        Conexion Conexion = new Conexion();
        
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
            
            JSONParser parser = new JSONParser();
            JSONArray json = (JSONArray) parser.parse(kmz);
            datos.put("kmz",json);
            
        } catch (SQLException | JSONException | ParseException e) {
            System.err.print(e);
        } finally {
            if (Conexion != null) { Conexion.executeQueryClose(); System.out.println("close conexion"); }
            if (rs != null) { rs.close(); System.out.println("close rs"); }  
        }

        out.println(datos);
    }
    
    @RequestMapping(value = "deshabilitar_itinerario.htm", method = RequestMethod.POST)
    public void deshabilitar_itinerario(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException, SQLException {
        
        Conexion Conexion = new Conexion();
        
        response.setContentType("application/json");
        PrintWriter out = response.getWriter();
        
        String id_itinerario = request.getParameter("id_itinerario");
        String statusItinerario = request.getParameter("statusItinerario");
        String fecha_actualizacion = request.getParameter("fecha_actualizacion");
        
        JSONObject datos = new JSONObject();
        
        try {
            
            s = Conexion.update("UPDATE cat_itinerario SET \"statusItinerario\" = '"+statusItinerario+"', fecha_actualizacion = '"+fecha_actualizacion+"' WHERE id_itinerario = "+id_itinerario+"  RETURNING id_itinerario, nombre;");
            rs = s.getGeneratedKeys();
            
        } catch (SQLException e) {
            System.err.print(e);
        } finally {
            if (Conexion != null) { Conexion.executeQueryCloseUpdate(); System.out.println("close conexion"); }
            if (rs != null) { rs.close(); System.out.println("close rs"); }
        }
        
        try {

            rs = Conexion.query("SELECT nombre FROM cat_itinerario WHERE id_itinerario = "+id_itinerario+"");
            
            while(rs.next()){ 
                datos.put("nombre", rs.getString(1));
            }
           
        } catch (SQLException | JSONException e) {
            System.err.print("ERROR:"+e);
        } finally {
            if (Conexion != null) { Conexion.executeQueryClose(); System.out.println("close conexion"); }
            if (rs != null) { rs.close(); System.out.println("close rs"); }   
        }
        
        out.println(datos);
    }
    
    @RequestMapping(value = "eliminar_itinerario.htm", method = RequestMethod.POST)
    public void eliminar_itinerario(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        
        Conexion Conexion = new Conexion();
        
        response.setContentType("application/json");
        PrintWriter out = response.getWriter();
        
        String id_itinerario = request.getParameter("id_itinerario");
        
        JSONObject datos = new JSONObject();
        
        try {
            
            s = Conexion.update("DELETE FROM cat_itinerario WHERE id_itinerario = "+id_itinerario+";");
            
            datos.put("exito", 1); 
            
        } catch (JSONException e) {
            System.err.print(e);
        } finally {
            if (Conexion != null) { Conexion.executeQueryCloseUpdate(); System.out.println("close conexion"); }  
        }
        
        out.println(datos);
    }
    
    @RequestMapping(value = "editar_itinerario.htm", method = RequestMethod.POST)
    public void editar_itinerario(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException, SQLException {
        
        Conexion Conexion = new Conexion();
        
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
            
            s = Conexion.update("UPDATE cat_itinerario SET nombre = '"+nombre+"', id_ruta = "+id_ruta+", id_unidad = "+id_unidad+", \"KMZ\" = '"+kmz+"', fecha_actualizacion = '"+fecha_actualizacion+"' WHERE id_itinerario = "+id_itinerario+";");
            rs = s.getGeneratedKeys();
            
        } catch (SQLException e) {
            System.err.print(e);
        } finally {
            if (Conexion != null) { Conexion.executeQueryCloseUpdate(); System.out.println("close conexion"); }
            if (rs != null) { rs.close(); System.out.println("close rs"); }
        }
        
        out.println(datos);
    }
}
