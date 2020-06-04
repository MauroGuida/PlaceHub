package gestione;

import java.awt.EventQueue;
import java.io.File;
import java.sql.SQLException;
import java.util.ArrayList;

import javax.mail.MessagingException;
import javax.swing.JOptionPane;

import database.BusinessDAO;
import database.MappaDAO;
import database.RecensioneDAO;
import database.Connessione;
import database.UtenteDAO;
import eccezioni.CodMappaNonTrovatoException;
import eccezioni.CodiceBusinessNonTrovatoException;
import eccezioni.CodiceVerificaNonTrovatoException;
import eccezioni.CodiceVerificaNonValidoException;
import eccezioni.EmailSconosciutaException;
import eccezioni.UsernameOPasswordErratiException;
import frameGUI.SchermataAccesso;
import frameGUI.SchermataPrincipale;
import frameGUI.pannelliSchermataPrincipale.RicercaLocaleVuota;
import oggettiServizio.Business;
import oggettiServizio.Recensione;
import oggettiServizio.Utente;
import miscellaneous.InvioEmail;
import miscellaneousGUI.LocaleGUI;

public class Controller {
	private Utente utente;
	private Business locale;
	private Recensione recensione;
	
	private static SchermataAccesso schermataAccessoFrame;
	private static SchermataPrincipale schermataPrincipaleFrame;
	
	private static Connessione connessioneAlDatabase;
	private static UtenteDAO utenteDAO;
	private static BusinessDAO businessDAO;
	private static MappaDAO mappaDAO;
	private static RecensioneDAO recensioneDAO;
	
	private InvioEmail mail;
	private LayoutEmail corpoMail;
	
	
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
	
	private Controller() {
		try {
			connessioneAlDatabase = new Connessione();
			utenteDAO = new UtenteDAO();
			businessDAO = new BusinessDAO();
			mappaDAO = new MappaDAO();
			recensioneDAO = new RecensioneDAO();
			
			mail = new InvioEmail();
			corpoMail = new LayoutEmail();
			
			utente = new Utente();
		} catch (ClassNotFoundException | SQLException e) {
			e.printStackTrace();
		}
	}
	
	
	public static SchermataAccesso getSchermataAccessoFrame() {
		return schermataAccessoFrame;
	}
	
	public static SchermataPrincipale getSchermataPrincipaleFrame() {
		return schermataPrincipaleFrame;
	}
	
	public static Connessione getConnessioneAlDatabase() {
		return connessioneAlDatabase;
	}
	
	
	//SCHERMATA ACCESSO 
	public void loginSchermataAccesso(String Username, char[] Password) {
		try {
			utente.setCodUtente(utenteDAO.login(Username, Password));
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
				
				utenteDAO.registrati(Username, Nome, Cognome, Email, DataDiNascita, Password);
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
			utente.setCodUtente(utenteDAO.recuperaCodiceUtenteDaEmail(email)); // Nella classe utente viene impostato il codice dell'utente recuperato
			utenteDAO.generaCodiceVerifica(utente.getcodUtente());
		} catch(EmailSconosciutaException e) {
			schermataAccessoFrame.mostraErroreReimpostaPassword1();
		} catch (SQLException e) {
			e.printStackTrace();
		}
	}
	
	public void invioEmailCodiceVerificaSchermataAccessoReimpostaPassword(String email) {
		try {
			final String oggetto = "Placehub - Reimposta password!";
			mail.inviaEmail(email, oggetto, corpoMail.corpoEmailReimpostaPassword(utenteDAO.recuperaCodiceVerifica(utenteDAO.recuperaCodiceUtenteDaEmail(email))));
			
			schermataAccessoFrame.mostraPannelloReimpostaPassword2();
			schermataAccessoFrame.nascondiPannelloReimpostaPassword1();
		} catch (MessagingException | SQLException | CodiceVerificaNonTrovatoException | EmailSconosciutaException  e) {
			schermataAccessoFrame.mostraErroreReimpostaPassword1();
		}
	}
	
