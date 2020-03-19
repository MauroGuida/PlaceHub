package database;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import errori.CodiceVerificaNonTrovatoException;
import errori.CodiceVerificaNonValidoException;
import errori.EmailSconosciutaException;
import errori.UsernameOPasswordErratiException;
import gestione.Controller;

public class UtenteDAO {
	
	private String codUtente = null;

	public String getIdUtente() {
		return codUtente;
	}
	
	public void login(String Username, char[] Password) throws UsernameOPasswordErratiException, SQLException{
		String sql = "SELECT login(?, ?)";
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
		String sql = "CALL ResetPassword(?)";
		PreparedStatement query;
		query = Controller.getConnessioneAlDatabase().getConnessione().prepareStatement(sql);
		query.setInt(1, Integer.parseInt(codiceUtente));
		query.executeUpdate();
	}

	public String recuperaCodiceVerifica(String codiceUtente) throws SQLException, CodiceVerificaNonTrovatoException{
		String sql;
		sql = "SELECT codiceVerifica From Utente WHERE codUtente = ?";
		PreparedStatement query;
		query = Controller.getConnessioneAlDatabase().getConnessione().prepareStatement(sql);
		query.setInt(1, Integer.parseInt(codiceUtente));
		ResultSet datiRecuperati = query.executeQuery();
		
		if(datiRecuperati.next())
			return datiRecuperati.getString(1);
		else
			throw new CodiceVerificaNonTrovatoException();
	}
	
	public String recuperaCodiceUtenteDaEmail(String Email) throws SQLException, EmailSconosciutaException{	
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
	
	
	/**
	* Richiede che sia presente nella variabile codUtente della classe un valore codUtente valido,
	* una valore corretto viene impostato dalla funzione recuperaCodiceUtenteDaEmail
	*/
	public void impostaPassword(String codiceVerifica, char[] Password) throws SQLException, CodiceVerificaNonValidoException {
		if(codiceVerifica.isBlank() || codiceVerifica.isEmpty()) {
			throw new CodiceVerificaNonValidoException();
		} else {
			String sql = "SELECT codUtente FROM Utente WHERE codUtente = ? AND codiceVerifica = ?";
			PreparedStatement queryVerifica;
			queryVerifica = Controller.getConnessioneAlDatabase().getConnessione().prepareStatement(sql);
			queryVerifica.setInt(1, Integer.parseInt(codUtente));
			queryVerifica.setString(2, codiceVerifica);
			ResultSet datiRecuperati = queryVerifica.executeQuery();
			
			if(datiRecuperati.next()){
				datiRecuperati.getString(1); //Se il codice di verfica non è valido da un eccezione
				
				sql = "CALL impostaNuovaPassword(?, ?)";
				PreparedStatement query;
				query = Controller.getConnessioneAlDatabase().getConnessione().prepareStatement(sql);
				query.setInt(1, Integer.parseInt(codUtente));
				query.setString(2, new String(Password));
				query.executeUpdate();
			}else
				throw new CodiceVerificaNonValidoException();
		}
	}
}
