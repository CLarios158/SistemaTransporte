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
public class consultar_gps {
    
    PreparedStatement ps;
    ResultSet rs;
    Statement s;
    
    
    @RequestMapping("consultar_gps.htm")
    protected org.springframework.web.servlet.ModelAndView index(HttpServletResponse response, HttpServletRequest request) throws IOException, SQLException {
        
        Conexion Conexion = new Conexion();
        
        HttpSession session = request.getSession(false);
        org.springframework.web.servlet.ModelAndView mav = new org.springframework.web.servlet.ModelAndView();
  
        mav.setViewName("consultar_gps"); 
         
        ArrayList<Model.model_GPS> modelos_option;
        modelos_option = new ArrayList<>();
        
        try {
            
            rs = Conexion.query("SELECT \"id_modelo_GPS\", nombre FROM \"cat_modelo_GPS\";");
            
            while(rs.next()){ 
                modelos_option.add(new Model.model_GPS(
                    rs.getInt("id_modelo_GPS"),
                    rs.getString("nombre")
                ));
            }
            mav.addObject("modelos_option", modelos_option); 
            
        } catch (SQLException e) {
            System.err.print(e);
        } finally {
            if (Conexion != null) { Conexion.executeQueryClose(); System.out.println("close conexion"); }
            if (rs != null) { rs.close(); System.out.println("close rs"); }  
        }
        
        return mav;
    }
    
