package gui.pannelliSchermataPrincipale;

import java.awt.Color;
import java.awt.Font;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.awt.event.MouseAdapter;
import java.awt.event.MouseEvent;

import javax.swing.DefaultComboBoxModel;
import javax.swing.ImageIcon;
import javax.swing.JButton;
import javax.swing.JLabel;
import javax.swing.JPanel;
import javax.swing.JTextField;
import javax.swing.border.LineBorder;

import gestione.Controller;
import gui.SchermataPrincipale;
import javax.swing.SwingConstants;
import java.awt.event.KeyAdapter;
import java.awt.event.KeyEvent;
import java.awt.event.ComponentAdapter;
import java.awt.event.ComponentEvent;
import javax.swing.JComboBox;
import java.awt.event.ItemListener;
import java.awt.event.ItemEvent;
import javax.swing.ComboBoxModel;

public class PubblicaBusiness1 extends JPanel {

	private static final long serialVersionUID = 1L;
	
	private JLabel testoNomeBusiness;
	private JLabel testoTelefono;
	private JLabel testoIndirizzo;
	private JLabel testoPartitaIva;
	private JLabel testoRegione;
	private JLabel testoProvincia;
	private JLabel testoComune;
	private JLabel testoCAP;
	private JTextField textFieldNomeBusiness;
	private JTextField textFieldTelefono;
	private JTextField textFieldIndirizzo;
	private JTextField textFieldPartitaIVA;
	private JLabel lineaTestoNomeBusiness;
	private JLabel lineaTestoTelefono;
	private JLabel lineaTestoIndirizzo;
	private JLabel lineaTestoPartitaIVA ;
	private JLabel testoSelezionaOpzione;
	private JComboBox<String> comboBoxProvincia;
	private JComboBox<String> comboBoxRegione;
	private JComboBox<String> comboBoxComune;
	private JComboBox<String> comboBoxCAP;
	private DefaultComboBoxModel<String> modelloComboBoxProvincia;
	private DefaultComboBoxModel<String> modelloComboBoxRegione;
	private DefaultComboBoxModel<String> modelloComboBoxComune;
	private DefaultComboBoxModel<String> modelloComboBoxCAP;
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
		addComponentListener(new ComponentAdapter() {
			@Override
			public void componentHidden(ComponentEvent e) {
				pulisciPannello();
				ctrl.aggiungiRegioneAModelloComboBoxPubblicaBusiness1();
			}
		});
		
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
		
		generaCampoRegione();	
		generaCampoProvincia();	
		generaCampoComune();
		generaCampoCAP();
		
		generaBottoneAvanti();
		
		generaPannelloRaffRistorante();
		generaRaffinazioniAlloggio();
		generaRaffinazioniAttrazione();
		
		generaTestoErroreCampiVuoti();
		
