package gui.pannelliSchermataPrincipale;

import java.awt.Color;
import java.awt.Font;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.awt.event.MouseAdapter;
import java.awt.event.MouseEvent;

import javax.swing.ImageIcon;
import javax.swing.JButton;
import javax.swing.JComboBox;
import javax.swing.JLabel;
import javax.swing.JPanel;
import javax.swing.JTextField;
import javax.swing.border.LineBorder;

import gui.SchermataPrincipale;

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
	private JLabel immagineDocumentoFronte;
	private JLabel testoDocumentoFronte;
	private JLabel immagineDocumentroRetro;
	private JLabel testoDocumentroRetro;
	private JLabel testoSelezionaOpzione;
	private JButton bottoneRistorante;
	private JButton bottoneIntrattenimento;
	private JButton bottoneAlloggio;
	private JButton bottoneAvanti;
	private JLabel testoTipologia;
	private JComboBox comboBoxTipologia;
	int flagFocusBottoneGestisciBusiness1;
	
	public PubblicaBusiness1() {
		setLayout(null);
		setSize(850, 614);
		setBackground(Color.WHITE);
		
		
		generaCampoNomeBusiness();
		generaCampoTelefono();
		generaCampoIndirizzo();
		generaCampoPartitaIVA();
		
		generaCampoDocumentoFronte();
		generaCampoDocumentoRetro();	
		generaTestoSelezionaOpzione();
		
		generaTestoSelezionaOpzione();
		generaBottoneRistorante();		
		generaBottoneIntrattenimento();
		generaBottoneAlloggio();
		
		generaBottoneAvanti();
		
		testoTipologia = new JLabel("Tipologia:");
		testoTipologia.setBounds(201, 501, 100, 32);
		testoTipologia.setFont(new Font("Roboto", Font.PLAIN, 20));
		add(testoTipologia);
		
		comboBoxTipologia = new JComboBox();
		comboBoxTipologia.setBounds(319, 500, 240, 40);
		add(comboBoxTipologia);
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
		add(bottoneAvanti);
	}


	private void generaBottoneAlloggio() {
		bottoneAlloggio = new JButton("");
		bottoneAlloggio.setBounds(572, 350, 209, 110);
		bottoneAlloggio.setIcon(new ImageIcon(SchermataPrincipale.class.getResource("/Icone/bottoneAlloggio.png")));
		bottoneAlloggio.setOpaque(false);
		bottoneAlloggio.setContentAreaFilled(false);
		bottoneAlloggio.setBorderPainted(false);
		bottoneAlloggio.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent arg0) {
				flagFocusBottoneGestisciBusiness1 = 3;
				resettaIconeGestisciBusiness1(flagFocusBottoneGestisciBusiness1);
				cambiaIconeGestisciBusiness1(flagFocusBottoneGestisciBusiness1);
				
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
		bottoneIntrattenimento = new JButton("");
		bottoneIntrattenimento.setBounds(320, 350, 208, 110);
		bottoneIntrattenimento.setIcon(new ImageIcon(SchermataPrincipale.class.getResource("/Icone/bottoneIntrattenimento.png")));
		bottoneIntrattenimento.setOpaque(false);
		bottoneIntrattenimento.setContentAreaFilled(false);
		bottoneIntrattenimento.setBorderPainted(false);
		bottoneIntrattenimento.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent arg0) {
				flagFocusBottoneGestisciBusiness1 = 2;
				resettaIconeGestisciBusiness1(flagFocusBottoneGestisciBusiness1);
				cambiaIconeGestisciBusiness1(flagFocusBottoneGestisciBusiness1);
			}
		});
		bottoneIntrattenimento.addMouseListener(new MouseAdapter() {
			@Override
			public void mouseEntered(MouseEvent e) {
				bottoneIntrattenimento.setIcon(new ImageIcon(SchermataPrincipale.class.getResource("/Icone/bottoneIntrattenimentoFocus.png")));
			}
			@Override
			public void mouseExited(MouseEvent e) {
				if(flagFocusBottoneGestisciBusiness1 != 2)
					bottoneIntrattenimento.setIcon(new ImageIcon(SchermataPrincipale.class.getResource("/Icone/bottoneIntrattenimento.png")));
			}
		});
		add(bottoneIntrattenimento);
	}


	private void generaBottoneRistorante() {
		bottoneRistorante = new JButton("");
		bottoneRistorante.setBounds(68, 350, 208, 110);
		bottoneRistorante.setIcon(new ImageIcon(SchermataPrincipale.class.getResource("/Icone/bottoneRistorante.png")));
		bottoneRistorante.setOpaque(false);
		bottoneRistorante.setContentAreaFilled(false);
		bottoneRistorante.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent arg0) {
				flagFocusBottoneGestisciBusiness1 = 1;
				resettaIconeGestisciBusiness1(flagFocusBottoneGestisciBusiness1);
				cambiaIconeGestisciBusiness1(flagFocusBottoneGestisciBusiness1);
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

	
	private void cambiaIconeGestisciBusiness1(int flag) {
		switch(flag) {
			case 1:
				bottoneRistorante.setIcon(new ImageIcon(SchermataPrincipale.class.getResource("/Icone/bottoneRistoranteFocus.png")));
				break;
			case 2:
				bottoneIntrattenimento.setIcon(new ImageIcon(SchermataPrincipale.class.getResource("/Icone/bottoneIntrattenimentoFocus.png")));
				break;
			case 3:
				bottoneAlloggio.setIcon(new ImageIcon(SchermataPrincipale.class.getResource("/Icone/bottoneAlloggioFocus.png")));
				break;
		}
	}
	
	
	private void resettaIconeGestisciBusiness1(int flag) {
		bottoneRistorante.setIcon(new ImageIcon(SchermataPrincipale.class.getResource("/Icone/bottoneRistorante.png")));
		bottoneAlloggio.setIcon(new ImageIcon(SchermataPrincipale.class.getResource("/Icone/bottoneAlloggio.png")));
		bottoneIntrattenimento.setIcon(new ImageIcon(SchermataPrincipale.class.getResource("/Icone/bottoneIntrattenimento.png")));
	}
	
	
	private void generaTestoSelezionaOpzione() {
		testoSelezionaOpzione = new JLabel("Seleziona una opzione");
		testoSelezionaOpzione.setBounds(53, 307, 257, 23);
		testoSelezionaOpzione.setFont(new Font("Roboto", Font.PLAIN, 20));
		add(testoSelezionaOpzione);
	}


	private void generaCampoDocumentoRetro() {
		immagineDocumentroRetro = new JLabel("");
		immagineDocumentroRetro.setBounds(446, 220, 40, 40);
		immagineDocumentroRetro.setIcon(new ImageIcon(SchermataPrincipale.class.getResource("/Icone/InserisciDocumento.png")));
		add(immagineDocumentroRetro);
		
		testoDocumentroRetro = new JLabel("Documentro Retro");
		testoDocumentroRetro.setBounds(496, 230, 275, 20);
		testoDocumentroRetro.setFont(new Font("Roboto", Font.PLAIN, 20));
		add(testoDocumentroRetro);
	}


	private void generaCampoDocumentoFronte() {
		immagineDocumentoFronte = new JLabel("");
		immagineDocumentoFronte.setBounds(53, 220, 40, 40);
		immagineDocumentoFronte.setIcon(new ImageIcon(SchermataPrincipale.class.getResource("/Icone/InserisciDocumento.png")));
		add(immagineDocumentoFronte);
		
		testoDocumentoFronte = new JLabel("Documento Fronte");
		testoDocumentoFronte.setBounds(103, 230, 250, 20);
		testoDocumentoFronte.setFont(new Font("Roboto", Font.PLAIN, 20));
		add(testoDocumentoFronte);
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
		lineaTestoPartitaIVA.setBounds(471, 181, 262, 1);
		lineaTestoPartitaIVA.setIcon(new ImageIcon(SchermataPrincipale.class.getResource("/Icone/lineaGestisciAttivita.png")));
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
}
