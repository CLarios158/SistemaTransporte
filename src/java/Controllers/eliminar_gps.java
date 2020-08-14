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
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import org.json.JSONException;
import org.json.JSONObject;
import org.json.simple.parser.ParseException;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

/**
 *
 * @author Carlos Larios
 */
public class eliminar_gps {
    private Conexion connec;
    Conexion cn = new Conexion();
    Connection con;
    PreparedStatement ps;
    ResultSet rs;
    Model.lectura_vehiculo lv = new Model.lectura_vehiculo();
    
    
    @RequestMapping("eliminar_gps.htm")
    protected org.springframework.web.servlet.ModelAndView index(HttpServletResponse response, HttpServletRequest request) throws IOException {
        HttpSession session = request.getSession(false);
        org.springframework.web.servlet.ModelAndView mav = new org.springframework.web.servlet.ModelAndView();

         mav.setViewName("eliminar_gps");
        
        return mav;
    }
    
    @RequestMapping(value = "eliminar_informacion_gps.htm", method = RequestMethod.POST)
    public void eliminar_informacion_gps(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException, ParseException, JSONException {

        response.setContentType("application/json;charset=utf-8");
        PrintWriter out = response.getWriter();

        String id_gps = request.getParameter("id_gps");
        String id_unidad = request.getParameter("id_unidad");

        JSONObject datos = new JSONObject();

        try {
            rs = Conexion.query("DELETE FROM \"GPS_unidad\" WHERE id_gps = "+id_gps+" RETURNING 0;");
                //Conexion.query("DELETE FROM cat_unidad WHERE id_unidad = "+id_unidad+" RETURNING 0;");
            
            datos.put("estado", 1);
            
            rs.close();

        } catch (SQLException e) {
            System.err.print(e);
        }

        out.print(datos);
    }
    
    
}
