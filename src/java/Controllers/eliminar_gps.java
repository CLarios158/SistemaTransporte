/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package Controllers;

import Config.Conexion;
import java.io.IOException;
import java.sql.Statement;
import java.io.PrintWriter;
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

    PreparedStatement ps;
    ResultSet rs;
    Statement s;
    
    
    @RequestMapping("eliminar_gps.htm")
    protected org.springframework.web.servlet.ModelAndView index(HttpServletResponse response, HttpServletRequest request) throws IOException {
        HttpSession session = request.getSession(false);
        org.springframework.web.servlet.ModelAndView mav = new org.springframework.web.servlet.ModelAndView();

        mav.setViewName("eliminar_gps");
        
        return mav;
    }
    
    @RequestMapping(value = "eliminar_informacion_gps.htm", method = RequestMethod.POST)
    public void eliminar_informacion_gps(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException, ParseException, JSONException, SQLException {
        
        Conexion Conexion = new Conexion();
        
        response.setContentType("application/json;charset=utf-8");
        PrintWriter out = response.getWriter();

        String id_gps = request.getParameter("id_gps");
        String id_unidad = request.getParameter("id_unidad");

        JSONObject datos = new JSONObject();

        try {
            
            s = Conexion.update("DELETE FROM \"GPS_unidad\" WHERE id_gps = "+id_gps+";");
            rs = s.getGeneratedKeys();
            
            datos.put("estado", 1);

        } catch (SQLException e) {
            System.err.print(e);
        } finally {
            if (Conexion != null) { Conexion.executeQueryCloseUpdate(); System.out.println("close conexion"); }
            if (rs != null) { rs.close(); System.out.println("close rs"); }
        }

        out.print(datos);
    }
    
    
}
