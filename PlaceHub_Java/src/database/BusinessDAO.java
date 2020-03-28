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

	public ArrayList<Locale> ricercaInVoga() throws SQLException {
		locali.clear();

		String sql = "SELECT B.codBusiness, B.Nome, B.Indirizzo, B.Stelle, I.Url\r\n" + 
				"FROM Business B JOIN (SELECT DISTINCT codBusiness, URL FROM ImmagineProprieta) I ON (B.codBusiness = I.codBusiness)";
		PreparedStatement query;
		query = Controller.getConnessioneAlDatabase().getConnessione().prepareStatement(sql);
		ResultSet datiRecuperati = query.executeQuery();
		
		while(datiRecuperati.next())
			locali.add(new Locale(datiRecuperati.getString(1), datiRecuperati.getString(2), datiRecuperati.getString(3), datiRecuperati.getFloat(4),
					datiRecuperati.getString(5)));

		return locali;
	}
	
	public ArrayList<Locale> ricercaRistoranti() throws SQLException {
		locali.clear();
		
		recuperaLocaliDaTipo(new String("Ristorante"));
		
		return locali;
	}
	
	public ArrayList<Locale> ricercaAttrazioni() throws SQLException {
		locali.clear();
		
		recuperaLocaliDaTipo(new String("Attrazione"));
		
		return locali;
	}
	
	public ArrayList<Locale> ricercaAlloggi() throws SQLException {
		locali.clear();
		
		recuperaLocaliDaTipo(new String("Alloggio"));
		
		return locali;
	}
	
	public void recuperaLocaliDaTipo(String tipo) throws SQLException {
		String sql = "SELECT B.codBusiness, B.Nome, B.Indirizzo, B.Stelle, I.Url\r\n" + 
				"FROM Business B JOIN (SELECT DISTINCT codBusiness, URL FROM ImmagineProprieta) I ON (B.codBusiness = I.codBusiness)\r\n" + 
				"WHERE Tipo = ?::tipoBusiness";
		PreparedStatement query;
		query = Controller.getConnessioneAlDatabase().getConnessione().prepareStatement(sql);
		query.setString(1, tipo);
		ResultSet datiRecuperati = query.executeQuery();
		
		while(datiRecuperati.next())
			locali.add(new Locale(datiRecuperati.getString(1), datiRecuperati.getString(2), datiRecuperati.getString(3), datiRecuperati.getFloat(4),
					datiRecuperati.getString(5)));
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
		
		datiRecuperati.next();
		String risultato = datiRecuperati.getString(1);
		
		if(!(risultato == null || risultato.isEmpty() || risultato.isBlank()))
			return risultato;
		else
			throw new CodiceBusinessNonTrovatoException();
	}
	
	
	
	public Locale recuperaLocaleDaCodBusiness(String codBusiness) throws SQLException {
		//Recupero Informazioni
		String sql = "SELECT Nome, Indirizzo, Telefono, PartitaIVA, Descrizione, Stelle, tipo FROM Business WHERE codBusiness = ?";
		PreparedStatement query;
		query = Controller.getConnessioneAlDatabase().getConnessione().prepareStatement(sql);
		query.setString(1, codBusiness);
		ResultSet datiRecuperati = query.executeQuery();
		
		datiRecuperati.next();
		Locale risultato = new Locale();
		
		risultato.setCodBusiness(codBusiness);
		risultato.setNome(datiRecuperati.getString(1));
		risultato.setIndirizzo(datiRecuperati.getString(2));
		risultato.setTelefono(datiRecuperati.getString(3));
		risultato.setPartitaIVA(datiRecuperati.getString(4));
		risultato.setDescrizione(datiRecuperati.getString(5));
		risultato.setStelle(datiRecuperati.getFloat(6));
		risultato.setTipoBusiness(datiRecuperati.getString(7));

		//Recupero Immagini
		sql = "SELECT Url FROM ImmagineProprieta WHERE codBusiness = ?";
		PreparedStatement query2;
		query2 = Controller.getConnessioneAlDatabase().getConnessione().prepareStatement(sql);
		query2.setString(1, codBusiness);
		ResultSet datiRecuperati2 = query2.executeQuery();
		
		while(datiRecuperati2.next())
			risultato.aggiungiImmagini(datiRecuperati2.getString(1));
		
		
		//Recupero Raffinazioni
		sql = "SELECT raffinazione FROM AssociazioneRaffinazione WHERE codBusiness = ?";
		PreparedStatement query3;
		query3 = Controller.getConnessioneAlDatabase().getConnessione().prepareStatement(sql);
		query3.setString(1, codBusiness);
		ResultSet datiRecuperati3 = query3.executeQuery();
		String raffinazioni = "";
		
		while(datiRecuperati3.next())
			raffinazioni = raffinazioni.concat(datiRecuperati3.getString(1).concat(","));
		
		risultato.setRaffinazioni(raffinazioni);
		
		
		return risultato;
	}
	
	public ArrayList<Locale> recuperaBusinessDaCodUtente(String codUtente) throws SQLException {
		ArrayList<Locale> recuperato = new ArrayList<Locale>();
		
		String sql = "SELECT B.codBusiness, B.Nome, B.Indirizzo, B.Stelle, I.Url FROM Business B JOIN (SELECT DISTINCT codBusiness, URL FROM ImmagineProprieta) I ON (B.codBusiness = I.codBusiness) WHERE codUtente = ?";
		PreparedStatement query;
		query = Controller.getConnessioneAlDatabase().getConnessione().prepareStatement(sql);
		query.setInt(1, Integer.parseInt(codUtente));
		ResultSet datiRecuperati = query.executeQuery();
		
		while(datiRecuperati.next())
			recuperato.add(new Locale(datiRecuperati.getString(1), datiRecuperati.getString(2), datiRecuperati.getString(3), datiRecuperati.getFloat(4),
					datiRecuperati.getString(5)));
		
		
		return recuperato;
	}
}
