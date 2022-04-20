/* 
Connection pools in Java

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

import java.util.ArrayList;

import java.util.List;

import com.zaxxer.hikari.HikariConfig;

import java.sql.*;

public class connectionPool {

	private static PreparedStatement getRiderStmt;
	private static Connection connection;

	public static void main(String[] args) {

		try {
		  HikariConfig config = new HikariConfig();
			Class.forName("org.postgresql.Driver");
			String connectionURL = "jdbc:" + args[0];
			String userName = args[1];
			String passWord = args[2];
			String riderName;

			connection = DriverManager.getConnection(connectionURL, userName, passWord);
			Statement stmt = connection.createStatement();
			ResultSet rs = stmt
					.executeQuery("SELECT CONCAT('Hello from CockroachDB at '," + "CAST (NOW() as STRING)) AS hello");
			rs.next();
			System.out.println(rs.getString("hello"));
			stmt.execute("use adventureworks");

			// Simple concatenated fetch
			riderName = getRiderName("ffc3c373-63ec-43fe-98ff-311f29424d8b");
			System.out.println(riderName);

			// SQL injection
			riderName = getRiderName(
					"ffc3c373-63ec-43fe-98ff-311f29424d8b' UNION select credit_card from movr.users order by 1,name 'n");
			System.out.println(riderName);

			// Create Prepared Statement
			getRiderStmt = connection.prepareStatement(
					"SELECT u.name FROM movr.rides r " 
			  + " JOIN movr.users u ON (r.rider_id=u.id) " 
			  + " WHERE r.id=?");
			riderName = getRiderNamePrepared("ffc3c373-63ec-43fe-98ff-311f29424d8b");
			System.out.println(riderName);

			List<String> riderIds = getRiderIds(stmt);
			warmCache("movr.rides");
			warmCache("movr.users");

			long elapsed;
			int loops = 1;
			/*elapsed = testInternalPrepared(riderIds, loops);
			System.out.printf("Internal elapsed %d\n", elapsed); */
			
			elapsed = testPrepared(riderIds, loops);
			System.out.printf("Prepared elapsed %d\n", elapsed);
			//

			elapsed = testNonPrepared(riderIds, loops);
			System.out.printf("Non-Prepared elapsed %d\n", elapsed);
			


		} catch (Exception e) {
			e.printStackTrace();
			System.err.println(e.getClass().getName() + ": " + e.getMessage());
			System.exit(0);
		}

	}

	private static void warmCache(String tableName) throws SQLException {
		Statement stmt = connection.createStatement();
		ResultSet dataRs = stmt.executeQuery("SELECT id from " + tableName);
		while (dataRs.next()) {
		}

	}

	private static long testNonPrepared(List<String> riderIds, int loops) throws SQLException {
		String riderName;
		long startTime = System.currentTimeMillis();
		Statement stmt = connection.createStatement();

		for (int i = 0; i < loops; i++) {
			for (String riderId : riderIds) {
				String sql = " SELECT u.name FROM movr.rides r " + "  JOIN movr.users u ON (r.rider_id=u.id) " + " WHERE r.id='"
						+ riderId + "'";
				ResultSet rs = stmt.executeQuery(sql);
				rs.next();
			}
		}
		long elapsed = (System.currentTimeMillis() - startTime);
		return elapsed;
	}

	private static long testPrepared(List<String> riderIds, int loops) throws SQLException {
		String riderName;
		long startTime = System.currentTimeMillis();
		PreparedStatement getRiderStmt = connection.prepareStatement(
				"SELECT u.name FROM movr.rides r " + "  JOIN movr.users u ON (r.rider_id=u.id) " + " WHERE r.id=?");
		for (int i = 0; i < loops; i++) {
			for (String riderId : riderIds) {
				getRiderStmt.setString(1, riderId);
				ResultSet rs = getRiderStmt.executeQuery();
				rs.next();
			}
		}
		long elapsed = (System.currentTimeMillis() - startTime);
		return elapsed;
	}
	
	private static long testInternalPrepared(List<String> riderIds, int loops) throws SQLException {
		String riderName;
		long startTime = System.currentTimeMillis();
		Statement stmt = connection.createStatement();
		 stmt.execute("PREPARE riderQuery AS SELECT * FROM movr.rides r WHERE r.id=$1");
		for (int i = 0; i < loops; i++) {
			for (String riderId : riderIds) {
				getRiderStmt.setString(1, riderId);
				ResultSet rs =stmt.executeQuery("EXECUTE riderQuery('"+riderId+"')");					
				rs.next();
			}
		}
		long elapsed = (System.currentTimeMillis() - startTime);
		return elapsed;
	}

	private static List<String> getRiderIds(Statement stmt) throws SQLException {
		ResultSet riderIdRs = stmt.executeQuery("SELECT id from movr.rides");
		List<String> riderIds = new ArrayList<>();
		// Prepared

		while (riderIdRs.next()) {
			String riderId = riderIdRs.getString("ID");
			riderIds.add(riderId);
		}
		return riderIds;
	}

	private static String getRiderNamePrepared(String riderId) throws SQLException {
		getRiderStmt.setString(1, riderId);
		ResultSet rs = getRiderStmt.executeQuery();
		rs.next();
		return (rs.getString("name"));
	}

	private static String getRiderName(String riderId) throws SQLException {
		Statement stmt = connection.createStatement();
		String sql = " SELECT u.name FROM movr.rides r " + "  JOIN movr.users u ON (r.rider_id=u.id) " + " WHERE r.id='"
				+ riderId + "'";
		ResultSet rs = stmt.executeQuery(sql);
		rs.next();
		return (rs.getString("name"));
	}

}
