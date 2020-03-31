package oggetti;

import java.util.ArrayList;

public class Recensione {
	private String codUtente;
	private String codBusiness;
	
	private String testoRecensione;
	private int stelle;
	private ArrayList<String> listaImmagini = new ArrayList<String>();
	
	public Recensione(String codUtente, String codBusiness) {
		this.codUtente = codUtente;
		this.codBusiness = codBusiness;
	}

	//Getters and Setters
	
	public String getCodUtente() {
		return codUtente;
	}

	public void setCodUtente(String codUtente) {
		this.codUtente = codUtente;
	}

	public String getTestoRecensione() {
		return testoRecensione;
	}

	public void setTestoRecensione(String recensione) {
		this.testoRecensione = recensione;
	}
	
	public String getCodBusiness() {
		return codBusiness;
	}

	public void setCodBusiness(String codBusiness) {
		this.codBusiness = codBusiness;
	}
	
	public int getStelle() {
		return stelle;
	}

	public void setStelle(int stelle) {
		this.stelle = stelle;
	}
	
	public ArrayList<String> getListaImmagini() {
		return listaImmagini;
	}
	
	//METODI

	public void aggiungiImmagini(String filePath) {
		listaImmagini.add(new String(filePath));
	}
	
	public int getNumeroImmagini() {
		return listaImmagini.size();
	}
}
