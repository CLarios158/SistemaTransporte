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
import org.json.simple.parser.ParseException;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

/**
 *
 * @author Carlos Larios
 */
public class crear_itinerario {
    
    PreparedStatement ps;
    ResultSet rs;
    Statement s;
    
    
    @RequestMapping("crear_itinerario.htm")
    protected org.springframework.web.servlet.ModelAndView index(HttpServletResponse response, HttpServletRequest request) throws IOException, SQLException {
        
        Conexion Conexion = new Conexion();
        
        HttpSession session = request.getSession(false);
        org.springframework.web.servlet.ModelAndView mav = new org.springframework.web.servlet.ModelAndView();

        mav.setViewName("crear_itinerario"); 
         
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
    
    
    @RequestMapping(value = "registrar_itinerario.htm", method = RequestMethod.POST)
    public void registrar_itinerario(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException, ParseException, JSONException, SQLException {
        
        Conexion Conexion = new Conexion();
        
        response.setContentType("application/json");
        PrintWriter out = response.getWriter();
           
        String nombre = request.getParameter("nombre");
        String id_ruta = request.getParameter("id_ruta"); 
        String id_unidad = request.getParameter("id_unidad");
        String kmz = request.getParameter("kmz");
        String statusItinerario = request.getParameter("statusItinerario");
        String fecha_registro = request.getParameter("fecha_registro");

        JSONObject datos = new JSONObject();
         
        try {
            s = Conexion.update("INSERT INTO cat_itinerario(nombre,\"statusItinerario\",fecha_registro,\"KMZ\",id_ruta,id_unidad) VALUES('"+nombre+"','"+statusItinerario+"','"+fecha_registro+"','"+kmz+"',"+id_ruta+","+id_unidad+");");
            
            rs = s.getGeneratedKeys(); //Obtener el id que se genero al realizar el INSERT
            
        } catch (SQLException e) {
            System.err.print(e);
        } finally {
            if (Conexion != null) { Conexion.executeQueryCloseUpdate(); System.out.println("close conexion"); }
            if (rs != null) { rs.close(); System.out.println("close rs"); }
        }
         
        out.println(datos);
    }
    
    @RequestMapping(value = "validar_itinerario.htm", method = RequestMethod.POST)
    public void validar_itinerario(HttpServletRequest request, HttpSession session, HttpServletResponse response) throws ServletException, IOException, SQLException {
        
        Conexion Conexion = new Conexion();
        
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
        } finally {
            if (Conexion != null) { Conexion.executeQueryClose(); System.out.println("close conexion"); }
            if (rs != null) { rs.close(); System.out.println("close rs"); }  
        }
                
        out.println(datos); 
    }
    
    @RequestMapping(value = "buscar_unidad_itinerario.htm", method = RequestMethod.GET)
    public void buscar_unidad_itinerario(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException, SQLException {
        
        Conexion Conexion = new Conexion();
        
        response.setContentType("application/json");
        PrintWriter out = response.getWriter();
        
        String unidad = request.getParameter("unidad"); 
        String id_ruta = request.getParameter("id_ruta");
                 
        JSONArray unidades = new JSONArray(); 
        
        try {
            rs = Conexion.query("SELECT u.id_unidad, u.no_unidad, u.\"NIV\" \n" +
                "FROM cat_unidad u INNER JOIN ruta_unidad ru on u.id_unidad = ru.id_unidad\n" +
                "WHERE u.no_unidad::text LIKE '%"+unidad+"%' \n" +
                "AND ru.id_ruta = "+id_ruta+" \n" +
                "AND u.id_unidad not in (select id_unidad from cat_itinerario) ");
            
            while(rs.next()){
                Map m = new LinkedHashMap(2);
                m.put("id_unidad", rs.getString(1));     
                m.put("no_unidad", rs.getString(2));  
                m.put("niv", rs.getString(3)); 
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
}
