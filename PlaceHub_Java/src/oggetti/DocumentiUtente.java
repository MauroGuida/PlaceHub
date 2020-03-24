package oggetti;

import java.io.File;

public class DocumentiUtente {
	private File fronteDocumento = null;
	private File retroDocumento = null;
	
	
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
