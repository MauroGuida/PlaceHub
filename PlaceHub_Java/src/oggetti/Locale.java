package oggetti;

import java.io.File;
import java.util.ArrayList;

public class Locale {
	
	@SuppressWarnings("unused")
	private String codBusiness;
	private String nome;
	private String indirizzo;
	private String telefono;
	private String partitaIVA;
	private String descrizione;
	private String tipoBusiness;
	private String raffinazioni;
	
	private ArrayList<File> listaImmagini;
	
	public Locale(String codBusiness, String nome, String indirizzo,
				  String telefono, String partitaIVA, String descrizione, String tipoBusiness, String raffinazioni) {
		this.codBusiness = codBusiness;
		this.nome = nome;
		this.indirizzo = indirizzo;
		this.telefono = telefono;
		this.partitaIVA = partitaIVA;
		this.descrizione = descrizione;
		this.tipoBusiness = tipoBusiness;
		this.raffinazioni = raffinazioni;
		listaImmagini = new ArrayList<File>();
	}

	
	//CANI

	
	public void setNome(String nome) {
		this.nome = nome;
	}


	public void setIndirizzo(String indirizzo) {
		this.indirizzo = indirizzo;
	}


	public void setTelefono(String telefono) {
		this.telefono = telefono;
	}


	public void setPartitaIVA(String partitaIVA) {
		this.partitaIVA = partitaIVA;
	}


	public void setDescrizione(String descrizione) {
		this.descrizione = descrizione;
	}

	public void setTipoBusiness(String tipoBusiness) {
		this.tipoBusiness = tipoBusiness;
	}
	
	public void setRaffinazini(String raffinazini) {
		this.raffinazioni = raffinazini;
	}

	
	//Getters
	
	
	public String getNome() {
		return nome;
	}

	public String getIndirizzo() {
		return indirizzo;
	}
	
	public String getTelefono() {
		return telefono;
	}

	public String getPartitaIVA() {
		return partitaIVA;
	}

	public String getDescrizione() {
		return descrizione;
	}
	
	public String getTipoBusiness() {
		return tipoBusiness;
	}

	public String getRaffinazioni() {
		return raffinazioni;
	}

	
	
	//METODI
	
	
	public void aggiungiImmagini(String filePath) {
		listaImmagini.add(new File(filePath));
	}

	public int getNumeroImmagini() {
		return listaImmagini.size();
	}
}
