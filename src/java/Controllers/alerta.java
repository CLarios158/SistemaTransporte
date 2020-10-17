/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package Controllers;

import Config.Conexion;
import java.io.IOException;
import java.io.PrintWriter;
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
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

/**
 *
 * @author Carlos Larios
 */
public class alerta {
    
    PreparedStatement ps;
    ResultSet rs;
    
    
    @RequestMapping("alerta.htm")
    protected org.springframework.web.servlet.ModelAndView index(HttpServletResponse response, HttpServletRequest request) throws IOException {
        HttpSession session = request.getSession(false);
        org.springframework.web.servlet.ModelAndView mav = new org.springframework.web.servlet.ModelAndView();

         mav.setViewName("alerta");
        
        return mav;
    }
    
    @RequestMapping(value = "buscar_unidad_alerta.htm", method = RequestMethod.GET)
    public void buscar_unidad_alerta(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException, SQLException {
        
        Conexion Conexion = new Conexion();
        
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
        } finally {
            if (Conexion != null) { Conexion.executeQueryClose(); System.out.println("close conexion"); }
            if (rs != null) { rs.close(); System.out.println("close rs"); }  
        }
        
        out.println(unidades);
    }
    
    @RequestMapping(value = "obtener_unidad_alerta.htm", method = RequestMethod.POST)
    public void obtener_unidad_alerta(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException, JSONException, SQLException {
        
        Conexion Conexion = new Conexion();
       
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
            "GROUP BY cat.nombre, a.id_mensajealerta ORDER BY cat.nombre "); 
            
            while(rs.next()){
                Map m = new LinkedHashMap(3);
                m.put("id_mensajealerta", rs.getString(1));
                m.put("nombre", rs.getString(2));
                m.put("cantidad", rs.getString(3)); 
                alertasU.add(m);
            }
            
            datos.put("alertasUnidad",alertasU); 
            
        } catch (SQLException | JSONException e) {
            System.err.print(e);
        } finally {
            if (Conexion != null) { Conexion.executeQueryClose(); System.out.println("close conexion"); }
            if (rs != null) { rs.close(); System.out.println("close rs"); }  
        }
        
        try {
            rs = Conexion.query("SELECT a.id_mensajealerta, cat.nombre, COUNT(a.id_mensajealerta) as Numero\n" +
            "FROM alerta a INNER JOIN \"cat_mensajeAlerta\" cat on a.id_mensajealerta = cat.id_mensajealerta\n" +
            "WHERE a.niv = '"+niv+"' and cat.id_tipoalerta = 2\n" +
            "GROUP BY cat.nombre, a.id_mensajealerta ORDER BY cat.nombre"); 
            
            while(rs.next()){
                Map m = new LinkedHashMap(3);
                m.put("id_mensajealerta", rs.getString(1));
                m.put("nombre", rs.getString(2));
                m.put("cantidad", rs.getString(3));
                alertasA.add(m);  
            }
            
            datos.put("alertasAlcancia",alertasA);   
            
        } catch (SQLException | JSONException e) {
            System.err.print(e);
        } finally {
            if (Conexion != null) { Conexion.executeQueryClose(); System.out.println("close conexion"); }
            if (rs != null) { rs.close(); System.out.println("close rs"); }  
        }
        
