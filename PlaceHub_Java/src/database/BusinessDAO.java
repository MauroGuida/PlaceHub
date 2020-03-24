package database;

import java.util.ArrayList;

import oggetti.Locale;

public class BusinessDAO {
	private ArrayList<Locale> locali = new ArrayList<Locale>();
	
	private Locale localeBuffer;
	
	public Locale getLocaleBuffer() {
		return localeBuffer;
	}

	public void setLocaleBuffer(Locale localeBuffer) {
		this.localeBuffer = localeBuffer;
	}

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
	
}
