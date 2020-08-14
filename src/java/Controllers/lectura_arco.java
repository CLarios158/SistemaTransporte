/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package Controllers;

import Config.Conexion;
import Model.Arco;
import Model.lectura_arco_detalle;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
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
public class lectura_arco {

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

    @RequestMapping(value = "consultar_alertas_arcos.htm", method = RequestMethod.POST)
    public void lecturas_arco(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        PrintWriter out = response.getWriter();

        Boolean critico = Boolean.parseBoolean(request.getParameter("danger"));
        Boolean informativo = Boolean.parseBoolean(request.getParameter("info"));
        Boolean advertencia = Boolean.parseBoolean(request.getParameter("warning"));
        int critico1=0,informativo1=0,advertencia1=0;
        
        if(critico == true){
            critico1=1;
        }
        if(informativo == true){
            informativo1=1;
        }
        if(advertencia == true){
            advertencia1=1;
        }

        String fecha_inicial = request.getParameter("fecha_inicial");
        String fecha_final = request.getParameter("fecha_final");
        String id_arco = request.getParameter("id_arco");
        String color = request.getParameter("color");

        Boolean Motocicleta = Boolean.parseBoolean(request.getParameter("Motocicleta"));
        Boolean Carro = Boolean.parseBoolean(request.getParameter("Carro"));
        Boolean Taxi = Boolean.parseBoolean(request.getParameter("Taxi"));
        Boolean Camion = Boolean.parseBoolean(request.getParameter("Camion"));
        Boolean Camioneta = Boolean.parseBoolean(request.getParameter("Camioneta"));

        System.out.println(color);

        ArrayList<String> tipo_vehiculo = new ArrayList<>();

        if (Motocicleta == true) {
            tipo_vehiculo.add("Motocicleta");
        }
        if (Carro == true) {
            tipo_vehiculo.add("Carro");
        }
        if (Taxi == true) {
            tipo_vehiculo.add("Taxi");
        }
        if (Camion == true) {
            tipo_vehiculo.add("Camion");
        }
        if (Camioneta == true) {
            tipo_vehiculo.add("Camioneta");
        }
        
        JSONObject jsAlertas = new JSONObject();
        JSONObject jsAlertasTodas = new JSONObject();

        int contador = 0;

        for (int i = 0; i <= tipo_vehiculo.size(); i++) {
            try {
                System.out.println("Entro por: "+tipo_vehiculo.get(i));
                ResultSet rs = Conexion.query("select * from sp_consultar_lectura_vehiculo_tipo_vehiculo('" + fecha_inicial + "','" + fecha_final + "','" + id_arco + "','" + informativo1 + "','" + advertencia1 + "','" + critico1 + "','" + tipo_vehiculo.get(i) + "','" + color + "');");
                while (rs.next()) {
                    jsAlertas = new JSONObject();
                    jsAlertas.put("tipo_registro", rs.getString(1));
                    jsAlertas.put("fecha_hora", rs.getString(2));
                    jsAlertas.put("nombre_arco", rs.getString(3));
                    jsAlertas.put("descripcion", rs.getString(4));
                    jsAlertas.put("niv", rs.getString(5));
                    jsAlertas.put("fuente", rs.getString(6));
                    jsAlertas.put("placa", rs.getString(7));
                    try (ResultSet res = Conexion.query("select * from sp_ubicacion_arco('"+rs.getString(8)+"')")){
                        if (res.next()) {
                            jsAlertas.put("coordenadas", res.getString(1));
                        }
                    } catch (Exception e) {
                        log("ERROR", e.getMessage());
                    }
                    
                    jsAlertasTodas.put("Alerta"+contador, jsAlertas);
                    
                    contador++;
                }
            } catch (Exception e) {
            }
        }
        System.out.println(jsAlertasTodas);
        out.print(jsAlertasTodas);

    }

    @RequestMapping("lecturas_arco.htm") //1  
    public org.springframework.web.servlet.ModelAndView indexLecturas_vehiculos(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        org.springframework.web.servlet.ModelAndView mav = new org.springframework.web.servlet.ModelAndView();
        if (session == null || !request.isRequestedSessionIdValid()) {
            mav.setViewName("login");
        } else {
            
            ResultSet r = Conexion.query("SELECT * from public.sp_consultar_arcos();");
            ArrayList<Arco> arcos = new ArrayList<>();

            try {
                while (r.next()) {
                    double latitud, longitud;
                    String[] LatLng = r.getString("ubicacion").split(", ");
                    latitud = Double.parseDouble(LatLng[0].trim());
                    longitud = Double.parseDouble(LatLng[1].trim());

                    arcos.add(new Arco(
                            r.getInt("id_lector"),
                            r.getString("nombre"),
                            r.getString("descripcion"),
                            latitud,
                            longitud
                    ));
                }
                r.close();

                System.out.println("ARCOS_ENCONTRADOS: " + arcos.size());

                mav.addObject("arcos", arcos);

            } catch (SQLException ex) {
                Logger.getLogger(index.class.getName()).log(Level.SEVERE, null, ex);
            }
            
            mav.setViewName("lecturas_arco");
        }
        return mav;
    }

    private void log(String TAG, String message) {
        System.out.println("Log: "+TAG+"\t"+message);
    }
}
