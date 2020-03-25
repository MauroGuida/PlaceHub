package database;

import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.util.ArrayList;

import gestione.Controller;
import oggetti.Locale;

public class BusinessDAO {
	private ArrayList<Locale> locali = new ArrayList<Locale>();

	public ArrayList<Locale> ricercaInVoga() {
		locali.clear();

		//DA GESTIRE

		return locali;
	}
	
	public ArrayList<Locale> ricercaRistoranti() {
		locali.clear();
		
		//DA GESTIRE
		
		return locali;
	}
	
	public void inserisciBusiness(Locale bufferLocale, String codUtente) throws SQLException {
		String sql = "CALL inserisciBusiness(?,?,?,?,?,?,?)";
		PreparedStatement query;
		query = Controller.getConnessioneAlDatabase().getConnessione().prepareStatement(sql);
		query.setString(1, bufferLocale.getNome());
		query.setString(2, bufferLocale.getIndirizzo());
		query.setString(3, bufferLocale.getTelefono());
		query.setString(4, bufferLocale.getPartitaIVA());
		query.setString(5, bufferLocale.getTipoBusiness());
		query.setString(6, bufferLocale.getDescrizione());
		query.setInt(7, Integer.parseInt(codUtente));
		
		query.executeUpdate();
	}
}
