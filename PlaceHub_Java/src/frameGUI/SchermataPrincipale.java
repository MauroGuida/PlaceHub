package frameGUI;

import javax.swing.JFrame;
import javax.swing.JPanel;

import gestione.Controller;
import oggettiServizio.Business;
import oggettiServizio.Recensione;
import miscellaneous.ComponentResizer;
import miscellaneousGUI.LocaleGUI;

import javax.swing.BorderFactory;

import java.awt.Color;
import java.awt.Dimension;
import java.awt.Insets;
import java.awt.event.WindowAdapter;
import java.awt.event.WindowEvent;
import java.util.ArrayList;

import javax.swing.GroupLayout;
import javax.swing.GroupLayout.Alignment;

import frameGUI.pannelliSchermataPrincipale.Bottoni;
import frameGUI.pannelliSchermataPrincipale.GestisciBusiness;
import frameGUI.pannelliSchermataPrincipale.PubblicaBusiness1;
import frameGUI.pannelliSchermataPrincipale.PubblicaBusiness2;
import frameGUI.pannelliSchermataPrincipale.PubblicaBusiness3;
import frameGUI.pannelliSchermataPrincipale.Ricerche;
import frameGUI.pannelliSchermataPrincipale.ScriviRecensione;
import frameGUI.pannelliSchermataPrincipale.SideBar;
import frameGUI.pannelliSchermataPrincipale.VerificaPubblicaBusiness;
import frameGUI.pannelliSchermataPrincipale.VisitaBusiness;

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
	private VisitaBusiness pannelloVisitaBusiness;
	
	public SchermataPrincipale(Controller ctrl) {
		this.ctrl = ctrl;
		
		impostazioniFrame();
		generaSideBar();
		generaBottoni();
		

		generaPannelloScriviRecensione(ctrl);
		generapannelloRicerche();
		generaPannelloVerificaPubblicaBusiness(ctrl);
		generaPannelloPubblicaBusiness3(ctrl);
		generaPannelloPubblicaBusiness2(ctrl);
        generaPannelloPubblicaBusiness1(ctrl);
        generaPannelloGestisciBusiness(ctrl);
        generaPannelloVisitaBusiness(ctrl);
        
		GroupLayout groupLayout = new GroupLayout(getContentPane());
		groupLayout.setHorizontalGroup(
			groupLayout.createParallelGroup(Alignment.LEADING)
				.addGroup(groupLayout.createSequentialGroup()
					.addComponent(pannelloSideBar, GroupLayout.PREFERRED_SIZE, GroupLayout.DEFAULT_SIZE, GroupLayout.PREFERRED_SIZE)
					.addGroup(groupLayout.createParallelGroup(Alignment.LEADING)
						.addComponent(pannelloBottoni, GroupLayout.DEFAULT_SIZE, 850, Short.MAX_VALUE)
						.addComponent(pannelloRicerche, GroupLayout.PREFERRED_SIZE, 0, Short.MAX_VALUE)
						.addComponent(pannelloPubblicaBusiness1, GroupLayout.PREFERRED_SIZE, 0, Short.MAX_VALUE)
						.addComponent(pannelloPubblicaBusiness3, GroupLayout.PREFERRED_SIZE, 0, Short.MAX_VALUE)
						.addComponent(pannelloVisitaBusiness, GroupLayout.PREFERRED_SIZE, 0, Short.MAX_VALUE)
						.addComponent(pannelloGestisciBusiness, GroupLayout.PREFERRED_SIZE, 0, Short.MAX_VALUE)
						.addComponent(pannelloVerificaPubblicaBusiness, GroupLayout.PREFERRED_SIZE, 0, Short.MAX_VALUE)
						.addComponent(pannelloScriviRecensione, GroupLayout.PREFERRED_SIZE, 0, Short.MAX_VALUE)
						.addComponent(pannelloPubblicaBusiness2, GroupLayout.DEFAULT_SIZE, GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)))
		);
		groupLayout.setVerticalGroup(
			groupLayout.createParallelGroup(Alignment.LEADING)
				.addComponent(pannelloSideBar, GroupLayout.DEFAULT_SIZE, GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
				.addGroup(groupLayout.createSequentialGroup()
					.addComponent(pannelloBottoni, GroupLayout.PREFERRED_SIZE, 36, GroupLayout.PREFERRED_SIZE)
					.addGroup(groupLayout.createParallelGroup(Alignment.LEADING)
						.addComponent(pannelloRicerche, GroupLayout.PREFERRED_SIZE, 0, Short.MAX_VALUE)
						.addComponent(pannelloPubblicaBusiness1, GroupLayout.PREFERRED_SIZE, 0, Short.MAX_VALUE)
						.addComponent(pannelloPubblicaBusiness3, GroupLayout.PREFERRED_SIZE, 0, Short.MAX_VALUE)
						.addComponent(pannelloVisitaBusiness, GroupLayout.PREFERRED_SIZE, 0, Short.MAX_VALUE)
						.addComponent(pannelloGestisciBusiness, GroupLayout.PREFERRED_SIZE, 0, Short.MAX_VALUE)
						.addComponent(pannelloVerificaPubblicaBusiness, GroupLayout.PREFERRED_SIZE, 0, Short.MAX_VALUE)
						.addComponent(pannelloScriviRecensione, GroupLayout.PREFERRED_SIZE, 0, Short.MAX_VALUE)
						.addComponent(pannelloPubblicaBusiness2, GroupLayout.DEFAULT_SIZE, GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)))
		);
		getContentPane().setLayout(groupLayout);
	}
	
	
	private void impostazioniFrame() {
		setDefaultCloseOperation(JFrame.DO_NOTHING_ON_CLOSE);
		addWindowListener(new WindowAdapter() {
		    @Override
		    public void windowClosing(WindowEvent event) {
		        Controller.chiudiSchermataPrincipale();
		    }
		});
		
		setSize(1300,700);
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
	}


	private void generaPannelloVisitaBusiness(Controller ctrl) {
		pannelloVisitaBusiness = new VisitaBusiness(ctrl);
        pannelloVisitaBusiness.setBounds(250, 36, 850, 614);
	}


	private void generaPannelloGestisciBusiness(Controller ctrl) {
		pannelloGestisciBusiness = new GestisciBusiness(ctrl);
        pannelloGestisciBusiness.setBounds(250, 36, 850, 614);
	}


	private void generaPannelloPubblicaBusiness1(Controller ctrl) {
		pannelloPubblicaBusiness1 = new PubblicaBusiness1(ctrl);
        pannelloPubblicaBusiness1.setBounds(250, 36, 850, 614);
	}


	private void generaPannelloPubblicaBusiness2(Controller ctrl) {
		pannelloPubblicaBusiness2 = new PubblicaBusiness2(ctrl);
		pannelloPubblicaBusiness2.setBounds(250, 36, 850, 614);
	}


	private void generaPannelloPubblicaBusiness3(Controller ctrl) {
		pannelloPubblicaBusiness3 = new PubblicaBusiness3(ctrl);
		pannelloPubblicaBusiness3.setBounds(250, 36, 850, 614);
	}


	private void generaPannelloVerificaPubblicaBusiness(Controller ctrl) {
		pannelloVerificaPubblicaBusiness = new VerificaPubblicaBusiness(ctrl);
		pannelloVerificaPubblicaBusiness.setBounds(250, 36, 850, 614);
	}


	private void generapannelloRicerche() {
		pannelloRicerche = new Ricerche();
		pannelloRicerche.setBounds(250, 36, 850, 614);
	}


	private void generaPannelloScriviRecensione(Controller ctrl) {
		pannelloScriviRecensione = new ScriviRecensione(ctrl);
		pannelloScriviRecensione.setBounds(250, 36, 850, 614);
	}


	private void generaBottoni() {
		pannelloBottoni = new Bottoni();
		pannelloBottoni.setBounds(250, 0, 850, 36);
	}


	private void generaSideBar() {
		pannelloSideBar = new SideBar(ctrl);
		pannelloSideBar.setBounds(0, 0, 250, 650);
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
	        pannelloVisitaBusiness.setVisible(false);
		}
		
		public void mostraGestisciBusiness() {
			nascondiTuttiIPannelli();
			pannelloGestisciBusiness.setVisible(true);
		}
		
		public void mostraRicerche() {
			nascondiTuttiIPannelli();
			pannelloRicerche.setVisible(true);
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
		
		public void mostraVisitaBusiness() {
			nascondiTuttiIPannelli();
			pannelloVisitaBusiness.setVisible(true);
		}
		
	//Gestione pannello ricerche
		public void svuotaRicerche() {
			pannelloRicerche.svuotaRicerche();
		}
		
		public void aggiungiRisultatoRicerca(JPanel risultatoRicerca) {
			pannelloRicerche.addRisultatoRicerca(risultatoRicerca);
		}
		
	//Gestisci Business
		public void aggiungiBusinessGestisciBusiness(LocaleGUI nuovo) {
			pannelloGestisciBusiness.aggiungiBusiness(nuovo);
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
		
		public void mostraErrorePartitaIVAInUsoPubblicaBusiness1() {
			pannelloPubblicaBusiness1.mostraErrorePartitaIVAInUso();
		}
		
		public void aggiungiRegioneAModelloPubblicaBusiness1(String regione) {
			pannelloPubblicaBusiness1.aggiungiRegioneAModello(regione);
		}
		
		public void aggiungiProvinciaAModelloPubblicaBusiness1(String provincia) {
			pannelloPubblicaBusiness1.aggiungiProvinciaAModello(provincia);
		}
		
		public void pulisciModelloProvinciaPubblicaBusiness1() {
			pannelloPubblicaBusiness1.pulisciModelloProvincia();
		}
		
		public void aggiungiComuneAModelloPubblicaBusiness1(String comune) {
			pannelloPubblicaBusiness1.aggiungiComuneAModello(comune);
		}
		
		public void pulisciModelloComunePubblicaBusiness1() {
			pannelloPubblicaBusiness1.pulisciModelloComune();
		}
		
		public void aggiungiCAPAModelloPubblicaBusiness1(String CAP) {
			pannelloPubblicaBusiness1.aggiungiCAPAModello(CAP);
		}
		
		public void pulisciModelloCAPPubblicaBusiness1() {
			pannelloPubblicaBusiness1.pulisciModelloCAP();
		}
		
		public void impostaBusinessPreesistentePubblicaBusiness1(Business locale) {
			pannelloPubblicaBusiness1.impostaBusinessPreesistente(locale);
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
		
		public void impostaBusinessPreesistentePubblicaBusiness2(Business locale) {
			pannelloPubblicaBusiness2.impostaBusinessPreesistente(locale);
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
		
	//Gestione pannello VisitaBusiness
		public void disattivaBottoneRecensioneVisitaBusiness() {
			pannelloVisitaBusiness.disattivaBottoneRecensione();
		}
		
		public void configuraPannelloVisitaBusiness(Business locale, ArrayList<Recensione> recensioni) {
			pannelloVisitaBusiness.configuraPannello(locale, recensioni);
		}
		
	//Gestione pannello ScriviRecensione
		public void mostraErroreRecensioneVuotaScriviRecensione() {
			pannelloScriviRecensione.mostraErroreRecensioneVuota();
		}
		
		public void mostraErroreStelleMancateScriviRecensione() {
			pannelloScriviRecensione.mostraErroreStelleMancate();
		}
		
	//Controllo pannelli visibili
		public boolean pannelloGestisciBusiness_IsVisible() {
			return pannelloGestisciBusiness.isVisible();
		}
		
		
		public boolean pannelloPubblicaBusiness1_IsVisible() {
			return pannelloPubblicaBusiness1.isVisible();
		}
		
		
		public boolean pannelloPubblicaBusiness2_IsVisible() {
			return pannelloPubblicaBusiness2.isVisible();
		}
		
		
		public boolean pannelloPubblicaBusiness3_IsVisible() {
			return pannelloPubblicaBusiness3.isVisible();
		}
		
		
		public boolean pannelloVerificaPubblicaBusiness_IsVisible() {
			return pannelloVerificaPubblicaBusiness.isVisible();
		}
}
