package database;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;

import gestione.Controller;
import oggettiServizio.Recensione;

public class RecensioneDAO {
	public void inserisciRecensione(Recensione recensione) throws SQLException {	
		//INSERISCI RECENSIONE
		String sql = "SELECT inserisciRecensione(?, ?, ?, ?)";
		PreparedStatement query;
		query = Controller.getConnessioneAlDatabase().getConnessione().prepareStatement(sql);
		query.setString(1, recensione.getTestoRecensione());
		query.setInt(2, (int)recensione.getStelle());
		query.setInt(3, Integer.parseInt(recensione.getCodBusiness()));
		query.setInt(4, Integer.parseInt(recensione.getCodUtente()));
		
		ResultSet datiRecuperati = query.executeQuery();
		
		if(!datiRecuperati.next())
			throw new SQLException();
		
		
		int codRecensione = datiRecuperati.getInt(1);
		
		//INSERISCI IMMAGINI
		sql = "CALL InserisciImmagineRecensione(?, ?)";
		for (String url : recensione.getListaImmagini()) {
			PreparedStatement query2;
			query2 = Controller.getConnessioneAlDatabase().getConnessione().prepareStatement(sql);
			query2.setString(1, url);
			query2.setInt(2, codRecensione);
			
			query2.executeUpdate();
		}
	}
	
	public boolean utenteConRecensione(String codUtente, String codBusiness) throws SQLException {
		String sql = "SELECT utenteConRecensione(?, ?)";
		PreparedStatement query;
		query = Controller.getConnessioneAlDatabase().getConnessione().prepareStatement(sql);
		query.setInt(1, Integer.parseInt(codUtente));
		query.setInt(2, Integer.parseInt(codBusiness));
		
		ResultSet datiRecuperati = query.executeQuery();
		
		datiRecuperati.next();
		
		return datiRecuperati.getBoolean(1);
	}
	
	public ArrayList<Recensione> recuperaRecensioniBusiness(String codBusiness) throws SQLException {
		ArrayList<Recensione> recensioni = new  ArrayList<Recensione>();
		 
		String sql = "SELECT r.testo,r.stelle,r.codrecensione,u.username,r.codUtente FROM recensione r, Utente u WHERE r.codUtente = u.codUtente AND r.codBusiness = ?";
		PreparedStatement query;
		query = Controller.getConnessioneAlDatabase().getConnessione().prepareStatement(sql);
		query.setInt(1, Integer.parseInt(codBusiness));
		
		ResultSet datiRecuperati = query.executeQuery();
		
		while(datiRecuperati.next()) {
			Recensione recensione = new Recensione(datiRecuperati.getString("codUtente"), codBusiness);
			recensione.setCodRecensione(datiRecuperati.getString("codrecensione"));
			recensione.setTestoRecensione(datiRecuperati.getString("testo"));
			recensione.setStelle(datiRecuperati.getInt("stelle"));
			recensione.setUsernameUtente(datiRecuperati.getString("Username"));
			recensioni.add(recensione);
			
			sql = "SELECT URL FROM immaginerecensione WHERE codrecensione = ?";
			PreparedStatement query2;
			query2 = Controller.getConnessioneAlDatabase().getConnessione().prepareStatement(sql);
			query2.setInt(1, Integer.parseInt(recensione.getCodRecensione()));
			
			ResultSet datiRecuperati2 = query2.executeQuery();
			
			while(datiRecuperati2.next())
				recensione.getListaImmagini().add(datiRecuperati2.getString("URL"));
		}
		
		return recensioni;
	}
}
