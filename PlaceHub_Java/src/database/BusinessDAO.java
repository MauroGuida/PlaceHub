package database;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;

import errori.CodiceBusinessNonTrovatoException;
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
	
	public void inserisciRaffinazioni(String codBusiness, String raffinazioni) throws SQLException {
		String sql = "CALL inserisciRaffinazioni(?,?)";
		PreparedStatement query;
		query = Controller.getConnessioneAlDatabase().getConnessione().prepareStatement(sql);
		query.setInt(1, Integer.parseInt(codBusiness));
		query.setString(2, raffinazioni);
		query.executeUpdate();
	}
	
	public void inserisciImmagine(String codBusiness, String immagine) throws SQLException {
		String sql = "CALL inserisciImmaginiABusiness(?,?)";
		PreparedStatement query;
		query = Controller.getConnessioneAlDatabase().getConnessione().prepareStatement(sql);
		query.setInt(1, Integer.parseInt(codBusiness));
		query.setString(2, immagine);
		query.executeUpdate();
	}
	
	public String recuperaCodiceBusinessDaPartitaIVA(String partitaIVA) throws SQLException, CodiceBusinessNonTrovatoException {
		String sql = "SELECT recuperaCodBusiness(?)";
		PreparedStatement query;
		query = Controller.getConnessioneAlDatabase().getConnessione().prepareStatement(sql);
		query.setString(1, partitaIVA);
		ResultSet datiRecuperati = query.executeQuery();
		
		if(datiRecuperati.next())
			return datiRecuperati.getString(1);
		else
			throw new CodiceBusinessNonTrovatoException();

	}
}
