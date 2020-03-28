package gestione;

import java.awt.EventQueue;
import java.io.File;
import java.sql.SQLException;

import javax.mail.MessagingException;
import javax.swing.JOptionPane;

import database.BusinessDAO;
import database.Connessione;
import database.UtenteDAO;
import errori.CodiceBusinessNonTrovatoException;
import errori.CodiceVerificaNonTrovatoException;
import errori.CodiceVerificaNonValidoException;
import errori.EmailSconosciutaException;
import errori.UsernameOPasswordErratiException;
import gui.LocaleGUI;
import gui.SchermataAccesso;
import gui.SchermataPrincipale;
import oggetti.DocumentiUtente;
import oggetti.Locale;
import res.FileChooser;
import res.InvioEmail;

public class Controller {
	private DocumentiUtente bufferDocumenti;
	private Locale localeBuffer;
	
	private static SchermataAccesso schermataAccessoFrame;
	private static SchermataPrincipale schermataPrincipaleFrame;
	
	private static Connessione connessioneAlDatabase;
	private UtenteDAO utente;
	private BusinessDAO business;
	
	private InvioEmail mail;
	private LayoutEmail corpoMail;
	private FileChooser selettoreFile;
	
	
	//Inizializzazione programma
	public static void main(String[] args) {
		EventQueue.invokeLater(new Runnable() {
			public void run() {
				try {
					Controller ctrl = new Controller();	
					
					schermataAccessoFrame = new SchermataAccesso(ctrl);
					schermataAccessoFrame.setVisible(true);
				} catch (Exception e) {
					e.printStackTrace();
				}
			}
		});
	}
	
	public static SchermataAccesso getSchermataAccessoFrame() {
		return schermataAccessoFrame;
	}
	
	public static SchermataPrincipale getSchermataPrincipaleFrame() {
		return schermataPrincipaleFrame;
	}
	
	private Controller() {
		try {
			connessioneAlDatabase = new Connessione();
			utente = new UtenteDAO();
			business = new BusinessDAO();
			
			mail = new InvioEmail();
			corpoMail = new LayoutEmail();
			selettoreFile = new FileChooser();
			
			bufferDocumenti = new DocumentiUtente();
		} catch (ClassNotFoundException | SQLException e) {
			e.printStackTrace();
		}
	}
	
	public static Connessione getConnessioneAlDatabase() {
		return connessioneAlDatabase;
	}
	
	
	//SCHERMATA ACCESSO 
	public void loginSchermataAccesso(String Username, char[] Password) {
		try {
			utente.login(Username, Password);
			schermataAccessoFrame.mostraErroreUsernamePassword(false);
			schermataPrincipaleFrame = new SchermataPrincipale(this);
			schermataPrincipaleFrame.setVisible(true);
			schermataAccessoFrame.dispose();
		} catch (UsernameOPasswordErratiException e1) {
			schermataAccessoFrame.mostraErroreUsernamePassword(true);
		} catch(SQLException e2) {
			e2.printStackTrace();
		}
	}
	
	public void registratiSchermataAccesso(String Username, String Nome, String Cognome, String Email, String DataDiNascita, char[] Password) {
		schermataAccessoFrame.resettaErroriRegistrazione();
		
		if(Username.isBlank() || Username.isEmpty() || Nome.isBlank() || Nome.isEmpty() || Cognome.isBlank() || Cognome.isEmpty() ||
				Email.isBlank() || Email.isEmpty() || DataDiNascita.isBlank() || DataDiNascita.isEmpty() || Password.length==0) {
			schermataAccessoFrame.mostraErroreNonPossonoEsserciCampiVuotiRegistrazione();
		}else {
			try {
				final String oggetto = "Benvenuto su PlaceHub";
				
				utente.registrati(Username, Nome, Cognome, Email, DataDiNascita, Password);
				mail.inviaEmail(Email, oggetto, corpoMail.corpoEmailBenvenutoRegistrazione(Username));
				
				schermataAccessoFrame.mostraConfermaRegistrazione();
			} catch (SQLException e) {		
				if(e.toString().indexOf("utente_username_key") != -1)
					schermataAccessoFrame.mostraErroreUsernameNonDisponibileRegistrazione();
				if(e.toString().indexOf("utente_email_check") != -1)
					schermataAccessoFrame.mostraErroreEmailNonValidaRegistrazione();
				if(e.toString().indexOf("utente_email_key") != -1)
					schermataAccessoFrame.mostraErroreEmailGiaInUsoRegistrazione();
				if(e.toString().indexOf("lunghezzapassword") != -1)
					schermataAccessoFrame.mostraErrorePasswordNonValidaRegistrazione();
				if(e.toString().indexOf("datadinascitanonvalida") != -1)
					schermataAccessoFrame.mostraErroreDataDiNascitaNonValida();
				
				e.printStackTrace();
			} catch (MessagingException e) {
				schermataAccessoFrame.mostraErroreEmailNonValidaRegistrazione();
				
				e.printStackTrace();
			}
		}
	}
	
