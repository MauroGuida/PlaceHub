package gestione;

import java.awt.EventQueue;
import java.sql.SQLException;

import javax.mail.MessagingException;

import database.Connessione;
import database.UtenteDAO;
import errori.CodiceVerificaNonValidoException;
import errori.UsernameOPasswordErratiException;
import gui.SchermataAccesso;
import gui.SchermataPrincipale;
import res.InvioEmail;

public class Controller {

	private static SchermataAccesso schermataAccessoFrame;
	private static SchermataPrincipale schermataPrincipaleFrame;
	
	private static Connessione connessioneAlDatabase;
	private UtenteDAO utente;
	
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
	
	public static SchermataAccesso getSchermataAccessoFrame() {
		return schermataAccessoFrame;
	}
	
	private Controller() {
		try {
			connessioneAlDatabase = new Connessione();
			utente = new UtenteDAO();
			
			mail = new InvioEmail();
			corpoMail = new LayoutEmail();
		} catch (ClassNotFoundException | SQLException e) {
			e.printStackTrace();
		}
	}
	
	public static Connessione getConnessioneAlDatabase() {
		return connessioneAlDatabase;
	}
	
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
				mail.inviaEmail(Email, oggetto, corpoMail.corpoEmailBenvenutoRegistrazione(Username));
				utente.registrati(Username, Nome, Cognome, Email, DataDiNascita, Password);
				
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
				
				e.printStackTrace();
			} catch (MessagingException e) {
				schermataAccessoFrame.mostraErroreEmailNonValidaRegistrazione();
				
				e.printStackTrace();
			}
		}
	}
	
	public void invioEmailCodiceVerificaSchermataAccessoReimpostaPassword(String email) {
		try {
			final String oggetto = "Placehub - Reimposta password!";
			mail.inviaEmail(email, oggetto, corpoMail.corpoEmailReimpostaPassword(utente.reimpostaPassword(email)));
			
			schermataAccessoFrame.mostraPannelloReimpostaPassword2();
			schermataAccessoFrame.nascondiPannelloReimpostaPassword1();
		} catch (MessagingException | SQLException e) {
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
}
