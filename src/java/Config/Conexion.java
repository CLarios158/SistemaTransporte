package Config;

import java.io.FileNotFoundException;
import java.io.IOException;
import java.sql.ResultSet;
import java.sql.Connection;
import java.sql.SQLException;
import java.sql.Statement;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.datasource.DriverManagerDataSource;

public class Conexion {
    
    public DriverManagerDataSource dataSource;
    //
    public static String servidorBD = "yimicol2020.ddns.net";
    public static String puertoBD = "5432";
    public static String nombreBD = "Migo_Monitoreo";
    public static String usuarioBD = "postgres";
    //public static String passwordBD = "NU3V0.M4N4G3R";
    public static String passwordBD = "kioadmin";
    
    public  Connection conexion = null;
    public  Statement stt_Sentencia = null;
    public  ResultSet resultSet;
    public JdbcTemplate jdbcTemplate;
    
    public DriverManagerDataSource conectar() throws IOException, SQLException
    {
        //System.out.println("Inicializando configuraci[on de conexi'on...");
        dataSource = new DriverManagerDataSource();
        dataSource.setDriverClassName("org.postgresql.Driver");
        dataSource.setUrl("jdbc:postgresql://"+servidorBD+":"+puertoBD+"/"+nombreBD);
        dataSource.setUsername(usuarioBD);
        dataSource.setPassword(passwordBD);
        //System.out.println("Intentanto conectar base de datos...");
        // Inicializar conexi'on
        try{
            conexion = dataSource.getConnection();
            conexion.setAutoCommit(false);
            System.out.println("Conexi'on realizada exitosamente...");
        } catch (SQLException error) {
            conexion = null;
            System.err.println("Conexi'on fallida : " + error.getMessage());
        }
        return dataSource;
        
    }
    
    public JdbcTemplate createJdbcTemplate()
    {
        try{
            jdbcTemplate = new JdbcTemplate(dataSource);
        }catch(Exception error){
            jdbcTemplate = null;
        }
        return jdbcTemplate;
    }
    
    public ResultSet query(String sqlQuery) throws FileNotFoundException {
      try {
        System.out.println(sqlQuery);
        // Conectar
        conectar();
        stt_Sentencia = conexion.createStatement();
        resultSet = stt_Sentencia.executeQuery(sqlQuery);
        conexion.commit();
      } catch (IOException | SQLException e) {
          System.err.println("Error al ejecutar Query:"+e.getMessage());
          return null;
      }
      return resultSet;
        
   }
    
   public boolean executeQueryClose() throws FileNotFoundException, SQLException {
       stt_Sentencia.close();
       //conexion.commit();
       conexion.close();
       return true;
   }
   
   public boolean executeQueryCloseUpdate(){
        try {
            stt_Sentencia.close();
            //conexion.commit();
            conexion.close();
            return true;
        } catch (SQLException e) {
            System.err.println("Error al ejecutar Query:"+e.getMessage());
            return false;
        }
   }
   public Statement update(String SQL) throws IOException{
        System.out.println(SQL);
        try{
            conectar();
            stt_Sentencia = conexion.createStatement();
            stt_Sentencia.executeUpdate(SQL, Statement.RETURN_GENERATED_KEYS);
            conexion.commit();
            return stt_Sentencia;
        } 
        catch(SQLException ex){
            System.out.println(ex.getMessage());
            return null;
        }
        /*return conexion.createStatement().executeUpdate(SQL);
        return 0;*/
        /*try {
            return CONEXION.createStatement().executeUpdate(SQL);
        } catch (SQLException ex) {
            System.err.println("Error update "+ex);
            return 0;
        }*/
    }

    /*private final static Connection CONEXION = conection();
    static Connection con = null;

    private static Connection conection() {
        try {
            Class.forName("org.postgresql.Driver");
        } catch (ClassNotFoundException e) {
            System.out.println("Class not found " + e);
        }
        try {
            //con = DriverManager.getConnection("jdbc:postgresql://localhost:5433/prueba2", "postgres", "123456");//
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
    }*/
}
