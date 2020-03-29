package oggetti;

import java.util.ArrayList;

public class Locale {

	@SuppressWarnings("unused")
	private String codBusiness;
	private String nome;
	private String indirizzo;
	private String telefono;
	private String partitaIVA;
	private String descrizione;
	private float stelle;
	private String tipoBusiness;
	private String raffinazioni;
	private String codMappa;
	
	private ArrayList<String> listaImmagini = new ArrayList<String>();

	public Locale(String nome, String indirizzo,
				  String telefono, String partitaIVA,String tipoBusiness, String raffinazioni, String codMappa) {
		this.nome = nome;
		this.indirizzo = indirizzo;
		this.telefono = telefono;
		this.partitaIVA = partitaIVA;
		this.tipoBusiness = tipoBusiness;
		this.raffinazioni = raffinazioni;
		this.codMappa = codMappa;
	}
	
	public Locale(String codBusiness, String nome, String indirizzo,
			  String telefono, String partitaIVA, String descrizione, float stelle, String tipoBusiness, String raffinazioni, String codMappa) {
		this.setCodBusiness(codBusiness);
		this.nome = nome;
		this.indirizzo = indirizzo;
		this.telefono = telefono;
		this.partitaIVA = partitaIVA;
		this.descrizione = descrizione;
		this.stelle = stelle;
		this.tipoBusiness = tipoBusiness;
		this.raffinazioni = raffinazioni;
		this.codMappa = codMappa;
	}
	
	public Locale(String codBusiness, String nome, String indirizzo, float stelle, String immagine) {
		this.setCodBusiness(codBusiness);
		this.nome = nome;
		this.indirizzo = indirizzo;
		this.stelle = stelle;
		listaImmagini.add(new String(immagine));
	}
	
	public Locale() {
	}

	
	//CANI

	
	public void setCodBusiness(String codBusiness) {
		this.codBusiness = codBusiness;
	}
	
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

	public void setStelle(float stelle) {
		this.stelle = stelle;
	}

	public void setTipoBusiness(String tipoBusiness) {
		this.tipoBusiness = tipoBusiness;
	}
	
	public void setRaffinazioni(String raffinazini) {
		this.raffinazioni = raffinazini;
	}

	public void setCodMappa(String codMappa) {
		this.codMappa = codMappa;
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
	
	public float getStelle() {
		return stelle;
	}
	
	public String getTipoBusiness() {
		return tipoBusiness;
	}

	public String getRaffinazioni() {
		return raffinazioni;
	}
	
	public ArrayList<String> getListaImmagini() {
		return listaImmagini;
	}
	
	public String getImmaginePrincipale() {
		return listaImmagini.get(0);
	}

	public String getCodMappa() {
		return codMappa;
	}
	
	
	//METODI
	
	
	public void aggiungiImmagini(String filePath) {
		listaImmagini.add(new String(filePath));
	}

	public int getNumeroImmagini() {
		return listaImmagini.size();
	}
}
