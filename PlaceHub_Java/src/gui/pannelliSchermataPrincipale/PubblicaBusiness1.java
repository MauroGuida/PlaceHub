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
import javax.swing.GroupLayout;
import javax.swing.GroupLayout.Alignment;

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
		
		GroupLayout groupLayout = new GroupLayout(this);
		groupLayout.setHorizontalGroup(
			groupLayout.createParallelGroup(Alignment.LEADING)
				.addGroup(Alignment.TRAILING, groupLayout.createSequentialGroup()
					.addGap(53)
					.addComponent(testoNomeBusiness, GroupLayout.PREFERRED_SIZE, 257, GroupLayout.PREFERRED_SIZE)
					.addGap(183)
					.addComponent(testoIndirizzo, GroupLayout.DEFAULT_SIZE, 282, Short.MAX_VALUE)
					.addGap(75))
				.addGroup(groupLayout.createSequentialGroup()
					.addGap(53)
					.addComponent(textFieldNomeBusiness, GroupLayout.DEFAULT_SIZE, 287, Short.MAX_VALUE)
					.addGap(153)
					.addComponent(textFieldIndirizzo, GroupLayout.DEFAULT_SIZE, 287, Short.MAX_VALUE)
					.addGap(70))
				.addGroup(groupLayout.createSequentialGroup()
					.addGap(53)
					.addComponent(lineaTestoNomeBusiness, GroupLayout.PREFERRED_SIZE, 287, Short.MAX_VALUE)
					.addGap(153)
					.addComponent(lineaTestoIndirizzo, GroupLayout.PREFERRED_SIZE, 287, Short.MAX_VALUE)
					.addGap(70))
				.addGroup(groupLayout.createSequentialGroup()
					.addGap(53)
					.addComponent(testoTelefono, GroupLayout.PREFERRED_SIZE, 257, GroupLayout.PREFERRED_SIZE)
					.addGap(183)
					.addComponent(testoPartitaIva, GroupLayout.DEFAULT_SIZE, 282, Short.MAX_VALUE)
					.addGap(75))
				.addGroup(groupLayout.createSequentialGroup()
					.addGap(53)
					.addComponent(textFieldTelefono, GroupLayout.DEFAULT_SIZE, 287, Short.MAX_VALUE)
					.addGap(153)
					.addComponent(textFieldPartitaIVA, GroupLayout.DEFAULT_SIZE, 287, Short.MAX_VALUE)
					.addGap(70))
				.addGroup(groupLayout.createSequentialGroup()
					.addGap(53)
					.addComponent(lineaTestoTelefono, GroupLayout.PREFERRED_SIZE, 287, Short.MAX_VALUE)
					.addGap(153)
					.addComponent(lineaTestoPartitaIVA, GroupLayout.PREFERRED_SIZE, 287, Short.MAX_VALUE)
					.addGap(70))
				.addGroup(groupLayout.createSequentialGroup()
					.addGap(53)
					.addComponent(testoRegione, GroupLayout.PREFERRED_SIZE, 170, GroupLayout.PREFERRED_SIZE)
					.addGap(47)
					.addComponent(testoProvincia, GroupLayout.PREFERRED_SIZE, 90, GroupLayout.PREFERRED_SIZE)
					.addGap(35)
					.addComponent(testoComune, GroupLayout.PREFERRED_SIZE, 170, GroupLayout.PREFERRED_SIZE)
					.addGap(45)
					.addComponent(testoCAP, GroupLayout.PREFERRED_SIZE, 170, GroupLayout.PREFERRED_SIZE))
				.addGroup(groupLayout.createSequentialGroup()
					.addGap(52)
					.addComponent(comboBoxRegione, GroupLayout.PREFERRED_SIZE, 170, GroupLayout.PREFERRED_SIZE)
					.addGap(48)
					.addComponent(comboBoxProvincia, GroupLayout.PREFERRED_SIZE, 81, GroupLayout.PREFERRED_SIZE)
					.addGap(44)
					.addComponent(comboBoxComune, GroupLayout.PREFERRED_SIZE, 170, GroupLayout.PREFERRED_SIZE)
					.addGap(45)
					.addComponent(comboBoxCAP, GroupLayout.PREFERRED_SIZE, 170, GroupLayout.PREFERRED_SIZE))
				.addGroup(groupLayout.createSequentialGroup()
					.addGap(53)
					.addComponent(testoSelezionaOpzione, GroupLayout.PREFERRED_SIZE, 257, GroupLayout.PREFERRED_SIZE)
					.addGap(90)
					.addComponent(testoErrori, GroupLayout.PREFERRED_SIZE, 381, GroupLayout.PREFERRED_SIZE)
					.addGap(69))
				.addGroup(groupLayout.createSequentialGroup()
					.addGap(100)
					.addComponent(pannelloRaffRistorante, GroupLayout.PREFERRED_SIZE, GroupLayout.DEFAULT_SIZE, GroupLayout.PREFERRED_SIZE))
				.addGroup(groupLayout.createSequentialGroup()
					.addGap(100)
					.addGroup(groupLayout.createParallelGroup(Alignment.LEADING)
						.addComponent(pannelloRaffAttrazioni, GroupLayout.PREFERRED_SIZE, GroupLayout.DEFAULT_SIZE, GroupLayout.PREFERRED_SIZE)
						.addComponent(pannelloRaffAlloggi, GroupLayout.PREFERRED_SIZE, GroupLayout.DEFAULT_SIZE, GroupLayout.PREFERRED_SIZE)))
				.addGroup(Alignment.TRAILING, groupLayout.createSequentialGroup()
					.addGap(668)
					.addComponent(bottoneAvanti, GroupLayout.PREFERRED_SIZE, 140, GroupLayout.PREFERRED_SIZE)
					.addGap(42))
				.addGroup(Alignment.TRAILING, groupLayout.createSequentialGroup()
					.addGap(53)
					.addGroup(groupLayout.createParallelGroup(Alignment.TRAILING)
						.addComponent(testoErroreTipologiaVuota, Alignment.LEADING, GroupLayout.DEFAULT_SIZE, 733, Short.MAX_VALUE)
						.addGroup(groupLayout.createSequentialGroup()
							.addComponent(bottoneRistorante, GroupLayout.PREFERRED_SIZE, 208, Short.MAX_VALUE)
							.addGap(54)
							.addComponent(bottoneAttrazioni, GroupLayout.PREFERRED_SIZE, 208, Short.MAX_VALUE)
							.addGap(54)
							.addComponent(bottoneAlloggio, GroupLayout.PREFERRED_SIZE, 209, Short.MAX_VALUE)))
					.addGap(64))
		);
		groupLayout.setVerticalGroup(
			groupLayout.createParallelGroup(Alignment.LEADING)
				.addGroup(groupLayout.createSequentialGroup()
					.addGap(20)
					.addGroup(groupLayout.createParallelGroup(Alignment.LEADING)
						.addComponent(testoNomeBusiness, GroupLayout.PREFERRED_SIZE, 19, GroupLayout.PREFERRED_SIZE)
						.addComponent(testoIndirizzo, GroupLayout.PREFERRED_SIZE, 19, GroupLayout.PREFERRED_SIZE))
					.addGap(9)
					.addGroup(groupLayout.createParallelGroup(Alignment.LEADING)
						.addComponent(textFieldNomeBusiness, GroupLayout.PREFERRED_SIZE, 32, GroupLayout.PREFERRED_SIZE)
						.addComponent(textFieldIndirizzo, GroupLayout.PREFERRED_SIZE, 32, GroupLayout.PREFERRED_SIZE))
					.addGap(1)
					.addGroup(groupLayout.createParallelGroup(Alignment.LEADING)
						.addComponent(lineaTestoNomeBusiness)
						.addComponent(lineaTestoIndirizzo))
					.addGap(28)
					.addGroup(groupLayout.createParallelGroup(Alignment.LEADING)
						.addComponent(testoTelefono, GroupLayout.PREFERRED_SIZE, 19, GroupLayout.PREFERRED_SIZE)
						.addComponent(testoPartitaIva, GroupLayout.PREFERRED_SIZE, 19, GroupLayout.PREFERRED_SIZE))
					.addGap(9)
					.addGroup(groupLayout.createParallelGroup(Alignment.LEADING)
						.addComponent(textFieldTelefono, GroupLayout.PREFERRED_SIZE, 32, GroupLayout.PREFERRED_SIZE)
						.addComponent(textFieldPartitaIVA, GroupLayout.PREFERRED_SIZE, 32, GroupLayout.PREFERRED_SIZE))
					.addGap(1)
					.addGroup(groupLayout.createParallelGroup(Alignment.LEADING)
						.addComponent(lineaTestoTelefono)
						.addComponent(lineaTestoPartitaIVA))
					.addGap(28)
					.addGroup(groupLayout.createParallelGroup(Alignment.LEADING)
						.addComponent(testoRegione, GroupLayout.PREFERRED_SIZE, 19, GroupLayout.PREFERRED_SIZE)
						.addComponent(testoProvincia, GroupLayout.PREFERRED_SIZE, 19, GroupLayout.PREFERRED_SIZE)
						.addComponent(testoComune, GroupLayout.PREFERRED_SIZE, 19, GroupLayout.PREFERRED_SIZE)
						.addComponent(testoCAP, GroupLayout.PREFERRED_SIZE, 19, GroupLayout.PREFERRED_SIZE))
					.addGap(9)
					.addGroup(groupLayout.createParallelGroup(Alignment.LEADING)
						.addComponent(comboBoxRegione, GroupLayout.PREFERRED_SIZE, 35, GroupLayout.PREFERRED_SIZE)
						.addComponent(comboBoxProvincia, GroupLayout.PREFERRED_SIZE, 35, GroupLayout.PREFERRED_SIZE)
						.addComponent(comboBoxComune, GroupLayout.PREFERRED_SIZE, 35, GroupLayout.PREFERRED_SIZE)
						.addComponent(comboBoxCAP, GroupLayout.PREFERRED_SIZE, 35, GroupLayout.PREFERRED_SIZE))
					.addGap(27)
					.addGroup(groupLayout.createParallelGroup(Alignment.LEADING)
						.addComponent(testoSelezionaOpzione, GroupLayout.PREFERRED_SIZE, 23, GroupLayout.PREFERRED_SIZE)
						.addComponent(testoErrori))
					.addGap(27)
					.addGroup(groupLayout.createParallelGroup(Alignment.LEADING, false)
						.addComponent(bottoneRistorante, GroupLayout.PREFERRED_SIZE, 110, GroupLayout.PREFERRED_SIZE)
						.addComponent(bottoneAttrazioni, GroupLayout.PREFERRED_SIZE, 110, GroupLayout.PREFERRED_SIZE)
						.addComponent(bottoneAlloggio, GroupLayout.PREFERRED_SIZE, 110, GroupLayout.PREFERRED_SIZE))
					.addGap(15)
					.addComponent(pannelloRaffRistorante, GroupLayout.PREFERRED_SIZE, GroupLayout.DEFAULT_SIZE, GroupLayout.PREFERRED_SIZE)
					.addGap(4)
					.addGroup(groupLayout.createParallelGroup(Alignment.LEADING)
						.addComponent(pannelloRaffAttrazioni, GroupLayout.PREFERRED_SIZE, GroupLayout.DEFAULT_SIZE, GroupLayout.PREFERRED_SIZE)
						.addComponent(pannelloRaffAlloggi, GroupLayout.PREFERRED_SIZE, GroupLayout.DEFAULT_SIZE, GroupLayout.PREFERRED_SIZE))
					.addGap(4)
					.addComponent(testoErroreTipologiaVuota)
					.addGap(43)
					.addComponent(bottoneAvanti, GroupLayout.PREFERRED_SIZE, 50, GroupLayout.PREFERRED_SIZE)
					.addGap(27))
		);
		setLayout(groupLayout);
	}


	private void generaCampoCAP() {
		testoCAP = new JLabel("CAP");
		testoCAP.setFont(new Font("Roboto", Font.PLAIN, 20));
		
		modelloComboBoxCAP = new DefaultComboBoxModel<String>();
	    comboBoxCAP = new JComboBox<String>(modelloComboBoxCAP);
		comboBoxCAP.setBackground(Color.WHITE);
		comboBoxCAP.setFont(new Font("Roboto", Font.PLAIN, 17));
	}


	private void generaCampoComune() {
		testoComune = new JLabel("Comune");
		testoComune.setFont(new Font("Roboto", Font.PLAIN, 20));
		
		modelloComboBoxComune = new DefaultComboBoxModel<String>(); 
		comboBoxComune = new JComboBox<String>(modelloComboBoxComune);
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
		testoProvincia.setFont(new Font("Roboto", Font.PLAIN, 20));
		
		modelloComboBoxProvincia = new DefaultComboBoxModel<String>();
		comboBoxProvincia = new JComboBox<String>(modelloComboBoxProvincia);
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
		testoRegione.setFont(new Font("Roboto", Font.PLAIN, 20));
		
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
	}


	private void generaTestoErroreTipologiaVuota() {
		testoErroreTipologiaVuota = new JLabel("Seleziona una tipologia");
		testoErroreTipologiaVuota.setHorizontalAlignment(SwingConstants.CENTER);
		testoErroreTipologiaVuota.setForeground(Color.RED);
		testoErroreTipologiaVuota.setFont(new Font("Roboto", Font.PLAIN, 16));
		testoErroreTipologiaVuota.setVisible(false);
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
		pannelloRaffAttrazioni.setVisible(false);
	}


	private void generaRaffinazioniAlloggio() {
		pannelloRaffAlloggi = new gui.pannelliSchermataPrincipale.raffinazioni.pannelloRaffinazioneAlloggi();
		pannelloRaffAlloggi.setVisible(false);
	}


	private void generaPannelloRaffRistorante() {
		pannelloRaffRistorante = new gui.pannelliSchermataPrincipale.raffinazioni.pannelloRaffinazioniRistorante();
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
		testoSelezionaOpzione.setFont(new Font("Roboto", Font.PLAIN, 20));
	}

	private void generaCampoPartitaIVA() {
		testoPartitaIva = new JLabel("Partita IVA");
		testoPartitaIva.setFont(new Font("Roboto", Font.PLAIN, 20));
		
		textFieldPartitaIVA = new JTextField();
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
		lineaTestoPartitaIVA.setIcon(new ImageIcon(PubblicaBusiness1.class.getResource("/Icone/lineaGestisciAttivita.png")));
	}


	private void generaCampoIndirizzo() {
		testoIndirizzo = new JLabel("Indirizzo");
		testoIndirizzo.setFont(new Font("Roboto", Font.PLAIN, 20));
		
		textFieldIndirizzo = new JTextField();
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
		lineaTestoIndirizzo.setIcon(new ImageIcon(SchermataPrincipale.class.getResource("/Icone/lineaGestisciAttivita.png")));
	}


	private void generaCampoTelefono() {
		testoTelefono = new JLabel("Telefono");
		testoTelefono.setFont(new Font("Roboto", Font.PLAIN, 20));
		
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
		
		lineaTestoTelefono = new JLabel("");
		lineaTestoTelefono.setIcon(new ImageIcon(SchermataPrincipale.class.getResource("/Icone/lineaGestisciAttivita.png")));
	}


	private void generaCampoNomeBusiness() {
		testoNomeBusiness = new JLabel("Nome Business");
		testoNomeBusiness.setFont(new Font("Roboto", Font.PLAIN, 20));
		
		textFieldNomeBusiness = new JTextField();
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
