package database;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;

import gestione.Controller;

public class MappaDAO {
	public ArrayList<String> prelevaRegione() throws SQLException {
		ArrayList<String> regione = new ArrayList<String>();
		
		String sql = "SELECT DISTINCT Regione FROM Mappa ORDER BY Regione";
		PreparedStatement query;
		query = Controller.getConnessioneAlDatabase().getConnessione().prepareStatement(sql);
		ResultSet datiRecuperati = query.executeQuery();
		
		while(datiRecuperati.next())
			regione.add(datiRecuperati.getString(1));
		
		return regione;
	}

	public ArrayList<String> prelevaProvincieDiRegione(String regione) throws SQLException {
		ArrayList<String> provincia = new ArrayList<String>();
		
		String sql = "SELECT DISTINCT Provincia FROM Mappa WHERE Regione = ? ORDER BY Provincia";
		PreparedStatement query;
		query = Controller.getConnessioneAlDatabase().getConnessione().prepareStatement(sql);
		query.setString(1, regione);
		ResultSet datiRecuperati = query.executeQuery();
		
		while(datiRecuperati.next())
			provincia.add(datiRecuperati.getString(1));
		
		return provincia;
	}
}
