package Config;

import java.sql.ResultSet;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.sql.Statement;

public class Conexion {

    private final static Connection CONEXION = conection();
    static Connection con = null;

    private static Connection conection() {
        try {
            Class.forName("org.postgresql.Driver");
        } catch (ClassNotFoundException e) {
            System.out.println("Class not found " + e);
        }
        try {
            //con = DriverManager.getConnection("jdbc:postgresql://localhost:5433/prueba", "postgres", "123456");//
            con = DriverManager.getConnection("jdbc:postgresql://yimicol2020.ddns.net:5432/Migo_Monitoreo", "clarios", "1234");
            //con = DriverManager.getConnection("jdbc:postgresql://192.168.1.66:5432/BD_Central_Arcos", "postgres", "kioadmin");
            return con;
        } catch (SQLException ex) {
            System.err.println("Error de conexion " + ex);
        }
        return null;
    }

    public static ResultSet query(String SQL) {
        System.out.println(SQL);
        try {
            return CONEXION.createStatement().executeQuery(SQL);
        } catch (SQLException ex) {  
            System.err.println("Error query " + ex);  
            return null;
        }
    }
    
    public static int update(String SQL) {
        System.out.println(SQL); 
        try {
            return CONEXION.createStatement().executeUpdate(SQL);
        } catch (SQLException ex) {
            System.err.println("Error update " + ex); 
            return 0;
        }
    }
    
    public static ResultSet queryPS(String SQL, String unidad) {
        System.out.println(SQL);
        System.out.println(unidad);
        try {
            PreparedStatement ps = CONEXION.prepareStatement(SQL);
            ps.setString(1, "%" + unidad + "%");
            return ps.executeQuery();
        } catch (SQLException ex) {
            System.err.println("Error query " + ex);
            return null;
        }
    }

    public Connection getConnection() {
        return con;
    }
}
