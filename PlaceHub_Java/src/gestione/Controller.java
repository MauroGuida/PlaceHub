package gestione;

import java.awt.EventQueue;
import java.sql.SQLException;

import database.Connessione;
import database.UtenteDAO;
import errori.CampiVuotiException;
import errori.DataDiNascitaNonValidaException;
import errori.EmailNonValidaException;
import errori.PasswordNonValidaException;
import errori.UsernameNonValidoException;
import errori.UsernameOPasswordErratiException;
import gui.SchermataAccesso;
import gui.SchermataPrincipale;

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
		} catch (UsernameOPasswordErratiException e) {
			System.out.print("Username o Password errata!");
			schermataAccessoFrame.mostraErroreUsernamePassword(true);
		}
	}
	
	public void registratiSchermataAccesso(String Username, String Nome, String Cognome, String Email, String DataDiNascita, char[] Password) throws UsernameNonValidoException,
			EmailNonValidaException, DataDiNascitaNonValidaException, PasswordNonValidaException, CampiVuotiException {
		
		if(Username.isBlank() || Username.isEmpty() || Nome.isBlank() || Nome.isEmpty() || Cognome.isBlank() || Cognome.isEmpty() ||
				Email.isBlank() || Email.isEmpty() || DataDiNascita.isBlank() || DataDiNascita.isEmpty() || Password.length==0)
			throw new CampiVuotiException();
		
		try {
			utente.registrati(Username, Nome, Cognome, Email, DataDiNascita, Password);
		} catch (Exception e) {		
			if(e.toString().indexOf("utente_username_key") != -1) {
				throw new UsernameNonValidoException();
			}
		}
	}
	

}