    @RequestMapping(value = "buscar_gps.htm", method = RequestMethod.POST) 
    public void buscar_uniad_gps(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException, ParseException, JSONException, SQLException {
        
        Conexion Conexion = new Conexion();
        
        response.setContentType("application/json");
        PrintWriter out = response.getWriter(); 
           
        String niv = request.getParameter("niv");    
        JSONArray datos = new JSONArray();  
         
        try {
            rs = Conexion.query("SELECT u.id_unidad, u.kilometraje, gu.id_gps, gu.niv, gu.\"no_serie_GPS\", cmg.\"id_modelo_GPS\", cmg.nombre \n" +
                "FROM  cat_unidad u \n" +
                "INNER JOIN \"GPS_unidad\" gu on u.\"NIV\" = gu.niv \n" +
                "INNER JOIN \"cat_modelo_GPS\" cmg on gu.id_modelo_gps = cmg.\"id_modelo_GPS\" \n" +
                "WHERE u.\"NIV\" LIKE '%" + niv + "%';");
            
            while(rs.next()){
                Map m = new LinkedHashMap(2);
                m.put("id_unidad", rs.getString(1));
                m.put("kilometraje", rs.getString(2));
                m.put("id_gps", rs.getString(3));
                m.put("niv", rs.getString(4));
                m.put("no_serie_gps", rs.getString(5));
                m.put("id_modelo_gps", rs.getString(6));
                m.put("nombre", rs.getString(7));
                datos.add(m);
            }
            
        } catch (SQLException e) {
            System.err.print(e);
        } finally {
            if (Conexion != null) { Conexion.executeQueryClose(); System.out.println("close conexion"); }
            if (rs != null) { rs.close(); System.out.println("close rs"); }  
        }
        
        out.println(datos);
    }
    
    @RequestMapping(value = "obtener_datos_gps.htm", method = RequestMethod.POST)
    public void obtener_datos_gps(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException, ParseException, JSONException, SQLException {
        
        Conexion Conexion = new Conexion();
        
        response.setContentType("application/json");
        PrintWriter out = response.getWriter();
           
        String niv = request.getParameter("niv");  
        
        JSONObject datos = new JSONObject();
         
        try {
            rs = Conexion.query("SELECT u.id_unidad, u.kilometraje, gu.id_gps, gu.niv, gu.\"no_serie_GPS\", cmg.\"id_modelo_GPS\", cmg.nombre \n" +
                "FROM  cat_unidad u\n" +
                "INNER JOIN \"GPS_unidad\" gu on u.\"NIV\" = gu.niv \n" +
                "INNER JOIN \"cat_modelo_GPS\" cmg on gu.id_modelo_gps = cmg.\"id_modelo_GPS\" \n" +
                "WHERE u.\"NIV\" = '" + niv + "';");
            
            while(rs.next()){
                datos.put("id_unidad", rs.getString(1));
                datos.put("kilometraje", rs.getString(2));
                datos.put("id_gps", rs.getString(3));
                datos.put("niv", rs.getString(4));
                datos.put("no_serie_gps", rs.getString(5));
                datos.put("id_modelo_gps", rs.getString(6));
                datos.put("nombre", rs.getString(7));
            }
            
        } catch (SQLException | JSONException e) {
            System.err.print(e);
        } finally {
            if (Conexion != null) { Conexion.executeQueryClose(); System.out.println("close conexion"); }
            if (rs != null) { rs.close(); System.out.println("close rs"); }  
        }
        
        out.print(datos);
    }
    
    
    @RequestMapping(value = "actualizar_gps.htm", method = RequestMethod.POST)
    public void actualizar_gps(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException, ParseException, JSONException, SQLException {
            
        Conexion Conexion = new Conexion();
        
        response.setContentType("application/json");
        PrintWriter out = response.getWriter();
           
        String id_gps = request.getParameter("id_gps"); 
        String no_serie = request.getParameter("no_serie");
        String niv = request.getParameter("niv"); 
        String id_modelo_gps = request.getParameter("id_modelo_gps"); 
        String id_unidad = request.getParameter("id_unidad"); 
        String kilometraje = request.getParameter("kilometraje"); 
        String fecha_actualizacion = request.getParameter("fecha_actualizacion"); 
        String var = "";
       
 
        JSONObject datos = new JSONObject();
         
        try {
            rs = Conexion.query("SELECT niv FROM \"GPS_unidad\" WHERE niv = '"+niv+"';");

            while (rs.next()) {
                var = rs.getString(1);
            }
            
        } catch (SQLException e) {
            System.err.print(e);
        } finally {
            if (Conexion != null) { Conexion.executeQueryClose(); System.out.println("close conexion"); }
            if (rs != null) { rs.close(); System.out.println("close rs"); }  
        }
        
        if(!"".equals(var)){
            try {
                s = Conexion.update("UPDATE \"GPS_unidad\"  \n" +
                    "SET id_modelo_gps = "+id_modelo_gps+", \"no_serie_GPS\" = '"+no_serie+"', fecha_actualizacion = '"+fecha_actualizacion+"' \n" +
                    "WHERE id_gps = "+id_gps+";");
                
                rs = s.getGeneratedKeys();
                /*while(rs.next()){
                    datos.put("id_gps", rs.getString(1));                
                    datos.put("id_modelo_gps", rs.getString(2));
                    datos.put("niv", rs.getString(3));
                    datos.put("no_serie_gps", rs.getString(4));
                }*/
                
            } catch (SQLException e) {
                System.err.print(e);
            } finally {
                if (Conexion != null) { Conexion.executeQueryCloseUpdate(); System.out.println("close conexion"); }
                if (rs != null) { rs.close(); System.out.println("close rs"); }
            }

            try {
                
                s = Conexion.update("UPDATE cat_unidad SET kilometraje = " + kilometraje + " WHERE id_unidad = " + id_unidad + " RETURNING id_unidad, kilometraje;");
                rs = s.getGeneratedKeys();
                /*while (rs.next()) {
                    datos.put("id_unidad", rs.getString(1));
                    datos.put("kilometraje", rs.getString(2));
                }*/
                
            } catch (SQLException e) {
                System.err.print(e);
            } finally {
                if (Conexion != null) { Conexion.executeQueryCloseUpdate(); System.out.println("close conexion"); }
                if (rs != null) { rs.close(); System.out.println("close rs"); }
            }
            
        }else{
            datos.put("estado", 1);
        }
        
        out.println(datos);
    }
}
