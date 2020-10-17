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
public class asociar_gps {

    PreparedStatement ps;
    ResultSet rs;
    Statement s;

    @RequestMapping("asociar_gps.htm")
    protected org.springframework.web.servlet.ModelAndView index(HttpServletResponse response, HttpServletRequest request) throws IOException, SQLException {
        
        Conexion Conexion = new Conexion();
        
        HttpSession session = request.getSession(false);
        org.springframework.web.servlet.ModelAndView mav = new org.springframework.web.servlet.ModelAndView();

        mav.setViewName("asociar_gps");
        
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

    @RequestMapping(value = "buscar_niv.htm", method = RequestMethod.GET)
    public void buscar_niv(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException, SQLException {
        
        Conexion Conexion = new Conexion();
        
        response.setContentType("application/json");
        PrintWriter out = response.getWriter();

        String niv = request.getParameter("niv");

        JSONArray unidades = new JSONArray(); 

        try {
            //rs = Conexion.query("SELECT id_unidad, no_unidad, \"NIV\" FROM cat_unidad WHERE \"NIV\"::text LIKE '%" + niv + "%'");
            rs = Conexion.query("SELECT id_unidad, no_unidad, \"NIV\" \n" +
                "FROM cat_unidad \n" +
                "WHERE \"NIV\"::text LIKE '%" + niv + "%' AND \"NIV\"  not in (select niv from \"GPS_unidad\");");
            
            while (rs.next()) {
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

    @RequestMapping(value = "registrar_asociacion.htm", method = RequestMethod.POST)
    public void registrar_asociacion(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException, ParseException, JSONException, SQLException {
        
        Conexion Conexion = new Conexion();
        
        response.setContentType("application/json;charset=utf-8");
        PrintWriter out = response.getWriter();

        String no_serie = request.getParameter("no_serie");
        String id_modelo_gps = request.getParameter("id_modelo_gps");
        String id_unidad = request.getParameter("id_unidad");
        String niv = request.getParameter("niv");
        String kilometraje = request.getParameter("kilometraje");
        String fecha_registro = request.getParameter("fecha_registro");
        String var = "";

        JSONObject datos = new JSONObject();
        
        try {
            
            rs = Conexion.query("SELECT niv FROM \"GPS_unidad\" WHERE niv = '"+niv+"';");

            while (rs.next()) {
                var = rs.getString(1);
            }
            
            /*rs = Conexion.query("SELECT niv FROM \"GPS_unidad\" WHERE id_modelo_gps = "+id_modelo_gps+" and \"no_serie_GPS\" = '"+no_serie+"';");

            while (rs.next()) {
                var = rs.getString(1);
            }*/

        } catch (SQLException e) {
            System.err.print(e);
        } finally {
            if (Conexion != null) { Conexion.executeQueryClose(); System.out.println("close conexion"); }
            if (rs != null) { rs.close(); System.out.println("close rs"); }  
        }
        
        if("".equals(var)){
            try {
                s = Conexion.update("INSERT INTO \"GPS_unidad\"(niv,id_modelo_gps,\"no_serie_GPS\",fecha_registro) VALUES('" + niv + "'," + id_modelo_gps + ",'" + no_serie + "','" + fecha_registro + "');");
                rs = s.getGeneratedKeys();
                /*while (rs.next()) {
                    datos.put("id_gps", rs.getString(1));
                    datos.put("niv", rs.getString(2));
                    datos.put("id_modelo_gps", rs.getString(3));
                    datos.put("no_serie_gps", rs.getString(4));
                    datos.put("fecha_registro", rs.getString(5));
                }
                rs.close();*/


            } catch (SQLException e) {
                System.err.print(e);
            } finally {
                if (Conexion != null) { Conexion.executeQueryCloseUpdate(); System.out.println("close conexion"); }
                if (rs != null) { rs.close(); System.out.println("close rs"); }
            }

            try {
                
                s = Conexion.update("UPDATE cat_unidad SET kilometraje = " + kilometraje + " WHERE id_unidad = " + id_unidad + ";");
                rs = s.getGeneratedKeys();
                /*while (rs.next()) {
                    datos.put("kilometraje", rs.getString(1));
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
        
        out.print(datos);
    }
}
