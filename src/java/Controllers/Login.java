/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package Controllers;

import Config.Conexion;
import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.sql.ResultSet;
import java.util.List;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import org.apache.http.client.methods.CloseableHttpResponse;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.entity.StringEntity;
import org.apache.http.impl.client.CloseableHttpClient;
import org.apache.http.impl.client.HttpClients;
import org.apache.http.util.EntityUtils;
import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.json.simple.parser.ParseException;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

/**
 *
 * @author marti
 */
public class Login {

    @RequestMapping("login.htm") //1  
    public ModelAndView controlador_add(HttpServletRequest request, HttpServletResponse response) throws UnsupportedEncodingException, ParseException, IOException {
        String usuario = request.getParameter("inputUsuario");
        String password = request.getParameter("inputPassword");

        ModelAndView mav = new ModelAndView();
        
                
        /*try (ResultSet r = Conexion.query("select * from sp_validar_usuario('" + usuario + "','" + password + "');")) {
            System.out.println("Entro al try");
            if (r.next()) {
                String codigo = r.getString(1);
                System.out.println("########### HAY REGISTRO ###########");
                if (codigo.equals("1")) {
                    System.out.println("Entro al if");
                    HttpSession session = request.getSession(true);
                    session.setAttribute("usuario", usuario);
                    //mav.setViewName("index");
                } else {
                    mav.setViewName("login");
                }
            }
        } catch (Exception e) {
            System.out.println(e);
        }*/

        /*// URL
        HttpPost post = new HttpPost("http://127.0.0.1:3001/webservice/validar_usuario");

        // Headers
        post.addHeader("Accept", "application/json");
        post.addHeader("content-type", "application/json");

        // Body en formato JSON
        StringBuilder body = new StringBuilder();
        body.append("{");
        body.append("\"p_usuario\": \"").append(usuario).append("\",");
        body.append("\"p_contrasena\": \"").append(password).append("\"");
        body.append("}");

        // Enviar el JSON
        post.setEntity(new StringEntity(body.toString()));
        try (
            CloseableHttpClient httpClient = HttpClients.createDefault();
            CloseableHttpResponse responses = httpClient.execute(post);) {

            String res = EntityUtils.toString(responses.getEntity());
            System.out.println(res);

            JSONObject datos = (JSONObject) new JSONParser().parse(res);
            JSONArray array = (JSONArray) datos.get("datos");
            JSONObject array0 = (JSONObject) array.get(0);
            System.out.println(array0.get("codigo"));
            Long resp = (Long) array0.get("codigo");

            if (resp == 1) {
                HttpSession session = request.getSession(true);
                session.setAttribute("usuario", usuario);
                httpClient.close();
                mav.setViewName("index");
            } else {
                httpClient.close();
                mav.setViewName("login");
            }

        } catch (ParseException ex) {
            System.out.println("Error: " + ex);
        }*/
        return mav;

    }

    @RequestMapping("logout.htm")
    protected ModelAndView logout(HttpServletResponse response, HttpServletRequest request) throws IOException {
        HttpSession session = request.getSession(true);
        session.invalidate();
        ModelAndView mav = new ModelAndView();
        mav.setViewName("login");
        return mav;
    }

}