        out.println(datos);
    }
    
    @RequestMapping(value = "obtener_datos_alerta.htm", method = RequestMethod.POST)
    public void obtener_datos_alerta(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException, JSONException, SQLException {
        
        Conexion Conexion = new Conexion();
        
        response.setContentType("application/json");
        PrintWriter out = response.getWriter();
        
        String id_mensajealerta = request.getParameter("id_mensajealerta");
        String niv = request.getParameter("niv");

        JSONObject datos = new JSONObject();
        JSONArray array = new JSONArray();
        
        if(null != id_mensajealerta)switch (id_mensajealerta) {
            case "1":
                // Puntos de control en los que se paro la unidad
                System.out.println("ENTRO AL IF 1");
                try {
                    rs = Conexion.query("SELECT to_char(al.fecha_hora::timestamp::time,'HH24:MI') as hora, al.fecha_hora::timestamp::date as Fecha, pc.nombre\n" +
                            "FROM alerta al INNER JOIN \"cat_puntoControl\" pc on al.valor::integer = pc.\"id_puntoControl\"\n" +
                            "WHERE niv = '"+niv+"' and id_mensajealerta = "+id_mensajealerta+";");
                    
                    while(rs.next()){
                        Map m = new LinkedHashMap(3);
                        m.put("hora",rs.getString(1));
                        m.put("fecha",rs.getString(2));
                        m.put("nombre",rs.getString(3));
                        array.add(m);
                    }
                    
                    datos.put("datos",array);
                    
                } catch (SQLException | JSONException e) {
                    System.err.print(e);
                } finally {
                    if (Conexion != null) { Conexion.executeQueryClose(); System.out.println("close conexion"); }
                    if (rs != null) { rs.close(); System.out.println("close rs"); }  
                }   break;
            case "2":
                // Paradas obligatoria no realizadas
                System.out.println("ENTRO AL IF 2");
                try {
                    rs = Conexion.query("SELECT to_char(fecha_hora::timestamp::time,'HH24:MI') as hora, fecha_hora::timestamp::date as Fecha, pa.nombre\n" +
                            "FROM alerta al INNER JOIN cat_paradas pa on al.valor::integer = pa.id_parada\n" +
                            "WHERE niv = '"+niv+"' and id_mensajealerta = "+id_mensajealerta+";");
                    
                    while(rs.next()){
                        Map m = new LinkedHashMap(3);
                        m.put("hora",rs.getString(1));
                        m.put("fecha",rs.getString(2));
                        m.put("ubicacion",rs.getString(3));
                        array.add(m);
                    }
                    
                    datos.put("datos",array);
                    
                } catch (SQLException | JSONException e) {
                    System.err.print(e);
                } finally {
                    if (Conexion != null) { Conexion.executeQueryClose(); System.out.println("close conexion"); }
                    if (rs != null) { rs.close(); System.out.println("close rs"); }  
                }  break;
            case "3":
                // Incumplimineto de itinerario
                System.out.println("ENTRO AL IF 3");
                try {
                    rs = Conexion.query("SELECT it.element->>'hora' as horaI, to_char(fecha_hora::timestamp::time,'HH24:MI') as horaR, fecha_hora::timestamp::date as Fecha, it.element->>'lugar' as lugar\n" +
                            "FROM alerta al\n" +
                            "INNER JOIN cat_unidad u on al.niv = u.\"NIV\"\n" +
                            "INNER JOIN (SELECT id_itinerario,id_unidad,jsonb_array_elements(\"KMZ\") as element FROM cat_itinerario) as it on u.id_unidad = it.id_unidad\n" +
                            "WHERE niv = '"+niv+"' and id_mensajealerta = "+id_mensajealerta+" and it.element->>'id' = al.valor");
                    
                    while(rs.next()){
                        Map m = new LinkedHashMap(3);
                        m.put("horaI",rs.getString(1));
                        m.put("horaR",rs.getString(2));
                        m.put("fecha",rs.getString(3));
                        m.put("ubicacion",rs.getString(4));
                        array.add(m);
                    }
                    
                    datos.put("datos",array);
                    
                } catch (SQLException | JSONException e) {
                    System.err.print(e);
                } finally {
                    if (Conexion != null) { Conexion.executeQueryClose(); System.out.println("close conexion"); }
                    if (rs != null) { rs.close(); System.out.println("close rs"); }  
                }  break;
            case "4":
                // Incumplimineto de recorrido
                System.out.println("ENTRO AL IF 4");
                try {
                    rs = Conexion.query("SELECT to_char(al.fecha_hora::timestamp::time,'HH24:MI') as hora, al.fecha_hora::timestamp::date as fecha, r.numero, ram.nombre, al.direccion\n" +
                            "FROM alerta al\n" +
                            "INNER JOIN cat_unidad u on al.niv = u.\"NIV\"\n" +
                            "INNER JOIN ruta_unidad ru on u.id_unidad = ru.id_unidad\n" +
                            "INNER JOIN cat_ruta r on ru.id_ruta = r.id_ruta\n" +
                            "INNER JOIN ramal_unidad rau on u.id_unidad = rau.id_unidad\n" +
                            "INNER JOIN cat_ramal ram on rau.id_ramal = ram.id_ramal\n" +
                            "WHERE niv = '"+niv+"' and id_mensajealerta = "+id_mensajealerta+";");
                    
                    while(rs.next()){
                        Map m = new LinkedHashMap(5);
                        m.put("hora",rs.getString(1));
                        m.put("fecha",rs.getString(2));
                        m.put("ruta",rs.getString(3));
                        m.put("ramal",rs.getString(4));
                        m.put("ubicacion",rs.getString(5));
                        array.add(m);
                    }
                    
                    datos.put("datos",array);
                    
                } catch (SQLException | JSONException e) {
                    System.err.print(e);
                } finally {
                    if (Conexion != null) { Conexion.executeQueryClose(); System.out.println("close conexion"); }
                    if (rs != null) { rs.close(); System.out.println("close rs"); }  
                }  break;
            case "5":
                // Exceso de velocidad
                System.out.println("ENTRO AL IF 5");
                try {
                    rs = Conexion.query("SELECT to_char(fecha_hora::timestamp::time,'HH24:MI') as hora, fecha_hora::timestamp::date as Fecha, valor, direccion\n" +
                            "FROM alerta\n" +
                            "WHERE niv = '"+niv+"' and id_mensajealerta = "+id_mensajealerta+";");
                    
                    while(rs.next()){
                        Map m = new LinkedHashMap(3);
                        m.put("hora",rs.getString(1));
                        m.put("fecha",rs.getString(2));
                        m.put("kph",rs.getString(3));
                        m.put("ubicacion",rs.getString(4));
                        array.add(m);
                    }
                    
                    datos.put("datos",array);
                    
                } catch (SQLException | JSONException e) {
                    System.err.print(e);
                } finally {
                    if (Conexion != null) { Conexion.executeQueryClose(); System.out.println("close conexion"); }
                    if (rs != null) { rs.close(); System.out.println("close rs"); }  
                }  break;
            case "6":
                // Unidad fuera de conexión
                System.out.println("ENTRO AL IF 6");
                try {
                    rs = Conexion.query("SELECT to_char(fecha_hora::timestamp::time,'HH24:MI') as hora, fecha_hora::timestamp::date as Fecha, direccion\n" +
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
                    
                } catch (SQLException | JSONException e) {
                    System.err.print(e);
                } finally {
                    if (Conexion != null) { Conexion.executeQueryClose(); System.out.println("close conexion"); }
                    if (rs != null) { rs.close(); System.out.println("close rs"); }  
                }  break;
            case "7":
                // Alcancía fuera de conexión
                System.out.println("ENTRO AL IF 7");
                try {
                    rs = Conexion.query("SELECT to_char(fecha_hora::timestamp::time,'HH24:MI') as hora, fecha_hora::timestamp::date as Fecha, direccion\n" +
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
                    
                } catch (SQLException | JSONException e) {
                    System.err.print(e);
                } finally {
                    if (Conexion != null) { Conexion.executeQueryClose(); System.out.println("close conexion"); }
                    if (rs != null) { rs.close(); System.out.println("close rs"); }  
                }  break;
            case "8":
                // Apertura de puerta
                System.out.println("ENTRO AL IF 8");
                try {
                    rs = Conexion.query("SELECT to_char(fecha_hora::timestamp::time,'HH24:MI') as hora, fecha_hora::timestamp::date as Fecha, direccion\n" +
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
                    
                } catch (SQLException | JSONException e) {
                    System.err.print(e);
                } finally {
                    if (Conexion != null) { Conexion.executeQueryClose(); System.out.println("close conexion"); }
                    if (rs != null) { rs.close(); System.out.println("close rs"); }  
                }  break;
            case "9":
                // Detección de tarjeta en lista negra
                System.out.println("ENTRO AL IF 9");
                try {
                    rs = Conexion.query("SELECT to_char(fecha_hora::timestamp::time,'HH24:MI') as hora, fecha_hora::timestamp::date as fecha, direccion, valor\n" +
                            "FROM alerta\n" +
                            "WHERE niv = '"+niv+"' and id_mensajealerta = "+id_mensajealerta+" ;");
                    
                    while(rs.next()){
                        Map m = new LinkedHashMap(4);
                        m.put("hora",rs.getString(1));
                        m.put("fecha",rs.getString(2));
                        m.put("ubicacion",rs.getString(3));
                        m.put("tarjeta",rs.getString(4));
                        array.add(m);
                    }
                    
                    datos.put("datos",array);
                    
                } catch (SQLException | JSONException e) {
                    System.err.print(e);
                } finally {
                    if (Conexion != null) { Conexion.executeQueryClose(); System.out.println("close conexion"); }
                    if (rs != null) { rs.close(); System.out.println("close rs"); }  
                }  break;
            case "10":
                // Papel térmico agotado
                System.out.println("ENTRO AL IF 10");
                try {
                    rs = Conexion.query("SELECT to_char(fecha_hora::timestamp::time,'HH24:MI') as hora, fecha_hora::timestamp::date as Fecha, direccion\n" +
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
                    
                } catch (SQLException | JSONException e) {
                    System.err.print(e);
                } finally {
                    if (Conexion != null) { Conexion.executeQueryClose(); System.out.println("close conexion"); }
                    if (rs != null) { rs.close(); System.out.println("close rs"); }  
                }  break;
            case "11":
                // Detección de pago excesivo con tarjeta
                System.out.println("ENTRO AL IF 11");
                try {
                    rs = Conexion.query("SELECT to_char(fecha_hora::timestamp::time,'HH24:MI') as hora, fecha_hora::timestamp::date as fecha, direccion, valor\n" +
                            "FROM alerta\n" +
                            "WHERE niv = '"+niv+"' and id_mensajealerta = "+id_mensajealerta+" ;");
                    
                    while(rs.next()){
                        Map m = new LinkedHashMap(4);
                        m.put("hora",rs.getString(1));
                        m.put("fecha",rs.getString(2));
                        m.put("ubicacion",rs.getString(3));
                        m.put("tarjeta",rs.getString(4));
                        array.add(m);
                    }
                    
                    datos.put("datos",array);
                    
                } catch (SQLException | JSONException e) {
                    System.err.print(e);
                } finally {
                    if (Conexion != null) { Conexion.executeQueryClose(); System.out.println("close conexion"); }
                    if (rs != null) { rs.close(); System.out.println("close rs"); }  
                }  break;
            case "12":
                // Alcancía por llenarse
                System.out.println("ENTRO AL IF 12");
                try {
                    rs = Conexion.query("SELECT to_char(fecha_hora::timestamp::time,'HH24:MI') as hora, fecha_hora::timestamp::date as Fecha, direccion\n" +
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
                      
                } catch (SQLException | JSONException e) {
                    System.err.print(e);
                } finally {
                    if (Conexion != null) { Conexion.executeQueryClose(); System.out.println("close conexion"); }
                    if (rs != null) { rs.close(); System.out.println("close rs"); }  
                }  break;
            default:
                break;
        }
        
        out.println(datos);
    }
    
     @RequestMapping(value = "obtener_datos_alerta_fecha.htm", method = RequestMethod.POST)
    public void obtener_datos_alerta_fecha(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException, JSONException, SQLException {
        
        Conexion Conexion = new Conexion();
       
        response.setContentType("application/json");
        PrintWriter out = response.getWriter();
        
        String id_mensajealerta = request.getParameter("id_mensajealerta");
        String niv = request.getParameter("niv");
        String fecha_inicio = request.getParameter("fecha_inicio");
        String fecha_fin = request.getParameter("fecha_fin");

        JSONObject datos = new JSONObject();
        JSONArray array = new JSONArray();
        
        if(null != id_mensajealerta)switch (id_mensajealerta) {
            case "1":
                // Puntos de control en los que se paro la unidad
                System.out.println("ENTRO AL IF 1");
                try {
                    rs = Conexion.query("SELECT to_char(al.fecha_hora::timestamp::time,'HH24:MI') as hora, al.fecha_hora::timestamp::date as Fecha, pc.nombre\n" +
                            "FROM alerta al INNER JOIN \"cat_puntoControl\" pc on al.valor::integer = pc.\"id_puntoControl\"\n" +
                            "WHERE al.niv = '"+niv+"' and al.id_mensajealerta = "+id_mensajealerta+" and al.fecha_hora::timestamp::date >= '"+fecha_inicio+"' and al.fecha_hora::timestamp::date <= '"+fecha_fin+"';");
                    
                    while(rs.next()){
                        Map m = new LinkedHashMap(3);
                        m.put("hora",rs.getString(1));
                        m.put("fecha",rs.getString(2));
                        m.put("ubicacion",rs.getString(3));
                        array.add(m);
                    }
                    
                    datos.put("datos",array);
                    
                } catch (SQLException | JSONException e) {
                    System.err.print(e);
                } finally {
                    if (Conexion != null) { Conexion.executeQueryClose(); System.out.println("close conexion"); }
                    if (rs != null) { rs.close(); System.out.println("close rs"); }  
                }  break;
            case "2":
                // Paradas obligatoria no realizadas
                System.out.println("ENTRO AL IF 2");
                try {
                    rs = Conexion.query("SELECT to_char(fecha_hora::timestamp::time,'HH24:MI') as hora, fecha_hora::timestamp::date as Fecha, pa.nombre\n" +
                            "FROM alerta al INNER JOIN cat_paradas pa on al.valor::integer = pa.id_parada\n" +
                            "WHERE niv = '"+niv+"' and id_mensajealerta = "+id_mensajealerta+" and al.fecha_hora::timestamp::date >= '"+fecha_inicio+"' and al.fecha_hora::timestamp::date <= '"+fecha_fin+"';");
                    
                    while(rs.next()){
                        Map m = new LinkedHashMap(3);
                        m.put("hora",rs.getString(1));
                        m.put("fecha",rs.getString(2));
                        m.put("ubicacion",rs.getString(3));
                        array.add(m);
                    }
                    
                    datos.put("datos",array);
                    
                } catch (SQLException | JSONException e) {
                    System.err.print(e);
                } finally {
                    if (Conexion != null) { Conexion.executeQueryClose(); System.out.println("close conexion"); }
                    if (rs != null) { rs.close(); System.out.println("close rs"); }  
                }  break;
            case "3":
                // Incumplimineto de itinerario
                System.out.println("ENTRO AL IF 3");
                try {
                    rs = Conexion.query("SELECT it.element->>'hora' as horaI, to_char(fecha_hora::timestamp::time,'HH24:MI') as horaR, fecha_hora::timestamp::date as Fecha, it.element->>'lugar' as lugar\n" +
                            "FROM alerta al \n" +
                            "INNER JOIN cat_unidad u on al.niv = u.\"NIV\"\n" +
                            "INNER JOIN (SELECT id_itinerario,id_unidad,jsonb_array_elements(\"KMZ\") as element FROM cat_itinerario) as it on u.id_unidad = it.id_unidad\n" +
                            "WHERE niv = '"+niv+"' and id_mensajealerta = "+id_mensajealerta+" and al.fecha_hora::timestamp::date >= '"+fecha_inicio+"' and al.fecha_hora::timestamp::date <= '"+fecha_fin+"';");
                    
                    while(rs.next()){
                        Map m = new LinkedHashMap(3);
                        m.put("horaI",rs.getString(1));
                        m.put("horaR",rs.getString(2));
                        m.put("fecha",rs.getString(3));
                        m.put("ubicacion",rs.getString(4));
                        array.add(m);
                    }
                    
                    datos.put("datos",array);
                    
                } catch (SQLException | JSONException e) {
                    System.err.print(e);
                } finally {
                    if (Conexion != null) { Conexion.executeQueryClose(); System.out.println("close conexion"); }
                    if (rs != null) { rs.close(); System.out.println("close rs"); }  
                }  break;
            case "4":
                // Incumplimineto de recorrido
                System.out.println("ENTRO AL IF 4");
                try {
                    rs = Conexion.query("SELECT to_char(al.fecha_hora::timestamp::time,'HH24:MI') as hora, al.fecha_hora::timestamp::date as fecha, r.numero, ram.nombre, al.direccion\n" +
                            "FROM alerta al\n" +
                            "INNER JOIN cat_unidad u on al.niv = u.\"NIV\"\n" +
                            "INNER JOIN ruta_unidad ru on u.id_unidad = ru.id_unidad\n" +
                            "INNER JOIN cat_ruta r on ru.id_ruta = r.id_ruta\n" +
                            "INNER JOIN ramal_unidad rau on u.id_unidad = rau.id_unidad\n" +
                            "INNER JOIN cat_ramal ram on rau.id_ramal = ram.id_ramal\n" +
                            "WHERE niv = '"+niv+"' and id_mensajealerta = "+id_mensajealerta+" and al.fecha_hora::timestamp::date >= '"+fecha_inicio+"' and al.fecha_hora::timestamp::date <= '"+fecha_fin+"';");
                    
                    while(rs.next()){
                        Map m = new LinkedHashMap(5);
                        m.put("hora",rs.getString(1));
                        m.put("fecha",rs.getString(2));
                        m.put("ruta",rs.getString(3));
                        m.put("ramal",rs.getString(4));
                        m.put("ubicacion",rs.getString(5));
                        array.add(m);
                    }
                    
                    datos.put("datos",array);
                    
                } catch (SQLException | JSONException e) {
                    System.err.print(e);
                } finally {
                    if (Conexion != null) { Conexion.executeQueryClose(); System.out.println("close conexion"); }
                    if (rs != null) { rs.close(); System.out.println("close rs"); }  
                }  break;
            case "5":
                // Exceso de velocidad
                System.out.println("ENTRO AL IF 5");
                try {
                    rs = Conexion.query("SELECT to_char(fecha_hora::timestamp::time,'HH24:MI') as hora, fecha_hora::timestamp::date as Fecha, valor, direccion\n" +
                            "FROM alerta al \n" +
                            "WHERE niv = '"+niv+"' and id_mensajealerta = "+id_mensajealerta+" and al.fecha_hora::timestamp::date >= '"+fecha_inicio+"' and al.fecha_hora::timestamp::date <= '"+fecha_fin+"';");
                    
                    while(rs.next()){
                        Map m = new LinkedHashMap(3);
                        m.put("hora",rs.getString(1));
                        m.put("fecha",rs.getString(2));
                        m.put("kph",rs.getString(3));
                        m.put("ubicacion",rs.getString(4));
                        array.add(m);
                    }
                    
                    datos.put("datos",array);
                    
                } catch (SQLException | JSONException e) {
                    System.err.print(e);
                } finally {
                    if (Conexion != null) { Conexion.executeQueryClose(); System.out.println("close conexion"); }
                    if (rs != null) { rs.close(); System.out.println("close rs"); }  
                }  break;
            case "6":
                // Unidad fuera de conexión
                System.out.println("ENTRO AL IF 6");
                try {
                    rs = Conexion.query("SELECT to_char(fecha_hora::timestamp::time,'HH24:MI') as hora, fecha_hora::timestamp::date as Fecha, direccion\n" +
                            "FROM alerta al\n" +
                            "WHERE niv = '"+niv+"' and id_mensajealerta = "+id_mensajealerta+" and al.fecha_hora::timestamp::date >= '"+fecha_inicio+"' and al.fecha_hora::timestamp::date <= '"+fecha_fin+"';");
                    
                    while(rs.next()){
                        Map m = new LinkedHashMap(3);
                        m.put("hora",rs.getString(1));
                        m.put("fecha",rs.getString(2));
                        m.put("ubicacion",rs.getString(3));
                        array.add(m);
                    }
                    
                    datos.put("datos",array);
                    
                } catch (SQLException | JSONException e) {
                    System.err.print(e);
                } finally {
                    if (Conexion != null) { Conexion.executeQueryClose(); System.out.println("close conexion"); }
                    if (rs != null) { rs.close(); System.out.println("close rs"); }  
                }  break;
            case "7":
                // Alcancía fuera de conexión
                System.out.println("ENTRO AL IF 7");
                try {
                    rs = Conexion.query("SELECT to_char(fecha_hora::timestamp::time,'HH24:MI') as hora, fecha_hora::timestamp::date as Fecha, direccion\n" +
                            "FROM alerta al\n" +
                            "WHERE niv = '"+niv+"' and id_mensajealerta = "+id_mensajealerta+" and al.fecha_hora::timestamp::date >= '"+fecha_inicio+"' and al.fecha_hora::timestamp::date <= '"+fecha_fin+"';");
                    
                    while(rs.next()){
                        Map m = new LinkedHashMap(3);
                        m.put("hora",rs.getString(1));
                        m.put("fecha",rs.getString(2));
                        m.put("ubicacion",rs.getString(3));
                        array.add(m);
                    }
                    
                    datos.put("datos",array);
                    
                } catch (SQLException | JSONException e) {
                    System.err.print(e);
                } finally {
                    if (Conexion != null) { Conexion.executeQueryClose(); System.out.println("close conexion"); }
                    if (rs != null) { rs.close(); System.out.println("close rs"); }  
                }  break;
            case "8":
                // Apertura de puerta
                System.out.println("ENTRO AL IF 8");
                try {
                    rs = Conexion.query("SELECT to_char(fecha_hora::timestamp::time,'HH24:MI') as hora, fecha_hora::timestamp::date as Fecha, direccion\n" +
                            "FROM alerta al\n" +
                            "WHERE niv = '"+niv+"' and id_mensajealerta = "+id_mensajealerta+" and al.fecha_hora::timestamp::date >= '"+fecha_inicio+"' and al.fecha_hora::timestamp::date <= '"+fecha_fin+"';");
                    
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
                } finally {
                    if (Conexion != null) { Conexion.executeQueryClose(); System.out.println("close conexion"); }
                    if (rs != null) { rs.close(); System.out.println("close rs"); }  
                }  break;
            case "9":
                // Detección de tarjeta en lista negra
                System.out.println("ENTRO AL IF 9");
                try {
                    rs = Conexion.query("SELECT to_char(fecha_hora::timestamp::time,'HH24:MI') as hora, fecha_hora::timestamp::date as fecha, direccion, valor\n" +
                            "FROM alerta al\n" +
                            "WHERE niv = '"+niv+"' and id_mensajealerta = "+id_mensajealerta+" and al.fecha_hora::timestamp::date >= '"+fecha_inicio+"' and al.fecha_hora::timestamp::date <= '"+fecha_fin+"';");
                    
                    while(rs.next()){
                        Map m = new LinkedHashMap(4);
                        m.put("hora",rs.getString(1));
                        m.put("fecha",rs.getString(2));
                        m.put("ubicacion",rs.getString(3));
                        m.put("tarjeta",rs.getString(4));
                        array.add(m);
                    }
                    
                    datos.put("datos",array);
                    
                } catch (SQLException | JSONException e) {
                    System.err.print(e);
                }  finally {
                    if (Conexion != null) { Conexion.executeQueryClose(); System.out.println("close conexion"); }
                    if (rs != null) { rs.close(); System.out.println("close rs"); }  
                } break;
            case "10":
                // Papel térmico agotado
                System.out.println("ENTRO AL IF 10");
                try {
                    rs = Conexion.query("SELECT to_char(fecha_hora::timestamp::time,'HH24:MI') as hora, fecha_hora::timestamp::date as Fecha, direccion\n" +
                            "FROM alerta al\n" +
                            "WHERE niv = '"+niv+"' and id_mensajealerta = "+id_mensajealerta+" and al.fecha_hora::timestamp::date >= '"+fecha_inicio+"' and al.fecha_hora::timestamp::date <= '"+fecha_fin+"';");
                    
                    while(rs.next()){
                        Map m = new LinkedHashMap(3);
                        m.put("hora",rs.getString(1));
                        m.put("fecha",rs.getString(2));
                        m.put("ubicacion",rs.getString(3));
                        array.add(m);
                    }
                    
                    datos.put("datos",array);
                    
                } catch (SQLException | JSONException e) {
                    System.err.print(e);
                } finally {
                    if (Conexion != null) { Conexion.executeQueryClose(); System.out.println("close conexion"); }
                    if (rs != null) { rs.close(); System.out.println("close rs"); }  
                }  break;
            case "11":
                // Detección de pago excesivo con tarjeta
                System.out.println("ENTRO AL IF 11");
                try {
                    rs = Conexion.query("SELECT to_char(fecha_hora::timestamp::time,'HH24:MI') as hora, fecha_hora::timestamp::date as fecha, direccion, valor\n" +
                            "FROM alerta al\n" +
                            "WHERE niv = '"+niv+"' and id_mensajealerta = "+id_mensajealerta+" and al.fecha_hora::timestamp::date >= '"+fecha_inicio+"' and al.fecha_hora::timestamp::date <= '"+fecha_fin+"';");
                    
                    while(rs.next()){
                        Map m = new LinkedHashMap(4);
                        m.put("hora",rs.getString(1));
                        m.put("fecha",rs.getString(2));
                        m.put("ubicacion",rs.getString(3));
                        m.put("tarjeta",rs.getString(4));
                        array.add(m);
                    }
                    
                    datos.put("datos",array);
                    
                } catch (SQLException | JSONException e) {
                    System.err.print(e);
                } finally {
                    if (Conexion != null) { Conexion.executeQueryClose(); System.out.println("close conexion"); }
                    if (rs != null) { rs.close(); System.out.println("close rs"); }  
                }  break;
            case "12":
                // Alcancía por llenarse
                System.out.println("ENTRO AL IF 12");
                try {
                    rs = Conexion.query("SELECT to_char(fecha_hora::timestamp::time,'HH24:MI') as hora, fecha_hora::timestamp::date as Fecha, direccion\n" +
                            "FROM alerta al\n" +
                            "WHERE niv = '"+niv+"' and id_mensajealerta = "+id_mensajealerta+" and al.fecha_hora::timestamp::date >= '"+fecha_inicio+"' and al.fecha_hora::timestamp::date <= '"+fecha_fin+"';");
                    
                    while(rs.next()){
                        Map m = new LinkedHashMap(3);
                        m.put("hora",rs.getString(1));
                        m.put("fecha",rs.getString(2));
                        m.put("ubicacion",rs.getString(3));
                        array.add(m);
                    }
                    
                    datos.put("datos",array);
                      
                } catch (SQLException | JSONException e) {
                    System.err.print(e);
                }  finally {
                    if (Conexion != null) { Conexion.executeQueryClose(); System.out.println("close conexion"); }
                    if (rs != null) { rs.close(); System.out.println("close rs"); }  
                } break;
            default:
                break;
        }
        
        out.println(datos);
    }
    
    
}
