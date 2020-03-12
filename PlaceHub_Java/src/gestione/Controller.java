package gestione;

import java.awt.EventQueue;
import java.sql.SQLException;

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
			utente = new UtenteDAO();
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
				utente.registrati(Username, Nome, Cognome, Email, DataDiNascita, Password);
				schermataAccessoFrame.mostraConfermaRegistrazione();
			} catch (Exception e) {		
				if(e.toString().indexOf("utente_username_key") != -1)
					schermataAccessoFrame.mostraErroreUsernameNonDisponibileRegistrazione();;
				if(e.toString().indexOf("utente_email_check") != -1)
					schermataAccessoFrame.mostraErroreEmailNonValidaRegistrazione();
				if(e.toString().indexOf("utente_email_key") != -1)
					schermataAccessoFrame.mostraErroreEmailGiaInUsoRegistrazione();
				if(e.toString().indexOf("lunghezzapassword") != -1)
					schermataAccessoFrame.mostraErrorePasswordNonValidaRegistrazione();
				
//				e.printStackTrace();
			}
		}
	}
	
	public void invioEmailCodiceVerificaSchermataAccessoReimpostaPassword(String Email) {
		try {
			InvioEmail mail=new InvioEmail();
			
			final String Oggetto = "Placehub - Reimposta password!";
			String Corpo = "<!doctype html>\r\n" + 
					"<html>\r\n" + 
					"	<head>\r\n" + 
					"		<title>PlaceHub</title>\r\n" + 
					"	</head>\r\n" + 
					"	<body>\r\n" + 
					"		<p>\r\n" + 
					"			<center>\r\n" + 
					"				<img src=\"https://i.ibb.co/YdXbkqH/PlaceHub.png\" width=\"480\" height=\"270\" alt=\"Logo\">\r\n" + 
					"			</center>\r\n" + 
					"		</p>\r\n" + 
					"		<p>\r\n" + 
					"			\r\n" + 
					"		</p>\r\n" + 
					"		<p>\r\n" + 
					"			<center>Il tuo codice di verifica: " + utente.reimpostaPassword(Email) + "</center>\r\n" + 
					"		</p>\r\n" + 
					"	</body>\r\n" + 
					"</html>";
			
			mail.inviaEmail(Email, Oggetto, Corpo);
			
			schermataAccessoFrame.mostraPannelloSuccessivoReimpostaPassword1();
		} catch (Exception e) {
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
