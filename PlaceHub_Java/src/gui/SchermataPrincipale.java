package gui;

import javax.swing.JFrame;

import gestione.Controller;
import gui.pannelliSchermataPrincipale.Bottoni;
import gui.pannelliSchermataPrincipale.PubblicaBusiness1;
import gui.pannelliSchermataPrincipale.PubblicaBusiness2;
import gui.pannelliSchermataPrincipale.PubblicaBusiness3;
import gui.pannelliSchermataPrincipale.Ricerche;
import gui.pannelliSchermataPrincipale.ScriviRecensione;
import gui.pannelliSchermataPrincipale.SideBar;
import res.ComponentResizer;

import javax.swing.BorderFactory;
import errori.NumeroStelleNonValidoException;

import java.awt.Color;
import java.awt.Dimension;
import java.awt.Insets;

public class SchermataPrincipale extends JFrame {
	private static final long serialVersionUID = 1L;
	
	private Controller ctrl;
	
	private Bottoni pannelloBottoni;
	private SideBar pannelloSideBar;
	private ScriviRecensione pannelloScriviRecensione;
	private Ricerche pannelloRicerche;
	private PubblicaBusiness1 pannelloPubblicaBusiness1;
	private PubblicaBusiness2 pannelloPubblicaBusiness2;
	private PubblicaBusiness3 pannelloPubblicaBusiness3;
	
	public SchermataPrincipale(Controller Ctrl) {
		this.ctrl = Ctrl;
		setBackground(Color.WHITE);
		setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
		setSize(1100,650);
		setMinimumSize(new Dimension(1100,650));
		setLocationRelativeTo(null);
		setUndecorated(true);
		setResizable(true);
		getRootPane().setBorder(BorderFactory.createMatteBorder(3, 3, 3, 3, new Color(51,51,51)));
		
		ComponentResizer componentResizer = new ComponentResizer();
		componentResizer.registerComponent(this);
		componentResizer.setSnapSize(new Dimension(5,5));
		componentResizer.setDragInsets(new Insets(5, 5, 5, 5));
		
		pannelloSideBar = new SideBar();
		pannelloSideBar.setBounds(0, 0, 250, 650);

		pannelloBottoni = new Bottoni();
		pannelloBottoni.setBounds(250, 0, 850, 36);
		
		pannelloScriviRecensione = new ScriviRecensione();
		pannelloScriviRecensione.setBounds(250, 36, 850, 614);
		pannelloScriviRecensione.setVisible(false);
		
		pannelloRicerche = new Ricerche();
		pannelloRicerche.setBounds(250, 36, 850, 614);
		pannelloRicerche.setVisible(true);
		
		pannelloPubblicaBusiness3 = new PubblicaBusiness3();
		pannelloPubblicaBusiness3.setBounds(250, 36, 850, 614);
		pannelloPubblicaBusiness3.setVisible(false);
		
		pannelloPubblicaBusiness2 = new PubblicaBusiness2();
		pannelloPubblicaBusiness2.setBounds(250, 36, 850, 614);
		pannelloPubblicaBusiness2.setVisible(false);
        
        pannelloPubblicaBusiness1 = new PubblicaBusiness1();
        pannelloPubblicaBusiness1.setBounds(250, 36, 850, 614);
        pannelloPubblicaBusiness1.setVisible(false);
		
		getContentPane().setLayout(null);
		getContentPane().add(pannelloSideBar);
		getContentPane().add(pannelloBottoni);
		getContentPane().add(pannelloPubblicaBusiness2);
		getContentPane().add(pannelloPubblicaBusiness3);
		getContentPane().add(pannelloScriviRecensione);
		getContentPane().add(pannelloPubblicaBusiness1);
		getContentPane().add(pannelloRicerche);
		
		PROVE();
	}

	private void PROVE() {
		try {
			for(int i=0; i<10; i++)
				pannelloRicerche.addRisultatoRicerca("dio", "dio",
						"https://www.lalucedimaria.it/wp-content/uploads/2018/10/Ges%C3%B9-MIsericordioso-1-e1569917989814.jpg");
		} catch (NumeroStelleNonValidoException e1) {
			// TODO Auto-generated catch block
			e1.printStackTrace();
		}
	}
}
