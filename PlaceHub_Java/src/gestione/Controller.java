package gestione;

import java.awt.EventQueue;

import gui.SchermataAccesso;
import gui.SchermataPrincipale;

public class Controller {

	private static SchermataAccesso schermataAccessoFrame;
	private static SchermataPrincipale schermataPrincipaleFrame;
	//Inizializzazione programma

	public static void main(String[] args) {
		EventQueue.invokeLater(new Runnable() {
			public void run() {
				try {
					Controller ctrl = new Controller();
					schermataAccessoFrame = new SchermataAccesso(ctrl);
					//schermataAccessoFrame.setVisible(true);
					
					schermataPrincipaleFrame = new SchermataPrincipale(ctrl);
					schermataPrincipaleFrame.setVisible(true);
				} catch (Exception e) {
					e.printStackTrace();
				}
			}
		});
	}
	
}
