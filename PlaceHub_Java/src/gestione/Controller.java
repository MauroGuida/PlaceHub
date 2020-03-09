package gestione;

import java.awt.EventQueue;

import database.Connessione;
import database.UtenteDAO;
import errori.UsernameOPasswordErrati;
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
					connessioneAlDatabase = new Connessione();
					
					schermataAccessoFrame = new SchermataAccesso(ctrl);
					schermataAccessoFrame.setVisible(true);
				} catch (Exception e) {
					e.printStackTrace();
				}
			}
		});
	}
	
	public static Connessione getConnessioneAlDatabase() {
		return connessioneAlDatabase;
	}
	
	public void loginSchermataAccesso(String Username, char[] Password) {
		utente = new UtenteDAO();
		try {
			utente.login(Username, Password);
			
			schermataPrincipaleFrame = new SchermataPrincipale(this);
			schermataPrincipaleFrame.setVisible(true);
			schermataAccessoFrame.dispose();
		} catch (UsernameOPasswordErrati e) {
			System.out.print("Username o Password errata!");
		}
	}

}
