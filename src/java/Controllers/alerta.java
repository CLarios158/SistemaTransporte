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
public class alerta {
    private Conexion connec;
    Conexion cn = new Conexion();
    Connection con;
    PreparedStatement ps;
    ResultSet rs;
    Model.lectura_vehiculo lv = new Model.lectura_vehiculo();
    
    
    @RequestMapping("alerta.htm")
    protected org.springframework.web.servlet.ModelAndView index(HttpServletResponse response, HttpServletRequest request) throws IOException {
        HttpSession session = request.getSession(false);
        org.springframework.web.servlet.ModelAndView mav = new org.springframework.web.servlet.ModelAndView();

         mav.setViewName("alerta");
        
        return mav;
    }
    
    @RequestMapping(value = "buscar_unidad_alerta.htm", method = RequestMethod.GET)
    public void buscar_unidad_alerta(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        
        response.setContentType("application/json");
        PrintWriter out = response.getWriter();
        
        String unidad = request.getParameter("unidad");
                 
        JSONArray unidades = new JSONArray(); 
        
        try {
            rs = Conexion.query("SELECT id_unidad, no_unidad, \"NIV\" FROM cat_unidad WHERE \"NIV\"::text LIKE '%"+unidad+"%'");
            
            while(rs.next()){  
                Map m = new LinkedHashMap(2);
                m.put("id_unidad", rs.getString(1));
                m.put("no_unidad", rs.getString(2));  
                m.put("niv", rs.getString(3));
                unidades.add(m);
            }
            
        } catch (SQLException e) {
            System.err.print(e);
        }
        
        out.println(unidades);
    }
    
    @RequestMapping(value = "obtener_unidad_alerta.htm", method = RequestMethod.POST)
    public void obtener_unidad_alerta(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException, JSONException {
        
        response.setContentType("application/json");
        PrintWriter out = response.getWriter();
        
        String niv = request.getParameter("niv");

        JSONObject datos = new JSONObject();
        JSONArray alertasU = new JSONArray();
        JSONArray alertasA = new JSONArray();
        
        try {
            rs = Conexion.query("SELECT a.id_mensajealerta ,cat.nombre, COUNT(a.id_mensajealerta) as Numero\n" +
            "FROM alerta a INNER JOIN \"cat_mensajeAlerta\" cat on a.id_mensajealerta = cat.id_mensajealerta\n" +
            "WHERE a.niv = '"+niv+"' and cat.id_tipoalerta = 1\n" +
            "GROUP BY cat.nombre, a.id_mensajealerta");
            
            while(rs.next()){
                Map m = new LinkedHashMap(3);
                m.put("id_mensajealerta", rs.getString(1));
                m.put("nombre", rs.getString(2));
                m.put("cantidad", rs.getString(3));
                alertasU.add(m);
            }
            
            datos.put("alertasUnidad",alertasU); 
            
            rs.close();
            
        } catch (SQLException | JSONException e) {
            System.err.print(e);
        }
        
        try {
            rs = Conexion.query("SELECT a.id_mensajealerta, cat.nombre, COUNT(a.id_mensajealerta) as Numero\n" +
            "FROM alerta a INNER JOIN \"cat_mensajeAlerta\" cat on a.id_mensajealerta = cat.id_mensajealerta\n" +
            "WHERE a.niv = '"+niv+"' and cat.id_tipoalerta = 2\n" +
            "GROUP BY cat.nombre, a.id_mensajealerta");
            
            while(rs.next()){
                Map m = new LinkedHashMap(3);
                m.put("id_mensajealerta", rs.getString(1));
                m.put("nombre", rs.getString(2));
                m.put("cantidad", rs.getString(3));
                alertasA.add(m);  
            }
            
            datos.put("alertasAlcancia",alertasA);  
            
            rs.close();
            
        } catch (SQLException | JSONException e) {
            System.err.print(e);
        }
        
        System.out.println(datos);
        out.println(datos);
    }
    
    @RequestMapping(value = "obtener_datos_alerta.htm", method = RequestMethod.POST)
    public void obtener_datos_alerta(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException, JSONException {
        
        response.setContentType("application/json");
        PrintWriter out = response.getWriter();
        
        String id_mensajealerta = request.getParameter("id_mensajealerta");
        String niv = request.getParameter("niv");

        JSONObject datos = new JSONObject();
        JSONArray array = new JSONArray();
        
        try {
            rs = Conexion.query("SELECT to_char(fecha_hora::timestamp::time,'HH24:MI') as hora, fecha_hora::timestamp::date as Fecha, ubicacion\n" +
                "FROM alerta\n" +
                "WHERE niv = '"+niv+"' and id_mensajealerta = "+id_mensajealerta+" ;");
            
            while(rs.next()){
                Map m = new LinkedHashMap(3);
                m.put("hora",rs.getString(1));
                m.put("fecha",rs.getString(2));
                m.put("ubicacion",rs.getString(3));
                array.add(m);  
            }
            
            datos.put("datos",array);  
            
            rs.close();
            
        } catch (SQLException | JSONException e) {
            System.err.print(e);
        }
        
        System.out.println(datos);
        out.println(datos);
    }
}
