package database;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import errori.UsernameOPasswordErratiException;
import gestione.Controller;

public class UtenteDAO {
	
	private String codUtente = null;

	public String getIdUtente() {
		return codUtente;
	}
	
	public void login(String Username, char[] Password) throws UsernameOPasswordErratiException, SQLException{
		String sql = "SELECT codUtente FROM utente where username = ? and password = ?";
		PreparedStatement query;
		query = Controller.getConnessioneAlDatabase().getConnessione().prepareStatement(sql);
		query.setString(1, Username);
		query.setString(2, new String(Password));
		ResultSet datiRecuperati = query.executeQuery();
			
		if(datiRecuperati.next())
			codUtente = datiRecuperati.getString(1);
		else
			throw new UsernameOPasswordErratiException();
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
	
	public String reimpostaPassword(String Email) throws SQLException{
		codUtente=recuperaCodiceUtenteDaEmail(Email);
		
		String sql = "CALL ResetPassword(?)";
		PreparedStatement query;
		query = Controller.getConnessioneAlDatabase().getConnessione().prepareStatement(sql);
		query.setInt(1, Integer.parseInt(codUtente));
		query.executeUpdate();
		
		sql = "SELECT Password From Utente Where codUtente = ?";
		PreparedStatement query2;
		query2 = Controller.getConnessioneAlDatabase().getConnessione().prepareStatement(sql);
		query2.setInt(1, Integer.parseInt(codUtente));
		ResultSet datiRecuperati = query2.executeQuery();
		
		datiRecuperati.next();
		
		return datiRecuperati.getString(1);
	}
	
	private String recuperaCodiceUtenteDaEmail(String Email) throws SQLException{	
		String sql = "SELECT codUtente FROM utente where email=?";
		PreparedStatement query;
		query = Controller.getConnessioneAlDatabase().getConnessione().prepareStatement(sql);
		query.setString(1, Email);
		ResultSet datiRecuperati = query.executeQuery();
		
		datiRecuperati.next();
		
		return datiRecuperati.getString(1);
	}
	
	public void impostaPassword(char[] Password) throws SQLException {
		String sql = "UPDATE Utente SET Password = ? WHERE codUtente = ?";
		PreparedStatement query;
		query = Controller.getConnessioneAlDatabase().getConnessione().prepareStatement(sql);
		query.setString(1, new String(Password));
		query.setInt(2, Integer.parseInt(codUtente));
		query.executeUpdate();
	}
}
