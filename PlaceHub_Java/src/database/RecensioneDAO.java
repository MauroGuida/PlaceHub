package database;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import gestione.Controller;
import oggetti.Recensione;

public class RecensioneDAO {
	public void inserisciRecensione(Recensione recensione) throws SQLException {	
		//INSERISCI RECENSIONE
		String sql = "SELECT inserisciRecensione(?, ?, ?, ?)";
		PreparedStatement query;
		query = Controller.getConnessioneAlDatabase().getConnessione().prepareStatement(sql);
		query.setString(1, recensione.getTestoRecensione());
		query.setInt(2, recensione.getStelle());
		query.setInt(3, Integer.parseInt(recensione.getCodBusiness()));
		query.setInt(4, Integer.parseInt(recensione.getCodUtente()));
		
		ResultSet datiRecuperati = query.executeQuery();
		
		if(!datiRecuperati.next())
			throw new SQLException();
		
		System.out.print("CIAO");
		
		int codRecensione = datiRecuperati.getInt(1);
		
		//INSERISCI IMMAGINI
		sql = "CALL InserisciImmagineRecensione(?, ?)";
		for (String url : recensione.getListaImmagini()) {
			System.out.print("CIAO");
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
}
