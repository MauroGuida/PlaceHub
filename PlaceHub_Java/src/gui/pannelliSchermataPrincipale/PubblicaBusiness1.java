package gui.pannelliSchermataPrincipale;

import java.awt.Color;
import java.awt.Font;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.awt.event.MouseAdapter;
import java.awt.event.MouseEvent;

import javax.swing.ImageIcon;
import javax.swing.JButton;
import javax.swing.JLabel;
import javax.swing.JPanel;
import javax.swing.JTextField;
import javax.swing.border.LineBorder;

import gestione.Controller;
import gui.SchermataPrincipale;
import javax.swing.SwingConstants;

public class PubblicaBusiness1 extends JPanel {

	private static final long serialVersionUID = 1L;
	
	private JLabel testoNomeBusiness;
	private JLabel testoTelefono;
	private JLabel testoIndirizzo;
	private JLabel testoPartitaIva;
	private JTextField textFieldNomeBusiness;
	private JTextField textFieldTelefono;
	private JTextField textFieldIndirizzo;
	private JTextField textFieldPartitaIVA;
	private JLabel lineaTestoNomeBusiness;
	private JLabel lineaTestoTelefono;
	private JLabel lineaTestoIndirizzo;
	private JLabel lineaTestoPartitaIVA ;
	private JLabel testoSelezionaOpzione;
	private JButton bottoneRistorante;
	private JButton bottoneAttrazioni;
	private JButton bottoneAlloggio;
	private JButton bottoneAvanti;
	int flagFocusBottoneGestisciBusiness1;
	private gui.pannelliSchermataPrincipale.raffinazioni.pannelloRaffinazioniRistorante pannelloRaffRistorante;
	private gui.pannelliSchermataPrincipale.raffinazioni.pannelloRaffinazioneAlloggi pannelloRaffAlloggi;
	private gui.pannelliSchermataPrincipale.raffinazioni.pannelloRaffinazioneAttrazioni pannelloRaffAttrazioni;
	
	private JLabel testoErrori;
	
	private Controller ctrl;
	private JLabel testoErroreTipologiaVuota;
	
	public PubblicaBusiness1(Controller ctrl) {
		
		this.ctrl = ctrl;
		setLayout(null);
		setSize(850, 614);
		setVisible(false);
		setBackground(Color.WHITE);
		
		generaCampoNomeBusiness();
		generaCampoTelefono();
		generaCampoIndirizzo();
		generaCampoPartitaIVA();
		
		generaTestoSelezionaOpzione();
		
		generaTestoSelezionaOpzione();
		generaBottoneRistorante();		
		generaBottoneIntrattenimento();
		generaBottoneAlloggio();
		
		generaBottoneAvanti();
		
		generaPannelloRaffRistorante();
		generaRaffinazioniAlloggio();
		generaRaffinazioniAttrazione();
		
		generaTestoErroreCampiVuoti();
		
		generaTestoErroreTipologiaVuota();
	}


	private void generaTestoErroreTipologiaVuota() {
		testoErroreTipologiaVuota = new JLabel("Seleziona una tipologia");
		testoErroreTipologiaVuota.setHorizontalAlignment(SwingConstants.CENTER);
		testoErroreTipologiaVuota.setForeground(Color.RED);
		testoErroreTipologiaVuota.setFont(new Font("Roboto", Font.PLAIN, 16));
		testoErroreTipologiaVuota.setBounds(100, 555, 506, 19);
		testoErroreTipologiaVuota.setVisible(false);
		add(testoErroreTipologiaVuota);
	}


	private void generaTestoErroreCampiVuoti() {
		testoErrori = new JLabel("Non possono esserci campi vuoti");
		testoErrori.setHorizontalAlignment(SwingConstants.CENTER);
		testoErrori.setForeground(Color.RED);
		testoErrori.setFont(new Font("Roboto", Font.PLAIN, 16));
		testoErrori.setBounds(53, 205, 675, 19);
		testoErrori.setVisible(false);
		add(testoErrori);
	}


	private void generaRaffinazioniAttrazione() {
		pannelloRaffAttrazioni = new gui.pannelliSchermataPrincipale.raffinazioni.pannelloRaffinazioneAttrazioni();
		pannelloRaffAttrazioni.setLocation(100, 440);
		pannelloRaffAttrazioni.setVisible(false);
		add(pannelloRaffAttrazioni);
	}


	private void generaRaffinazioniAlloggio() {
		pannelloRaffAlloggi = new gui.pannelliSchermataPrincipale.raffinazioni.pannelloRaffinazioneAlloggi();
		pannelloRaffAlloggi.setLocation(100, 440);
		pannelloRaffAlloggi.setVisible(false);
		add(pannelloRaffAlloggi);
	}


