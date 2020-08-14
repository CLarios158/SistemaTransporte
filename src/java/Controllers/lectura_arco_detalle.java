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
import java.util.ArrayList;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import org.json.simple.JSONObject;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.portlet.ModelAndView;

/**
 *
 * @author oswal
 */
@Controller
public class lectura_arco_detalle {

    private Conexion connec;
    Conexion cn = new Conexion();
    Connection con;
    PreparedStatement ps;
    ResultSet rs;

    @GetMapping("/Sis_Arcos/lecturas_vehiculo.htm")
    protected void lecturaVehiculo(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.sendRedirect("lecturas_vehiculo.htm");
    }

    @GetMapping("/Sis_Arcos/index.htm")
    protected void index(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.sendRedirect("index.htm");
    }

    @RequestMapping("lecturas_arco_detalle.htm") //1  
    public org.springframework.web.servlet.ModelAndView indexLecturas_vehiculos(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        org.springframework.web.servlet.ModelAndView mav = new org.springframework.web.servlet.ModelAndView();
        if (session == null || !request.isRequestedSessionIdValid()) {
            mav.setViewName("login");
        } else {
            mav.setViewName("lecturas_arco_detalle");
        }
        return mav;
    }

}
