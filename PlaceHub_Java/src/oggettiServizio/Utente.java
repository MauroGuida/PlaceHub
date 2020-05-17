package oggettiServizio;

import java.io.File;

public class Utente {
	private File fronteDocumento = null;
	private File retroDocumento = null;
	
	private String codUtente = null;
	
	public String getcodUtente() {
		return codUtente;
	}
	
	public void setCodUtente(String codUtente) {
		this.codUtente = codUtente;
	}
	
	
	public File getFronteDocumento() {
		return fronteDocumento;
	}
	public void setFronteDocumento(File fronteDocumento) {
		this.fronteDocumento = fronteDocumento;
	}
	public File getRetroDocumento() {
		return retroDocumento;
	}
	public void setRetroDocumento(File retroDocumento) {
		this.retroDocumento = retroDocumento;
	}
}
