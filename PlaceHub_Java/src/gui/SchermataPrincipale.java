package gui;

import javax.swing.JFrame;

import gestione.Controller;
import res.ComponentResizer;
import res.ScrollPaneVerde;
import res.WrapLayout;

import javax.swing.JPanel;
import javax.swing.JButton;
import javax.swing.BorderFactory;
import javax.swing.GroupLayout;
import javax.swing.GroupLayout.Alignment;
import javax.swing.ImageIcon;
import javax.swing.LayoutStyle.ComponentPlacement;
import javax.swing.border.LineBorder;
import javax.swing.plaf.ColorUIResource;
import javax.swing.plaf.basic.BasicScrollBarUI;

import errori.NumeroStelleNonValidoException;
import oggetti.Locale;

import java.awt.event.ActionListener;
import java.awt.event.MouseAdapter;
import java.awt.event.MouseEvent;
import java.awt.event.ActionEvent;
import java.awt.BorderLayout;
import java.awt.Color;
import java.awt.Cursor;
import java.awt.Dimension;
import java.awt.FlowLayout;
import java.awt.Font;
import java.awt.GridLayout;
import java.awt.Insets;
import java.awt.Point;
import java.awt.ScrollPane;

import javax.swing.JTextField;
import java.awt.event.FocusAdapter;
import java.awt.event.FocusEvent;
import javax.swing.JLabel;
import javax.swing.JTextArea;
import javax.swing.JComboBox;
import java.awt.event.MouseMotionAdapter;
import javax.swing.JScrollPane;
import javax.swing.ScrollPaneConstants;
import javax.swing.UIManager;

public class SchermataPrincipale extends JFrame {
	private static final long serialVersionUID = 1L;
	
	private Controller ctrl;
	private JButton bottoneEsci;
	private JTextField textFieldCosa;
	private JTextField textFieldDove;
	private JButton bottoneHomepage;
	private JButton bottoneRistoranti;
	private JButton bottoneIntrattenimento;
	private JButton bottoneAlloggi;
	private int flagFocusBottone;
	private int flagFocusBottoneGestisciBusiness1;
	private JTextField textFieldNomeBusiness;
	private JTextField textFieldTelefono;
	private JTextField textFieldIndirizzo;
	private JTextField textFieldPartitaIVA;
	private JButton bottoneRistoranteGestisciBusiness1;
	private JButton bottoneIntrattenimentoGestisciBusiness1;
	private JButton bottoneAlloggioGestisciBusiness1;
	private JButton bottoneAvantiGestisciBusiness2;
	private JPanel pannelloBottoni;
	private Point clickIniziale;
	
	private JPanel PannelloRicerche;
	