	public void impostaPassword(String codiceVerifica, char[] Password) {
		try {
			utenteDAO.impostaPassword(utente.getcodUtente(), codiceVerifica, Password);
			utente.setCodUtente(null);
			
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
	public static void chiudiSchermataPrincipale() {
		try {
			connessioneAlDatabase.disconnetti();
			schermataPrincipaleFrame.dispose();
			System.exit(0);
		} catch (SQLException e) {
			System.exit(1);
		}
	}
	
	
		//RICERCHE
		public void generaRisultatiHomePage() {	
			schermataPrincipaleFrame.svuotaRicerche();
			
			try {
				for (Business locale : businessDAO.ricercaInVoga())
					schermataPrincipaleFrame.aggiungiRisultatoRicerca(new LocaleGUI(locale, this));
			} catch (SQLException e) {
				e.printStackTrace();
			}
		}
		
		public void generaRisultatiRistoranti() {
			schermataPrincipaleFrame.svuotaRicerche();
			
			try {
				for (Business locale : businessDAO.recuperaLocaliDaTipo("Ristorante"))
					schermataPrincipaleFrame.aggiungiRisultatoRicerca(new LocaleGUI(locale, this));
			} catch (SQLException e) {
				e.printStackTrace();
			}
		}
		
		public void generaRisultatiAttrazioni() {
			schermataPrincipaleFrame.svuotaRicerche();
			
			try {
				for (Business locale : businessDAO.recuperaLocaliDaTipo("Attrazione"))
					schermataPrincipaleFrame.aggiungiRisultatoRicerca(new LocaleGUI(locale, this));
			} catch (SQLException e) {
				e.printStackTrace();
			}
		}

		public void generaRisultatiAlloggi() {
			schermataPrincipaleFrame.svuotaRicerche();
			
			try {
				for (Business locale : businessDAO.recuperaLocaliDaTipo("Alloggio"))
					schermataPrincipaleFrame.aggiungiRisultatoRicerca(new LocaleGUI(locale, this));
			} catch (SQLException e) {
				e.printStackTrace();
			}
		}
		
		public void generaRisultatiRicercaLocale(String campoCosa,String campoDove) {
			schermataPrincipaleFrame.svuotaRicerche();
			
			try {
				if(campoCosa.isEmpty() || campoCosa.isBlank() || campoCosa.equals("Cosa?"))
					campoCosa = "";
				
				if(campoDove.isEmpty() || campoDove.isBlank() || campoDove.equals("Dove?"))
					campoDove = "";
				
				ArrayList<Business> locali = businessDAO.recuperaLocaliDaRicerca(campoCosa, campoDove);
				if(locali.isEmpty())
					schermataPrincipaleFrame.aggiungiRisultatoRicerca(new RicercaLocaleVuota());
				else
					for(Business locale : locali)
						schermataPrincipaleFrame.aggiungiRisultatoRicerca(new LocaleGUI(locale,this));
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
				if(utente.getcodUtente().equals(businessDAO.recuperaProprietarioLocaleDaPartitaIVA(partitaIVA)) && (locale != null && locale.isModifica())) {
					locale.setNome(nomeBusiness);
					locale.setIndirizzo(indirizzo);
					locale.setTelefono(telefono);
					locale.setTipoBusiness(tipoBusiness);
					locale.setRaffinazioni(raffinazioni);
					
					schermataPrincipaleFrame.mostraPubblicaBusiness2();
					schermataPrincipaleFrame.impostaBusinessPreesistentePubblicaBusiness2(locale);
					return;
				}else {
					schermataPrincipaleFrame.mostraErrorePartitaIVAInUsoPubblicaBusiness1();
					flagErrore = true;
				}
			} catch (SQLException e) {
				
			}
			
			try {
				codMappa = mappaDAO.recuperaCodMappa(Regione, Provincia, Comune, CAP);
			} catch (SQLException | CodMappaNonTrovatoException e) {
				e.printStackTrace();
				flagErrore = true;
			}
			
			if(!flagErrore) {
				locale = new Business(nomeBusiness, indirizzo, telefono, partitaIVA, tipoBusiness, raffinazioni, codMappa);
				schermataPrincipaleFrame.mostraPubblicaBusiness2();
			}
		}
		
		public void aggiungiRegioneAModelloComboBoxPubblicaBusiness1() {
			try {
				for (String regione: mappaDAO.prelevaRegione())
					schermataPrincipaleFrame.aggiungiRegioneAModelloPubblicaBusiness1(regione);
			} catch (SQLException e) {
				e.printStackTrace();
			}
		}
		
		public void aggiungiProvinciaAModelloComboBoxPubblicaBusiness1(String regione) {
			schermataPrincipaleFrame.pulisciModelloProvinciaPubblicaBusiness1();
			try {
				for (String provincia: mappaDAO.prelevaProvincieDiRegione(regione))
					schermataPrincipaleFrame.aggiungiProvinciaAModelloPubblicaBusiness1(provincia);
			} catch (SQLException e) {
				e.printStackTrace();
			}
		}
		
		public void aggiungiComuneAModelloComboBoxPubblicaBusiness1(String provincia) {
			schermataPrincipaleFrame.pulisciModelloComunePubblicaBusiness1();
			try {
				for (String comune: mappaDAO.prelevaComuneDiProvincia(provincia))
					schermataPrincipaleFrame.aggiungiComuneAModelloPubblicaBusiness1(comune);
			} catch (SQLException e) {
				e.printStackTrace();
			}
		}
		
		public void aggiungiCAPAModelloComboBoxPubblicaBusiness1(String comune) {
			schermataPrincipaleFrame.pulisciModelloCAPPubblicaBusiness1();
			try {
				for (String CAP: mappaDAO.prelevaCAPDiComune(comune))
					schermataPrincipaleFrame.aggiungiCAPAModelloPubblicaBusiness1(CAP);
			} catch (SQLException e) {
				e.printStackTrace();
			}
		}
		
		public void modificaBusinessPubblicaBusiness1(String codBusiness) {
			try {
				locale = businessDAO.recuperaBusinessCompletoDaCodBusiness(codBusiness);
				locale.setModifica(true);
				schermataPrincipaleFrame.mostraPubblicaBusiness1();
				schermataPrincipaleFrame.impostaBusinessPreesistentePubblicaBusiness1(locale);
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
				
				if(locale.getNumeroImmagini() < 1) {
					schermataPrincipaleFrame.mostraErroreInserisciImmaginePubblicaBusiness2();
					flagErrore = true;
				}

				if(!flagErrore) {
					locale.setDescrizione(testoDescriviBusiness);
					if(JOptionPane.showConfirmDialog(null, "Confermi i dati inseriti?", "Conferma", JOptionPane.YES_NO_OPTION) == JOptionPane.YES_OPTION) {
						try {
							inserisciBusinessInDatabase();
							inserisciRaffinazioniBusiness(businessDAO.recuperaCodiceBusinessDaPartitaIVA(locale.getPartitaIVA()), locale.getRaffinazioni());
							inserisciListaImmaginiInDatabase();
							schermataPrincipaleFrame.mostraPubblicaBusiness3();
						} catch (SQLException | CodiceBusinessNonTrovatoException e) {
							e.printStackTrace();
						}
					}
				}
		}
		
		public void inserisciBusinessInDatabase() {
			try {
				businessDAO.inserisciBusiness(locale, utente.getcodUtente());
			} catch (SQLException e) {
				e.printStackTrace();
			}
		}
		
		public void inserisciListaImmaginiInDatabase() {
			try {
				String codBusiness = businessDAO.recuperaCodiceBusinessDaPartitaIVA(locale.getPartitaIVA());
				
				for(String immagine: locale.getListaImmagini()) {
					try {
						businessDAO.inserisciImmagine(codBusiness, immagine);
					}catch(SQLException e) {
						//Se viene restituito un errore quell'immagine e' duplicata e quindi non e' aggiunta
					}
				}
			} catch (SQLException | CodiceBusinessNonTrovatoException e) {
				e.printStackTrace();
			}
		}
		
		public boolean caricaImmagineLocale(File nuovaImmagine) {
			if(haEstensioneImmagine(nuovaImmagine)) {
				locale.aggiungiImmagini(nuovaImmagine.getAbsolutePath());
				return true;
			}
			
			return false;
		}
		
		public void inserisciRaffinazioniBusiness(String codBusiness, String raffinazioni) {
			try {
				businessDAO.inserisciRaffinazioni(codBusiness, raffinazioni);
			} catch (SQLException e) {
				e.printStackTrace();
			}
			
			
		}
		
		//GESTISCI BUSINESS
		public void controllaDocumentiUtente() {
			try {
				if(utenteDAO.controllaDocumentiUtente(utente.getcodUtente())) {
					locale = null;
					schermataPrincipaleFrame.mostraPubblicaBusiness1();
				}else
					schermataPrincipaleFrame.mostraVerificaPubblicaBusiness();
				
			} catch (SQLException e) {
				e.printStackTrace();
			}
				
		}
		
		public void recuperaBusinessUtente() {
			try {
				for (Business recuperato : businessDAO.recuperaBusinessDaCodUtente(utente.getcodUtente()))
					schermataPrincipaleFrame.aggiungiBusinessGestisciBusiness(new LocaleGUI(recuperato, this, true));
			} catch (SQLException e) {
				e.printStackTrace();
			}
		}
		
		
		//VERIFICA PUBBLICA BUSINESS
		public boolean caricaDocumentoFronteInBuffer(File documentoFronte) {
			if(haEstensioneImmagine(documentoFronte)) {
				utente.setFronteDocumento(documentoFronte);
				return true;
			}
			
			return false;
		}
		
		public boolean caricaDocumentoRetroInBuffer(File documentoRetro) {
			if(haEstensioneImmagine(documentoRetro)) {
				utente.setRetroDocumento(documentoRetro);
				return true;
			}
			
			return false;
		}
		
		private void caricaDocumentiInDatabase() {
			try {
				utenteDAO.inserisciDocumentiUtente(utente.getcodUtente(), utente.getFronteDocumento(),
						utente.getRetroDocumento());
			} catch (SQLException e) {
				e.printStackTrace();
			}
		}
		
		public void inviaCodiceVerificaVerificaPubblicaBusiness() {
			String codUtente;
			try {
				codUtente = utente.getcodUtente();
				utenteDAO.generaCodiceVerifica(codUtente);
				
				final String oggetto = "Placehub - Verifica i tuoi documenti!";
				mail.inviaEmail(utenteDAO.recuperaEmail(codUtente), oggetto, corpoMail.corpoEmailVerificaDocumenti(utenteDAO.recuperaCodiceVerifica(codUtente)));
				
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
				if(utenteDAO.controllaCodiceVerrifica(utente.getcodUtente(), codiceVerifica))
					schermataPrincipaleFrame.mostraPubblicaBusiness1();
					caricaDocumentiInDatabase();
			} catch (SQLException | CodiceVerificaNonValidoException e) {
				schermataPrincipaleFrame.mostraErroreCodiceVerificaVerificaPubblicaBusiness();
			}
		}
		
		//VISITA BUSINESS
		public void vaiAVisitaBusiness(String codBusiness) {
			try {
				//Recupero Business completo
				locale = businessDAO.recuperaBusinessCompletoDaCodBusiness(codBusiness);
				locale.setLuogo(mappaDAO.recuperaCittaDaCodMappa(locale.getCodMappa()));
				
				schermataPrincipaleFrame.configuraPannelloVisitaBusiness(locale, recensioneDAO.recuperaRecensioniBusiness(codBusiness));
				
				//Il proprietario non puo' auto-recensirsi
				if(utente.getcodUtente().equals(businessDAO.recuperaProprietarioLocale(codBusiness)))
					schermataPrincipaleFrame.disattivaBottoneRecensioneVisitaBusiness();
				
				//Non posso avere recensioni duplicate
				if(recensioneDAO.utenteConRecensione(utente.getcodUtente(), codBusiness))
					schermataPrincipaleFrame.disattivaBottoneRecensioneVisitaBusiness();
				
				schermataPrincipaleFrame.mostraVisitaBusiness();
			} catch (SQLException e) {
				e.printStackTrace();
			}
		}
		
		public void vaiAScriviRecensione() {
			recensione = new Recensione(utente.getcodUtente(), locale.getCodBusiness());
			schermataPrincipaleFrame.mostraScriviRecensione();
		}

		//RECENSISCI
		public boolean caricaImmagineRecensione(File nuovaImmagine) {
			if(haEstensioneImmagine(nuovaImmagine)) {
				recensione.aggiungiImmagini(nuovaImmagine.getAbsolutePath());
				return true;
			}
			
			return false;
		}

		public void pubblicaRecensione(String testo, int stelle) {
			if(testo.equals("Scrivi qui! MAX(2000 caratteri)") || testo.isBlank() || testo.isEmpty()) {
				schermataPrincipaleFrame.mostraErroreRecensioneVuotaScriviRecensione();
			}else if(stelle == 0) {
				schermataPrincipaleFrame.mostraErroreStelleMancateScriviRecensione();
			}else if(JOptionPane.showConfirmDialog(null, "Confermi i dati inseriti?", "Conferma", JOptionPane.YES_NO_OPTION) == JOptionPane.YES_OPTION) {
				try {
					recensione.setTestoRecensione(testo);
					recensione.setStelle(stelle);
					
					recensioneDAO.inserisciRecensione(recensione);
					
					schermataPrincipaleFrame.mostraHomepage();
				} catch (SQLException e) {
					e.printStackTrace();
				}
			}	
		}
		
		public void tornaAVisitaBusiness() {
			if(JOptionPane.showConfirmDialog(null, "I dati inseriti andranno persi, Confermi?", "Conferma", JOptionPane.YES_NO_OPTION) == JOptionPane.YES_OPTION)
				schermataPrincipaleFrame.mostraVisitaBusiness();
		}

		
	// ACCESSORI
	private boolean haEstensioneImmagine(File file) {
		if(file != null && (file.getAbsolutePath().toLowerCase().contains(".jpg") || file.getAbsolutePath().toLowerCase().contains(".gif") ||
				file.getAbsolutePath().toLowerCase().contains(".png") || file.getAbsolutePath().toLowerCase().contains(".jpeg"))){
			return true;
		}
		return false;
	}
}
