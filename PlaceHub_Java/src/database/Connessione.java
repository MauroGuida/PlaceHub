package database;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class Connessione {
	private Connection connessione = null;
	
	public Connessione() throws ClassNotFoundException, SQLException{
		Class.forName("org.postgresql.Driver");
		connessione = DriverManager.getConnection("jdbc:postgresql://localhost/placehub", "postgres", "TestPW");
	}
	
	public void disconnetti() throws SQLException {
		connessione.close();
	}

	public Connection getConnessione() {
		return connessione;
	}
}
