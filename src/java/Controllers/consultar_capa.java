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
import java.sql.Connection;
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
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.commons.CommonsMultipartFile;

/**
 *
 * @author Carlos Larios
 */
public class consultar_capa {
    private Conexion connec;
    Conexion cn = new Conexion();
    Connection con;
    PreparedStatement ps;
    ResultSet rs;
    Model.lectura_vehiculo lv = new Model.lectura_vehiculo();
    
    
    @RequestMapping("consultar_capa.htm")
    protected org.springframework.web.servlet.ModelAndView index(HttpServletResponse response, HttpServletRequest request) throws IOException {
        HttpSession session = request.getSession(false);
        org.springframework.web.servlet.ModelAndView mav = new org.springframework.web.servlet.ModelAndView();
        
        mav.setViewName("consultar_capa");
        ArrayList<Capa> capas = new ArrayList<>();
        
        try {
            rs = Conexion.query("SELECT id_capa,nombre,icon,\"KMZ\" FROM cat_capa;");
              
             while(rs.next()){
                capas.add(new Capa(
                    rs.getInt(1),
                    rs.getString(2), 
                    rs.getString(3),
                    rs.getString(4)        
                        
                )); 
            }
             
            //rs.close();
            
            mav.addObject("capas", capas); 
            
        } catch (SQLException e) {
            System.err.print(e);
        }
        
        return mav;
    }
    
    @RequestMapping(value = "obtener_datos_capa.htm", method = RequestMethod.POST)
    public void obtener_datos_capa(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        
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
            
            rs.close();
            
            JSONParser parser = new JSONParser();
            JSONArray json = (JSONArray) parser.parse(kmz);
            datos.put("kmz",json);
            
        } catch (SQLException | JSONException | ParseException e) {
            System.err.print(e);
        }
        out.println(datos);
    }
    
    @RequestMapping(value = "deshabilitar_capa.htm", method = RequestMethod.POST)
    public void deshabilitar_capa(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        
        response.setContentType("application/json");
        PrintWriter out = response.getWriter();
        
        String id_capa = request.getParameter("id_capa");
        String statusCapa = request.getParameter("statusCapa");
        String fecha_actualizacion = request.getParameter("fecha_actualizacion");
        
        JSONObject datos = new JSONObject();
        
        try {
            rs = Conexion.query("UPDATE cat_capa SET \"statusCapa\" = '"+statusCapa+"', fecha_actualizacion = '"+fecha_actualizacion+"' WHERE id_capa = "+id_capa+"  RETURNING id_capa;");
            
            while(rs.next()){
                datos.put("id_capa", rs.getString(1));  
            }
            
            rs.close();  
            
        } catch (SQLException | JSONException e) {
            System.err.print(e);
        }
        out.println(datos);
    }
    
    @RequestMapping(value = "eliminar_capa.htm", method = RequestMethod.POST)
    public void eliminar_capa(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException, JSONException {
        
        response.setContentType("application/json");
        PrintWriter out = response.getWriter(); 
        
        String id_capa = request.getParameter("id_capa");
        String variable = "";
        
        JSONArray rutas = new JSONArray();
        JSONObject datos = new JSONObject();
        
        try {
            rs = 
                Conexion.query("DELETE FROM ruta_ramal WHERE id_ruta IN (SELECT r.id_ruta FROM cat_capa c INNER JOIN cat_ruta r on c.id_capa = r.id_capa WHERE c.id_capa = "+id_capa+") RETURNING 'Delete ruta_ramal';");
                Conexion.query("DELETE FROM cat_itinerario WHERE id_ruta IN (SELECT r.id_ruta FROM cat_capa c INNER JOIN cat_ruta r on c.id_capa = r.id_capa WHERE c.id_capa = "+id_capa+") RETURNING 'Delete cat_itinerario';");
                Conexion.query("DELETE FROM ruta_unidad WHERE id_ruta IN (SELECT r.id_ruta FROM cat_capa c INNER JOIN cat_ruta r on c.id_capa = r.id_capa WHERE c.id_capa = "+id_capa+") RETURNING 'Delete ruta_unidad';");
                Conexion.query("DELETE FROM cat_ruta WHERE id_ruta IN (SELECT r.id_ruta FROM cat_capa c INNER JOIN cat_ruta r on c.id_capa = r.id_capa WHERE c.id_capa = "+id_capa+") RETURNING 'Delete cat_ruta';");
                Conexion.query("DELETE FROM cat_capa WHERE id_capa = "+id_capa+" RETURNING 'Delete cat_capa';");
            
            while(rs.next()){ 
                System.out.println(rs.getString(1));
            }
           
        } catch (SQLException e) {
            System.err.print(e);
        }
        
        out.println(datos);
    }
    
    @RequestMapping(value = "editar_capa.htm", method = RequestMethod.POST)
    public void editar_capa(HttpServletRequest request, HttpSession session, HttpServletResponse response, @RequestParam CommonsMultipartFile file) throws ServletException, IOException {
        
        response.setContentType("application/json"); 
        PrintWriter out = response.getWriter();  
        
        String path=session.getServletContext().getRealPath("/");   
        String filename = file.getOriginalFilename();  
        
        String id_capa = request.getParameter("id_capa"); 
        String nombre = request.getParameter("nombre"); 
        String kmz = request.getParameter("kmz");
        String rutaFoto = request.getParameter("rutaFoto");
        String fecha_actualizacion = request.getParameter("fecha_actualizacion");
        String rutaIcon = "";
        
        try{  
            byte barr[] = file.getBytes(); 
            BufferedOutputStream br = new BufferedOutputStream(new FileOutputStream(path+"images/"+filename));  
            br.write(barr);  
            br.flush();  
            br.close();
            rutaIcon = "images/"+filename;
        } catch(IOException e){
            rutaIcon = rutaFoto;
            System.out.println(e);
        }
        
        org.json.simple.JSONObject datos = new org.json.simple.JSONObject();
        
        try {
            rs = Conexion.query("UPDATE cat_capa SET nombre = '"+nombre+"', icon = '"+rutaIcon+"', \"KMZ\" = '"+kmz+"' WHERE id_capa = "+id_capa+" RETURNING id_capa;");
            while(rs.next()){
                datos.put("id_capa", rs.getString(1));  
            }
        } catch (SQLException e) {
            System.err.print(e);
        }
                
        out.println(datos);
    }
}
