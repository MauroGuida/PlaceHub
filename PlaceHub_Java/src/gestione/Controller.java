package gestione;

import java.awt.EventQueue;
import java.io.File;
import java.sql.SQLException;

import javax.mail.MessagingException;
import javax.swing.JOptionPane;

import database.BusinessDAO;
import database.MappaDAO;
import database.Connessione;
import database.UtenteDAO;
import errori.CodMappaNonTrovatoException;
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
import oggetti.Recensione;
import res.FileChooser;
import res.InvioEmail;

public class Controller {
	private DocumentiUtente bufferDocumenti;
	private Locale bufferLocale;
	private Recensione bufferRecensione;
	
	private static SchermataAccesso schermataAccessoFrame;
	private static SchermataPrincipale schermataPrincipaleFrame;
	
	private static Connessione connessioneAlDatabase;
	private static UtenteDAO utente;
	private static BusinessDAO business;
	private static MappaDAO mappa;
	
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
			mappa = new MappaDAO();
			
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
			schermataPrincipaleFrame.mostraHomepage();
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
	
	
		//RICERCHE
		public void generaRisultatiHomePage() {	
			schermataPrincipaleFrame.svuotaRicerche();
			
			try {
				for (Locale locale : business.ricercaInVoga())
					schermataPrincipaleFrame.addRisultatoRicerca(new LocaleGUI(locale));
			} catch (SQLException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}
		
		public void generaRisultatiRistoranti() {
			schermataPrincipaleFrame.svuotaRicerche();
			
			try {
				for (Locale locale : business.ricercaRistoranti())
					schermataPrincipaleFrame.addRisultatoRicerca(new LocaleGUI(locale));
			} catch (SQLException e) {
				e.printStackTrace();
			}
		}
		
		public void generaRisultatiAttrazioni() {
			schermataPrincipaleFrame.svuotaRicerche();
			
			try {
				for (Locale locale : business.ricercaAttrazioni())
					schermataPrincipaleFrame.addRisultatoRicerca(new LocaleGUI(locale));
			} catch (SQLException e) {
				e.printStackTrace();
			}
		}

		public void generaRisultatiAlloggi() {
			schermataPrincipaleFrame.svuotaRicerche();
			
			try {
				for (Locale locale : business.ricercaAlloggi())
					schermataPrincipaleFrame.addRisultatoRicerca(new LocaleGUI(locale));
			} catch (SQLException e) {
				e.printStackTrace();
			}
		}
		
	
		//PUBBLICA BUSINESS 1
		public void procediInPubblicaBusiness2(String nomeBusiness, String indirizzo, 
											   String telefono, String partitaIVA, 
											   String tipoBusiness, String raffinazioni,
											   String Regione, String Provincia, String Comune, String CAP) {
			String codMappa = null;
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
			
			try {
				codMappa = mappa.recuperaCodMappa(Regione, Provincia, Comune, CAP);
			} catch (SQLException | CodMappaNonTrovatoException e) {
				e.printStackTrace(); //DA SCRIVERE ERRORE
				flagErrore = true;
			}
			
			if(!flagErrore) {
				bufferLocale = new Locale(nomeBusiness, indirizzo, telefono, partitaIVA, tipoBusiness, raffinazioni, codMappa);
				schermataPrincipaleFrame.mostraPubblicaBusiness2();
			}
		}
		
		public void aggiungiRegioneAModelloComboBoxPubblicaBusiness1() {
			try {
				for (String regione: mappa.prelevaRegione())
					schermataPrincipaleFrame.aggiungiRegioneAModelloPubblicaBusiness1(regione);
			} catch (SQLException e) {
				e.printStackTrace();
			}
		}
		
		public void aggiungiProvinciaAModelloComboBoxPubblicaBusiness1(String regione) {
			schermataPrincipaleFrame.pulisciModelloProvinciaPubblicaBusiness1();
			try {
				for (String provincia: mappa.prelevaProvincieDiRegione(regione))
					schermataPrincipaleFrame.aggiungiProvinciaAModelloPubblicaBusiness1(provincia);
			} catch (SQLException e) {
				e.printStackTrace();
			}
		}
		
		public void aggiungiComuneAModelloComboBoxPubblicaBusiness1(String provincia) {
			schermataPrincipaleFrame.pulisciModelloComunePubblicaBusiness1();
			try {
				for (String comune: mappa.prelevaComuneDiProvincia(provincia))
					schermataPrincipaleFrame.aggiungiComuneAModelloPubblicaBusiness1(comune);
			} catch (SQLException e) {
				e.printStackTrace();
			}
		}
		
		public void aggiungiCAPAModelloComboBoxPubblicaBusiness1(String comune) {
			schermataPrincipaleFrame.pulisciModelloCAPPubblicaBusiness1();
			try {
				for (String CAP: mappa.prelevaCAPDiComune(comune))
					schermataPrincipaleFrame.aggiungiCAPAModelloPubblicaBusiness1(CAP);
			} catch (SQLException e) {
				e.printStackTrace();
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
				
				if(bufferLocale.getNumeroImmagini() < 1) {
					schermataPrincipaleFrame.mostraErroreInserisciImmaginePubblicaBusiness2();
					flagErrore = true;
				}

				if(!flagErrore) {
					bufferLocale.setDescrizione(testoDescriviBusiness);
					if(JOptionPane.showConfirmDialog(null, "Confermi i dati inseriti?", "Conferma", JOptionPane.YES_NO_OPTION) == JOptionPane.YES_OPTION) {
						try {
							inserisciBusinessInDatabase();
							inserisciRaffinazioniBusiness(business.recuperaCodiceBusinessDaPartitaIVA(bufferLocale.getPartitaIVA()), bufferLocale.getRaffinazioni());
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
				String codBusiness = business.recuperaCodiceBusinessDaPartitaIVA(bufferLocale.getPartitaIVA());
				
				for(String immagine: bufferLocale.getListaImmagini()) {
					business.inserisciImmagine(codBusiness, immagine);
				}
			} catch (SQLException | CodiceBusinessNonTrovatoException e) {
				e.printStackTrace();
			}
		}
		
		public File caricaImmagineLocale() {
			File nuovaImmagine = selettoreFile.selezionaFile();
			
			bufferLocale.aggiungiImmagini(nuovaImmagine.getAbsolutePath());
			
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
				business.inserisciBusiness(bufferLocale, utente.getcodUtente());
			} catch (SQLException e) {
				e.printStackTrace();
			}
		}
		
		//VISITA BUSINESS
		public static void recuperaBusinessCompletoDaCodBusiness(String codBusiness) {
			try {
				schermataPrincipaleFrame.mostraVisitaBusiness();
				schermataPrincipaleFrame.configuraPannelloVisitaBusiness(business.recuperaBusinessCompletoDaCodBusiness(codBusiness));
				
				if(utente.getcodUtente().equals(business.recuperaProprietarioLocale(codBusiness)))
					schermataPrincipaleFrame.disattivaBottoneRecensioneVisitaBusiness();
			} catch (SQLException e) {
				e.printStackTrace();
			}
		}
		
		public void scriviUnaRecensione() {
			bufferRecensione = new Recensione(utente.getcodUtente());
			schermataPrincipaleFrame.mostraScriviRecensione();
		}

		
		//RECENSISCI
		public File caricaImmagineRecensione() {
			File nuovaImmagine = selettoreFile.selezionaFile();
			
			bufferRecensione.aggiungiImmagini(nuovaImmagine.getAbsolutePath());
			
			return nuovaImmagine;
		}
}
