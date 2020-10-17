/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package Controllers;

import Config.Conexion;
import Model.Capa;
import java.io.BufferedOutputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Statement;
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
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.commons.CommonsMultipartFile;

/**
 *
 * @author Carlos Larios
 */
public class consultar_capa {
    
    PreparedStatement ps;
    ResultSet rs;
    Statement s;
    
    
    @RequestMapping("consultar_capa.htm")
    protected org.springframework.web.servlet.ModelAndView index(HttpServletResponse response, HttpServletRequest request) throws IOException, SQLException {
        
        Conexion Conexion = new Conexion();
        
        HttpSession session = request.getSession(false);
        org.springframework.web.servlet.ModelAndView mav = new org.springframework.web.servlet.ModelAndView();
        
        mav.setViewName("consultar_capa");
        ArrayList<Capa> capas = new ArrayList<>();
        
        try {
            rs = Conexion.query("SELECT id_capa,nombre,icon,\"KMZ\",\"statusCapa\" FROM cat_capa;");
              
             while(rs.next()){  
                capas.add(new Capa(
                    rs.getInt(1),
                    rs.getString(2), 
                    rs.getString(3),
                    rs.getString(4),
                    rs.getInt(5)      
                )); 
            }

            mav.addObject("capas", capas); 

        } catch (SQLException e) {
            System.err.print(e);
        } finally {
            if (Conexion != null) { Conexion.executeQueryClose(); System.out.println("close conexion"); }
            if (rs != null) { rs.close(); System.out.println("close rs"); }  
        }
        
        return mav;
    }
    
