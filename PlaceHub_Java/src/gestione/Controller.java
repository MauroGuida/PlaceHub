package gestione;

import java.awt.EventQueue;

import gui.SchermataAccesso;

public class Controller {

	private static SchermataAccesso schermataAccessoFrame;
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
}
