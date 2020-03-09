package database;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import errori.UsernameOPasswordErrati;
import gestione.Controller;

public class UtenteDAO {
	
	private String idUtente = null;
	
	public String getIdUtente() {
		return idUtente;
	}
	
	public void login(String Username, char[] Password) throws UsernameOPasswordErrati{
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
				throw new UsernameOPasswordErrati();
		} catch (SQLException e) {
			e.printStackTrace();
		}
	}
}
