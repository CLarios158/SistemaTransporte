/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package Controllers;

import Config.Conexion;
import java.io.BufferedOutputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Statement;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import org.json.simple.JSONObject;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.commons.CommonsMultipartFile;

/**
 *
 * @author Carlos Larios
 */
@Controller
public class crear_capa extends HttpServlet {

    PreparedStatement ps;
    ResultSet rs;
    Statement s;

    @RequestMapping("crear_capa.htm")
    protected org.springframework.web.servlet.ModelAndView index(HttpServletResponse response, HttpServletRequest request) throws IOException {
        HttpSession session = request.getSession(false);
        org.springframework.web.servlet.ModelAndView mav = new org.springframework.web.servlet.ModelAndView();

        mav.setViewName("crear_capa");

        return mav;
    }
    
    @RequestMapping(value = "validar_capa.htm", method = RequestMethod.POST)
    public void validar_capa(HttpServletRequest request, HttpSession session, HttpServletResponse response) throws ServletException, IOException, SQLException {
        
        Conexion Conexion = new Conexion();
        
        response.setContentType("application/json");
        PrintWriter out = response.getWriter();
        
        String nombre = request.getParameter("nombre");
        System.out.println(nombre);
         
        JSONObject datos = new JSONObject();
        
        try {
            rs = Conexion.query("SELECT nombre FROM cat_capa WHERE UPPER(nombre) = UPPER('"+nombre+"')");  
            
            while(rs.next()){
                datos.put("nombre",rs.getString(1)); 
            } 
            
        } catch (SQLException e) {
            System.err.print(e);
        } finally {
            if (Conexion != null) { Conexion.executeQueryClose(); System.out.println("close conexion"); }
            if (rs != null) { rs.close(); System.out.println("close rs"); }  
        }
        
        out.println(datos); 
    }

    @RequestMapping(value = "registrar_capa.htm", method = RequestMethod.POST)
    public void registrar_capa(HttpServletRequest request, HttpSession session, HttpServletResponse response, @RequestParam CommonsMultipartFile file) throws ServletException, IOException, SQLException {
        
        Conexion Conexion = new Conexion();
        
        response.setContentType("application/json");
        PrintWriter out = response.getWriter();
        
        String path=session.getServletContext().getRealPath("/");
        String ruta = path.replace("\\build\\web\\","\\web\\");    
        String filename = file.getOriginalFilename();  
          
        String nombre = request.getParameter("nombre");
        byte[] nombreBytes = nombre.getBytes("ISO-8859-1");
        String nombreEncode = new String(nombreBytes, "UTF-8");
        String kmz = request.getParameter("kmz");
        String statusCapa = request.getParameter("statusCapa");
        String fecha_registro = request.getParameter("fecha_registro");
        String rutaIcon = "images/"+filename;
        
        try{  
            byte barr[] = file.getBytes();  

            BufferedOutputStream br = new BufferedOutputStream(new FileOutputStream(ruta+"images/"+filename));  
            br.write(barr);  
            br.flush();  
            br.close();      
        } catch(IOException e){
            System.out.println(e);
        } 
        
        JSONObject datos = new JSONObject();
        
        try {
            s = Conexion.update("select * from sp_registrar_capa('" + nombreEncode + "','" + statusCapa + "','" + kmz + "','" + fecha_registro + "','" + rutaIcon + "');");
            
            rs = s.getGeneratedKeys(); //Obtener el id que se genero al realizar el INSERT
            /*while(rs.next()){
                datos.put("nombre", rs.getString(1)); 
                datos.put("statusCapa", rs.getString(2));
                datos.put("coordenadas", rs.getString(3));
                datos.put("icon", rs.getString(6));  
                datos.put("fecha_registro", rs.getString(4));
            }*/
            
        } catch (SQLException e) {
            System.err.print(e);
        } finally {
            if (Conexion != null) { Conexion.executeQueryCloseUpdate(); System.out.println("close conexion"); }
            if (rs != null) { rs.close(); System.out.println("close rs"); }  
        } 
        
        out.println(datos); 
    }

}
