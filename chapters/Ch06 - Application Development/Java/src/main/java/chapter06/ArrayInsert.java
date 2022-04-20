/* 
Array inserts in Java

CockroachDB the Definitive Guide sample code 
This code  is public domain software, i.e. not copyrighted.

Warranty Exclusion
------------------
You agree that this software is a non-commercially developed program that may 
contain "bugs"   and that it may not function as intended.
The software is licensed "as is". The authors make no, and hereby expressly
disclaim all, warranties, express, implied, statutory, or otherwise
with respect to the software, including noninfringement and the implied
warranties of merchantability and fitness for a particular purpose.

@author:  gharriso (guy.a.harrison@gmail.com)
*/

package chapter06;

import java.sql.*;
import java.util.ArrayList;

public class ArrayInsert {

  public static void main(String[] args) {

    try {
      Class.forName("org.postgresql.Driver");
      String connectionURL = "jdbc:" + args[0];
      String userName = args[1];
      String passWord = args[2];

      Connection connection = DriverManager.getConnection(connectionURL, userName, passWord);
      connection.setAutoCommit(false);
      Statement stmt=connection.createStatement();
      
      int arrayCount=100;
      ArrayList<Integer> idArray=new ArrayList<>(arrayCount);
      ArrayList<String> xArray=new ArrayList<>(arrayCount);
      ArrayList<Integer> yArray=new ArrayList<>(arrayCount);
      for (int i=0;i<arrayCount;i++) {
        idArray.add(i);
        yArray.add(i);
        xArray.add("Nonsense");
      }
      stmt.execute("USE chapter06");
      stmt.execute("TRUNCATE TABLE insertTest");
      
      String sql="INSERT INTO insertTest(id,x,y) VALUES (?,?,?)";
      PreparedStatement InsertStmt = connection.prepareStatement(sql);
      
      for (int arrayIdx = 1; arrayIdx < arrayCount; arrayIdx++) {
          InsertStmt.setInt(1, idArray.get(arrayIdx)); 
          InsertStmt.setString(2, xArray.get(arrayIdx)); 
          InsertStmt.setInt(3, yArray.get(arrayIdx)); 
          InsertStmt.addBatch();  
          } 
      
      InsertStmt.executeBatch();
      connection.close();

    } catch (

    Exception e) {
      e.printStackTrace();
      System.exit(0);
    }

  }

  public static void traceData(Connection connection) throws SQLException {
    String sql = "SELECT age , message\n" + "        FROM [SHOW TRACE FOR SESSION]\n"
        + "        WHERE message LIKE 'query cache miss'\n" + "        OR message LIKE 'rows affected%'\n"
        + "        OR message LIKE '%executing PrepareStmt%'\n" + "        OR message LIKE 'executing:%'\n"
        + "        ORDER BY age";
    Statement stmt=connection.createStatement();
    ResultSet results = stmt.executeQuery(sql);
    for (int ri = 0; ri < 10; ri++) {
      if (results.next())
        System.out.println(results.getString("MESSAGE"));
    }
  }

}
