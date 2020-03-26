package gui;

import javax.swing.JFrame;

import gestione.Controller;
import gui.pannelliSchermataPrincipale.Bottoni;
import gui.pannelliSchermataPrincipale.GestisciBusiness;
import gui.pannelliSchermataPrincipale.PubblicaBusiness1;
import gui.pannelliSchermataPrincipale.PubblicaBusiness2;
import gui.pannelliSchermataPrincipale.PubblicaBusiness3;
import gui.pannelliSchermataPrincipale.Ricerche;
import gui.pannelliSchermataPrincipale.ScriviRecensione;
import gui.pannelliSchermataPrincipale.SideBar;
import gui.pannelliSchermataPrincipale.VerificaPubblicaBusiness;
import res.ComponentResizer;

import javax.swing.BorderFactory;

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
	
	private VerificaPubblicaBusiness pannelloVerificaPubblicaBusiness;
	private GestisciBusiness pannelloGestisciBusiness;
	private PubblicaBusiness1 pannelloPubblicaBusiness1;
	private PubblicaBusiness2 pannelloPubblicaBusiness2;
	private PubblicaBusiness3 pannelloPubblicaBusiness3;
	
	public SchermataPrincipale(Controller Ctrl) {
		this.ctrl = Ctrl;
		setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
		setSize(1100,650);
		setMinimumSize(new Dimension(1100,650));
		setLocationRelativeTo(null);
		setUndecorated(true);
		setResizable(true);
		getContentPane().setBackground(Color.WHITE);
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
		
		pannelloRicerche = new Ricerche();
		pannelloRicerche.setBounds(250, 36, 850, 614);
		
		pannelloVerificaPubblicaBusiness = new VerificaPubblicaBusiness(ctrl);
		pannelloVerificaPubblicaBusiness.setBounds(250, 36, 850, 614);

		pannelloPubblicaBusiness3 = new PubblicaBusiness3();
		pannelloPubblicaBusiness3.setBounds(250, 36, 850, 614);
		
		pannelloPubblicaBusiness2 = new PubblicaBusiness2(ctrl);
		pannelloPubblicaBusiness2.setBounds(250, 36, 850, 614);
        
        pannelloPubblicaBusiness1 = new PubblicaBusiness1(ctrl);
        pannelloPubblicaBusiness1.setBounds(250, 36, 850, 614);
        
        pannelloGestisciBusiness = new GestisciBusiness(ctrl);
        pannelloGestisciBusiness.setBounds(250, 36, 850, 614);
		
		getContentPane().setLayout(null);
		getContentPane().add(pannelloSideBar);
		getContentPane().add(pannelloBottoni);
		getContentPane().add(pannelloGestisciBusiness);
		getContentPane().add(pannelloVerificaPubblicaBusiness);
		getContentPane().add(pannelloPubblicaBusiness1);
		getContentPane().add(pannelloPubblicaBusiness2);
		getContentPane().add(pannelloPubblicaBusiness3);
		getContentPane().add(pannelloScriviRecensione);
		getContentPane().add(pannelloRicerche);
	}
	
	
	//METODI

	//Gestione visibilita' pannelli
		private void nascondiTuttiIPannelli() {
			pannelloScriviRecensione.setVisible(false);
			pannelloRicerche.setVisible(false);
			pannelloVerificaPubblicaBusiness.setVisible(false);
			pannelloPubblicaBusiness3.setVisible(false);
			pannelloPubblicaBusiness2.setVisible(false);
	        pannelloPubblicaBusiness1.setVisible(false);
	        pannelloGestisciBusiness.setVisible(false);
		}
		
		public void mostraGestisciBusiness() {
			nascondiTuttiIPannelli();
			pannelloGestisciBusiness.setVisible(true);
		}
		
		private void mostraRicerche() {
			nascondiTuttiIPannelli();
			pannelloRicerche.setVisible(true);
		}
		
		public void mostraHomepage() {
			mostraRicerche();
			ctrl.generaRisultatiHomePage();
		}
		
		public void mostraRistornati() {
			mostraRicerche();
			ctrl.generaRisultatiRistoranti();
		}
		
		public void mostraScriviRecensione() {
			nascondiTuttiIPannelli();
			pannelloScriviRecensione.setVisible(true);
		}
		
		public void mostraVerificaPubblicaBusiness() {
			nascondiTuttiIPannelli();
			pannelloVerificaPubblicaBusiness.setVisible(true);
		}
		
		public void mostraPubblicaBusiness1() {
			nascondiTuttiIPannelli();
			pannelloPubblicaBusiness1.setVisible(true);
		}
		
		public void mostraPubblicaBusiness2() {
			nascondiTuttiIPannelli();
			pannelloPubblicaBusiness2.setVisible(true);
		}
		
		public void mostraPubblicaBusiness3() {
			nascondiTuttiIPannelli();
			pannelloPubblicaBusiness3.setVisible(true);
		}
		
	//Gestione pannello ricerche
		public void svuotaRicerche() {
			pannelloRicerche.svuotaRicerche();
		}
		
		public void addRisultatoRicerca(LocaleGUI risultatoRicerca) {
			pannelloRicerche.addRisultatoRicerca(risultatoRicerca);
		}
		
		
	//Gestione pannello PubblicaBusiness1
		public void mostraErroreCampiVuotiPubblicaBusiness1() {
			pannelloPubblicaBusiness1.mostraErroreCampiVuoti();
		}
		
		public void mostraErroreNumeroDiTelefonoPubblicaBusiness1() {
			pannelloPubblicaBusiness1.mostraErroreNumeroDiTelefono();
		}
		
		public void mostraErroreTipologiaVuotaPubblicaBusiness1() {
			pannelloPubblicaBusiness1.mostraErroreTipologiaVuota();
		}
		
		public void resettaVisibilitaErroriPubblicaBusiness1() {
			pannelloPubblicaBusiness1.resettaVisibilitaErrori();
		}
		
		public void pulisciPannelloPubblicaBusiness1() {
			pannelloPubblicaBusiness1.pulisciPannello();
		}
		
		public void mostraErrorePatternCampiPubblicaBusiness1() {
			pannelloPubblicaBusiness1.mostraErrorePatternCampi();
		}
		
		public void mostraErrorePartitaIVAPubblicaBusiness1() {
			pannelloPubblicaBusiness1.mostraErrorePartitaIVA();
		}
		
	//Gestione pannello PubblicaBusiness2
		public void resettaVisibilitaErroriPubblicaBusiness2() {
			pannelloPubblicaBusiness2.resettaVisibilitaErrori();
		}
		
		public void mostraErroreInserisciDescrizionePubblicaBusiness2() {
			pannelloPubblicaBusiness2.mostraErroreInserisciDescrizione();
		}
		
		public void mostraErroreInserisciImmaginePubblicaBusiness2() {
			pannelloPubblicaBusiness2.mostraErroreInserisciImmagine();
		}
		
		public void pulisciPannelloPubblicaBusiness2() {
			pannelloPubblicaBusiness2.pulisciPannello();
		}
		
		
	//Gestione Pannello VerificaPubblicaBusiness
		public void resettaVisibilitaErroriVerificaPubblicaBusiness() {
			pannelloVerificaPubblicaBusiness.resettaVisibilitaErrori();
		}
		
		public void mostraErroreCodiceVerificaVerificaPubblicaBusiness() {
			pannelloVerificaPubblicaBusiness.mostraErroreCodiceVerifica();
		}
		
		public void mostraErroreEmailVerificaPubblicaBusiness() {
			pannelloVerificaPubblicaBusiness.mostraErroreEmail();
		}
		
		public void mostraEmailInviataVerificaPubblicaBusiness() {
			pannelloVerificaPubblicaBusiness.mostraEmailInviata();
		}
		
		public void disabilitaCaricaDocumentoVerificaPubblicaBusiness() {
			pannelloVerificaPubblicaBusiness.disabilitaCaricaDocumento();
		}
		
		
	//Controllo pannelli visibili
		private boolean pannelloGestisciBusiness_IsVisible() {
			return pannelloGestisciBusiness.isVisible();
		}
		
		
		private boolean pannelloPubblicaBusiness1_IsVisible() {
			return pannelloPubblicaBusiness1.isVisible();
		}
		
		
		private boolean pannelloPubblicaBusiness2_IsVisible() {
			return pannelloPubblicaBusiness2.isVisible();
		}
		
		
		private boolean pannelloPubblicaBusiness3_IsVisible() {
			return pannelloPubblicaBusiness3.isVisible();
		}
		
		
		private boolean pannelloVerificaPubblicaBusiness_IsVisible() {
			return pannelloVerificaPubblicaBusiness.isVisible();
		}
		
		
		public boolean controlloPannelliBusinessVisibili() {
			if(pannelloGestisciBusiness_IsVisible() || pannelloPubblicaBusiness1_IsVisible() || 
			   pannelloPubblicaBusiness2_IsVisible() || pannelloPubblicaBusiness3_IsVisible() ||
			   pannelloVerificaPubblicaBusiness_IsVisible())
				return true;
				
			return false;
		}
}
