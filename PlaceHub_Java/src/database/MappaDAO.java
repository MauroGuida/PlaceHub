package database;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;

import errori.CodMappaNonTrovatoException;
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
		
		String sql = "SELECT DISTINCT SiglaProvincia FROM Mappa WHERE Regione = ? ORDER BY SiglaProvincia";
		PreparedStatement query;
		query = Controller.getConnessioneAlDatabase().getConnessione().prepareStatement(sql);
		query.setString(1, regione);
		ResultSet datiRecuperati = query.executeQuery();
		
		while(datiRecuperati.next())
			provincia.add(datiRecuperati.getString(1));
		
		return provincia;
	}
	
	public ArrayList<String> prelevaComuneDiProvincia(String SiglaProvincia) throws SQLException {
		ArrayList<String> comune = new ArrayList<String>();
		
		String sql = "SELECT DISTINCT Comune FROM Mappa WHERE SiglaProvincia = ? ORDER BY Comune";
		PreparedStatement query;
		query = Controller.getConnessioneAlDatabase().getConnessione().prepareStatement(sql);
		query.setString(1, SiglaProvincia);
		ResultSet datiRecuperati = query.executeQuery();
		
		while(datiRecuperati.next())
			comune.add(datiRecuperati.getString(1));
		
		return comune;
	}
	
	public ArrayList<String> prelevaCAPDiComune(String comune) throws SQLException {
		ArrayList<String> CAP = new ArrayList<String>();
		
		String sql = "SELECT DISTINCT CAP FROM Mappa WHERE Comune = ? ORDER BY CAP";
		PreparedStatement query;
		query = Controller.getConnessioneAlDatabase().getConnessione().prepareStatement(sql);
		query.setString(1, comune);
		ResultSet datiRecuperati = query.executeQuery();
		
		while(datiRecuperati.next())
			CAP.add(datiRecuperati.getString(1));
		
		return CAP;
	}

	public String recuperaCodMappa(String Regione, String Provincia, String Comune, String CAP) throws SQLException, CodMappaNonTrovatoException {
		String sql = "SELECT codMappa FROM Mappa WHERE Regione = ? AND SiglaProvincia = ? AND Comune = ? AND CAP = ?";
		PreparedStatement query;
		query = Controller.getConnessioneAlDatabase().getConnessione().prepareStatement(sql);
		query.setString(1, Regione);
		query.setString(2, Provincia);
		query.setString(3, Comune);
		query.setString(4, CAP);
		ResultSet datiRecuperati = query.executeQuery();
		
		if(datiRecuperati.next())
			return String.valueOf(datiRecuperati.getInt(1));
		else
			throw new CodMappaNonTrovatoException();
	}
}
