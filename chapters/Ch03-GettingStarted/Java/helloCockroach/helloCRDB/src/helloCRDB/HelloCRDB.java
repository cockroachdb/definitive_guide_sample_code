package helloCRDB;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.Statement;

public class HelloCRDB {

        public static void main(String[] args) {
                Connection cdb = null;
                try {
                        Class.forName("org.postgresql.Driver");
                        String connectionURL = "jdbc:" + args[0];
                        String userName = args[1];
                        String passWord = args[2];

                        cdb = DriverManager.getConnection(connectionURL, userName, passWord);
                        Statement stmt = cdb.createStatement();
                        ResultSet rs = stmt.executeQuery("SELECT CONCAT('Hello from CockroachDB at ',"
                                        + "CAST (NOW() as STRING)) AS hello");
                        rs.next();
                        System.out.println(rs.getString("hello"));

                } catch (Exception e) {
                        e.printStackTrace();
                        System.err.println(e.getClass().getName() + ": " + e.getMessage());
                        System.exit(0);
                }

        }

}