	public void richediGenerazioneCodiceVerificaSchermataAccessoReimpostaPassword(String email) {
		try {
			utente.generaCodiceVerifica(utente.recuperaCodiceUtenteDaEmail(email));
		} catch(EmailSconosciutaException e) {
			schermataAccessoFrame.mostraErroreReimpostaPassword1();
		} catch (SQLException e) {
			e.printStackTrace();
		}
	}
	
	public void invioEmailCodiceVerificaSchermataAccessoReimpostaPassword(String email) {
		try {
			final String oggetto = "Placehub - Reimposta password!";
			mail.inviaEmail(email, oggetto, corpoMail.corpoEmailReimpostaPassword(utente.recuperaCodiceVerifica(utente.recuperaCodiceUtenteDaEmail(email))));
			
			schermataAccessoFrame.mostraPannelloReimpostaPassword2();
			schermataAccessoFrame.nascondiPannelloReimpostaPassword1();
		} catch (MessagingException | SQLException | CodiceVerificaNonTrovatoException | EmailSconosciutaException  e) {
			schermataAccessoFrame.mostraErroreReimpostaPassword1();
			
			e.printStackTrace();
		}
	}
	
	public void impostaPassword(String codiceVerifica, char[] Password) {
		try {
			utente.impostaPassword(codiceVerifica, Password);
			
			schermataAccessoFrame.mostraAvvisoPasswordImpostataConSuccessoReimpostaPassword2();
		} catch (SQLException e) {
			if(e.toString().indexOf("lunghezzapassword") != -1)
				schermataAccessoFrame.mostraErrorePasswordTroppoCortaReimpostaPassword2();
			
			e.printStackTrace();
		}catch (CodiceVerificaNonValidoException e) {
			schermataAccessoFrame.mostraErroreCodiceDiVerificaNonValidoReimpostaPassword2();
		}
	}
	
	
	//SCHERMATA PRINCIPALE
	
	
		//LOCALE
		public void generaRisultatiHomePage() {	
			schermataPrincipaleFrame.svuotaRicerche();
			
			for (Locale locale : business.ricercaInVoga())
				schermataPrincipaleFrame.addRisultatoRicerca(new LocaleGUI(locale));
		}
		
		public void generaRisultatiRistoranti() {
			schermataPrincipaleFrame.svuotaRicerche();
			
			for (Locale locale : business.ricercaRistoranti())
				schermataPrincipaleFrame.addRisultatoRicerca(new LocaleGUI(locale));
		}
		
		public void generaRisultatiAttrazioni() {
			schermataPrincipaleFrame.svuotaRicerche();
			
			for (Locale locale : business.ricercaAttrazioni())
				schermataPrincipaleFrame.addRisultatoRicerca(new LocaleGUI(locale));
		}

