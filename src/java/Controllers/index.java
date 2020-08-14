/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package Controllers;

import Config.Conexion;
import Model.Arco;
import Model.lectura_vehiculo;
import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.PrintWriter;
import java.net.HttpURLConnection;
import java.net.URL;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
//import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.enterprise.inject.Model;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import org.json.simple.JSONObject;
import org.springframework.jdbc.core.JdbcTemplate;
//import javax.servlet.http.HttpSession;
//import org.json.JSONException;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.portlet.ModelAndView;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

/**
 *
 * @author oswal
 */
@Controller
public class index extends HttpServlet {

    private Conexion connec;
    Conexion cn = new Conexion();
    Connection con;
    PreparedStatement ps;
    ResultSet rs;
    lectura_vehiculo lv = new lectura_vehiculo();
    
    
    @RequestMapping("index.htm")
    protected org.springframework.web.servlet.ModelAndView index(HttpServletResponse response, HttpServletRequest request) throws IOException {
        HttpSession session = request.getSession(false);
        org.springframework.web.servlet.ModelAndView mav = new org.springframework.web.servlet.ModelAndView();

         mav.setViewName("index");
        
        return mav;
    }

    @GetMapping("/Sis_Arcos/lecturas_vehiculo.htm")
    protected void processRequest(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.sendRedirect("lecturas_vehiculo.htm");
    }

    @GetMapping("/Sis_Arcos/logout.htm")
    protected void logOut(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.sendRedirect("logout.htm");
    }

    @RequestMapping(value = "listar_autos_interfazPrincipal.htm", method = RequestMethod.POST)
    public void listar_autos_interfazPrincipal(HttpServletRequest request, HttpServletResponse response) throws IOException {
        Boolean critico = Boolean.parseBoolean(request.getParameter("danger"));
        Boolean informativo = Boolean.parseBoolean(request.getParameter("info"));
        Boolean advertencia = Boolean.parseBoolean(request.getParameter("warning"));
        int dias = Integer.parseInt(request.getParameter("dias"));

        PrintWriter out = response.getWriter();

        int critico1 = 0, informativo1 = 0, advertencia1 = 0;

        if (critico == true) {
            critico1 = 1;
        }
        if (informativo == true) {
            informativo1 = 1;
        }
        if (advertencia == true) {
            advertencia1 = 1;
        }

        JSONObject jsAlertasVehiculos = new JSONObject();
        JSONObject jsAlerta;
        int contador = 0;

        try (ResultSet r = Conexion.query("select * from sp_consultar_alerta_arcos_interfaz1('" + dias + "','" + informativo1 + "','" + advertencia1 + "','" + critico1 + "');")) {
            while (r.next()) {
                jsAlerta = new JSONObject();
                jsAlerta.put("tipo_registro", r.getString(1));
                jsAlerta.put("fecha_hora", r.getString(2));
                jsAlerta.put("nombre_arco", r.getString(3));
                jsAlerta.put("Descripcion", r.getString(4));
                jsAlerta.put("niv", r.getString(5));
                jsAlerta.put("fuente", r.getString(6));
                try (ResultSet res = Conexion.query("select * from sp_ubicacion_arco('" + r.getString(7) + "')")) {
                    if (res.next()) {
                        jsAlerta.put("coordenadas", res.getString(1));
                    }
                } catch (Exception e) {
                    System.out.println(e.getMessage());
                }
                jsAlertasVehiculos.put("Alerta_" + contador, jsAlerta);
                contador++;
            }
        } catch (SQLException e) {
            // Handle error.
        }

        // Aqui se trae las alertas de los arcos, ingresandolos a un JSON y agregandolo a un JSON para todas las alertas
        JSONObject jsAlertasArcos = new JSONObject();
        JSONObject jsAlertas = new JSONObject();
        contador = 0;

        try {
            ResultSet r = Conexion.query("select * from sp_consultar_alertas_arcos('" + dias + "','" + informativo1 + "','" + advertencia1 + "','" + critico1 + "');");

            while (r.next()) {
                jsAlertas = new JSONObject();
                jsAlertas.put("fecha_hora", r.getString(1));
                jsAlertas.put("nombre_arco", r.getString(2));
                jsAlertas.put("nombre_alerta", r.getString(3));
                jsAlertas.put("ubicacion", r.getString(4));
                jsAlertas.put("tipo_registro", r.getString(5));
                try (ResultSet res = Conexion.query("select * from sp_ubicacion_arco('" + r.getString(6) + "')")) {
                    if (res.next()) {
                        jsAlertas.put("coordenadas", res.getString(1));
                    }
                } catch (Exception e) {
                    System.out.println(e.getMessage());
                }
                System.out.println(r.getString(5));
                jsAlertasArcos.put("Alerta" + contador, jsAlertas);
                contador++;
            }
            r.close();
        } catch (Exception e) {
        }

        // Aqui se juntaron los dos JSON de las alertas en uno
        JSONObject jsTodasAlertas = new JSONObject();
        jsTodasAlertas.put("Alertas_Vehiculos", jsAlertasVehiculos);
        jsTodasAlertas.put("Alertas_Arcos", jsAlertasArcos);

        //System.out.println(jsTodasAlertas);
        out.print(jsTodasAlertas);

    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    String index = "/Sis_Arcos/index.jsp";

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