    @RequestMapping(value = "obtener_datos_capa.htm", method = RequestMethod.POST)
    public void obtener_datos_capa(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException, SQLException {
        
        Conexion Conexion = new Conexion();
        
        response.setContentType("application/json");
        PrintWriter out = response.getWriter();
        
        String id_capa = request.getParameter("id_capa"); 
        String kmz = ""; 
        JSONObject datos = new JSONObject();
        
        try {
            rs = Conexion.query("SELECT id_capa, nombre, \"KMZ\", icon FROM cat_capa WHERE id_capa = "+id_capa+";");
            
            while(rs.next()){
                datos.put("id_capa", rs.getString(1));
                datos.put("nombre", rs.getString(2));
                kmz = rs.getString(3);
                datos.put("icon", rs.getString(4));
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
    
    @RequestMapping(value = "deshabilitar_capa.htm", method = RequestMethod.POST)
    public void deshabilitar_capa(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException, SQLException {
        
        Conexion Conexion = new Conexion();
        
        response.setContentType("application/json");
        PrintWriter out = response.getWriter();
        
        String id_capa = request.getParameter("id_capa");
        String statusCapa = request.getParameter("statusCapa");
        String fecha_actualizacion = request.getParameter("fecha_actualizacion");
        
        JSONObject datos = new JSONObject();
        
        try {
            
            s = Conexion.update("UPDATE cat_capa SET \"statusCapa\" = '"+statusCapa+"', fecha_actualizacion = '"+fecha_actualizacion+"' WHERE id_capa = "+id_capa+";");
            
            rs = s.getGeneratedKeys(); //Obtener el id que se actualizo
            
        } catch (SQLException e) {
            System.err.print(e);
        } finally {
            if (Conexion != null) { Conexion.executeQueryCloseUpdate(); System.out.println("close conexion"); }
            if (rs != null) { rs.close(); System.out.println("close rs"); }  
        }
        
        try {
            
            rs = Conexion.query("SELECT id_capa, nombre FROM cat_capa WHERE id_capa = "+id_capa+";"); 
            
            while(rs.next()){
                datos.put("id_capa", rs.getString(1));
                datos.put("nombre", rs.getString(2)); 
            }
            
        } catch (SQLException | JSONException e) {
            System.err.print(e);
        } finally {
            if (Conexion != null) { Conexion.executeQueryCloseUpdate(); System.out.println("close conexion"); }
            if (rs != null) { rs.close(); System.out.println("close rs"); }  
        }
        
        out.println(datos);
    }
    
    @RequestMapping(value = "eliminar_capa.htm", method = RequestMethod.POST)
    public void eliminar_capa(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException, JSONException {
        
        Conexion Conexion = new Conexion();
        
        response.setContentType("application/json");
        PrintWriter out = response.getWriter(); 
        
        String id_capa = request.getParameter("id_capa");
        String variable = "";
        
        JSONArray rutas = new JSONArray();
        JSONObject datos = new JSONObject();
        
        try {
             
            s = Conexion.update("DELETE FROM ruta_ramal WHERE id_ruta IN (SELECT r.id_ruta FROM cat_capa c INNER JOIN cat_ruta r on c.id_capa = r.id_capa WHERE c.id_capa = "+id_capa+");");

            datos.put("exito", 1); 
              
        } catch (JSONException e) {
            System.err.print("ERROR: "+e);
        } finally {
            if (Conexion != null) { Conexion.executeQueryCloseUpdate(); System.out.println("close conexion"); }  
        }
        
        try {
             
            s = Conexion.update("DELETE FROM cat_itinerario WHERE id_ruta IN (SELECT r.id_ruta FROM cat_capa c INNER JOIN cat_ruta r on c.id_capa = r.id_capa WHERE c.id_capa = "+id_capa+");");

            datos.put("exito", 1); 
              
        } catch (JSONException e) {
            System.err.print("ERROR: "+e);
        } finally {
            if (Conexion != null) { Conexion.executeQueryCloseUpdate(); System.out.println("close conexion"); }  
        }
        
        try {
             
            s = Conexion.update("DELETE FROM ruta_unidad WHERE id_ruta IN (SELECT r.id_ruta FROM cat_capa c INNER JOIN cat_ruta r on c.id_capa = r.id_capa WHERE c.id_capa = "+id_capa+");");

            datos.put("exito", 1); 
              
        } catch (JSONException e) {
            System.err.print("ERROR: "+e);
        } finally {
            if (Conexion != null) { Conexion.executeQueryCloseUpdate(); System.out.println("close conexion"); }  
        }
        
        try {
             
            s = Conexion.update("DELETE FROM cat_ruta WHERE id_ruta IN (SELECT r.id_ruta FROM cat_capa c INNER JOIN cat_ruta r on c.id_capa = r.id_capa WHERE c.id_capa = "+id_capa+");");

            datos.put("exito", 1);  
              
        } catch (JSONException e) {
            System.err.print("ERROR: "+e);   
        } finally {
            if (Conexion != null) { Conexion.executeQueryCloseUpdate(); System.out.println("close conexion"); }  
        }
        
        try {
             
            s = Conexion.update("DELETE FROM cat_capa WHERE id_capa = "+id_capa+";");

            datos.put("exito", 1); 
              
        } catch (JSONException e) {
            System.err.print("ERROR: "+e);
        } finally {
            if (Conexion != null) { Conexion.executeQueryCloseUpdate(); System.out.println("close conexion"); }  
        }
        
        out.println(datos);
    }
    
    @RequestMapping(value = "editar_capa.htm", method = RequestMethod.POST, produces = "text/html; charset=UTF-8")
    public void editar_capa(HttpServletRequest request, HttpSession session, HttpServletResponse response) throws ServletException, IOException, SQLException {
        
        Conexion Conexion = new Conexion();
        
        response.setContentType("application/json");
        PrintWriter out = response.getWriter();  
        
        String path = session.getServletContext().getRealPath("/");   
       
        String id_capa = request.getParameter("id_capa");  
        String nombre = request.getParameter("nombre"); 
        byte[] nombreBytes = nombre.getBytes("ISO-8859-1");
        String nombreEncode = new String(nombreBytes, "UTF-8");
        String kmz = request.getParameter("kmz");
        String rutaFoto = request.getParameter("rutaFoto");
        String fecha_actualizacion = request.getParameter("fecha_actualizacion");
        
        org.json.simple.JSONObject datos = new org.json.simple.JSONObject();  
        
        try {
            s = Conexion.update("UPDATE cat_capa SET nombre = '"+nombreEncode+"', icon = '"+rutaFoto+"', \"KMZ\" = '"+kmz+"', fecha_actualizacion = '"+fecha_actualizacion+"' WHERE id_capa = "+id_capa+";");
            
            rs = s.getGeneratedKeys(); //Obtener el id que se actualizo
            
        } catch (SQLException e) {
            System.err.print(e);
        } finally {
            if (Conexion != null) { Conexion.executeQueryCloseUpdate(); System.out.println("close conexion"); }
            if (rs != null) { rs.close(); System.out.println("close rs"); }
        }
        
        try {
            
            rs = Conexion.query("SELECT id_capa, nombre FROM cat_capa WHERE id_capa = "+id_capa+";");
            
            while(rs.next()){
                datos.put("id_capa", rs.getString(1));
                datos.put("nombre", rs.getString(2));  
            }
            
        } catch (SQLException e) {
            System.err.print(e);
        } finally {
            if (Conexion != null) { Conexion.executeQueryClose(); System.out.println("close conexion"); }
            if (rs != null) { rs.close(); System.out.println("close rs"); }
        }
                
        out.println(datos);
    }
    
    @RequestMapping(value = "editar_capa_file.htm", method = RequestMethod.POST)
    public void editar_capa(@RequestParam CommonsMultipartFile file, HttpServletRequest request, HttpSession session, HttpServletResponse response) throws ServletException, IOException, SQLException {
        
        Conexion Conexion = new Conexion();
        
        response.setContentType("application/json");  
        PrintWriter out = response.getWriter();  
        
        String path = session.getServletContext().getRealPath("/");
        String ruta = path.replace("\\build\\web\\","\\web\\"); 
        String filename = file.getOriginalFilename();   
       
        String id_capa = request.getParameter("id_capa"); 
        String nombre = request.getParameter("nombre"); 
        byte[] nombreBytes = nombre.getBytes("ISO-8859-1");
        String nombreEncode = new String(nombreBytes, "UTF-8");
        String kmz = request.getParameter("kmz");
        String fecha_actualizacion = request.getParameter("fecha_actualizacion");
        String rutaIcon = "";
        
        try{  
            byte barr[] = file.getBytes(); 
            BufferedOutputStream br = new BufferedOutputStream(new FileOutputStream(ruta+"images/"+filename));  
            br.write(barr);  
            br.flush();  
            br.close();
            rutaIcon = "images/"+filename;
        } catch(IOException e){
            System.out.println(e);
        }
        
        org.json.simple.JSONObject datos = new org.json.simple.JSONObject();
        
        try {
            
            s = Conexion.update("UPDATE cat_capa SET nombre = '"+nombreEncode+"', icon = '"+rutaIcon+"', \"KMZ\" = '"+kmz+"' WHERE id_capa = "+id_capa+";");
            
            rs = s.getGeneratedKeys(); //Obtener el id que se actualizo
            
        } catch (SQLException e) {
            System.err.print(e);
        } finally {
            if (Conexion != null) { Conexion.executeQueryCloseUpdate(); System.out.println("close conexion"); }
            if (rs != null) { rs.close(); System.out.println("close rs"); }
        }
        
        try {
            
            rs = Conexion.query("SELECT id_capa, nombre FROM cat_capa WHERE id_capa = "+id_capa+";");
            
            while(rs.next()){
                datos.put("id_capa", rs.getString(1));
                datos.put("nombre", rs.getString(2));  
            }
            
        } catch (SQLException e) {
            System.err.print(e);
        } finally {
            if (Conexion != null) { Conexion.executeQueryClose(); System.out.println("close conexion"); }
            if (rs != null) { rs.close(); System.out.println("close rs"); }
        }

        out.println(datos);
    }
}
