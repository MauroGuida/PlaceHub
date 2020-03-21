package gestione;

import java.awt.EventQueue;
import java.sql.SQLException;

import javax.mail.MessagingException;

import database.BusinessDAO;
import database.Connessione;
import database.UtenteDAO;
import errori.CodiceVerificaNonTrovatoException;
import errori.CodiceVerificaNonValidoException;
import errori.EmailSconosciutaException;
import errori.UsernameOPasswordErratiException;
import gui.SchermataAccesso;
import gui.SchermataPrincipale;
import oggetti.Locale;
import res.FileChooser;
import res.InvioEmail;

public class Controller {

	private static SchermataAccesso schermataAccessoFrame;
	private static SchermataPrincipale schermataPrincipaleFrame;
	
	private static Connessione connessioneAlDatabase;
	private UtenteDAO utente;
	private BusinessDAO business;
	
	private InvioEmail mail;
	private LayoutEmail corpoMail;
	private FileChooser uploadFile;
	
	
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
			uploadFile = new FileChooser();
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
	
	public void generaRisultatiHomePage() {	
		schermataPrincipaleFrame.svuotaRicerche();
		
		for (Locale locale : business.ricercaInVoga())
			schermataPrincipaleFrame.addRisultatoRicerca(locale);
	}
	
	public void generaRisultatiRistoranti() {
		schermataPrincipaleFrame.svuotaRicerche();
		
		for (Locale locale : business.ricercaRistoranti())
			schermataPrincipaleFrame.addRisultatoRicerca(locale);
	}
	
	
		//PUBBLICA BUSINESS
		
		public void procediInPubblicaBusiness2(String nomeBusiness, String Indirizzo, 
											   String Telefono, String PartitaIVA, int flagTipologia) {
			
			boolean flagErrore = false;
			schermataPrincipaleFrame.resettaVisibilitaErroriPubblicaBusiness1();
			if(nomeBusiness.isBlank() || nomeBusiness.isEmpty() || Indirizzo.isBlank() || Indirizzo.isEmpty() ||
			   Telefono.isBlank() || Telefono.isEmpty() || PartitaIVA.isBlank() || PartitaIVA.isEmpty()) {
				schermataPrincipaleFrame.mostraErroreCampiVuotiPubblicaBusiness1();
				flagErrore = true;
			}
			if(flagTipologia == 0) {
				schermataPrincipaleFrame.mostraErroreTipologiaVuotaPubblicaBusiness1();
				flagErrore = true;
			}
			
			if(!flagErrore) {
				schermataPrincipaleFrame.mostraPubblicaBusiness2();
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
		
		
		//VERIFICA PUBBLICA BUSINESS
		
		public void uploadDocumentoFronte() {
			uploadFile.selezionaFile(); //DA GESTIRE
		}
		
		public void uploadDocumentoRetro() {
			uploadFile.selezionaFile(); //DA GESTIRE
		}
	
}
