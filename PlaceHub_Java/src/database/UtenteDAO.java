package database;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import errori.UsernameOPasswordErratiException;
import gestione.Controller;

public class UtenteDAO {
	
	private String idUtente = null;
	
	public String getIdUtente() {
		return idUtente;
	}
	
	public void login(String Username, char[] Password) throws UsernameOPasswordErratiException{
		try {
			String sql = "SELECT codUtente FROM utente where username = ? and password = ?";
			PreparedStatement query;
			query = Controller.getConnessioneAlDatabase().getConnessione().prepareStatement(sql);
			query.setString(1, Username);
			query.setString(2, new String(Password));
			ResultSet datiRecuperati = query.executeQuery();
			
			if(datiRecuperati.next())
				idUtente = datiRecuperati.getString(1);
			else
				throw new UsernameOPasswordErratiException();
		} catch (SQLException e) {
			e.printStackTrace();
		}
	}
	
	public void registrati(String Username, String Nome, String Cognome, String Email, String DataDiNascita, char[] Password) throws SQLException {
			String sql = "INSERT INTO Utente(Username, Nome, Cognome, Email, DataDiNascita, Password) Values(?,?,?,?,?,?)";
			PreparedStatement query;
			query = Controller.getConnessioneAlDatabase().getConnessione().prepareStatement(sql);
			query.setString(1, Username);
			query.setString(2, Nome);
			query.setString(3, Cognome);
			query.setString(4, Email);
			query.setDate(5, java.sql.Date.valueOf(DataDiNascita));
			query.setString(6, new String(Password));
			query.executeUpdate();
	}
}
