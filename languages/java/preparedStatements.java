/* 
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

/* Using prepared statements in java */

package chapter06;

import java.sql.*;

public class preparedStatements {

  public static void main(String[] args) {

    try {
      Class.forName("org.postgresql.Driver");
      String connectionURL = "jdbc:" + args[0];
      String userName = args[1];
      String passWord = args[2];

      Connection connection = DriverManager.getConnection(connectionURL, userName, passWord);
      connection.setAutoCommit(false);
      Statement stmt = connection.createStatement();
      stmt.execute("USE chapter06");
      stmt.execute("set tracing=on");
      System.out.println(stmt.getFetchSize());

      long startTime = System.currentTimeMillis();
      ResultSet results = stmt
          .executeQuery("SELECT post_timestamp, summary FROM blog_posts ORDER BY post_timestamp DESC ");
      results.next();
      System.out.println("elaspsed fetchSize=0 "+(System.currentTimeMillis() - startTime));
      results.close();

      startTime = System.currentTimeMillis();
      stmt.setFetchSize(100);
      results = stmt
          .executeQuery("SELECT post_timestamp, summary " + "  FROM blog_posts " + "  ORDER BY post_timestamp DESC ");
      for (int ri = 0; ri < 10; ri++) {
        if (results.next())
          System.out.println(results.getString("SUMMARY"));
      }

      System.out.println("elaspsed fetchSize=100 "+(System.currentTimeMillis() - startTime));
      results.close();

      stmt.close();
      traceData(connection);
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