	public SchermataPrincipale(Controller Ctrl) {
		getContentPane().setBackground(Color.WHITE);
		this.ctrl = Ctrl;
		setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
		setBounds(100, 100, 450, 300);
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
		
		JPanel pannelloGestisciBusiness1 = new JPanel();
		pannelloGestisciBusiness1.setBounds(250, 36, 850, 614);
		pannelloGestisciBusiness1.setVisible(false);
		pannelloGestisciBusiness1.setVisible(false);
		pannelloGestisciBusiness1.setBackground(Color.WHITE);
		
		JLabel testoNomeBusiness = new JLabel("Nome Business");
		testoNomeBusiness.setFont(new Font("Roboto", Font.PLAIN, 20));
		
		JLabel testoTelefono = new JLabel("Telefono");
		testoTelefono.setFont(new Font("Roboto", Font.PLAIN, 20));
		
		JLabel testoIndirizzo = new JLabel("Indirizzo");
		testoIndirizzo.setFont(new Font("Roboto", Font.PLAIN, 20));
		
		JLabel testoPartitaIva = new JLabel("Partita IVA");
		testoPartitaIva.setFont(new Font("Roboto", Font.PLAIN, 20));
		
		textFieldNomeBusiness = new JTextField();
		textFieldNomeBusiness.setFont(new Font("Roboto", Font.PLAIN, 17));
		textFieldNomeBusiness.setBackground(new Color(255,255,255));
		textFieldNomeBusiness.setBorder(new LineBorder(new Color(255,255,255),1));
		textFieldNomeBusiness.setColumns(10);
		
		textFieldTelefono = new JTextField();
		textFieldTelefono.setFont(new Font("Roboto", Font.PLAIN, 17));
		textFieldTelefono.setBackground(new Color(255,255,255));
		textFieldTelefono.setBorder(new LineBorder(new Color(255,255,255),1));
		textFieldTelefono.setColumns(10);
		
		textFieldIndirizzo = new JTextField();
		textFieldIndirizzo.setFont(new Font("Roboto", Font.PLAIN, 17));
		textFieldIndirizzo.setBackground(new Color(255,255,255));
		textFieldIndirizzo.setBorder(new LineBorder(new Color(255,255,255),1));
		textFieldIndirizzo.setColumns(10);
		
		textFieldPartitaIVA = new JTextField();
		textFieldPartitaIVA.setFont(new Font("Roboto", Font.PLAIN, 17));
		textFieldPartitaIVA.setBackground(new Color(255,255,255));
		textFieldPartitaIVA.setBorder(new LineBorder(new Color(255,255,255),1));
		textFieldPartitaIVA.setColumns(10);
		
		JLabel lineaTestoNomeBusiness = new JLabel("");
		lineaTestoNomeBusiness.setIcon(new ImageIcon(SchermataPrincipale.class.getResource("/Icone/lineaGestisciAttivita.png")));
		
		JLabel lineaTestoIndirizzo = new JLabel("");
		lineaTestoIndirizzo.setIcon(new ImageIcon(SchermataPrincipale.class.getResource("/Icone/lineaGestisciAttivita.png")));
		
		JLabel lineaTestoTelefono = new JLabel("");
		lineaTestoTelefono.setIcon(new ImageIcon(SchermataPrincipale.class.getResource("/Icone/lineaGestisciAttivita.png")));
		
		JLabel lineaTestoPartitaIVA = new JLabel("");
		lineaTestoPartitaIVA.setIcon(new ImageIcon(SchermataPrincipale.class.getResource("/Icone/lineaGestisciAttivita.png")));
		
		JLabel testoSelezionaOpzione = new JLabel("Seleziona una opzione");
		testoSelezionaOpzione.setFont(new Font("Roboto", Font.PLAIN, 20));
		
		bottoneRistoranteGestisciBusiness1 = new JButton("");
		bottoneRistoranteGestisciBusiness1.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent arg0) {
				flagFocusBottoneGestisciBusiness1 = 1;
				resettaIconeGestisciBusiness1(flagFocusBottoneGestisciBusiness1);
				cambiaIconeGestisciBusiness1(flagFocusBottoneGestisciBusiness1);
			}
		});
		bottoneRistoranteGestisciBusiness1.addMouseListener(new MouseAdapter() {
			@Override
			public void mouseEntered(MouseEvent e) {
				bottoneRistoranteGestisciBusiness1.setIcon(new ImageIcon(SchermataPrincipale.class.getResource("/Icone/bottoneRistoranteFocus.png")));
			}
			@Override
			public void mouseExited(MouseEvent e) {
				if(flagFocusBottoneGestisciBusiness1 != 1)
					bottoneRistoranteGestisciBusiness1.setIcon(new ImageIcon(SchermataPrincipale.class.getResource("/Icone/bottoneRistorante.png")));
			}
		});
		bottoneRistoranteGestisciBusiness1.setIcon(new ImageIcon(SchermataPrincipale.class.getResource("/Icone/bottoneRistorante.png")));
		bottoneRistoranteGestisciBusiness1.setOpaque(false);
		bottoneRistoranteGestisciBusiness1.setContentAreaFilled(false);
		bottoneRistoranteGestisciBusiness1.setBorderPainted(false);
		
		bottoneIntrattenimentoGestisciBusiness1 = new JButton("");
		bottoneIntrattenimentoGestisciBusiness1.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent arg0) {
				flagFocusBottoneGestisciBusiness1 = 2;
				resettaIconeGestisciBusiness1(flagFocusBottoneGestisciBusiness1);
				cambiaIconeGestisciBusiness1(flagFocusBottoneGestisciBusiness1);
			}
		});
		bottoneIntrattenimentoGestisciBusiness1.addMouseListener(new MouseAdapter() {
			@Override
			public void mouseEntered(MouseEvent e) {
				bottoneIntrattenimentoGestisciBusiness1.setIcon(new ImageIcon(SchermataPrincipale.class.getResource("/Icone/bottoneIntrattenimentoFocus.png")));
			}
			@Override
			public void mouseExited(MouseEvent e) {
				if(flagFocusBottoneGestisciBusiness1 != 2)
					bottoneIntrattenimentoGestisciBusiness1.setIcon(new ImageIcon(SchermataPrincipale.class.getResource("/Icone/bottoneIntrattenimento.png")));
			}
		});
		bottoneIntrattenimentoGestisciBusiness1.setIcon(new ImageIcon(SchermataPrincipale.class.getResource("/Icone/bottoneIntrattenimento.png")));
		bottoneIntrattenimentoGestisciBusiness1.setOpaque(false);
		bottoneIntrattenimentoGestisciBusiness1.setContentAreaFilled(false);
		bottoneIntrattenimentoGestisciBusiness1.setBorderPainted(false);
		
		bottoneAlloggioGestisciBusiness1 = new JButton("");
		bottoneAlloggioGestisciBusiness1.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent arg0) {
				flagFocusBottoneGestisciBusiness1 = 3;
				resettaIconeGestisciBusiness1(flagFocusBottoneGestisciBusiness1);
				cambiaIconeGestisciBusiness1(flagFocusBottoneGestisciBusiness1);
				
			}
		});
		bottoneAlloggioGestisciBusiness1.addMouseListener(new MouseAdapter() {
			@Override
			public void mouseEntered(MouseEvent e) {
				bottoneAlloggioGestisciBusiness1.setIcon(new ImageIcon(SchermataPrincipale.class.getResource("/Icone/bottoneAlloggioFocus.png")));
			}
			@Override
			public void mouseExited(MouseEvent e) {
				if(flagFocusBottoneGestisciBusiness1 != 3)
					bottoneAlloggioGestisciBusiness1.setIcon(new ImageIcon(SchermataPrincipale.class.getResource("/Icone/bottoneAlloggio.png")));
			}
		});
		bottoneAlloggioGestisciBusiness1.setIcon(new ImageIcon(SchermataPrincipale.class.getResource("/Icone/bottoneAlloggio.png")));
		bottoneAlloggioGestisciBusiness1.setOpaque(false);
		bottoneAlloggioGestisciBusiness1.setContentAreaFilled(false);
		bottoneAlloggioGestisciBusiness1.setBorderPainted(false);
		
		JLabel immagineDocumentoFronte = new JLabel("");
		immagineDocumentoFronte.setIcon(new ImageIcon(SchermataPrincipale.class.getResource("/Icone/InserisciDocumento.png")));
		
		JLabel testoDocumentoFronte = new JLabel("Documento Fronte");
		testoDocumentoFronte.setFont(new Font("Roboto", Font.PLAIN, 20));
		
		JLabel immagineDocumentroRetro = new JLabel("");
		immagineDocumentroRetro.setIcon(new ImageIcon(SchermataPrincipale.class.getResource("/Icone/InserisciDocumento.png")));
		
		JLabel testoDocumentroRetro = new JLabel("Documentro Retro");
		testoDocumentroRetro.setFont(new Font("Roboto", Font.PLAIN, 20));
		
		JLabel testoTipologiaGestisciBusiness1 = new JLabel("Tipologia:");
		testoTipologiaGestisciBusiness1.setFont(new Font("Roboto", Font.PLAIN, 20));
		
		JComboBox comboBoxTipologia = new JComboBox();
		
		JButton bottoneAvantiGestisciBusiness1 = new JButton("");
		bottoneAvantiGestisciBusiness1.setIcon(new ImageIcon(SchermataPrincipale.class.getResource("/Icone/AvantiButton.png")));
		bottoneAvantiGestisciBusiness1.setOpaque(false);
		bottoneAvantiGestisciBusiness1.setContentAreaFilled(false);
		bottoneAvantiGestisciBusiness1.setBorderPainted(false);
		bottoneAvantiGestisciBusiness1.addMouseListener(new MouseAdapter() {
			@Override
			public void mouseEntered(MouseEvent e) {
				bottoneAvantiGestisciBusiness1.setIcon(new ImageIcon(SchermataPrincipale.class.getResource("/Icone/AvantiButtonFocus.png")));
			}
			@Override
			public void mouseExited(MouseEvent e) {
				bottoneAvantiGestisciBusiness1.setIcon(new ImageIcon(SchermataPrincipale.class.getResource("/Icone/AvantiButton.png")));
			}
		});
		GroupLayout gl_pannelloGestisciBusiness1 = new GroupLayout(pannelloGestisciBusiness1);
		gl_pannelloGestisciBusiness1.setHorizontalGroup(
			gl_pannelloGestisciBusiness1.createParallelGroup(Alignment.LEADING)
				.addGroup(gl_pannelloGestisciBusiness1.createSequentialGroup()
					.addGap(53)
					.addComponent(testoNomeBusiness, GroupLayout.PREFERRED_SIZE, 257, GroupLayout.PREFERRED_SIZE)
					.addGap(136)
					.addComponent(testoIndirizzo, GroupLayout.DEFAULT_SIZE, 257, Short.MAX_VALUE)
					.addGap(122))
				.addGroup(gl_pannelloGestisciBusiness1.createSequentialGroup()
					.addGap(53)
					.addComponent(textFieldNomeBusiness, GroupLayout.PREFERRED_SIZE, 262, GroupLayout.PREFERRED_SIZE)
					.addGap(131)
					.addComponent(textFieldIndirizzo, GroupLayout.DEFAULT_SIZE, 262, Short.MAX_VALUE)
					.addGap(117))
				.addGroup(gl_pannelloGestisciBusiness1.createSequentialGroup()
					.addGap(53)
					.addComponent(lineaTestoNomeBusiness, GroupLayout.PREFERRED_SIZE, 262, GroupLayout.PREFERRED_SIZE)
					.addGap(131)
					.addComponent(lineaTestoIndirizzo, GroupLayout.PREFERRED_SIZE, 262, Short.MAX_VALUE)
					.addGap(117))
				.addGroup(gl_pannelloGestisciBusiness1.createSequentialGroup()
					.addGap(53)
					.addComponent(testoTelefono, GroupLayout.PREFERRED_SIZE, 257, GroupLayout.PREFERRED_SIZE)
					.addGap(136)
					.addComponent(testoPartitaIva, GroupLayout.DEFAULT_SIZE, 257, Short.MAX_VALUE)
					.addGap(122))
				.addGroup(gl_pannelloGestisciBusiness1.createSequentialGroup()
					.addGap(53)
					.addComponent(textFieldTelefono, GroupLayout.PREFERRED_SIZE, 262, GroupLayout.PREFERRED_SIZE)
					.addGap(131)
					.addComponent(textFieldPartitaIVA, GroupLayout.DEFAULT_SIZE, 262, Short.MAX_VALUE)
					.addGap(117))
				.addGroup(gl_pannelloGestisciBusiness1.createSequentialGroup()
					.addGap(53)
					.addComponent(lineaTestoTelefono, GroupLayout.PREFERRED_SIZE, 262, GroupLayout.PREFERRED_SIZE)
					.addPreferredGap(ComponentPlacement.RELATED, 131, Short.MAX_VALUE)
					.addComponent(lineaTestoPartitaIVA, GroupLayout.PREFERRED_SIZE, 262, GroupLayout.PREFERRED_SIZE)
					.addGap(117))
				.addGroup(gl_pannelloGestisciBusiness1.createSequentialGroup()
					.addGap(53)
					.addComponent(immagineDocumentoFronte, GroupLayout.PREFERRED_SIZE, 40, GroupLayout.PREFERRED_SIZE)
					.addGap(10)
					.addComponent(testoDocumentoFronte, GroupLayout.PREFERRED_SIZE, 250, GroupLayout.PREFERRED_SIZE)
					.addGap(93)
					.addComponent(immagineDocumentroRetro, GroupLayout.PREFERRED_SIZE, 40, GroupLayout.PREFERRED_SIZE)
					.addGap(10)
					.addComponent(testoDocumentroRetro, GroupLayout.DEFAULT_SIZE, 250, Short.MAX_VALUE)
					.addGap(79))
				.addGroup(gl_pannelloGestisciBusiness1.createSequentialGroup()
					.addGap(53)
					.addComponent(testoSelezionaOpzione, GroupLayout.PREFERRED_SIZE, 257, GroupLayout.PREFERRED_SIZE))
				.addGroup(gl_pannelloGestisciBusiness1.createSequentialGroup()
					.addGap(68)
					.addComponent(bottoneRistoranteGestisciBusiness1, GroupLayout.PREFERRED_SIZE, 200, Short.MAX_VALUE)
					.addGap(44)
					.addComponent(bottoneIntrattenimentoGestisciBusiness1, GroupLayout.PREFERRED_SIZE, 200, Short.MAX_VALUE)
					.addGap(44)
					.addComponent(bottoneAlloggioGestisciBusiness1, GroupLayout.PREFERRED_SIZE, 200, Short.MAX_VALUE)
					.addGap(69))
				.addGroup(gl_pannelloGestisciBusiness1.createSequentialGroup()
					.addGap(201)
					.addComponent(testoTipologiaGestisciBusiness1, GroupLayout.PREFERRED_SIZE, 100, GroupLayout.PREFERRED_SIZE)
					.addGap(18)
					.addComponent(comboBoxTipologia, GroupLayout.PREFERRED_SIZE, 240, GroupLayout.PREFERRED_SIZE)
					.addPreferredGap(ComponentPlacement.RELATED, 84, Short.MAX_VALUE)
					.addComponent(bottoneAvantiGestisciBusiness1, GroupLayout.PREFERRED_SIZE, 140, GroupLayout.PREFERRED_SIZE)
					.addGap(42))
		);
		gl_pannelloGestisciBusiness1.setVerticalGroup(
			gl_pannelloGestisciBusiness1.createParallelGroup(Alignment.LEADING)
				.addGroup(gl_pannelloGestisciBusiness1.createSequentialGroup()
					.addGap(30)
					.addGroup(gl_pannelloGestisciBusiness1.createParallelGroup(Alignment.LEADING, false)
						.addComponent(testoNomeBusiness, GroupLayout.PREFERRED_SIZE, 19, GroupLayout.PREFERRED_SIZE)
						.addComponent(testoIndirizzo, GroupLayout.PREFERRED_SIZE, 19, GroupLayout.PREFERRED_SIZE))
					.addGap(9)
					.addGroup(gl_pannelloGestisciBusiness1.createParallelGroup(Alignment.LEADING)
						.addComponent(textFieldNomeBusiness, GroupLayout.PREFERRED_SIZE, 32, GroupLayout.PREFERRED_SIZE)
						.addComponent(textFieldIndirizzo, GroupLayout.PREFERRED_SIZE, 32, GroupLayout.PREFERRED_SIZE))
					.addGap(1)
					.addGroup(gl_pannelloGestisciBusiness1.createParallelGroup(Alignment.LEADING)
						.addComponent(lineaTestoNomeBusiness)
						.addComponent(lineaTestoIndirizzo))
					.addGap(28)
					.addGroup(gl_pannelloGestisciBusiness1.createParallelGroup(Alignment.LEADING)
						.addComponent(testoTelefono, GroupLayout.PREFERRED_SIZE, 19, GroupLayout.PREFERRED_SIZE)
						.addComponent(testoPartitaIva, GroupLayout.PREFERRED_SIZE, 19, GroupLayout.PREFERRED_SIZE))
					.addGap(9)
					.addGroup(gl_pannelloGestisciBusiness1.createParallelGroup(Alignment.LEADING)
						.addComponent(textFieldTelefono, GroupLayout.PREFERRED_SIZE, 32, GroupLayout.PREFERRED_SIZE)
						.addComponent(textFieldPartitaIVA, GroupLayout.PREFERRED_SIZE, 32, GroupLayout.PREFERRED_SIZE))
					.addGap(1)
					.addGroup(gl_pannelloGestisciBusiness1.createParallelGroup(Alignment.LEADING)
						.addComponent(lineaTestoTelefono)
						.addComponent(lineaTestoPartitaIVA))
					.addGap(38)
					.addGroup(gl_pannelloGestisciBusiness1.createParallelGroup(Alignment.LEADING)
						.addComponent(immagineDocumentoFronte, GroupLayout.DEFAULT_SIZE, GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
						.addGroup(gl_pannelloGestisciBusiness1.createSequentialGroup()
							.addGap(10)
							.addComponent(testoDocumentoFronte, GroupLayout.PREFERRED_SIZE, 20, Short.MAX_VALUE)
							.addGap(10))
						.addComponent(immagineDocumentroRetro, GroupLayout.DEFAULT_SIZE, GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
						.addGroup(gl_pannelloGestisciBusiness1.createSequentialGroup()
							.addGap(10)
							.addComponent(testoDocumentroRetro, GroupLayout.PREFERRED_SIZE, 20, Short.MAX_VALUE)
							.addGap(10)))
					.addGap(47)
					.addComponent(testoSelezionaOpzione, GroupLayout.PREFERRED_SIZE, 23, Short.MAX_VALUE)
					.addGap(20)
					.addGroup(gl_pannelloGestisciBusiness1.createParallelGroup(Alignment.LEADING)
						.addComponent(bottoneRistoranteGestisciBusiness1, GroupLayout.PREFERRED_SIZE, 110, GroupLayout.PREFERRED_SIZE)
						.addComponent(bottoneIntrattenimentoGestisciBusiness1, GroupLayout.PREFERRED_SIZE, 110, GroupLayout.PREFERRED_SIZE)
						.addComponent(bottoneAlloggioGestisciBusiness1, GroupLayout.PREFERRED_SIZE, 110, GroupLayout.PREFERRED_SIZE))
					.addGap(40)
					.addGroup(gl_pannelloGestisciBusiness1.createParallelGroup(Alignment.TRAILING)
						.addGroup(gl_pannelloGestisciBusiness1.createSequentialGroup()
							.addComponent(testoTipologiaGestisciBusiness1, GroupLayout.PREFERRED_SIZE, 32, GroupLayout.PREFERRED_SIZE)
							.addGap(54))
						.addGroup(gl_pannelloGestisciBusiness1.createSequentialGroup()
							.addComponent(comboBoxTipologia, GroupLayout.PREFERRED_SIZE, 40, GroupLayout.PREFERRED_SIZE)
							.addGap(47))
						.addComponent(bottoneAvantiGestisciBusiness1, GroupLayout.PREFERRED_SIZE, 50, GroupLayout.PREFERRED_SIZE))
					.addGap(27))
		);
		pannelloGestisciBusiness1.setLayout(gl_pannelloGestisciBusiness1);
		
		JPanel pannelloGestisciBusiness3 = new JPanel();
		pannelloGestisciBusiness3.setBounds(250, 36, 850, 614);
		pannelloGestisciBusiness3.setVisible(false);
		pannelloGestisciBusiness3.setBackground(Color.WHITE);
		
		JLabel testoRegistrazioneAvvenutaConSuccesso = new JLabel("Registrazione avvenuta con successo!");
		testoRegistrazioneAvvenutaConSuccesso.setFont(new Font("Roboto", Font.PLAIN, 25));
		
		JLabel immagineVerified = new JLabel("");
		immagineVerified.setIcon(new ImageIcon(SchermataPrincipale.class.getResource("/Icone/verified.png")));
		
		JButton bottoneOKGestisciBusiness3 = new JButton("");
		bottoneOKGestisciBusiness3.setOpaque(false);
		bottoneOKGestisciBusiness3.setBorderPainted(false);
		bottoneOKGestisciBusiness3.setContentAreaFilled(false);
		bottoneOKGestisciBusiness3.addMouseListener(new MouseAdapter() {
			@Override
			public void mouseEntered(MouseEvent e) {
				bottoneOKGestisciBusiness3.setIcon(new ImageIcon(SchermataPrincipale.class.getResource("/Icone/bottoneOKFocus.png")));
			}
			@Override
			public void mouseExited(MouseEvent e) {
				bottoneOKGestisciBusiness3.setIcon(new ImageIcon(SchermataPrincipale.class.getResource("/Icone/bottoneOK.png")));
			}
		});
		bottoneOKGestisciBusiness3.setIcon(new ImageIcon(SchermataPrincipale.class.getResource("/Icone/bottoneOK.png")));
		GroupLayout gl_pannelloGestisciBusiness3 = new GroupLayout(pannelloGestisciBusiness3);
		gl_pannelloGestisciBusiness3.setHorizontalGroup(
			gl_pannelloGestisciBusiness3.createParallelGroup(Alignment.TRAILING)
				.addGroup(gl_pannelloGestisciBusiness3.createSequentialGroup()
					.addGap(352)
					.addComponent(immagineVerified, GroupLayout.DEFAULT_SIZE, GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
					.addGap(353))
				.addGroup(gl_pannelloGestisciBusiness3.createSequentialGroup()
					.addGap(197)
					.addComponent(testoRegistrazioneAvvenutaConSuccesso, GroupLayout.DEFAULT_SIZE, 430, Short.MAX_VALUE)
					.addGap(198))
				.addGroup(gl_pannelloGestisciBusiness3.createSequentialGroup()
					.addGap(643)
					.addComponent(bottoneOKGestisciBusiness3, GroupLayout.PREFERRED_SIZE, 140, GroupLayout.PREFERRED_SIZE)
					.addGap(42))
		);
		gl_pannelloGestisciBusiness3.setVerticalGroup(
			gl_pannelloGestisciBusiness3.createParallelGroup(Alignment.LEADING)
				.addGroup(gl_pannelloGestisciBusiness3.createSequentialGroup()
					.addGap(180)
					.addComponent(immagineVerified, GroupLayout.DEFAULT_SIZE, 120, Short.MAX_VALUE)
					.addGap(13)
					.addComponent(testoRegistrazioneAvvenutaConSuccesso, GroupLayout.PREFERRED_SIZE, 30, Short.MAX_VALUE)
					.addGap(194)
					.addComponent(bottoneOKGestisciBusiness3, GroupLayout.PREFERRED_SIZE, 50, GroupLayout.PREFERRED_SIZE)
					.addGap(27))
		);
		pannelloGestisciBusiness3.setLayout(gl_pannelloGestisciBusiness3);
		
		JPanel pannelloGestisciBusiness2 = new JPanel();
		pannelloGestisciBusiness2.setBounds(250, 36, 850, 614);
		pannelloGestisciBusiness2.setVisible(false);
		pannelloGestisciBusiness2.setBackground(new Color(255, 255, 255));
		
		JTextArea areaTestoDescriviBusiness2 = new JTextArea();
		areaTestoDescriviBusiness2.addFocusListener(new FocusAdapter() {
			@Override
			public void focusGained(FocusEvent e) {
				areaTestoDescriviBusiness2.setText("");
				areaTestoDescriviBusiness2.setForeground(Color.BLACK);
			}
		});
		areaTestoDescriviBusiness2.setForeground(new Color(192, 192, 192));
		areaTestoDescriviBusiness2.setBackground(new Color(255, 255, 255));
		areaTestoDescriviBusiness2.setFont(new Font("Roboto", Font.PLAIN, 17));
		areaTestoDescriviBusiness2.setRows(20);
		areaTestoDescriviBusiness2.setColumns(55);
		areaTestoDescriviBusiness2.setText("Scrivi qui! MAX(2000 caratteri)");
		areaTestoDescriviBusiness2.setForeground(Color.DARK_GRAY);
		areaTestoDescriviBusiness2.setBorder(new LineBorder(Color.BLACK,1));
		
		JLabel testoDescriviBusiness = new JLabel("Descrivi la tua attivita'");
		testoDescriviBusiness.setFont(new Font("Roboto", Font.PLAIN, 20));
		
		JButton bottoneIndietroGestisciBusiness2 = new JButton("");
		bottoneIndietroGestisciBusiness2.addMouseListener(new MouseAdapter() {
			@Override
			public void mouseEntered(MouseEvent e) {
				bottoneIndietroGestisciBusiness2.setIcon(new ImageIcon(SchermataPrincipale.class.getResource("/Icone/IndietroButtonFocus.png")));
			}
			@Override
			public void mouseExited(MouseEvent e) {
				bottoneIndietroGestisciBusiness2.setIcon(new ImageIcon(SchermataPrincipale.class.getResource("/Icone/IndietroButton.png")));
			}
		});
		bottoneIndietroGestisciBusiness2.setIcon(new ImageIcon(SchermataPrincipale.class.getResource("/Icone/IndietroButton.png")));
		bottoneIndietroGestisciBusiness2.setOpaque(false);
		bottoneIndietroGestisciBusiness2.setContentAreaFilled(false);
		bottoneIndietroGestisciBusiness2.setBorderPainted(false);
		
		bottoneAvantiGestisciBusiness2 = new JButton("");
		bottoneAvantiGestisciBusiness2.setIcon(new ImageIcon(SchermataPrincipale.class.getResource("/Icone/AvantiButton.png")));
		bottoneAvantiGestisciBusiness2.addMouseListener(new MouseAdapter() {
			@Override
			public void mouseEntered(MouseEvent e) {
				bottoneAvantiGestisciBusiness2.setIcon(new ImageIcon(SchermataPrincipale.class.getResource("/Icone/AvantiButtonFocus.png")));

			}
			@Override
			public void mouseExited(MouseEvent e) {
				bottoneAvantiGestisciBusiness2.setIcon(new ImageIcon(SchermataPrincipale.class.getResource("/Icone/AvantiButton.png")));
			}
		});
		
		pannelloBottoni = new JPanel();
		pannelloBottoni.setBounds(250, 0, 850, 36);
		pannelloBottoni.addMouseListener(new MouseAdapter() {
			@Override
			public void mousePressed(MouseEvent e) {
				clickIniziale = e.getPoint();
                setCursor(new Cursor(Cursor.HAND_CURSOR));
			}
			@Override
			public void mouseReleased(MouseEvent e) {
				setCursor(new Cursor(Cursor.DEFAULT_CURSOR));
			}
		});
		pannelloBottoni.addMouseMotionListener(new MouseMotionAdapter() {
			@Override
			public void mouseDragged(MouseEvent e) {
				int x = getLocation().x;
				int y = getLocation().y;
				int xMoved = e.getX() - clickIniziale.x;
				int yMoved = e.getY() - clickIniziale.y;
				setLocation(x + xMoved, y + yMoved);
			}
		});
		pannelloBottoni.setBackground(Color.WHITE);
		
		bottoneEsci = new JButton("");
		bottoneEsci.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent arg0) {
				System.exit(0);
			}
		});
		bottoneEsci.setIcon(new ImageIcon(SchermataAccesso.class.getResource("/Icone/X.png")));
		bottoneEsci.setBorderPainted(false);
		bottoneEsci.setContentAreaFilled(false);
		bottoneEsci.setOpaque(false);
		bottoneEsci.setFocusPainted(false);
		
		JButton bottoneMassimizza = new JButton("");
		bottoneMassimizza.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent arg0) {
				if(getExtendedState() != SchermataPrincipale.MAXIMIZED_BOTH) {
					setExtendedState(SchermataPrincipale.MAXIMIZED_BOTH);
				}else {
					setExtendedState(SchermataPrincipale.NORMAL);
				}
			}
		});
		bottoneMassimizza.setOpaque(false);
		bottoneMassimizza.setContentAreaFilled(false);
		bottoneMassimizza.setBorderPainted(false);
		bottoneMassimizza.setFocusPainted(false);
		bottoneMassimizza.setIcon(new ImageIcon(SchermataPrincipale.class.getResource("/Icone/IncreaseSize.png")));
		
		JButton bottoneMinimizza = new JButton("");
		bottoneMinimizza.setOpaque(false);
		bottoneMinimizza.setBorderPainted(false);
		bottoneMinimizza.setContentAreaFilled(false);
		bottoneMinimizza.setFocusPainted(false);
		bottoneMinimizza.setIcon(new ImageIcon(SchermataPrincipale.class.getResource("/Icone/minimizza.png")));
		bottoneMinimizza.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent arg0) {
				setState(ICONIFIED);
			}
		});
		
		pannelloBottoni.setLayout(new FlowLayout(FlowLayout.RIGHT, -10, 0));
		pannelloBottoni.add(bottoneMinimizza, BorderLayout.EAST);
		pannelloBottoni.add(bottoneMassimizza, BorderLayout.EAST);
		pannelloBottoni.add(bottoneEsci, BorderLayout.EAST);
		
			JPanel pannelloSideBar = new JPanel();
			pannelloSideBar.setBounds(0, 0, 250, 650);
			pannelloSideBar.setBackground(new Color(51,51,51));
			
	    bottoneHomepage = new JButton("");
	    bottoneHomepage.addActionListener(new ActionListener() {
	    	public void actionPerformed(ActionEvent arg0) {
	    		flagFocusBottone = 1;
	    		resettaFocusIconeSideBar(flagFocusBottone);
	    		cambiaFocusIconeSideBar(flagFocusBottone);
	    	}
	    });
	    bottoneHomepage.addMouseListener(new MouseAdapter() {
	    	@Override
	    	public void mouseEntered(MouseEvent e) {
	    		bottoneHomepage.setIcon(new ImageIcon(SchermataPrincipale.class.getResource("/Icone/homepageFocus.png")));
	    	}
	    	@Override
	    	public void mouseExited(MouseEvent e) {
	    		if(flagFocusBottone != 1)
	    			bottoneHomepage.setIcon(new ImageIcon(SchermataPrincipale.class.getResource("/Icone/homepage.png")));
	    		else 
	    			bottoneHomepage.setIcon(new ImageIcon(SchermataPrincipale.class.getResource("/Icone/homepageFocus.png")));
	    	}

	    });
	    bottoneHomepage.setIcon(new ImageIcon(SchermataPrincipale.class.getResource("/Icone/homepage.png")));
	    bottoneHomepage.setOpaque(false);
	    bottoneHomepage.setFocusPainted(false);
	    bottoneHomepage.setContentAreaFilled(false);
	    bottoneHomepage.setBorderPainted(false);
	    
	    bottoneRistoranti = new JButton("");
	    bottoneRistoranti.addActionListener(new ActionListener() {
	    	public void actionPerformed(ActionEvent arg0) {
	    		flagFocusBottone = 2;
	    		resettaFocusIconeSideBar(flagFocusBottone);
	    		cambiaFocusIconeSideBar(flagFocusBottone);
	    	}
	    });
	    bottoneRistoranti.addMouseListener(new MouseAdapter() {
	    	@Override
	    	public void mouseEntered(MouseEvent e) {
	    		bottoneRistoranti.setIcon(new ImageIcon(SchermataPrincipale.class.getResource("/Icone/ristorantiFocus.png")));
	    	}
	    	@Override
	    	public void mouseExited(MouseEvent e) {
	    		if(flagFocusBottone != 2)
	    			bottoneRistoranti.setIcon(new ImageIcon(SchermataPrincipale.class.getResource("/Icone/ristoranti.png")));
	    		else
	    			bottoneRistoranti.setIcon(new ImageIcon(SchermataPrincipale.class.getResource("/Icone/ristorantiFocus.png")));
	    	}
	    });
	    bottoneRistoranti.setIcon(new ImageIcon(SchermataPrincipale.class.getResource("/Icone/ristoranti.png")));
	    bottoneRistoranti.setOpaque(false);
	    bottoneRistoranti.setFocusPainted(false);
	    bottoneRistoranti.setContentAreaFilled(false);
	    bottoneRistoranti.setBorderPainted(false);
	    
	    
	    bottoneIntrattenimento = new JButton("");
	    bottoneIntrattenimento.addMouseListener(new MouseAdapter() {
	    	@Override
	    	public void mouseEntered(MouseEvent e) {
	    		bottoneIntrattenimento.setIcon(new ImageIcon(SchermataPrincipale.class.getResource("/Icone/intrattenimentoFocus.png")));
	    	}
	    	@Override
	    	public void mouseExited(MouseEvent e) {
	    		if(flagFocusBottone != 3)
	    			bottoneIntrattenimento.setIcon(new ImageIcon(SchermataPrincipale.class.getResource("/Icone/intrattenimento.png")));
	    		else
	    			bottoneIntrattenimento.setIcon(new ImageIcon(SchermataPrincipale.class.getResource("/Icone/intrattenimentoFocus.png")));
	    	}
	    });
	    bottoneIntrattenimento.setOpaque(false);
	    bottoneIntrattenimento.setFocusPainted(false);
	    bottoneIntrattenimento.setContentAreaFilled(false);
	    bottoneIntrattenimento.setBorderPainted(false);
	    bottoneIntrattenimento.setIcon(new ImageIcon(SchermataPrincipale.class.getResource("/Icone/intrattenimento.png")));
	    bottoneIntrattenimento.addActionListener(new ActionListener() {
	    	public void actionPerformed(ActionEvent arg0) {
	    		flagFocusBottone = 3;
	    		resettaFocusIconeSideBar(flagFocusBottone);
	    		cambiaFocusIconeSideBar(flagFocusBottone);
	    	}
	    });
	    
	    bottoneAlloggi = new JButton("");
	    bottoneAlloggi.addActionListener(new ActionListener() {
	    	public void actionPerformed(ActionEvent arg0) {
	    		flagFocusBottone = 4;
	    		resettaFocusIconeSideBar(flagFocusBottone);
	    		cambiaFocusIconeSideBar(flagFocusBottone);
	    	}
	    });
	    bottoneAlloggi.addMouseListener(new MouseAdapter() {
	    	@Override
	    	public void mouseEntered(MouseEvent e) {
	    		bottoneAlloggi.setIcon(new ImageIcon(SchermataPrincipale.class.getResource("/Icone/alloggiFocus.png")));
	    	}
	    	@Override
	    	public void mouseExited(MouseEvent e) {
	    		if(flagFocusBottone != 4)
	    			bottoneAlloggi.setIcon(new ImageIcon(SchermataPrincipale.class.getResource("/Icone/alloggi.png")));
	    		else
	    			bottoneAlloggi.setIcon(new ImageIcon(SchermataPrincipale.class.getResource("/Icone/alloggiFocus.png")));
	    	}
	    });
	    bottoneAlloggi.setIcon(new ImageIcon(SchermataPrincipale.class.getResource("/Icone/alloggi.png")));
	    bottoneAlloggi.setOpaque(false);
	    bottoneAlloggi.setFocusPainted(false);
	    bottoneAlloggi.setContentAreaFilled(false);
	    bottoneAlloggi.setBorderPainted(false);
	    JPanel pannelloCerca = new JPanel();
	    pannelloCerca.setBackground(new Color(51,51,51));
	    
	    JButton bottoneGestisciBusiness = new JButton("");
	    bottoneGestisciBusiness.setIcon(new ImageIcon(SchermataPrincipale.class.getResource("/Icone/gestisciAttvita.png")));
	    bottoneGestisciBusiness.setOpaque(false);
	    bottoneGestisciBusiness.setFocusPainted(false);
	    bottoneGestisciBusiness.setContentAreaFilled(false);
	    bottoneGestisciBusiness.setBorderPainted(false);
	    
	    GroupLayout gl_pannelloSideBar = new GroupLayout(pannelloSideBar);
	    gl_pannelloSideBar.setHorizontalGroup(
	    	gl_pannelloSideBar.createParallelGroup(Alignment.LEADING)
	    		.addComponent(bottoneHomepage, GroupLayout.PREFERRED_SIZE, 250, GroupLayout.PREFERRED_SIZE)
	    		.addComponent(bottoneRistoranti, GroupLayout.PREFERRED_SIZE, 250, GroupLayout.PREFERRED_SIZE)
	    		.addComponent(bottoneIntrattenimento, GroupLayout.PREFERRED_SIZE, 250, GroupLayout.PREFERRED_SIZE)
	    		.addComponent(bottoneAlloggi, GroupLayout.PREFERRED_SIZE, 250, GroupLayout.PREFERRED_SIZE)
	    		.addComponent(pannelloCerca, GroupLayout.PREFERRED_SIZE, 250, GroupLayout.PREFERRED_SIZE)
	    		.addComponent(bottoneGestisciBusiness, GroupLayout.PREFERRED_SIZE, 250, GroupLayout.PREFERRED_SIZE)
	    );
	    gl_pannelloSideBar.setVerticalGroup(
	    	gl_pannelloSideBar.createParallelGroup(Alignment.LEADING)
	    		.addGroup(gl_pannelloSideBar.createSequentialGroup()
	    			.addComponent(bottoneHomepage, GroupLayout.DEFAULT_SIZE, 80, Short.MAX_VALUE)
	    			.addComponent(bottoneRistoranti, GroupLayout.DEFAULT_SIZE, 80, Short.MAX_VALUE)
	    			.addComponent(bottoneIntrattenimento, GroupLayout.DEFAULT_SIZE, 80, Short.MAX_VALUE)
	    			.addComponent(bottoneAlloggi, GroupLayout.DEFAULT_SIZE, 80, Short.MAX_VALUE)
	    			.addComponent(pannelloCerca, GroupLayout.DEFAULT_SIZE, 180, Short.MAX_VALUE)
	    			.addComponent(bottoneGestisciBusiness, GroupLayout.DEFAULT_SIZE, 150, Short.MAX_VALUE))
	    );
	    
	    textFieldCosa = new JTextField();
	    textFieldCosa.addFocusListener(new FocusAdapter() {
	    	@Override
	    	public void focusGained(FocusEvent e) {
	    		textFieldCosa.setText("");
	    		textFieldCosa.setForeground(Color.WHITE);
	    	}
	    	@Override
	    	public void focusLost(FocusEvent e) {
	    		if(textFieldCosa.getText().isEmpty() ){
	    			textFieldCosa.setText("Cosa?");
	    			textFieldCosa.setForeground(Color.LIGHT_GRAY);
	    		}
	    	}
	    });
	    textFieldCosa.setColumns(10);
	    textFieldCosa.setFont(new Font("Roboto", Font.PLAIN, 20));
	    textFieldCosa.setBackground(new Color(51,51,51));
	    textFieldCosa.setBorder(new LineBorder(new Color(51,51,51),1));
	    textFieldCosa.setText("Cosa?");
	    textFieldCosa.setForeground(Color.LIGHT_GRAY);
	    textFieldCosa.setCaretColor(Color.WHITE);
	    
	    textFieldDove = new JTextField();
	    textFieldDove.addFocusListener(new FocusAdapter() {
	    	@Override
	    	public void focusGained(FocusEvent e) {
	    		textFieldDove.setText("");
	    		textFieldDove.setForeground(Color.WHITE);
	    	}
	    	@Override
	    	public void focusLost(FocusEvent e) {
	    		if(textFieldDove.getText().isEmpty()) {
	    			textFieldDove.setText("Dove?");
	    			textFieldDove.setForeground(Color.LIGHT_GRAY);
	    		}
	    	}
	    });
	    textFieldDove.setColumns(10);
	    textFieldDove.setFont(new Font("Roboto", Font.PLAIN, 20));
	    textFieldDove.setBackground(new Color(51,51,51));
	    textFieldDove.setBorder(new LineBorder(new Color(51,51,51),1));
	    textFieldDove.setText("Dove?");
	    textFieldDove.setForeground(Color.LIGHT_GRAY);
	    textFieldDove.setCaretColor(Color.WHITE);
	    
	    JButton bottoneCercaSideBar = new JButton("");
	    bottoneCercaSideBar.addMouseListener(new MouseAdapter() {
	    	@Override
	    	public void mouseEntered(MouseEvent e) {
	    		bottoneCercaSideBar.setIcon(new ImageIcon(SchermataPrincipale.class.getResource("/Icone/CercaButtonFocus.png")));
	    		setCursor(new Cursor(Cursor.HAND_CURSOR));
	    	}
	    	@Override
	    	public void mouseExited(MouseEvent e) {
	    		setCursor(new Cursor(Cursor.DEFAULT_CURSOR));
	    		bottoneCercaSideBar.setIcon(new ImageIcon(SchermataPrincipale.class.getResource("/Icone/CercaButton.png")));
	    	}
	    });
	    
	    bottoneCercaSideBar.setOpaque(false);
	    bottoneCercaSideBar.setBorderPainted(false);
	    bottoneCercaSideBar.setContentAreaFilled(false);
	    bottoneCercaSideBar.setIcon(new ImageIcon(SchermataPrincipale.class.getResource("/Icone/CercaButton.png")));
	    
	    JLabel lineaTestoCosaSideBar = new JLabel("");
	    lineaTestoCosaSideBar.setIcon(new ImageIcon(SchermataPrincipale.class.getResource("/Icone/lineaTestoBianca.png")));
	    
	    JLabel lineaTestoDoveSideBar = new JLabel("");
	    lineaTestoDoveSideBar.setIcon(new ImageIcon(SchermataPrincipale.class.getResource("/Icone/lineaTestoBianca.png")));
	    GroupLayout gl_pannelloCerca = new GroupLayout(pannelloCerca);
	    gl_pannelloCerca.setHorizontalGroup(
	    	gl_pannelloCerca.createParallelGroup(Alignment.LEADING)
	    		.addGroup(gl_pannelloCerca.createSequentialGroup()
	    			.addGap(20)
	    			.addComponent(textFieldCosa, GroupLayout.PREFERRED_SIZE, 210, GroupLayout.PREFERRED_SIZE))
	    		.addGroup(gl_pannelloCerca.createSequentialGroup()
	    			.addGap(20)
	    			.addComponent(lineaTestoCosaSideBar))
	    		.addGroup(gl_pannelloCerca.createSequentialGroup()
	    			.addGap(20)
	    			.addComponent(textFieldDove, GroupLayout.PREFERRED_SIZE, 210, GroupLayout.PREFERRED_SIZE))
	    		.addGroup(gl_pannelloCerca.createSequentialGroup()
	    			.addGap(20)
	    			.addComponent(lineaTestoDoveSideBar))
	    		.addGroup(gl_pannelloCerca.createSequentialGroup()
	    			.addGap(70)
	    			.addComponent(bottoneCercaSideBar, GroupLayout.PREFERRED_SIZE, 120, GroupLayout.PREFERRED_SIZE))
	    );
	    gl_pannelloCerca.setVerticalGroup(
	    	gl_pannelloCerca.createParallelGroup(Alignment.LEADING)
	    		.addGroup(gl_pannelloCerca.createSequentialGroup()
	    			.addGap(20)
	    			.addComponent(textFieldCosa, GroupLayout.PREFERRED_SIZE, 40, GroupLayout.PREFERRED_SIZE)
	    			.addComponent(lineaTestoCosaSideBar)
	    			.addGap(19)
	    			.addComponent(textFieldDove, GroupLayout.PREFERRED_SIZE, 40, GroupLayout.PREFERRED_SIZE)
	    			.addComponent(lineaTestoDoveSideBar)
	    			.addGap(19)
	    			.addComponent(bottoneCercaSideBar, GroupLayout.PREFERRED_SIZE, 40, GroupLayout.PREFERRED_SIZE))
	    );
	    pannelloCerca.setLayout(gl_pannelloCerca);
	    pannelloSideBar.setLayout(gl_pannelloSideBar);
		
		bottoneAvantiGestisciBusiness2.setOpaque(false);
		bottoneAvantiGestisciBusiness2.setContentAreaFilled(false);
		bottoneAvantiGestisciBusiness2.setBorderPainted(false);
		
		JLabel testoTrascinaImmagini = new JLabel("Trascina Immagini");
		testoTrascinaImmagini.setFont(new Font("Roboto", Font.PLAIN, 20));
		
		JLabel immaginiFoto2 = new JLabel("");
		immaginiFoto2.setIcon(new ImageIcon(SchermataPrincipale.class.getResource("/Icone/camera.png")));
		
		JLabel immagineFoto1 = new JLabel("");
		immagineFoto1.setIcon(new ImageIcon(SchermataPrincipale.class.getResource("/Icone/camera.png")));
		
		JLabel imagineFoto3 = new JLabel("");
		imagineFoto3.setIcon(new ImageIcon(SchermataPrincipale.class.getResource("/Icone/camera.png")));
		GroupLayout gl_pannelloGestisciBusiness2 = new GroupLayout(pannelloGestisciBusiness2);
		gl_pannelloGestisciBusiness2.setHorizontalGroup(
			gl_pannelloGestisciBusiness2.createParallelGroup(Alignment.LEADING)
				.addGroup(gl_pannelloGestisciBusiness2.createSequentialGroup()
					.addGap(27)
					.addComponent(testoDescriviBusiness, GroupLayout.PREFERRED_SIZE, 417, GroupLayout.PREFERRED_SIZE))
				.addGroup(gl_pannelloGestisciBusiness2.createSequentialGroup()
					.addGap(27)
					.addComponent(areaTestoDescriviBusiness2, GroupLayout.DEFAULT_SIZE, 795, Short.MAX_VALUE)
					.addGap(28))
				.addGroup(gl_pannelloGestisciBusiness2.createSequentialGroup()
					.addGap(27)
					.addComponent(testoTrascinaImmagini, GroupLayout.PREFERRED_SIZE, 252, GroupLayout.PREFERRED_SIZE))
				.addGroup(gl_pannelloGestisciBusiness2.createSequentialGroup()
					.addGap(100)
					.addComponent(immagineFoto1, GroupLayout.DEFAULT_SIZE, 140, Short.MAX_VALUE)
					.addGap(122)
					.addComponent(immaginiFoto2, GroupLayout.DEFAULT_SIZE, 141, Short.MAX_VALUE)
					.addGap(122)
					.addComponent(imagineFoto3, GroupLayout.DEFAULT_SIZE, 128, Short.MAX_VALUE)
					.addGap(97))
				.addGroup(gl_pannelloGestisciBusiness2.createSequentialGroup()
					.addGap(27)
					.addComponent(bottoneIndietroGestisciBusiness2, GroupLayout.PREFERRED_SIZE, 140, GroupLayout.PREFERRED_SIZE)
					.addPreferredGap(ComponentPlacement.RELATED, 515, Short.MAX_VALUE)
					.addComponent(bottoneAvantiGestisciBusiness2, GroupLayout.PREFERRED_SIZE, 140, GroupLayout.PREFERRED_SIZE)
					.addGap(28))
		);
		gl_pannelloGestisciBusiness2.setVerticalGroup(
			gl_pannelloGestisciBusiness2.createParallelGroup(Alignment.LEADING)
				.addGroup(gl_pannelloGestisciBusiness2.createSequentialGroup()
					.addGap(8)
					.addComponent(testoDescriviBusiness, GroupLayout.PREFERRED_SIZE, 23, GroupLayout.PREFERRED_SIZE)
					.addGap(12)
					.addComponent(areaTestoDescriviBusiness2, GroupLayout.DEFAULT_SIZE, 247, Short.MAX_VALUE)
					.addGap(41)
					.addComponent(testoTrascinaImmagini, GroupLayout.PREFERRED_SIZE, 37, GroupLayout.PREFERRED_SIZE)
					.addGap(12)
					.addGroup(gl_pannelloGestisciBusiness2.createParallelGroup(Alignment.LEADING)
						.addComponent(immagineFoto1)
						.addComponent(immaginiFoto2)
						.addComponent(imagineFoto3, GroupLayout.DEFAULT_SIZE, GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE))
					.addGap(32)
					.addGroup(gl_pannelloGestisciBusiness2.createParallelGroup(Alignment.LEADING)
						.addComponent(bottoneIndietroGestisciBusiness2, GroupLayout.PREFERRED_SIZE, 50, GroupLayout.PREFERRED_SIZE)
						.addComponent(bottoneAvantiGestisciBusiness2, GroupLayout.PREFERRED_SIZE, 50, GroupLayout.PREFERRED_SIZE))
					.addGap(24))
		);
		pannelloGestisciBusiness2.setLayout(gl_pannelloGestisciBusiness2);
		
		JPanel pannelloScriviRecensione = new JPanel();
		pannelloScriviRecensione.setBounds(250, 36, 850, 614);
		pannelloScriviRecensione.setVisible(false); // temporaneo
		pannelloScriviRecensione.setBackground(Color.WHITE);
		pannelloScriviRecensione.setLayout(null);
		
		JButton bottonePubblicaScriviRecensione = new JButton("");
		bottonePubblicaScriviRecensione.addMouseListener(new MouseAdapter() {
			@Override
			public void mouseEntered(MouseEvent e) {
				bottonePubblicaScriviRecensione.setIcon(new ImageIcon(SchermataPrincipale.class.getResource("/Icone/bottonePubblicaFocus.png")));
			}
			@Override
			public void mouseExited(MouseEvent e) {
				bottonePubblicaScriviRecensione.setIcon(new ImageIcon(SchermataPrincipale.class.getResource("/Icone/bottonePubblica.png")));
			}
		});
		bottonePubblicaScriviRecensione.setIcon(new ImageIcon(SchermataPrincipale.class.getResource("/Icone/bottonePubblica.png")));
		bottonePubblicaScriviRecensione.setBounds(668, 537, 140, 50);
		bottonePubblicaScriviRecensione.setOpaque(false);
		bottonePubblicaScriviRecensione.setBorderPainted(false);
		bottonePubblicaScriviRecensione.setContentAreaFilled(false);
		pannelloScriviRecensione.add(bottonePubblicaScriviRecensione);
		
		JButton bottoneCancellaScriviRecensione = new JButton("");
		bottoneCancellaScriviRecensione.addMouseListener(new MouseAdapter() {
			@Override
			public void mouseEntered(MouseEvent e) {
				bottoneCancellaScriviRecensione.setIcon(new ImageIcon(SchermataPrincipale.class.getResource("/Icone/bottoneCancellaFocus.png")));
			}
			@Override
			public void mouseExited(MouseEvent e) {
				bottoneCancellaScriviRecensione.setIcon(new ImageIcon(SchermataPrincipale.class.getResource("/Icone/bottoneCancella.png")));
			}
		});
		bottoneCancellaScriviRecensione.setIcon(new ImageIcon(SchermataPrincipale.class.getResource("/Icone/bottoneCancella.png")));
		bottoneCancellaScriviRecensione.setBounds(42, 537, 140, 50);
		bottoneCancellaScriviRecensione.setOpaque(false);
		bottoneCancellaScriviRecensione.setBorderPainted(false);
		bottoneCancellaScriviRecensione.setContentAreaFilled(false);
		pannelloScriviRecensione.add(bottoneCancellaScriviRecensione);
		
		JLabel immagineScriviRecensione_1 = new JLabel("");
		immagineScriviRecensione_1.setIcon(new ImageIcon(SchermataPrincipale.class.getResource("/Icone/camera.png")));
		immagineScriviRecensione_1.setBounds(104, 390, 128, 128);
		pannelloScriviRecensione.add(immagineScriviRecensione_1);
		
		JLabel immagineScriviRecensione_2 = new JLabel("");
		immagineScriviRecensione_2.setIcon(new ImageIcon(SchermataPrincipale.class.getResource("/Icone/camera.png")));
		immagineScriviRecensione_2.setBounds(361, 390, 128, 128);
		pannelloScriviRecensione.add(immagineScriviRecensione_2);
		
		JLabel immagineScriviRecensione_3 = new JLabel("");
		immagineScriviRecensione_3.setIcon(new ImageIcon(SchermataPrincipale.class.getResource("/Icone/camera.png")));
		immagineScriviRecensione_3.setBounds(617, 390, 128, 128);
		pannelloScriviRecensione.add(immagineScriviRecensione_3);
		
		JTextArea textAreaScriviRecensione = new JTextArea();
		textAreaScriviRecensione.setRows(30);
		textAreaScriviRecensione.addFocusListener(new FocusAdapter() {
			@Override
			public void focusGained(FocusEvent e) {
				textAreaScriviRecensione.setText("");
				textAreaScriviRecensione.setForeground(Color.BLACK);
			}
		});
		textAreaScriviRecensione.setForeground(Color.DARK_GRAY);
		textAreaScriviRecensione.setBorder(new LineBorder(Color.BLACK,1));
		textAreaScriviRecensione.setFont(new Font("Roboto", Font.PLAIN, 17));
		textAreaScriviRecensione.setText("Scrivi qui la tua recensione (MAX 2000 caratteri)");
		textAreaScriviRecensione.setBounds(42, 53, 766, 240);
		pannelloScriviRecensione.add(textAreaScriviRecensione);
		
		JLabel testoInfoScriviRegistrazione_1 = new JLabel("La tua recensione verra'\u00A0 pubblicata e sara'\u00A0 visibile a tutti gli utenti registrati");
		testoInfoScriviRegistrazione_1.setFont(new Font("Roboto", Font.PLAIN, 13));
		testoInfoScriviRegistrazione_1.setBounds(42, 11, 766, 30);
		pannelloScriviRecensione.add(testoInfoScriviRegistrazione_1);
		
		JLabel lblUnaVoltaPubblicata = new JLabel("Una volta pubblicata la recensione non sara' piu' possibile recensire di nuovo questa attivita' ");
		lblUnaVoltaPubblicata.setFont(new Font("Roboto", Font.PLAIN, 13));
		lblUnaVoltaPubblicata.setBounds(42, 303, 766, 26);
		pannelloScriviRecensione.add(lblUnaVoltaPubblicata);
		
		JLabel lblNewLabel = new JLabel("Trascina qui le tue immagini");
		lblNewLabel.setFont(new Font("Roboto", Font.PLAIN, 24));
		lblNewLabel.setBounds(42, 340, 766, 39);
		pannelloScriviRecensione.add(lblNewLabel);
		
		JPanel pannelloRicerche = new JPanel();
		pannelloRicerche.setBounds(250, 36, 850, 614);
		pannelloRicerche.setBackground(Color.WHITE);
		
	    JPanel pannelloRisulatoRicerca = new JPanel();
	    pannelloRisulatoRicerca.setBackground(Color.WHITE);
	    pannelloRisulatoRicerca.setLayout(new WrapLayout(WrapLayout.CENTER));
	    
	    ScrollPaneVerde scorrimentoRisultati = new ScrollPaneVerde();
	    scorrimentoRisultati.setViewportView(pannelloRisulatoRicerca);
	    scorrimentoRisultati.setBounds(250, 36, 850, 614);
	    scorrimentoRisultati.setBackground(Color.WHITE);
	    scorrimentoRisultati.setBorder(new LineBorder(Color.WHITE,1));
	    
	    scorrimentoRisultati.setVerticalScrollBarPolicy(ScrollPaneConstants.VERTICAL_SCROLLBAR_ALWAYS);
	    scorrimentoRisultati.setHorizontalScrollBarPolicy(ScrollPaneConstants.HORIZONTAL_SCROLLBAR_NEVER);
	    scorrimentoRisultati.getVerticalScrollBar().setUnitIncrement(15);
	    scorrimentoRisultati.getVerticalScrollBar().setBackground(Color.WHITE);
	    
		for(int i=0; i<20; i++) {
			try {
				Locale aggiungiLocale = new Locale("dio", "dio",
						"https://www.lalucedimaria.it/wp-content/uploads/2018/10/Ges%C3%B9-MIsericordioso-1-e1569917989814.jpg");
				aggiungiLocale.gestioneStelle(4, true);
				pannelloRisulatoRicerca.add(aggiungiLocale);
			} catch (NumeroStelleNonValidoException e) {
				// TODO: handle exception
			}
		}
		
		GroupLayout gl_pannelloRicerche = new GroupLayout(pannelloRicerche);
		gl_pannelloRicerche.setHorizontalGroup(
			gl_pannelloRicerche.createParallelGroup(Alignment.LEADING)
				.addComponent(scorrimentoRisultati, Alignment.TRAILING, GroupLayout.DEFAULT_SIZE, 850, Short.MAX_VALUE)
		);
		gl_pannelloRicerche.setVerticalGroup(
			gl_pannelloRicerche.createParallelGroup(Alignment.LEADING)
				.addComponent(scorrimentoRisultati, Alignment.TRAILING, GroupLayout.DEFAULT_SIZE, 614, Short.MAX_VALUE)
		);
		pannelloRicerche.setLayout(gl_pannelloRicerche);
		getContentPane().setLayout(null);
		
		JPanel pannelloRecensioni = new JPanel();
		pannelloRecensioni.setBackground(Color.WHITE);
		pannelloRecensioni.setBounds(250, 36, 850, 614);
		getContentPane().add(pannelloRecensioni);
		pannelloRecensioni.setLayout(null);
		
		JButton bottoneRecensisci = new JButton("");
		bottoneRecensisci.addMouseListener(new MouseAdapter() {
			@Override
			public void mouseEntered(MouseEvent e) {
				bottoneRecensisci.setIcon(new ImageIcon(SchermataPrincipale.class.getResource("/Icone/bottoneRecensioneFocus.png")));
			}
			@Override
			public void mouseExited(MouseEvent e) {
				bottoneRecensisci.setIcon(new ImageIcon(SchermataPrincipale.class.getResource("/Icone/bottoneRecensione.png")));
			}
		});
		bottoneRecensisci.setIcon(new ImageIcon(SchermataPrincipale.class.getResource("/Icone/bottoneRecensione.png")));
		bottoneRecensisci.setBounds(612, 36, 199, 50);
		bottoneRecensisci.setOpaque(false);
		bottoneRecensisci.setContentAreaFilled(false);
		bottoneRecensisci.setBorderPainted(false);
		pannelloRecensioni.add(bottoneRecensisci);
		
		JLabel testoNomeBusinessRecensioni = new JLabel("Nome");
		testoNomeBusinessRecensioni.setFont(new Font("Roboto", Font.PLAIN, 18));
		testoNomeBusinessRecensioni.setBounds(31, 36, 280, 50);
		pannelloRecensioni.add(testoNomeBusinessRecensioni);
		getContentPane().add(pannelloSideBar);
		getContentPane().add(pannelloBottoni);
		getContentPane().add(pannelloRicerche);
		getContentPane().add(pannelloGestisciBusiness2);
		getContentPane().add(pannelloScriviRecensione);
		getContentPane().add(pannelloGestisciBusiness1);
		
	}
	
	private void cambiaFocusIconeSideBar(int flag) {
		switch(flag) {
			case 1:
				bottoneHomepage.setIcon(new ImageIcon(SchermataPrincipale.class.getResource("/Icone/homepageFocus.png")));
				break;
			case 2:
				bottoneRistoranti.setIcon(new ImageIcon(SchermataPrincipale.class.getResource("/Icone/ristorantiFocus.png")));
				break;
			case 3:
				bottoneIntrattenimento.setIcon(new ImageIcon(SchermataPrincipale.class.getResource("/Icone/intrattenimentoFocus.png")));
				break;
			case 4:
				bottoneAlloggi.setIcon(new ImageIcon(SchermataPrincipale.class.getResource("/Icone/alloggiFocus.png")));
				break;
		}
	}
	
	private void resettaFocusIconeSideBar(int flag) {
		bottoneHomepage.setIcon(new ImageIcon(SchermataPrincipale.class.getResource("/Icone/homepage.png")));
		bottoneRistoranti.setIcon(new ImageIcon(SchermataPrincipale.class.getResource("/Icone/ristoranti.png")));
		bottoneIntrattenimento.setIcon(new ImageIcon(SchermataPrincipale.class.getResource("/Icone/intrattenimento.png")));
		bottoneAlloggi.setIcon(new ImageIcon(SchermataPrincipale.class.getResource("/Icone/alloggi.png")));
	}
	
	private void cambiaIconeGestisciBusiness1(int flag) {
		switch(flag) {
			case 1:
				bottoneRistoranteGestisciBusiness1.setIcon(new ImageIcon(SchermataPrincipale.class.getResource("/Icone/bottoneRistoranteFocus.png")));
				break;
			case 2:
				bottoneIntrattenimentoGestisciBusiness1.setIcon(new ImageIcon(SchermataPrincipale.class.getResource("/Icone/bottoneIntrattenimentoFocus.png")));
				break;
			case 3:
				bottoneAlloggioGestisciBusiness1.setIcon(new ImageIcon(SchermataPrincipale.class.getResource("/Icone/bottoneAlloggioFocus.png")));
				break;
		}
	}
	
	private void resettaIconeGestisciBusiness1(int flag) {
		bottoneRistoranteGestisciBusiness1.setIcon(new ImageIcon(SchermataPrincipale.class.getResource("/Icone/bottoneRistorante.png")));
		bottoneAlloggioGestisciBusiness1.setIcon(new ImageIcon(SchermataPrincipale.class.getResource("/Icone/bottoneAlloggio.png")));
		bottoneIntrattenimentoGestisciBusiness1.setIcon(new ImageIcon(SchermataPrincipale.class.getResource("/Icone/bottoneIntrattenimento.png")));
	}
}