		public void generaRisultatiAlloggi() {
			schermataPrincipaleFrame.svuotaRicerche();
			
			for (Locale locale : business.ricercaAlloggi())
				schermataPrincipaleFrame.addRisultatoRicerca(new LocaleGUI(locale));
		}
	
	
		//PUBBLICA BUSINESS 1
		public void procediInPubblicaBusiness2(String nomeBusiness, String indirizzo, 
											   String telefono, String partitaIVA, 
											   String tipoBusiness, String raffinazioni) {
			
			boolean flagErrore = false;
			schermataPrincipaleFrame.resettaVisibilitaErroriPubblicaBusiness1();
			if(nomeBusiness.isBlank() || nomeBusiness.isEmpty() || indirizzo.isBlank() || indirizzo.isEmpty() ||
					telefono.isBlank() || telefono.isEmpty() || partitaIVA.isBlank() || partitaIVA.isEmpty()) {
				schermataPrincipaleFrame.mostraErroreCampiVuotiPubblicaBusiness1();
				flagErrore = true;
			}
			
			if(tipoBusiness == null) {
				schermataPrincipaleFrame.mostraErroreTipologiaVuotaPubblicaBusiness1();
				flagErrore = true;
			}
			
			if(nomeBusiness.matches("[0-9]+") || indirizzo.matches("[0-9]+")) {
				schermataPrincipaleFrame.mostraErrorePatternCampiPubblicaBusiness1();
				flagErrore = true;
			}
			
			if(telefono.length()!=10) {
				schermataPrincipaleFrame.mostraErroreNumeroDiTelefonoPubblicaBusiness1();
				flagErrore = true;
			}
			
			if(partitaIVA.length()!=11) {
				schermataPrincipaleFrame.mostraErrorePartitaIVAPubblicaBusiness1();
				flagErrore = true;
			}
			
			
			try {
				business.recuperaCodiceBusinessDaPartitaIVA(partitaIVA);
				schermataPrincipaleFrame.mostraErrorePartitaIVAInUsoPubblicaBusiness1();
				flagErrore = true;
			} catch (SQLException | CodiceBusinessNonTrovatoException e) {
				
			}
			
			
			if(!flagErrore) {
				localeBuffer = new Locale(nomeBusiness, indirizzo, telefono, partitaIVA, tipoBusiness, raffinazioni);
				schermataPrincipaleFrame.mostraPubblicaBusiness2();
			}
		}
		
		
		// PUBBLICA BUSINESS 2
		public void procediInPubblicaBusiness3(String testoDescriviBusiness) {
				boolean flagErrore = false;
				schermataPrincipaleFrame.resettaVisibilitaErroriPubblicaBusiness2();

				if(testoDescriviBusiness.isBlank() || testoDescriviBusiness.isEmpty() || 
				   testoDescriviBusiness.equals("Scrivi qui! MAX(2000 caratteri)")) {
					schermataPrincipaleFrame.mostraErroreInserisciDescrizionePubblicaBusiness2();
					flagErrore = true;
				}
				
				if(localeBuffer.getNumeroImmagini() < 1) {
					schermataPrincipaleFrame.mostraErroreInserisciImmaginePubblicaBusiness2();
					flagErrore = true;
				}

				if(!flagErrore) {
					localeBuffer.setDescrizione(testoDescriviBusiness);
					if(JOptionPane.showConfirmDialog(null, "Confermi i dati inseriti?", "Conferma", JOptionPane.YES_NO_OPTION) == JOptionPane.YES_OPTION) {
						try {
							inserisciBusinessInDatabase();
							inserisciRaffinazioniBusiness(business.recuperaCodiceBusinessDaPartitaIVA(localeBuffer.getPartitaIVA()), localeBuffer.getRaffinazioni());
							inserisciListaImmaginiInDatabase();
							schermataPrincipaleFrame.mostraPubblicaBusiness3();
						} catch (SQLException | CodiceBusinessNonTrovatoException e) {
							e.printStackTrace();
						}
					}
				}
		}
		
		public void inserisciListaImmaginiInDatabase() {
			try {
				String codBusiness = business.recuperaCodiceBusinessDaPartitaIVA(localeBuffer.getPartitaIVA());
				
				for(String immagine: localeBuffer.getListaImmagini()) {
					business.inserisciImmagine(codBusiness, immagine);
				}
			} catch (SQLException | CodiceBusinessNonTrovatoException e) {
				e.printStackTrace();
			}
		}
		
