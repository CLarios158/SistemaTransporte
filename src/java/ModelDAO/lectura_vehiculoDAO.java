/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package ModelDAO;

import Config.Conexion;
import Model.lectura_vehiculo;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

/**
 *
 * @author oswal
 */
public class lectura_vehiculoDAO {
    Conexion cn = new Conexion();
    Connection con;
    PreparedStatement ps;
    ResultSet rs;
    lectura_vehiculo lv = new lectura_vehiculo();
    

    
    public List listar_autos_interfazPrincipal() {
        ArrayList<lectura_vehiculo>list=new ArrayList<>();
        String sql = "select * from sp_consultar_alerta_arcos_interfaz1('100','1','1','1')";
        try{
            con=cn.getConnection();
            ps=con.prepareStatement(sql);
            rs=ps.executeQuery();
            while(rs.next()){
                lectura_vehiculo lv = new lectura_vehiculo();
                lv.setTipo_registro(rs.getInt("tipo_registro"));
                lv.setFecha_hora(rs.getString("fecha_hora"));
                lv.setNombre_arco(rs.getString("nombre_arco"));
                lv.setDescripcion(rs.getString("descripcion"));
                lv.setPlaca_niv(rs.getString("placa_niv"));
                lv.setFuente_informacion(rs.getString("fuente_informacion"));
                list.add(lv);
                
            }
        }catch(Exception e){
        }
        
        return list;
    }
    
}
