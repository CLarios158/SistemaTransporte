/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package Controllers;

import Config.Conexion;
import Model.Arco;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.json.simple.parser.ParseException;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Controller;
import static org.springframework.test.web.client.match.MockRestRequestMatchers.method;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

/**
 *
 * @author oswal
 */
@Controller
public class lectura_vehiculo extends HttpServlet {

    //@RequestMapping(value = "/lecturas_vehiculos1.htm", method = RequestMethod.POST)
    @RequestMapping(value = "consultar_vehiculo.htm", method = RequestMethod.POST) //1  
    public void lecturas_vehiculos(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException, ParseException {
        PrintWriter out = response.getWriter();
        JSONObject jsonVehiculo = new JSONObject();
        JSONObject jsonAlertasVehiculo = new JSONObject();
        JSONObject jsonAlertasDatos = new JSONObject();

        Boolean niv = Boolean.parseBoolean(request.getParameter("check_niv"));
        Boolean placa = Boolean.parseBoolean(request.getParameter("check_placa"));
        String placa_niv = request.getParameter("placa");
        String fecha_inicial = request.getParameter("fecha_inicial");
        String fecha_final = request.getParameter("fecha_final");
        String id_arco = request.getParameter("id_arco");

        Boolean critico = Boolean.parseBoolean(request.getParameter("danger"));
        Boolean informativo = Boolean.parseBoolean(request.getParameter("info"));
        Boolean advertencia = Boolean.parseBoolean(request.getParameter("warning"));

        if (niv == true) {
            // Se buscara por niv

            String sql_vehiculo = "select * from sp_consultar_unidad_niv('" + placa_niv + "');";
            System.out.println(sql_vehiculo);
            //Procesa la consulta para almacenar los resultados en una lista, con el fin de pasar los valores mediante Mav a la vista.

            try {
                ResultSet r = Conexion.query("select * from sp_consultar_unidad_niv('" + placa_niv + "');");

                while (r.next()) {
                    jsonVehiculo.put("Tipo", r.getString(1));
                    jsonVehiculo.put("Marca", r.getString(2));
                    jsonVehiculo.put("Color", r.getString(3));
                    jsonVehiculo.put("Placa", r.getString(4));
                    jsonVehiculo.put("niv", r.getString(5));
                }
                r.close();

            } catch (Exception e) {
            }
            
            
            System.out.println(jsonVehiculo);
            //out.print(jsonVehiculo);
            
            
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
            JSONObject jsAlertasVehiculosCompletos = new JSONObject();
            int contador = 1;
          
            try {
                ResultSet r = Conexion.query("select * from sp_consultar_lectura_vehiculo_niv('" + placa_niv + "','" + fecha_inicial + "','" + fecha_final + "','" + id_arco + "','" + informativo1 + "','" + advertencia1 + "','" + critico1 + "');");
                
                while (r.next()) {
                    jsonAlertasVehiculo = new JSONObject();
                    jsonAlertasVehiculo.put("tipo_registro", r.getString(1));
                    jsonAlertasVehiculo.put("fecha_hora", r.getString(2));
                    jsonAlertasVehiculo.put("nombre_arco", r.getString(3));
                    jsonAlertasVehiculo.put("Descripcion", r.getString(4));
                    jsonAlertasVehiculo.put("niv", r.getString(5));
                    jsonAlertasVehiculo.put("fuente", r.getString(6));
                    try (ResultSet res = Conexion.query("select * from sp_ubicacion_arco('"+r.getString(7)+"')")){
                        if (res.next()) {
                            jsonAlertasVehiculo.put("coordenadas", res.getString(1));
                        }
                    } catch (Exception e) {
                        System.out.println(e.getMessage());
                    }
                    jsAlertasVehiculosCompletos.put("Alerta_"+contador,jsonAlertasVehiculo);
                    
                    contador++;
                }
                r.close();
                System.out.println(jsAlertasVehiculosCompletos);
                
               

            } catch (Exception e) {
            }
            
            jsonAlertasDatos.put("DatosVehiculo", jsonVehiculo);
            jsonAlertasDatos.put("DatosAlerta",jsAlertasVehiculosCompletos);
            
            
            System.out.println(jsonAlertasDatos);
            out.print(jsonAlertasDatos);
            
            //out.print("Hello");
            

        } else if (placa == true) {
            // Se buscara por placa
            
            String sql_vehiculo = "select * from sp_consultar_unidad_placa('" + placa_niv + "');";
            System.out.println(sql_vehiculo);
            //Procesa la consulta para almacenar los resultados en una lista, con el fin de pasar los valores mediante Mav a la vista.

            try {
                ResultSet r = Conexion.query("select * from sp_consultar_unidad_placa('" + placa_niv + "');");

                while (r.next()) {
                    jsonVehiculo.put("Tipo", r.getString(1));
                    jsonVehiculo.put("Marca", r.getString(2));
                    jsonVehiculo.put("Color", r.getString(3));
                    jsonVehiculo.put("Placa", r.getString(4));
                    jsonVehiculo.put("niv", r.getString(5));
                }
                r.close();

            } catch (Exception e) {
            }
            
            
            System.out.println(jsonVehiculo);
            //out.print(jsonVehiculo);
            
            
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
            JSONObject jsAlertasVehiculosCompletos = new JSONObject();
            int contador = 1;
          
            try {
                ResultSet r = Conexion.query("select * from sp_consultar_lectura_vehiculo_placa('" + placa_niv + "','" + fecha_inicial + "','" + fecha_final + "','" + id_arco + "','" + informativo1 + "','" + advertencia1 + "','" + critico1 + "');");
                
                while (r.next()) {
                    jsonAlertasVehiculo = new JSONObject();
                    jsonAlertasVehiculo.put("tipo_registro", r.getString(1));
                    jsonAlertasVehiculo.put("fecha_hora", r.getString(2));
                    jsonAlertasVehiculo.put("nombre_arco", r.getString(3));
                    jsonAlertasVehiculo.put("Descripcion", r.getString(4));
                    jsonAlertasVehiculo.put("niv", r.getString(5));
                    jsonAlertasVehiculo.put("fuente", r.getString(6));
                    jsAlertasVehiculosCompletos.put("Alerta_"+contador,jsonAlertasVehiculo);
                    
                    contador++;
                }
                r.close();
                System.out.println(jsAlertasVehiculosCompletos);
                
               

            } catch (Exception e) {
            }
            
            jsonAlertasDatos.put("DatosVehiculo", jsonVehiculo);
            jsonAlertasDatos.put("DatosAlerta",jsAlertasVehiculosCompletos);
            
            
            System.out.println(jsonAlertasDatos);
            out.print(jsonAlertasDatos);

        }

    }

    @RequestMapping("lecturas_vehiculo.htm") //1  
    public ModelAndView indexLecturas_vehiculos(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
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
            
            mav.setViewName("lecturas_vehiculo");
        }
        return mav;

    }

}
