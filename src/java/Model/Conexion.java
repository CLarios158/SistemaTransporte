package Model;

import java.sql.ResultSet;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;



public class Conexion {
    
    private final static Connection CONEXION = conection();
    
    private static Connection conection(){
        try {
            return DriverManager.getConnection("jdbc:postgresql://localhost:5433/BD_Central_Arcos", "postgres", "1234");
        } catch (SQLException ex) {
            System.err.println("Error de conexion "+ex);
        }
        return null;
    }
    
    public static ResultSet query(String SQL){
        System.out.println(SQL);
        try {
            return CONEXION.createStatement().executeQuery(SQL);
        } catch (SQLException ex) {
            System.err.println("Error query "+ex);
            return null;
        }   
    }
    
    public static int update(String SQL){
        System.out.println(SQL);
        try {
            return CONEXION.createStatement().executeUpdate(SQL);
        } catch (SQLException ex) {
            System.err.println("Error update "+ex);
            return 0;
        }
    }
}

