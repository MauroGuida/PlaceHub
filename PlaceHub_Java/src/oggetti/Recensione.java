package oggetti;

import java.util.ArrayList;

public class Recensione {
	private ArrayList<String> listaImmagini = new ArrayList<String>();
	
	private String codUtente;
	private String Recensione;
	
	public Recensione(String codUtente) {
		this.codUtente = codUtente;
	}

	//Getters and Setters
	
	public String getCodUtente() {
		return codUtente;
	}

	public void setCodUtente(String codUtente) {
		this.codUtente = codUtente;
	}

	public String getRecensione() {
		return Recensione;
	}

	public void setRecensione(String recensione) {
		Recensione = recensione;
	}
	
	//METODI

	public void aggiungiImmagini(String filePath) {
		listaImmagini.add(new String(filePath));
	}
	
	public int getNumeroImmagini() {
		return listaImmagini.size();
	}
}
