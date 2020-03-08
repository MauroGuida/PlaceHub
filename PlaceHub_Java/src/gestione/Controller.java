package gestione;

import java.awt.EventQueue;

import gui.SchermataAccesso;

public class Controller {

	//Inizializzazione programma

	public static void main(String[] args) {
		EventQueue.invokeLater(new Runnable() {
			public void run() {
				try {
					Controller ctrl = new Controller();
					SchermataAccesso schermataAccessoFrame = new SchermataAccesso(ctrl);
				} catch (Exception e) {
					e.printStackTrace();
				}
			}
		});
	}
}
