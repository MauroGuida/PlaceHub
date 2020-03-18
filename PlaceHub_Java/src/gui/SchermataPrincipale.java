package gui;

import javax.swing.JFrame;

import gestione.Controller;
import gui.pannelliSchermataAccesso.menuATendina.Alloggi;
import gui.pannelliSchermataAccesso.menuATendina.Attrazioni;
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
import javax.swing.GroupLayout;
import javax.swing.GroupLayout.Alignment;

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
	
	public Alloggi tendinaAlloggi;  //NON DEVE ESSERE PUBLIC
	public Attrazioni tendinaAttrazioni;
	
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

		pannelloBottoni = new Bottoni();
		
		pannelloScriviRecensione = new ScriviRecensione();
		pannelloScriviRecensione.setVisible(false);
		
		pannelloRicerche = new Ricerche();
		pannelloRicerche.setVisible(true);
		
		pannelloPubblicaBusiness3 = new PubblicaBusiness3();
		pannelloPubblicaBusiness3.setVisible(false);
		
		pannelloPubblicaBusiness2 = new PubblicaBusiness2();
		pannelloPubblicaBusiness2.setVisible(false);
        
        pannelloPubblicaBusiness1 = new PubblicaBusiness1();
        pannelloPubblicaBusiness1.setVisible(false);
		
        tendinaAlloggi = new Alloggi();
        tendinaAlloggi.setVisible(false);
        
        tendinaAttrazioni = new Attrazioni();
        tendinaAttrazioni.setVisible(false);
		GroupLayout groupLayout = new GroupLayout(getContentPane());
		groupLayout.setHorizontalGroup(
			groupLayout.createParallelGroup(Alignment.LEADING)
				.addGroup(groupLayout.createSequentialGroup()
					.addComponent(pannelloSideBar, GroupLayout.PREFERRED_SIZE, GroupLayout.DEFAULT_SIZE, GroupLayout.PREFERRED_SIZE)
					.addGroup(groupLayout.createParallelGroup(Alignment.LEADING)
						.addComponent(pannelloBottoni, GroupLayout.DEFAULT_SIZE, 850, Short.MAX_VALUE)
						.addComponent(pannelloPubblicaBusiness2, GroupLayout.DEFAULT_SIZE, 850, Short.MAX_VALUE)
						.addComponent(tendinaAlloggi, GroupLayout.PREFERRED_SIZE, GroupLayout.DEFAULT_SIZE, GroupLayout.PREFERRED_SIZE)
						.addComponent(pannelloPubblicaBusiness3, GroupLayout.DEFAULT_SIZE, 850, Short.MAX_VALUE)
						.addComponent(pannelloScriviRecensione, GroupLayout.DEFAULT_SIZE, 850, Short.MAX_VALUE)
						.addComponent(tendinaAttrazioni, GroupLayout.PREFERRED_SIZE, GroupLayout.DEFAULT_SIZE, GroupLayout.PREFERRED_SIZE)
						.addComponent(pannelloPubblicaBusiness1, GroupLayout.DEFAULT_SIZE, 850, Short.MAX_VALUE)
						.addComponent(pannelloRicerche, GroupLayout.DEFAULT_SIZE, GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)))
		);
		groupLayout.setVerticalGroup(
			groupLayout.createParallelGroup(Alignment.LEADING)
				.addComponent(pannelloSideBar, GroupLayout.DEFAULT_SIZE, GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
				.addGroup(groupLayout.createSequentialGroup()
					.addComponent(pannelloBottoni, GroupLayout.PREFERRED_SIZE, 36, GroupLayout.PREFERRED_SIZE)
					.addGroup(groupLayout.createParallelGroup(Alignment.LEADING)
						.addComponent(pannelloPubblicaBusiness2, GroupLayout.DEFAULT_SIZE, 614, Short.MAX_VALUE)
						.addGroup(groupLayout.createSequentialGroup()
							.addGap(208)
							.addComponent(tendinaAlloggi, GroupLayout.PREFERRED_SIZE, GroupLayout.DEFAULT_SIZE, GroupLayout.PREFERRED_SIZE))
						.addComponent(pannelloPubblicaBusiness3, GroupLayout.DEFAULT_SIZE, GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
						.addComponent(pannelloScriviRecensione, GroupLayout.DEFAULT_SIZE, 614, Short.MAX_VALUE)
						.addGroup(groupLayout.createSequentialGroup()
							.addGap(130)
							.addComponent(tendinaAttrazioni, GroupLayout.PREFERRED_SIZE, 245, GroupLayout.PREFERRED_SIZE))
						.addComponent(pannelloPubblicaBusiness1, GroupLayout.DEFAULT_SIZE, 614, Short.MAX_VALUE)
						.addComponent(pannelloRicerche, GroupLayout.DEFAULT_SIZE, GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)))
		);
		getContentPane().setLayout(groupLayout);
		
		PROVE();
	}

	public void mostraTendinaAlloggi() {
		tendinaAlloggi.setVisible(true);
		tendinaAlloggi.requestFocus();
	}
	
	public void nascondiTendinaAlloggi() {
		tendinaAlloggi.setVisible(false);
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
