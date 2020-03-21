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

		for(int i=0; i<10; i++)
			locali.add(new Locale("dio", "dio",null,null,null,null,
					"https://www.lalucedimaria.it/wp-content/uploads/2018/10/Ges%C3%B9-MIsericordioso-1-e1569917989814.jpg"));

		return locali;
	}
	
	public ArrayList<Locale> ricercaRistoranti() {
		locali.clear();
		
		for(int i=0; i<5; i++)
			locali.add(new Locale("MAMMAMIA", "CIAOBELLA!",null,null,null,null,
					"https://i.ytimg.com/vi/CxZM0PM77Us/maxresdefault.jpg"));
		
		return locali;
	}
	
}
