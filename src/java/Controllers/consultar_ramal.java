/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package Controllers;

import Config.Conexion;
import Model.consultar_ruta;
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
public class consultar_ramal {
    
    PreparedStatement ps;
    ResultSet rs;
    Statement s;
    
    @RequestMapping("consultar_ramal.htm")
    protected org.springframework.web.servlet.ModelAndView index(HttpServletResponse response, HttpServletRequest request) throws IOException, SQLException {
        
        Conexion Conexion = new Conexion();
        
        HttpSession session = request.getSession(false);
        org.springframework.web.servlet.ModelAndView mav = new org.springframework.web.servlet.ModelAndView();

        mav.setViewName("consultar_ramal"); 
       
        ArrayList<consultar_ruta> rutas_option;
        rutas_option = new ArrayList<>();
        
        try {
            rs = Conexion.query("SELECT id_ruta, nombre FROM cat_ruta;");
            while(rs.next()){ 
                rutas_option.add(new consultar_ruta(
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
    
    @RequestMapping(value = "buscar_ramal.htm", method = RequestMethod.GET)
    public void buscar_ramal(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException, SQLException {
        
        Conexion Conexion = new Conexion();
        
        response.setContentType("application/json");
        PrintWriter out = response.getWriter();
        
        String ramal = request.getParameter("ramal");
                 
        JSONArray unidades = new JSONArray();
        
        try {
            rs = Conexion.query("SELECT id_ramal,nombre,\"statusRamal\" FROM cat_ramal WHERE nombre::text iLIKE '%"+ramal+"%'");
            
            while(rs.next()){ 
                Map m = new LinkedHashMap(2);
                m.put("id_ramal", rs.getString(1));
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
    
    @RequestMapping(value = "obtener_datos_ramal.htm", method = RequestMethod.POST)
    public void obtener_datos_ramal(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException, JSONException, SQLException {
        
        Conexion Conexion = new Conexion();
        
        response.setContentType("application/json");
        PrintWriter out = response.getWriter();
        
        String id_ramal = request.getParameter("id_ramal");
        String kmz = "";
        
        JSONArray unidades = new JSONArray();
        JSONObject datos = new JSONObject();
        
        try {
            rs = Conexion.query("SELECT id_ramal,nombre,numero,\"KMZ\" FROM cat_ramal WHERE id_ramal = "+id_ramal+";");
            
            while(rs.next()){
                datos.put("id_ramal", rs.getString(1));
                datos.put("nombre", rs.getString(2));
                datos.put("numero", rs.getString(3));
                kmz = rs.getString(4); 
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
        
        try {
            rs = Conexion.query("SELECT id_ruta FROM ruta_ramal WHERE id_ramal = "+id_ramal+";");
            
            while(rs.next()){
                datos.put("id_ruta", rs.getString(1));
            }
            
        } catch (SQLException | JSONException e) {
            System.err.print(e);
        } finally {
            if (Conexion != null) { Conexion.executeQueryClose(); System.out.println("close conexion"); }
            if (rs != null) { rs.close(); System.out.println("close rs"); }  
        }
        
        try {
            rs = Conexion.query("SELECT u.id_unidad, u.no_unidad\n" +
            "FROM ramal_unidad ru INNER JOIN cat_unidad u on ru.id_unidad = u.id_unidad\n" +
            "WHERE ru.id_ramal = "+id_ramal+";");

            while(rs.next()){
                Map m = new LinkedHashMap(2);
                m.put("id_unidad", rs.getString(1));
                m.put("no_unidad", rs.getString(2));
                unidades.add(m);
            }
            
            datos.put("unidades",unidades);
            
        } catch (SQLException e) {
            System.err.print(e);
        } finally {
            if (Conexion != null) { Conexion.executeQueryClose(); System.out.println("close conexion"); }
            if (rs != null) { rs.close(); System.out.println("close rs"); }  
        }
        
        out.println(datos);
    }
    
    @RequestMapping(value = "editar_ramal.htm", method = RequestMethod.POST)
    public void editar_ramal(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException, SQLException, ParseException {
        
        Conexion Conexion = new Conexion();
        
        response.setContentType("application/json");
        PrintWriter out = response.getWriter();
        
        String id_ramal = request.getParameter("id_ramal");
        String nombre = request.getParameter("nombre");
        String numero = request.getParameter("numero");
        String unidadesN = request.getParameter("unidadesN");
        String unidadesE = request.getParameter("unidadesE");
        String kmz = request.getParameter("kmz");
        String id_ruta = request.getParameter("id_ruta");
        String fecha_actualizacion = request.getParameter("fecha_actualizacion");
        
        JSONObject datos = new JSONObject();
        JSONParser parser;
        
        try {
            
            s = Conexion.update("UPDATE cat_ramal SET nombre = '"+nombre+"', numero = "+numero+", \"KMZ\" = '"+kmz+"',fecha_actualizacion = '"+fecha_actualizacion+"' WHERE id_ramal = "+id_ramal+";"); 
            
            rs = s.getGeneratedKeys();
            
        } catch (SQLException e) {
            System.err.print(e);
        } finally {
            if (Conexion != null) { Conexion.executeQueryClose(); System.out.println("close conexion"); }
            if (rs != null) { rs.close(); System.out.println("close rs"); }  
        }
        
        try {
            
            s = Conexion.update("UPDATE ruta_ramal SET id_ruta = "+id_ruta+" WHERE id_ramal = "+id_ramal+";");
            
            rs = s.getGeneratedKeys();
            
        } catch (SQLException e) {
            System.err.print(e);
        } finally {
            if (Conexion != null) { Conexion.executeQueryClose(); System.out.println("close conexion"); }
            if (rs != null) { rs.close(); System.out.println("close rs"); }  
        }
        
        if(!"".equals(unidadesN)){
            String variable = "";
            
            parser = new JSONParser();
            
            JSONArray unidadN = (JSONArray) parser.parse(unidadesN); 
            
            for (int i=0; i < unidadN.size(); i++) {
                try {
                    s = Conexion.update("INSERT INTO ramal_unidad(id_ramal,id_unidad) VALUES("+id_ramal+","+unidadN.get(i)+") ON CONFLICT (id_ramal, id_unidad) DO UPDATE SET id_unidad = "+unidadN.get(i)+";");

                    rs = s.getGeneratedKeys(); //Obtener el id que se genero al realizar el INSERT

                } catch (SQLException e) {
                    System.err.print(e);
                } finally {
                    if (Conexion != null) { Conexion.executeQueryCloseUpdate(); System.out.println("close conexion"); }
                    if (rs != null) { rs.close(); System.out.println("close rs"); }
                }
            }
        
        }
        
        /*try {
                s = Conexion.update("DELETE FROM ramal_unidad WHERE id_ramal = "+id_ramal+";");
                rs = s.getGeneratedKeys(); //Obtener el id que se genero al realizar el INSERT

            } catch (SQLException e) {
                System.err.print(e);
            } finally {
                if (Conexion != null) { Conexion.executeQueryCloseUpdate(); System.out.println("close conexion"); }
                if (rs != null) { rs.close(); System.out.println("close rs"); }
            }*/ 
        
        if(!"".equals(unidadesE)){ 
            
            String variable = "";
            
            parser = new JSONParser();
            
            JSONArray unidadE = (JSONArray) parser.parse(unidadesE);
            
            for (int i=0; i < unidadE.size(); i++) {   
                try {
                    s = Conexion.update("DELETE FROM ramal_unidad WHERE id_ramal = "+id_ramal+" and id_unidad = "+unidadE.get(i)+";");
                    rs = s.getGeneratedKeys(); //Obtener el id que se genero al realizar el INSERT
        
                } catch (SQLException e) {
                    System.err.print(e); 
                } finally {
                    if (Conexion != null) { Conexion.executeQueryCloseUpdate(); System.out.println("close conexion"); }
                    if (rs != null) { rs.close(); System.out.println("close rs"); }
                }
            }
        }
        
        out.println(datos);
    }
    
    @RequestMapping(value = "deshabilitar_ramal.htm", method = RequestMethod.POST)
    public void deshabilitar_ramal(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException, SQLException {
        
        Conexion Conexion = new Conexion();
        
        response.setContentType("application/json");
        PrintWriter out = response.getWriter();
        
        String id_ramal = request.getParameter("id_ramal");
        String statusRamal = request.getParameter("statusRamal");
        String fecha_actualizacion = request.getParameter("fecha_actualizacion");
        
        JSONObject datos = new JSONObject();
        
        try {
            
            s = Conexion.update("UPDATE cat_ramal SET \"statusRamal\" = '"+statusRamal+"', fecha_actualizacion = '"+fecha_actualizacion+"' WHERE id_ramal = "+id_ramal+"  RETURNING id_ramal,nombre;");
            
            rs = s.getGeneratedKeys();
            
        } catch (SQLException e) {
            System.err.print(e);
        }finally {
            if (Conexion != null) { Conexion.executeQueryClose(); System.out.println("close conexion"); }
            if (rs != null) { rs.close(); System.out.println("close rs"); }  
        }
        
        try {
            rs = Conexion.query("SELECT nombre FROM cat_ramal WHERE id_ramal = "+id_ramal+";");
            
            while(rs.next()){
                datos.put("nombre", rs.getString(1));
            }
            
        } catch (SQLException | JSONException e) { 
            System.err.print(e);
        } finally {
            if (Conexion != null) { Conexion.executeQueryClose(); System.out.println("close conexion"); }
            if (rs != null) { rs.close(); System.out.println("close rs"); }  
        }
        
        out.println(datos);
    }
    
    @RequestMapping(value = "eliminar_ramal.htm", method = RequestMethod.POST)
    public void eliminar_ramal(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        
        Conexion Conexion = new Conexion();
        
        response.setContentType("application/json");
        PrintWriter out = response.getWriter();
        
        String id_ramal = request.getParameter("id_ramal");
        
        JSONObject datos = new JSONObject();
        
        try {
             
            s = Conexion.update("DELETE FROM ruta_ramal WHERE id_ramal = "+id_ramal+";");

            datos.put("exito", 1); 
              
        } catch (JSONException e) {
            System.err.print("ERROR: "+e);
        } finally {
            if (Conexion != null) { Conexion.executeQueryCloseUpdate(); System.out.println("close conexion"); }  
        }
        
        try {
             
            s = Conexion.update("DELETE FROM cat_ramal WHERE id_ramal = "+id_ramal+";");

            datos.put("exito", 1); 
              
        } catch (JSONException e) {
            System.err.print("ERROR: "+e);
        } finally {
            if (Conexion != null) { Conexion.executeQueryCloseUpdate(); System.out.println("close conexion"); }  
        }
        
        out.println(datos);
    }
}
