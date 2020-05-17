package oggettiServizio;

import java.util.ArrayList;

public class Recensione {
	private String codRecensione;
	private String codUtente;
	private String codBusiness;
	
	private String UsernameUtente;
	private String testoRecensione;
	private double stelle;
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
	
	public double getStelle() {
		return stelle;
	}

	public void setStelle(double stelle) {
		this.stelle = stelle;
	}
	
	public ArrayList<String> getListaImmagini() {
		return listaImmagini;
	}

	public void setListaImmagini(ArrayList<String> listaImmagini) {
		this.listaImmagini = listaImmagini;
	}
	
	public String getCodRecensione() {
		return codRecensione;
	}

	public void setCodRecensione(String codRecensione) {
		this.codRecensione = codRecensione;
	}
	
	public String getUsernameUtente() {
		return UsernameUtente;
	}

	public void setUsernameUtente(String usernameUtente) {
		UsernameUtente = usernameUtente;
	}
	
	//METODI

	public void aggiungiImmagini(String filePath) {
		listaImmagini.add(new String(filePath));
	}
	
	public int getNumeroImmagini() {
		return listaImmagini.size();
	}
}
