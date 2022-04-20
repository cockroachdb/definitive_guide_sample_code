package crdb;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.Statement;

public class Hello {

	public static void main(String[] args) {
		Connection cdb = null;
		try {
			Class.forName("org.postgresql.Driver");
			cdb = DriverManager.getConnection("jdbc:postgresql://localhost:26257/bank?sslmode=disable", "root", "");
			Statement stmt = cdb.createStatement();
			ResultSet rs = stmt
					.executeQuery("SELECT CONCAT('Hello from CockroachDB at ',CAST (NOW() as STRING)) AS hello");
			rs.next();
			System.out.println(rs.getString("hello"));

		} catch (Exception e) {
			e.printStackTrace();
			System.err.println(e.getClass().getName() + ": " + e.getMessage());
			System.exit(0);
		}
	}

}
