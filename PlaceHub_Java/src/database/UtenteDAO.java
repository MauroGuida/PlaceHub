package database;

import java.io.File;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import eccezioni.CodiceVerificaNonTrovatoException;
import eccezioni.CodiceVerificaNonValidoException;
import eccezioni.EmailSconosciutaException;
import eccezioni.UsernameOPasswordErratiException;
import gestione.Controller;

public class UtenteDAO {
	public String login(String Username, char[] Password) throws UsernameOPasswordErratiException, SQLException{
		String sql = "SELECT login(?, ?)";
		PreparedStatement query;
		query = Controller.getConnessioneAlDatabase().getConnessione().prepareStatement(sql);
		query.setString(1, Username);
		query.setString(2, new String(Password));
		ResultSet datiRecuperati = query.executeQuery();
		
		datiRecuperati.next();
		String codUtente = datiRecuperati.getString(1);
		
		if(codUtente == null || codUtente.isBlank() || codUtente.isEmpty())
			throw new UsernameOPasswordErratiException();
		
		return codUtente;
	}
	
	public void registrati(String Username, String Nome, String Cognome, String Email, String DataDiNascita, char[] Password) throws SQLException {
			String sql = "CALL registrati(?,?,?,?,?,?)";
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
	
	public void generaCodiceVerifica(String codiceUtente) throws SQLException{
		String sql = "CALL generaCodiceVerifica(?)";
		PreparedStatement query;
		query = Controller.getConnessioneAlDatabase().getConnessione().prepareStatement(sql);
		query.setInt(1, Integer.parseInt(codiceUtente));
		query.executeUpdate();
	}

	public String recuperaCodiceVerifica(String codiceUtente) throws SQLException, CodiceVerificaNonTrovatoException{
		String sql = "SELECT codiceVerifica From Utente WHERE codUtente = ?";
		PreparedStatement query;
		query = Controller.getConnessioneAlDatabase().getConnessione().prepareStatement(sql);
		query.setInt(1, Integer.parseInt(codiceUtente));
		ResultSet datiRecuperati = query.executeQuery();
		
		if(datiRecuperati.next())
			return datiRecuperati.getString(1);
		else
			throw new CodiceVerificaNonTrovatoException();
	}
	
	public String recuperaEmail(String codUtente) throws SQLException {
		String sql = "SELECT email FROM utente WHERE codUtente = ?";
		PreparedStatement query;
		query = Controller.getConnessioneAlDatabase().getConnessione().prepareStatement(sql);
		query.setInt(1, Integer.parseInt(codUtente));
		
		ResultSet datiRecuperati = query.executeQuery();
		datiRecuperati.next();
		
		return datiRecuperati.getString(1);
	}
	
	public String recuperaCodiceUtenteDaEmail(String Email) throws SQLException, EmailSconosciutaException{	
		String codUtente;
		
		String sql = "SELECT codUtente FROM utente WHERE email = ?";
		PreparedStatement query;
		query = Controller.getConnessioneAlDatabase().getConnessione().prepareStatement(sql);
		query.setString(1, Email);
		ResultSet datiRecuperati = query.executeQuery();
		
		if(datiRecuperati.next()) {
			codUtente = datiRecuperati.getString(1);
			return codUtente;
		}else
			throw new EmailSconosciutaException();
	}
	
	public void impostaPassword(String codUtente, String codiceVerifica, char[] Password) throws SQLException, CodiceVerificaNonValidoException {
		if(controllaCodiceVerifica(codUtente, codiceVerifica)){
			String sql = "CALL impostaNuovaPassword(?, ?)";
			PreparedStatement query;
			query = Controller.getConnessioneAlDatabase().getConnessione().prepareStatement(sql);
			query.setInt(1, Integer.parseInt(codUtente));
			query.setString(2, new String(Password));
			query.executeUpdate();
		}
	}
	
	public boolean controllaCodiceVerifica(String codUtente, String codiceVerifica) throws SQLException, CodiceVerificaNonValidoException {
		String sql = "SELECT controllacodiceverifica(?, ?)";
		PreparedStatement queryVerifica;
		queryVerifica = Controller.getConnessioneAlDatabase().getConnessione().prepareStatement(sql);
		queryVerifica.setInt(1, Integer.parseInt(codUtente));
		queryVerifica.setString(2, codiceVerifica);
		ResultSet datiRecuperati = queryVerifica.executeQuery();
		
		datiRecuperati.next();
		
		if(datiRecuperati.getBoolean(1))
			return true;
		else
			throw new CodiceVerificaNonValidoException();
	}
	
	public boolean controllaDocumentiUtente(String codUtente) throws SQLException {
		String sql = "SELECT controllaDocumentiUtente(?)";
		PreparedStatement query;
		query = Controller.getConnessioneAlDatabase().getConnessione().prepareStatement(sql); 
		query.setInt(1, Integer.parseInt(codUtente));
		ResultSet datiRecuperati = query.executeQuery();
		
		datiRecuperati.next();

		return datiRecuperati.getBoolean(1);
	}
	
	public void inserisciDocumentiUtente(String codUtente, File fronteDocumento, File retroDocumento) throws SQLException {
		String sql = "CALL inserisciDocumentiUtente(?,?,?)";
		PreparedStatement query;
		query = Controller.getConnessioneAlDatabase().getConnessione().prepareStatement(sql);
		query.setInt(1, Integer.parseInt(codUtente));
		query.setString(2, fronteDocumento.getAbsolutePath());
		query.setString(3, retroDocumento.getAbsolutePath());
		query.executeUpdate();
	}
}