		public File caricaImmagineLocale() {
			File nuovaImmagine = selettoreFile.selezionaFile();
			
			localeBuffer.aggiungiImmagini(nuovaImmagine.getAbsolutePath());
			
			return nuovaImmagine;
		}
		
		public void inserisciRaffinazioniBusiness(String codBusiness, String raffinazioni) {
			try {
				business.inserisciRaffinazioni(codBusiness, raffinazioni);
			} catch (SQLException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
			
			
		}
		
		//GESTISCI BUSINESS
		public void controllaDocumentiUtente() {
			try {
				if(utente.controllaDocumentiUtente())
					schermataPrincipaleFrame.mostraPubblicaBusiness1();
				else
					schermataPrincipaleFrame.mostraVerificaPubblicaBusiness();
				
			} catch (SQLException e) {
				e.printStackTrace();
			}
				
		}
		
		public void recuperaBusinessUtente() {
			try {
				for (Locale recuperato : business.recuperaBusinessDaCodUtente(utente.getcodUtente()))
					schermataPrincipaleFrame.aggiungiBusinessGestisciBusiness(new LocaleGUI(recuperato));
			} catch (SQLException e) {
				e.printStackTrace();
			}
		}
		
		
		//VERIFICA PUBBLICA BUSINESS
		public File caricaDocumentoFronteInBuffer() {
			File docFronte = selettoreFile.selezionaFile();
			bufferDocumenti.setFronteDocumento(docFronte);
			
			return docFronte;
		}
		
		public File caricaDocumentoRetroInBuffer() {
			File docRetro = selettoreFile.selezionaFile();
			bufferDocumenti.setRetroDocumento(docRetro);
			
			return docRetro;
		}
		
		private void caricaDocumentiInDatabase() {
			try {
				utente.inserisciDocumentiUtente(utente.getcodUtente(), bufferDocumenti.getFronteDocumento(),
						bufferDocumenti.getRetroDocumento());
			} catch (SQLException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}
		
		public void inviaCodiceVerificaVerificaPubblicaBusiness() {
			String codUtente;
			try {
				codUtente = utente.getcodUtente();
				utente.generaCodiceVerifica(codUtente);
				
				final String oggetto = "Placehub - Verifica i tuoi documenti!";
				mail.inviaEmail(utente.recuperaEmail(codUtente), oggetto, corpoMail.corpoEmailVerificaDocumenti(utente.recuperaCodiceVerifica(codUtente)));
				
				schermataPrincipaleFrame.disabilitaCaricaDocumentoVerificaPubblicaBusiness();
				schermataPrincipaleFrame.mostraEmailInviataVerificaPubblicaBusiness();
			} catch (SQLException e) {
				e.printStackTrace();
			}catch ( MessagingException e) {
				schermataPrincipaleFrame.mostraErroreEmailVerificaPubblicaBusiness();
			}catch (CodiceVerificaNonTrovatoException e) {
				
			}
		}
		
		public void controllaCodiceVerificaECaricaDocumentiVerificaPubblicaBusiness(String codiceVerifica) {
			try {
				if(utente.controllaCodiceVerrifica(utente.getcodUtente(), codiceVerifica))
					schermataPrincipaleFrame.mostraPubblicaBusiness1();
					caricaDocumentiInDatabase();
			} catch (SQLException | CodiceVerificaNonValidoException e) {
				schermataPrincipaleFrame.mostraErroreCodiceVerificaVerificaPubblicaBusiness();
			}
		}
		
		
		//CONFERMA REGISTRAZIONE BUSINESS
		public void inserisciBusinessInDatabase() {
			try {
				business.inserisciBusiness(localeBuffer, utente.getcodUtente());
			} catch (SQLException e) {
				e.printStackTrace();
			}
		}
		
		//VISITA BUSINESS
		public Locale recuperaDatiLocale(String codBusiness) {
			try {
				return business.recuperaLocaleDaCodBusiness(codBusiness);
			} catch (SQLException e) {
				e.printStackTrace();
			}
			
			return null;
		}
}