		generaTestoErroreTipologiaVuota();
	}


	private void generaCampoCAP() {
		testoCAP = new JLabel("CAP");
		testoCAP.setFont(new Font("Roboto", Font.PLAIN, 20));
		testoCAP.setBounds(610, 200, 170, 19);
		add(testoCAP);
		
		modelloComboBoxCAP = new DefaultComboBoxModel<String>();
	    comboBoxCAP = new JComboBox<String>(modelloComboBoxCAP);
		comboBoxCAP.setBackground(Color.WHITE);
		comboBoxCAP.setFont(new Font("Roboto", Font.PLAIN, 17));
		comboBoxCAP.setBounds(610, 228, 170, 35);
		add(comboBoxCAP);
	}


	private void generaCampoComune() {
		testoComune = new JLabel("Comune");
		testoComune.setFont(new Font("Roboto", Font.PLAIN, 20));
		testoComune.setBounds(395, 200, 170, 19);
		add(testoComune);
		
		modelloComboBoxComune = new DefaultComboBoxModel<String>(); 
		comboBoxComune = new JComboBox<String>(modelloComboBoxComune);
		comboBoxComune.setBackground(Color.WHITE);
		comboBoxComune.setFont(new Font("Roboto", Font.PLAIN, 17));
		comboBoxComune.setBounds(395, 228, 170, 35);
		add(comboBoxComune);
	}


	private void generaCampoProvincia() {
		testoProvincia = new JLabel("Provincia");
		testoProvincia.setFont(new Font("Roboto", Font.PLAIN, 20));
		testoProvincia.setBounds(270, 200, 90, 19);
		add(testoProvincia);
		
		modelloComboBoxProvincia = new DefaultComboBoxModel<String>();
		comboBoxProvincia = new JComboBox<String>(modelloComboBoxProvincia);
		comboBoxProvincia.setBounds(270, 228, 81, 35);
		comboBoxProvincia.setBackground(Color.WHITE);
		comboBoxProvincia.setFont(new Font("Roboto", Font.PLAIN, 17));
		add(comboBoxProvincia);
	}

	private void generaCampoRegione() {
		testoRegione = new JLabel("Regione");
		testoRegione.setFont(new Font("Roboto", Font.PLAIN, 20));
		testoRegione.setBounds(53, 200, 170, 19);
		add(testoRegione);
		
		modelloComboBoxRegione = new DefaultComboBoxModel<String>();
		comboBoxRegione = new JComboBox<String>(modelloComboBoxRegione);
		comboBoxRegione.addItemListener(new ItemListener() {
			public void itemStateChanged(ItemEvent e) {
				int selezione = e.getStateChange();
				if(selezione == ItemEvent.SELECTED) {
					ctrl.aggiungiProvinciaAModelloComboBoxPubblicaBusiness1(modelloComboBoxRegione.getSelectedItem().toString());
				}
			}
		});
		comboBoxRegione.setBackground(Color.WHITE);
		comboBoxRegione.setFont(new Font("Roboto", Font.PLAIN, 17));
		comboBoxRegione.setBounds(52, 228, 170, 35);
		add(comboBoxRegione);
	}


	private void generaTestoErroreTipologiaVuota() {
		testoErroreTipologiaVuota = new JLabel("Seleziona una tipologia");
		testoErroreTipologiaVuota.setHorizontalAlignment(SwingConstants.CENTER);
		testoErroreTipologiaVuota.setForeground(Color.RED);
		testoErroreTipologiaVuota.setFont(new Font("Roboto", Font.PLAIN, 16));
		testoErroreTipologiaVuota.setBounds(100, 580, 506, 19);
		testoErroreTipologiaVuota.setVisible(false);
		add(testoErroreTipologiaVuota);
	}


	private void generaTestoErroreCampiVuoti() {
		testoErrori = new JLabel("ERRORI");
		testoErrori.setHorizontalAlignment(SwingConstants.CENTER);
		testoErrori.setForeground(Color.RED);
		testoErrori.setFont(new Font("Roboto", Font.PLAIN, 16));
		testoErrori.setBounds(400, 290, 381, 19);
		testoErrori.setVisible(false);
		add(testoErrori);
	}


	private void generaRaffinazioniAttrazione() {
		pannelloRaffAttrazioni = new gui.pannelliSchermataPrincipale.raffinazioni.pannelloRaffinazioneAttrazioni();
		pannelloRaffAttrazioni.setLocation(100, 470);
		pannelloRaffAttrazioni.setVisible(false);
		add(pannelloRaffAttrazioni);
	}


	private void generaRaffinazioniAlloggio() {
		pannelloRaffAlloggi = new gui.pannelliSchermataPrincipale.raffinazioni.pannelloRaffinazioneAlloggi();
		pannelloRaffAlloggi.setLocation(100, 470);
		pannelloRaffAlloggi.setVisible(false);
		add(pannelloRaffAlloggi);
	}


	private void generaPannelloRaffRistorante() {
		pannelloRaffRistorante = new gui.pannelliSchermataPrincipale.raffinazioni.pannelloRaffinazioniRistorante();
		pannelloRaffRistorante.setLocation(100, 465);
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
												checkTipoBusiness(),
												prendiRaffinazioni());
			}
		});
		add(bottoneAvanti);
	}


	private void generaBottoneAlloggio() {
		bottoneAlloggio = new JButton("");
		bottoneAlloggio.setBounds(577, 340, 209, 110);
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
		bottoneAttrazioni.setBounds(315, 340, 208, 110);
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
		bottoneRistorante.setBounds(53, 340, 208, 110);
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
		testoSelezionaOpzione.setBounds(53, 290, 257, 23);
		testoSelezionaOpzione.setFont(new Font("Roboto", Font.PLAIN, 20));
		add(testoSelezionaOpzione);
	}

	private void generaCampoPartitaIVA() {
		testoPartitaIva = new JLabel("Partita IVA");
		testoPartitaIva.setFont(new Font("Roboto", Font.PLAIN, 20));
		testoPartitaIva.setBounds(446, 110, 282, 19);
		add(testoPartitaIva);
		
		textFieldPartitaIVA = new JTextField();
		textFieldPartitaIVA.setFont(new Font("Roboto", Font.PLAIN, 17));
		textFieldPartitaIVA.setBackground(new Color(255,255,255));
		textFieldPartitaIVA.setBorder(new LineBorder(new Color(255,255,255),1));
		textFieldPartitaIVA.setColumns(10);
		textFieldPartitaIVA.setBounds(446, 138, 287, 32);
		textFieldPartitaIVA.addKeyListener(new KeyAdapter() {
			@Override
			public void keyPressed(KeyEvent e) {
				if((((e.getKeyChar() >= '0' && e.getKeyChar() <= '9') || (e.getKeyChar() >= 'A' && e.getKeyChar() <= 'Z') || (e.getKeyChar() >= 'a' && e.getKeyChar() <= 'z'))
						&& textFieldPartitaIVA.getText().length() <= 10) || e.getKeyCode() ==  KeyEvent.VK_BACK_SPACE ||
						e.getKeyCode() ==  KeyEvent.VK_DELETE)
					textFieldPartitaIVA.setEditable(true);
				else
					textFieldPartitaIVA.setEditable(false);
			}
		});
		add(textFieldPartitaIVA);
		
		lineaTestoPartitaIVA = new JLabel("");
		lineaTestoPartitaIVA.setBounds(446, 171, 287, 1);
		lineaTestoPartitaIVA.setIcon(new ImageIcon(PubblicaBusiness1.class.getResource("/Icone/lineaGestisciAttivita.png")));
		add(lineaTestoPartitaIVA);
	}


	private void generaCampoIndirizzo() {
		testoIndirizzo = new JLabel("Indirizzo");
		testoIndirizzo.setFont(new Font("Roboto", Font.PLAIN, 20));
		testoIndirizzo.setBounds(446, 20, 282, 19);
		add(testoIndirizzo);
		
		textFieldIndirizzo = new JTextField();
		textFieldIndirizzo.addKeyListener(new KeyAdapter() {
			@Override
			public void keyPressed(KeyEvent e) {
				if((((e.getKeyChar() >= '0' && e.getKeyChar() <= '9') || (e.getKeyChar() >= 'a' && e.getKeyChar() <= 'z') || (e.getKeyChar() >= 'A' && e.getKeyChar() <= 'Z'))
						&& textFieldIndirizzo.getText().length() <= 99) || e.getKeyCode() ==  KeyEvent.VK_BACK_SPACE ||
						e.getKeyCode() ==  KeyEvent.VK_DELETE)
					textFieldIndirizzo.setEditable(true);
				else
					textFieldIndirizzo.setEditable(false);
			}
		});
		textFieldIndirizzo.setFont(new Font("Roboto", Font.PLAIN, 17));
		textFieldIndirizzo.setBackground(new Color(255,255,255));
		textFieldIndirizzo.setBorder(new LineBorder(new Color(255,255,255),1));
		textFieldIndirizzo.setColumns(10);
		textFieldIndirizzo.setBounds(446, 48, 287, 32);
		add(textFieldIndirizzo);
		
		lineaTestoIndirizzo = new JLabel("");
		lineaTestoIndirizzo.setBounds(446, 81, 287, 1);
		lineaTestoIndirizzo.setIcon(new ImageIcon(SchermataPrincipale.class.getResource("/Icone/lineaGestisciAttivita.png")));
		add(lineaTestoIndirizzo);
	}


	private void generaCampoTelefono() {
		testoTelefono = new JLabel("Telefono");
		testoTelefono.setFont(new Font("Roboto", Font.PLAIN, 20));
		testoTelefono.setBounds(53, 110, 257, 19);
		add(testoTelefono);
		
		textFieldTelefono = new JTextField();
		textFieldTelefono.addKeyListener(new KeyAdapter() {
			@Override
			public void keyPressed(KeyEvent e) {
				if((e.getKeyChar() >= '0' && e.getKeyChar() <= '9' && textFieldTelefono.getText().length() <= 9)
						|| e.getKeyCode() ==  KeyEvent.VK_BACK_SPACE || e.getKeyCode() ==  KeyEvent.VK_DELETE)
					textFieldTelefono.setEditable(true);
				else
					textFieldTelefono.setEditable(false);
			}
		});
		textFieldTelefono.setFont(new Font("Roboto", Font.PLAIN, 17));
		textFieldTelefono.setBackground(new Color(255,255,255));
		textFieldTelefono.setBorder(new LineBorder(new Color(255,255,255),1));
		textFieldTelefono.setColumns(10);
		textFieldTelefono.setBounds(53, 138, 287, 32);
		add(textFieldTelefono);
		
		lineaTestoTelefono = new JLabel("");
		lineaTestoTelefono.setBounds(53, 171, 287, 1);
		lineaTestoTelefono.setIcon(new ImageIcon(SchermataPrincipale.class.getResource("/Icone/lineaGestisciAttivita.png")));
		add(lineaTestoTelefono);
	}


	private void generaCampoNomeBusiness() {
		testoNomeBusiness = new JLabel("Nome Business");
		testoNomeBusiness.setFont(new Font("Roboto", Font.PLAIN, 20));
		testoNomeBusiness.setBounds(53, 20, 257, 19);
		add(testoNomeBusiness);
		
		textFieldNomeBusiness = new JTextField();
		textFieldNomeBusiness.addKeyListener(new KeyAdapter() {
			@Override
			public void keyPressed(KeyEvent e) {
				if((((e.getKeyChar() >= '0' && e.getKeyChar() <= '9') || (e.getKeyChar() >= 'a' && e.getKeyChar() <= 'z') || (e.getKeyChar() >= 'A' && e.getKeyChar() <= 'Z'))
						&& textFieldNomeBusiness.getText().length() <= 49) || e.getKeyCode() ==  KeyEvent.VK_BACK_SPACE ||
						e.getKeyCode() ==  KeyEvent.VK_DELETE)
					textFieldNomeBusiness.setEditable(true);
				else
					textFieldNomeBusiness.setEditable(false);
			}
		});
		textFieldNomeBusiness.setFont(new Font("Roboto", Font.PLAIN, 17));
		textFieldNomeBusiness.setBackground(new Color(255,255,255));
		textFieldNomeBusiness.setBorder(new LineBorder(new Color(255,255,255),1));
		textFieldNomeBusiness.setColumns(10);
		textFieldNomeBusiness.setBounds(53, 48, 287, 32);
		add(textFieldNomeBusiness);
		
		lineaTestoNomeBusiness = new JLabel("");
		lineaTestoNomeBusiness.setBounds(53, 81, 287, 1);
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
		
		bottoneRistorante.setIcon(new ImageIcon(SchermataPrincipale.class.getResource("/Icone/bottoneRistorante.png")));
		bottoneAttrazioni.setIcon(new ImageIcon(SchermataPrincipale.class.getResource("/Icone/bottoneIntrattenimento.png")));
		bottoneAlloggio.setIcon(new ImageIcon(SchermataPrincipale.class.getResource("/Icone/bottoneAlloggio.png")));
		
		pannelloRaffRistorante.rimuoviTutteLeSpunte();
		pannelloRaffAttrazioni.rimuoviTutteLeSpunte();
		pannelloRaffAlloggi.rimuoviTutteLeSpunte();
		
		pannelloRaffAlloggi.setVisible(false);
		pannelloRaffAttrazioni.setVisible(false);
		pannelloRaffRistorante.setVisible(false);
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
	
	
	private String checkTipoBusiness() {
		if(pannelloRaffRistorante.isVisible()) {
			return "Ristorante";
		}else if (pannelloRaffAttrazioni.isVisible()) {
			return "Attrazione";
		}else if (pannelloRaffAlloggi.isVisible()) {
			return "Alloggio";
		}
		return null;
	}
	
	private String prendiRaffinazioni() {
		if(pannelloRaffRistorante.isVisible()) {
			return pannelloRaffRistorante.toString();
		}else if (pannelloRaffAttrazioni.isVisible()) {
			return pannelloRaffAttrazioni.toString();
		}else if (pannelloRaffAlloggi.isVisible()) {
			return pannelloRaffAlloggi.toString();
		}
		return null;
	}
	
	public void mostraErroreCampiVuoti() {
		testoErrori.setText("Non possono esserci campi vuoti");
		testoErrori.setVisible(true);
	}
	
	public void mostraErroreNumeroDiTelefono() {
		testoErrori.setText("Il numero di telefono non e' valido");
		testoErrori.setVisible(true);
	}
	
	public void mostraErrorePatternCampi() {
		testoErrori.setText("I valori inseriti per certi campi non sono accettati");
		testoErrori.setVisible(true);
	}
	
	public void mostraErroreTipologiaVuota() {
		testoErroreTipologiaVuota.setText("Seleziona una tipologia");
		testoErroreTipologiaVuota.setVisible(true);
	}
	
	public void mostraErrorePartitaIVA() {
		testoErrori.setText("La partita IVA non e' valida");
		testoErrori.setVisible(true);
	}
	
	public void mostraErrorePartitaIVAInUso() {
		testoErrori.setText("La partita IVA inserita e' gia' in uso");
		testoErrori.setVisible(true);
	}
	
	public void resettaVisibilitaErrori() {
		testoErrori.setVisible(false);
		testoErroreTipologiaVuota.setVisible(false);
	}
	
	public void aggiungiRegioneAModello(String regione) {
		modelloComboBoxRegione.addElement(regione);
	}
	
	public void aggiungiProvinciaAModello(String citta) {
		modelloComboBoxProvincia.addElement(citta);
	}
	
	public void pulisciModelloProvincia() {
		modelloComboBoxProvincia.removeAllElements();
	}
	
	public void aggiungiComuneAModello(String comune) {
		modelloComboBoxComune.addElement(comune);
	}
	
	public void pulisciModelloComune() {
		modelloComboBoxComune.removeAllElements();
	}
	
	public void aggiungiCAPAModello(String CAP) {
		modelloComboBoxCAP.addElement(CAP);
	}
	
	public void pulisciModelloCAP() {
		modelloComboBoxCAP.removeAllElements();
	}
}
