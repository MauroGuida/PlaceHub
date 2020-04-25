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
import net.miginfocom.swing.MigLayout;
import oggetti.Locale;

import java.awt.Component;
import javax.swing.Box;

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
	private Component horizontalStrut0;
	private Component horizontalStrut2;
	private Component horizontalGlue;
	private JPanel pannelloTOP;
	private JPanel pannelloMID;
	private JPanel pannelloBOT;
	private Component horizontalGlue_1;
	private Component horizontalGlue_2;
	private JPanel pannelloBOT2;
	private JPanel boxPannelliRaff;

	public PubblicaBusiness1(Controller ctrl) {
		addComponentListener(new ComponentAdapter() {
			@Override
			public void componentHidden(ComponentEvent e) {
				pulisciPannello();
				ctrl.aggiungiRegioneAModelloComboBoxPubblicaBusiness1();
	
			}
		});
		
		this.ctrl = ctrl;
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
		
		
		layoutTopPanel();
		layoutMidPanel();
		layoutBotPanel();
		layoutBot2Panel();
		
		setLayout(new MigLayout("", "[grow,fill]", "[grow,center][grow,center][grow,center][][grow,center]"));
		add(pannelloTOP, "cell 0 0,growx,growy,aligny top");
		add(pannelloMID, "cell 0 1,growx,growy,aligny top");
		add(pannelloBOT, "cell 0 2,grow,growy");
		add(testoErrori, "cell 0 3");
		add(pannelloBOT2, "cell 0 4,alignx left,grow");
		
	}


	private void layoutBot2Panel() {
		pannelloBOT2 = new JPanel();
		pannelloBOT2.setBackground(Color.WHITE);
		
		boxPannelliRaff = new JPanel();
		boxPannelliRaff.setSize(506, 106);
		boxPannelliRaff.setLayout(null);
		boxPannelliRaff.setBackground(Color.WHITE);
		
		boxPannelliRaff.add(pannelloRaffAttrazioni);
		boxPannelliRaff.add(pannelloRaffAlloggi);
		boxPannelliRaff.add(pannelloRaffRistorante);
		
		pannelloRaffAttrazioni.setLocation(0, 0);
		pannelloRaffAlloggi.setLocation(0, 0);
		pannelloRaffRistorante.setLocation(0, 0);
		
		pannelloBOT2.setLayout(new MigLayout("", "[506px][grow,center][]", "[106px]"));
		pannelloBOT2.add(boxPannelliRaff, "cell 0 0,grow");
		
		Component horizontalGlue_3 = Box.createHorizontalGlue();
		pannelloBOT2.add(horizontalGlue_3, "cell 1 0");
		pannelloBOT2.add(bottoneAvanti, "cell 2 0,growx,aligny center");
	}


	private void layoutBotPanel() {
		pannelloBOT = new JPanel();
		pannelloBOT.setBackground(Color.WHITE);
		pannelloBOT.setLayout(new MigLayout("", "[grow,fill][][][][grow,fill]", "[][][]"));
		
		pannelloBOT.add(testoSelezionaOpzione, "cell 1 0,alignx left,aligny center");
		
		horizontalGlue_1 = Box.createHorizontalGlue();
		pannelloBOT.add(horizontalGlue_1, "cell 0 2");
		
		horizontalGlue_2 = Box.createHorizontalGlue();
		pannelloBOT.add(horizontalGlue_2, "cell 4 2");
		
		pannelloBOT.add(bottoneRistorante, "cell 1 2,alignx left,aligny top");
		pannelloBOT.add(bottoneAttrazioni, "cell 2 2,alignx left,aligny top");
		pannelloBOT.add(bottoneAlloggio, "cell 3 2,alignx left,aligny top");
	}


	private void layoutMidPanel() {
		pannelloMID = new JPanel();
		pannelloMID.setBackground(Color.WHITE);
		pannelloMID.setLayout(new MigLayout("", "[grow][grow][grow][grow][grow][grow]", "[][]"));
		
		pannelloMID.add(testoRegione, "cell 1 0,alignx center,aligny center");
		pannelloMID.add(comboBoxRegione, "cell 1 1,alignx center");
		
		pannelloMID.add(testoProvincia, "cell 2 0,alignx center,aligny center");
		pannelloMID.add(comboBoxProvincia, "cell 2 1,alignx center");
		
		pannelloMID.add(testoComune, "cell 3 0,alignx center,aligny center");
		pannelloMID.add(comboBoxComune, "cell 3 1,alignx center");
		
		pannelloMID.add(testoCAP, "cell 4 0,alignx center,aligny center");
		pannelloMID.add(comboBoxCAP, "cell 4 1,alignx center");
	}


	private void layoutTopPanel() {
		pannelloTOP = new JPanel();
		pannelloTOP.setBackground(Color.WHITE);
		pannelloTOP.setLayout(new MigLayout("", "[grow,center][grow,fill][grow,fill][grow,fill][grow,center]", "[][][][][][][]"));
		
		horizontalStrut0 = Box.createHorizontalStrut(25);
		horizontalStrut2 = Box.createHorizontalStrut(25);
		horizontalGlue = Box.createHorizontalGlue();
		
		pannelloTOP.add(horizontalGlue, "cell 2 0,growx,aligny center");
		pannelloTOP.add(horizontalStrut0, "cell 0 0");
		pannelloTOP.add(horizontalStrut2, "cell 4 0");
		
		pannelloTOP.add(testoNomeBusiness, "cell 1 0,alignx left");
		pannelloTOP.add(textFieldNomeBusiness, "cell 1 1,growx");
		pannelloTOP.add(lineaTestoNomeBusiness, "cell 1 2,growx,aligny center");
		
		pannelloTOP.add(testoIndirizzo, "cell 3 0,alignx left");
		pannelloTOP.add(textFieldIndirizzo, "cell 3 1,growx");
		pannelloTOP.add(lineaTestoIndirizzo, "cell 3 2,growx,aligny center");
		
		pannelloTOP.add(testoTelefono, "cell 1 4,alignx left");
		pannelloTOP.add(textFieldTelefono, "cell 1 5,growx");
		pannelloTOP.add(lineaTestoTelefono, "cell 1 6, growx,aligny center");
		
		pannelloTOP.add(testoPartitaIva, "cell 3 4,alignx left");
		pannelloTOP.add(textFieldPartitaIVA, "cell 3 5,growx");
		pannelloTOP.add(lineaTestoPartitaIVA, "cell 3 6,growx,aligny center");
	}


	private void generaCampoCAP() {
		testoCAP = new JLabel("CAP");
		testoCAP.setBounds(610, 200, 170, 19);
		testoCAP.setFont(new Font("Roboto", Font.PLAIN, 20));
		
		modelloComboBoxCAP = new DefaultComboBoxModel<String>();
	    comboBoxCAP = new JComboBox<String>(modelloComboBoxCAP);
	    comboBoxCAP.setBounds(610, 228, 170, 35);
		comboBoxCAP.setBackground(Color.WHITE);
		comboBoxCAP.setFont(new Font("Roboto", Font.PLAIN, 17));
	}


	private void generaCampoComune() {
		testoComune = new JLabel("Comune");
		testoComune.setBounds(395, 200, 170, 19);
		testoComune.setFont(new Font("Roboto", Font.PLAIN, 20));
		
		modelloComboBoxComune = new DefaultComboBoxModel<String>(); 
		comboBoxComune = new JComboBox<String>(modelloComboBoxComune);
		comboBoxComune.setBounds(395, 228, 170, 35);
		comboBoxComune.addItemListener(new ItemListener() {
			public void itemStateChanged(ItemEvent e) {
				int selezione = e.getStateChange();
				if(selezione == ItemEvent.SELECTED) {
					ctrl.aggiungiCAPAModelloComboBoxPubblicaBusiness1(modelloComboBoxComune.getSelectedItem().toString());
				}
			}
		});
		comboBoxComune.setBackground(Color.WHITE);
		comboBoxComune.setFont(new Font("Roboto", Font.PLAIN, 17));
	}


	private void generaCampoProvincia() {
		testoProvincia = new JLabel("Provincia");
		testoProvincia.setBounds(270, 200, 90, 19);
		testoProvincia.setFont(new Font("Roboto", Font.PLAIN, 20));
		
		modelloComboBoxProvincia = new DefaultComboBoxModel<String>();
		comboBoxProvincia = new JComboBox<String>(modelloComboBoxProvincia);
		comboBoxProvincia.setBounds(270, 228, 81, 35);
		comboBoxProvincia.addItemListener(new ItemListener() {
			public void itemStateChanged(ItemEvent e) {
				int selezione = e.getStateChange();
				if(selezione == ItemEvent.SELECTED) {
					ctrl.aggiungiComuneAModelloComboBoxPubblicaBusiness1(modelloComboBoxProvincia.getSelectedItem().toString());
				}
			}
		});
		comboBoxProvincia.setBackground(Color.WHITE);
		comboBoxProvincia.setFont(new Font("Roboto", Font.PLAIN, 17));
	}

	private void generaCampoRegione() {
		testoRegione = new JLabel("Regione");
		testoRegione.setBounds(53, 200, 170, 19);
		testoRegione.setFont(new Font("Roboto", Font.PLAIN, 20));
		
		modelloComboBoxRegione = new DefaultComboBoxModel<String>();
		comboBoxRegione = new JComboBox<String>(modelloComboBoxRegione);
		comboBoxRegione.setBounds(52, 228, 170, 35);
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
	}


	private void generaTestoErroreCampiVuoti() {
		testoErrori = new JLabel("ERRORI");
		testoErrori.setHorizontalAlignment(SwingConstants.CENTER);
		testoErrori.setForeground(Color.RED);
		testoErrori.setFont(new Font("Roboto", Font.PLAIN, 16));
		testoErrori.setVisible(false);
	}


	private void generaRaffinazioniAttrazione() {
		pannelloRaffAttrazioni = new gui.pannelliSchermataPrincipale.raffinazioni.pannelloRaffinazioneAttrazioni();
		pannelloRaffAttrazioni.setBounds(0, 5, 507, 85);
		pannelloRaffAttrazioni.setVisible(false);
	}


	private void generaRaffinazioniAlloggio() {
		pannelloRaffAlloggi = new gui.pannelliSchermataPrincipale.raffinazioni.pannelloRaffinazioneAlloggi();
		pannelloRaffAlloggi.setBounds(10, 95, 486, 58);
		pannelloRaffAlloggi.setVisible(false);
	}


	private void generaPannelloRaffRistorante() {
		pannelloRaffRistorante = new gui.pannelliSchermataPrincipale.raffinazioni.pannelloRaffinazioniRistorante();
		pannelloRaffRistorante.setBounds(0, 158, 507, 85);
		pannelloRaffRistorante.setVisible(false);
	}


	private void generaBottoneAvanti() {
		bottoneAvanti = new JButton("");
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
				ctrl.procediInPubblicaBusiness2(textFieldNomeBusiness.getText(), textFieldIndirizzo.getText(), textFieldTelefono.getText(),
												textFieldPartitaIVA.getText(), checkTipoBusiness(), prendiRaffinazioni(),
												modelloComboBoxRegione.getSelectedItem().toString(), modelloComboBoxProvincia.getSelectedItem().toString(),
												modelloComboBoxComune.getSelectedItem().toString(), modelloComboBoxCAP.getSelectedItem().toString());
			}
		});
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
	}
	
	
	private void generaTestoSelezionaOpzione() {
		testoSelezionaOpzione = new JLabel("Seleziona una opzione");
		testoSelezionaOpzione.setBounds(53, 290, 257, 23);
		testoSelezionaOpzione.setFont(new Font("Roboto", Font.PLAIN, 20));
	}

	private void generaCampoPartitaIVA() {
		testoPartitaIva = new JLabel("Partita IVA");
		testoPartitaIva.setBounds(493, 110, 282, 19);
		testoPartitaIva.setFont(new Font("Roboto", Font.PLAIN, 20));
		
		textFieldPartitaIVA = new JTextField();
		textFieldPartitaIVA.setBounds(493, 138, 287, 32);
		textFieldPartitaIVA.setFont(new Font("Roboto", Font.PLAIN, 17));
		textFieldPartitaIVA.setBackground(new Color(255,255,255));
		textFieldPartitaIVA.setBorder(new LineBorder(new Color(255,255,255),1));
		textFieldPartitaIVA.setColumns(10);
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
		
		lineaTestoPartitaIVA = new JLabel("");
		lineaTestoPartitaIVA.setBounds(493, 171, 287, 1);
		lineaTestoPartitaIVA.setIcon(new ImageIcon(PubblicaBusiness1.class.getResource("/Icone/lineaGestisciAttivita.png")));
	}


	private void generaCampoIndirizzo() {
		testoIndirizzo = new JLabel("Indirizzo");
		testoIndirizzo.setBounds(493, 20, 282, 19);
		testoIndirizzo.setFont(new Font("Roboto", Font.PLAIN, 20));
		
		textFieldIndirizzo = new JTextField();
		textFieldIndirizzo.setBounds(493, 48, 287, 32);
		textFieldIndirizzo.addKeyListener(new KeyAdapter() {
			@Override
			public void keyPressed(KeyEvent e) {
				if((((e.getKeyChar() >= '0' && e.getKeyChar() <= '9') || (e.getKeyChar() >= 'a' && e.getKeyChar() <= 'z') || (e.getKeyChar() >= 'A' && e.getKeyChar() <= 'Z'))
						&& textFieldIndirizzo.getText().length() <= 99) || e.getKeyCode() ==  KeyEvent.VK_BACK_SPACE || e.getKeyCode() ==  KeyEvent.VK_SPACE ||
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
		
		lineaTestoIndirizzo = new JLabel("");
		lineaTestoIndirizzo.setBounds(493, 81, 287, 1);
		lineaTestoIndirizzo.setIcon(new ImageIcon(SchermataPrincipale.class.getResource("/Icone/lineaGestisciAttivita.png")));
	}


	private void generaCampoTelefono() {
		testoTelefono = new JLabel("Telefono");
		testoTelefono.setBounds(53, 110, 257, 19);
		testoTelefono.setFont(new Font("Roboto", Font.PLAIN, 20));
		
		textFieldTelefono = new JTextField();
		textFieldTelefono.setBounds(53, 138, 287, 32);
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
		
		lineaTestoTelefono = new JLabel("");
		lineaTestoTelefono.setBounds(53, 171, 287, 1);
		lineaTestoTelefono.setIcon(new ImageIcon(SchermataPrincipale.class.getResource("/Icone/lineaGestisciAttivita.png")));
	}


	private void generaCampoNomeBusiness() {
		testoNomeBusiness = new JLabel("Nome Business");
		testoNomeBusiness.setBounds(53, 20, 257, 19);
		testoNomeBusiness.setFont(new Font("Roboto", Font.PLAIN, 20));
		
		textFieldNomeBusiness = new JTextField();
		textFieldNomeBusiness.setBounds(53, 48, 287, 32);
		textFieldNomeBusiness.addKeyListener(new KeyAdapter() {
			@Override
			public void keyPressed(KeyEvent e) {
				if((((e.getKeyChar() >= '0' && e.getKeyChar() <= '9') || (e.getKeyChar() >= 'a' && e.getKeyChar() <= 'z') || (e.getKeyChar() >= 'A' && e.getKeyChar() <= 'Z'))
						&& textFieldNomeBusiness.getText().length() <= 49) || e.getKeyCode() ==  KeyEvent.VK_BACK_SPACE || e.getKeyCode() ==  KeyEvent.VK_SPACE ||
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
		
		lineaTestoNomeBusiness = new JLabel("");
		lineaTestoNomeBusiness.setBounds(53, 81, 287, 1);
		lineaTestoNomeBusiness.setIcon(new ImageIcon(SchermataPrincipale.class.getResource("/Icone/lineaGestisciAttivita.png")));
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
		
		resettaVisibilitaErrori();
		
		comboBoxRegione.setEnabled(true);
		comboBoxProvincia.setEnabled(true);
		comboBoxComune.setEnabled(true);
		comboBoxCAP.setEnabled(true);
		
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
		testoErrori.setText("Seleziona una tipologia");
		testoErrori.setVisible(true);
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
	
	public void impostaBusinessPreesistente(Locale locale) {
		testoNomeBusiness.setText(locale.getNome());
		testoIndirizzo.setText(locale.getIndirizzo());
		testoPartitaIva.setText(locale.getPartitaIVA());
		testoPartitaIva.setEnabled(false);
		testoTelefono.setText(locale.getTelefono());
		
		comboBoxRegione.setEnabled(false);
		comboBoxProvincia.setEnabled(false);
		comboBoxComune.setEnabled(false);
		comboBoxCAP.setEnabled(false);
		
		if(locale.getTipoBusiness().equals("Ristorante")) {
			bottoneRistorante.setIcon(new ImageIcon(SchermataPrincipale.class.getResource("/Icone/bottoneRistoranteFocus.png")));
			pannelloRaffRistorante.setVisible(true);
			pannelloRaffRistorante.impostaRaffinazioni(locale.getRaffinazioni());
		}else if(locale.getTipoBusiness().equals("Attrazione")) {
			bottoneAttrazioni.setIcon(new ImageIcon(SchermataPrincipale.class.getResource("/Icone/bottoneIntrattenimentoFocus.png")));
			pannelloRaffAttrazioni.setVisible(true);
			pannelloRaffAttrazioni.impostaRaffinazioni(locale.getRaffinazioni());
		}else {
			bottoneAlloggio.setIcon(new ImageIcon(SchermataPrincipale.class.getResource("/Icone/bottoneAlloggioFocus.png")));
			pannelloRaffAlloggi.setVisible(true);
			pannelloRaffAlloggi.impostaRaffinazioni(locale.getRaffinazioni());
		}
		
	}
}