	private void generaPannelloRaffRistorante() {
		pannelloRaffRistorante = new gui.pannelliSchermataPrincipale.raffinazioni.pannelloRaffinazioniRistorante();
		pannelloRaffRistorante.setLocation(100, 440);
		pannelloRaffRistorante.setVisible(false);
		add(pannelloRaffRistorante);
	}


	private void generaBottoneAvanti() {
		bottoneAvanti = new JButton("");

		bottoneAvanti.setBounds(668, 537, 140, 50);
		bottoneAvanti.setIcon(new ImageIcon(SchermataPrincipale.class.getResource("/Icone/AvantiButton.png")));
		bottoneAvanti.setOpaque(false);
		bottoneAvanti.setContentAreaFilled(false);
		bottoneAvanti.setBorderPainted(false);
		bottoneAvanti.addMouseListener(new MouseAdapter() {
			@Override
			public void mouseEntered(MouseEvent e) {
				bottoneAvanti.setIcon(new ImageIcon(SchermataPrincipale.class.getResource("/Icone/AvantiButtonFocus.png")));
			}
			@Override
			public void mouseExited(MouseEvent e) {
				bottoneAvanti.setIcon(new ImageIcon(SchermataPrincipale.class.getResource("/Icone/AvantiButton.png")));
			}
		});
		bottoneAvanti.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent arg0) {
				ctrl.procediInPubblicaBusiness2(textFieldNomeBusiness.getText(),
												textFieldIndirizzo.getText(),
												textFieldTelefono.getText(),
												textFieldPartitaIVA.getText(),
												checkTipoBusiness());
				
			}
		});
		add(bottoneAvanti);
	}


	private void generaBottoneAlloggio() {
		bottoneAlloggio = new JButton("");
		bottoneAlloggio.setBounds(572, 300, 209, 110);
		bottoneAlloggio.setIcon(new ImageIcon(SchermataPrincipale.class.getResource("/Icone/bottoneAlloggio.png")));
		bottoneAlloggio.setOpaque(false);
		bottoneAlloggio.setContentAreaFilled(false);
		bottoneAlloggio.setBorderPainted(false);
		bottoneAlloggio.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent arg0) {
				flagFocusBottoneGestisciBusiness1 = 3;
				resettaIconeGestisciBusiness1(flagFocusBottoneGestisciBusiness1);
				cambiaIconeGestisciBusiness1(flagFocusBottoneGestisciBusiness1);
				
				mostraRaffinazioni(3);
			}
		});
		bottoneAlloggio.addMouseListener(new MouseAdapter() {
			@Override
			public void mouseEntered(MouseEvent e) {
				bottoneAlloggio.setIcon(new ImageIcon(SchermataPrincipale.class.getResource("/Icone/bottoneAlloggioFocus.png")));
			}
			@Override
			public void mouseExited(MouseEvent e) {
				if(flagFocusBottoneGestisciBusiness1 != 3)
					bottoneAlloggio.setIcon(new ImageIcon(SchermataPrincipale.class.getResource("/Icone/bottoneAlloggio.png")));
			}
		});
		add(bottoneAlloggio);
	}


	private void generaBottoneIntrattenimento() {
		bottoneAttrazioni = new JButton("");
		bottoneAttrazioni.setBounds(320, 300, 208, 110);
		bottoneAttrazioni.setIcon(new ImageIcon(SchermataPrincipale.class.getResource("/Icone/bottoneIntrattenimento.png")));
		bottoneAttrazioni.setOpaque(false);
		bottoneAttrazioni.setContentAreaFilled(false);
		bottoneAttrazioni.setBorderPainted(false);
		bottoneAttrazioni.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent arg0) {
				flagFocusBottoneGestisciBusiness1 = 2;
				resettaIconeGestisciBusiness1(flagFocusBottoneGestisciBusiness1);
				cambiaIconeGestisciBusiness1(flagFocusBottoneGestisciBusiness1);
				
				mostraRaffinazioni(2);
			}
		});
		bottoneAttrazioni.addMouseListener(new MouseAdapter() {
			@Override
			public void mouseEntered(MouseEvent e) {
				bottoneAttrazioni.setIcon(new ImageIcon(SchermataPrincipale.class.getResource("/Icone/bottoneIntrattenimentoFocus.png")));
			}
			@Override
			public void mouseExited(MouseEvent e) {
				if(flagFocusBottoneGestisciBusiness1 != 2)
					bottoneAttrazioni.setIcon(new ImageIcon(SchermataPrincipale.class.getResource("/Icone/bottoneIntrattenimento.png")));
			}
		});
		add(bottoneAttrazioni);
	}


	private void generaBottoneRistorante() {
		bottoneRistorante = new JButton("");
		bottoneRistorante.setBounds(68, 300, 208, 110);
		bottoneRistorante.setIcon(new ImageIcon(SchermataPrincipale.class.getResource("/Icone/bottoneRistorante.png")));
		bottoneRistorante.setOpaque(false);
		bottoneRistorante.setContentAreaFilled(false);
		bottoneRistorante.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent arg0) {
				flagFocusBottoneGestisciBusiness1 = 1;
				resettaIconeGestisciBusiness1(flagFocusBottoneGestisciBusiness1);
				cambiaIconeGestisciBusiness1(flagFocusBottoneGestisciBusiness1);
				mostraRaffinazioni(1);
			}
		});
		bottoneRistorante.addMouseListener(new MouseAdapter() {
			@Override
			public void mouseEntered(MouseEvent e) {
				bottoneRistorante.setIcon(new ImageIcon(SchermataPrincipale.class.getResource("/Icone/bottoneRistoranteFocus.png")));
			}
			@Override
			public void mouseExited(MouseEvent e) {
				if(flagFocusBottoneGestisciBusiness1 != 1)
					bottoneRistorante.setIcon(new ImageIcon(SchermataPrincipale.class.getResource("/Icone/bottoneRistorante.png")));
			}
		});
		bottoneRistorante.setBorderPainted(false);
		add(bottoneRistorante);
	}
	
	
	private void generaTestoSelezionaOpzione() {
		testoSelezionaOpzione = new JLabel("Seleziona una opzione");
		testoSelezionaOpzione.setBounds(53, 240, 257, 23);
		testoSelezionaOpzione.setFont(new Font("Roboto", Font.PLAIN, 20));
		add(testoSelezionaOpzione);
	}

	private void generaCampoPartitaIVA() {
		testoPartitaIva = new JLabel("Partita IVA");
		testoPartitaIva.setFont(new Font("Roboto", Font.PLAIN, 20));
		testoPartitaIva.setBounds(446, 120, 282, 19);
		add(testoPartitaIva);
		
		textFieldPartitaIVA = new JTextField();
		textFieldPartitaIVA.setFont(new Font("Roboto", Font.PLAIN, 17));
		textFieldPartitaIVA.setBackground(new Color(255,255,255));
		textFieldPartitaIVA.setBorder(new LineBorder(new Color(255,255,255),1));
		textFieldPartitaIVA.setColumns(10);
		textFieldPartitaIVA.setBounds(446, 148, 287, 32);
		add(textFieldPartitaIVA);
		
		lineaTestoPartitaIVA = new JLabel("");
		lineaTestoPartitaIVA.setBounds(446, 181, 287, 1);
		lineaTestoPartitaIVA.setIcon(new ImageIcon(PubblicaBusiness1.class.getResource("/Icone/lineaGestisciAttivita.png")));
		add(lineaTestoPartitaIVA);
	}


	private void generaCampoIndirizzo() {
		testoIndirizzo = new JLabel("Indirizzo");
		testoIndirizzo.setFont(new Font("Roboto", Font.PLAIN, 20));
		testoIndirizzo.setBounds(446, 30, 282, 19);
		add(testoIndirizzo);
		
		textFieldIndirizzo = new JTextField();
		textFieldIndirizzo.setFont(new Font("Roboto", Font.PLAIN, 17));
		textFieldIndirizzo.setBackground(new Color(255,255,255));
		textFieldIndirizzo.setBorder(new LineBorder(new Color(255,255,255),1));
		textFieldIndirizzo.setColumns(10);
		textFieldIndirizzo.setBounds(446, 58, 287, 32);
		add(textFieldIndirizzo);
		
		lineaTestoIndirizzo = new JLabel("");
		lineaTestoIndirizzo.setBounds(446, 91, 287, 1);
		lineaTestoIndirizzo.setIcon(new ImageIcon(SchermataPrincipale.class.getResource("/Icone/lineaGestisciAttivita.png")));
		add(lineaTestoIndirizzo);
	}


	private void generaCampoTelefono() {
		testoTelefono = new JLabel("Telefono");
		testoTelefono.setFont(new Font("Roboto", Font.PLAIN, 20));
		testoTelefono.setBounds(53, 120, 257, 19);
		add(testoTelefono);
		
		textFieldTelefono = new JTextField();
		textFieldTelefono.setFont(new Font("Roboto", Font.PLAIN, 17));
		textFieldTelefono.setBackground(new Color(255,255,255));
		textFieldTelefono.setBorder(new LineBorder(new Color(255,255,255),1));
		textFieldTelefono.setColumns(10);
		textFieldTelefono.setBounds(53, 148, 262, 32);
		add(textFieldTelefono);
		
		lineaTestoTelefono = new JLabel("");
		lineaTestoTelefono.setBounds(53, 181, 262, 1);
		lineaTestoTelefono.setIcon(new ImageIcon(SchermataPrincipale.class.getResource("/Icone/lineaGestisciAttivita.png")));
		add(lineaTestoTelefono);
	}


	private void generaCampoNomeBusiness() {
		testoNomeBusiness = new JLabel("Nome Business");
		testoNomeBusiness.setFont(new Font("Roboto", Font.PLAIN, 20));
		testoNomeBusiness.setBounds(53, 30, 257, 19);
		add(testoNomeBusiness);
		
		textFieldNomeBusiness = new JTextField();
		textFieldNomeBusiness.setFont(new Font("Roboto", Font.PLAIN, 17));
		textFieldNomeBusiness.setBackground(new Color(255,255,255));
		textFieldNomeBusiness.setBorder(new LineBorder(new Color(255,255,255),1));
		textFieldNomeBusiness.setColumns(10);
		textFieldNomeBusiness.setBounds(53, 58, 262, 32);
		add(textFieldNomeBusiness);
		
		lineaTestoNomeBusiness = new JLabel("");
		lineaTestoNomeBusiness.setBounds(53, 91, 262, 1);
		lineaTestoNomeBusiness.setIcon(new ImageIcon(SchermataPrincipale.class.getResource("/Icone/lineaGestisciAttivita.png")));
		add(lineaTestoNomeBusiness);
	}
	
	
	//METODI
	
	
	public void pulisciPannello() {
		textFieldNomeBusiness.setText("");
		textFieldIndirizzo.setText("");
		textFieldTelefono.setText("");
		textFieldPartitaIVA.setText("");
		bottoneRistorante.setSelected(false);
		bottoneAttrazioni.setSelected(false);
		bottoneAlloggio.setSelected(false);
		pannelloRaffRistorante.rimuoviTutteLeSpunte();
		pannelloRaffAttrazioni.rimuoviTutteLeSpunte();
		pannelloRaffAlloggi.rimuoviTutteLeSpunte();
	}
	
	private void cambiaIconeGestisciBusiness1(int flag) {
		switch(flag) {
			case 1:
				bottoneRistorante.setIcon(new ImageIcon(SchermataPrincipale.class.getResource("/Icone/bottoneRistoranteFocus.png")));
				break;
			case 2:
				bottoneAttrazioni.setIcon(new ImageIcon(SchermataPrincipale.class.getResource("/Icone/bottoneIntrattenimentoFocus.png")));
				break;
			case 3:
				bottoneAlloggio.setIcon(new ImageIcon(SchermataPrincipale.class.getResource("/Icone/bottoneAlloggioFocus.png")));
				break;
		}
	}
	
	
	private void resettaIconeGestisciBusiness1(int flag) {
		bottoneRistorante.setIcon(new ImageIcon(SchermataPrincipale.class.getResource("/Icone/bottoneRistorante.png")));
		bottoneAlloggio.setIcon(new ImageIcon(SchermataPrincipale.class.getResource("/Icone/bottoneAlloggio.png")));
		bottoneAttrazioni.setIcon(new ImageIcon(SchermataPrincipale.class.getResource("/Icone/bottoneIntrattenimento.png")));
	}
	
	
	private void mostraRaffinazioni(int flagRaffinazione) {
		switch(flagRaffinazione) {
			case 1:
				pannelloRaffRistorante.setVisible(true);
				pannelloRaffAttrazioni.setVisible(false);
				pannelloRaffAlloggi.setVisible(false);
				break;
			
			case 2:
				pannelloRaffAttrazioni.setVisible(true);
				pannelloRaffRistorante.setVisible(false);
				pannelloRaffAlloggi.setVisible(false);
				break;
			
			case 3:
				pannelloRaffAlloggi.setVisible(true);
				pannelloRaffAttrazioni.setVisible(false);
				pannelloRaffRistorante.setVisible(false);
				break;
		}
	}
	
	
	private int checkTipoBusiness() {
		if(pannelloRaffRistorante.isVisible()) {
			return 1;
		}else if (pannelloRaffAttrazioni.isVisible()) {
			return 2;
		}else if (pannelloRaffAlloggi.isVisible()) {
			return 3;
		}
		return 0;
	}
	
	
	public void mostraErroreCampiVuoti() {
		testoErrori.setText("Non possono esserci campi vuoti");
		testoErrori.setVisible(true);
	}
	
	public void mostraErroreTipologiaVuota() {
		testoErroreTipologiaVuota.setText("Seleziona una tipologia");
		testoErroreTipologiaVuota.setVisible(true);
	}
		
	public void resettaVisibilitaErrori() {
		testoErrori.setVisible(false);
		testoErroreTipologiaVuota.setVisible(false);
	}
}
