package gui.pannelliSchermataPrincipale;

import java.awt.Color;
import java.awt.FlowLayout;
import java.awt.Font;
import java.awt.Image;
import java.awt.event.FocusAdapter;
import java.awt.event.FocusEvent;
import java.awt.event.MouseAdapter;
import java.awt.event.MouseEvent;
import java.io.File;
import java.io.IOException;

import javax.imageio.ImageIO;
import javax.swing.ImageIcon;
import javax.swing.JButton;
import javax.swing.JLabel;
import javax.swing.JPanel;
import javax.swing.JTextArea;
import javax.swing.ScrollPaneConstants;
import javax.swing.border.LineBorder;

import gestione.Controller;
import gui.SchermataPrincipale;
import res.ScrollPaneVerde;
import java.awt.event.ActionListener;
import java.awt.event.ActionEvent;

public class ScriviRecensione extends JPanel {
	private static final long serialVersionUID = 1L;
	
	private JButton bottonePubblica;
	private JButton bottoneCancella;
	private JLabel immagineFoto_1;
	private JPanel pannelloImmagini;
	private JTextArea textAreaScriviRecensione;
	private JLabel testoInfo_1;
	private JLabel testoTrascinaFoto;
	
	private JPanel pannelloVotazioniStelle;
	private JLabel immagineStella1;
	private JLabel immagineStella2;
	private JLabel immagineStella3;
	private JLabel immagineStella4;
	private JLabel immagineStella5;
	private int numStelleSelezionate = 0;
	
	private Controller ctrl;

	public ScriviRecensione(Controller ctrl) {
		this.ctrl = ctrl;
		
		setSize(850, 614);
		setVisible(false);
		setBackground(Color.WHITE);
		setLayout(null);
		
		generaBottonePubblica();
		generaBottoneCancella();
		
		generaImmagineFoto_1();
		generaVisualizzatoreImmagini();
		
		generaPannelloVotazioniStelle();
		
		generaTextAreaScriviRecensione();
		generaTestoInfo_1();
		generaTestoTrascinaFoto();
		
	}

	private void generaPannelloVotazioniStelle() {
		pannelloVotazioniStelle = new JPanel();
		pannelloVotazioniStelle.setBackground(Color.WHITE);
		pannelloVotazioniStelle.setBounds(588, 20, 240, 41);
		pannelloVotazioniStelle.setLayout(null);
		add(pannelloVotazioniStelle);
		
		generaImmagineStella1();
		generaImmagineStella2();		
		generaImmagineStella3();		
		generaImmagineStella4();	
		generaImmagineStella5();
	}

	private void generaImmagineStella5() {
		immagineStella5 = new JLabel("");
		immagineStella5.setIcon(new ImageIcon(ScriviRecensione.class.getResource("/Icone/stellaVuota.png")));
		immagineStella5.setBounds(200, 0, 40, 40);
		immagineStella5.addMouseListener(new MouseAdapter() {
			@Override
			public void mouseClicked(MouseEvent e) {
				selezionaStelle(1);
			}
		});
		pannelloVotazioniStelle.add(immagineStella5);
	}

	private void generaImmagineStella4() {
		immagineStella4 = new JLabel("");
		immagineStella4.setIcon(new ImageIcon(ScriviRecensione.class.getResource("/Icone/stellaVuota.png")));
		immagineStella4.setBounds(150, 0, 40, 40);
		immagineStella4.addMouseListener(new MouseAdapter() {
			@Override
			public void mouseClicked(MouseEvent e) {
				selezionaStelle(4);
			}
		});
		pannelloVotazioniStelle.add(immagineStella4);
	}

	private void generaImmagineStella3() {
		immagineStella3 = new JLabel("");
		immagineStella3.setIcon(new ImageIcon(ScriviRecensione.class.getResource("/Icone/stellaVuota.png")));
		immagineStella3.setBounds(100, 0, 40, 40);
		immagineStella3.addMouseListener(new MouseAdapter() {
			@Override
			public void mouseClicked(MouseEvent e) {
				selezionaStelle(3);
			}
		});
		pannelloVotazioniStelle.add(immagineStella3);
	}

	private void generaImmagineStella2() {
		immagineStella2 = new JLabel("");
		immagineStella2.setIcon(new ImageIcon(ScriviRecensione.class.getResource("/Icone/stellaVuota.png")));
		immagineStella2.setBounds(50, 0, 40, 40);
		immagineStella2.addMouseListener(new MouseAdapter() {
			@Override
			public void mouseClicked(MouseEvent e) {
				selezionaStelle(2);
			}
		});
		pannelloVotazioniStelle.add(immagineStella2);
	}

	private void generaImmagineStella1() {
		immagineStella1 = new JLabel("");
		immagineStella1.setIcon(new ImageIcon(ScriviRecensione.class.getResource("/Icone/stellaVuota.png")));
		immagineStella1.setBounds(0, 0, 40, 40);
		immagineStella1.addMouseListener(new MouseAdapter() {
			@Override
			public void mouseClicked(MouseEvent e) {
				selezionaStelle(1);
			}
		});
		pannelloVotazioniStelle.add(immagineStella1);
	}

	private void generaTestoTrascinaFoto() {
		testoTrascinaFoto = new JLabel("Trascina qui le tue immagini");
		testoTrascinaFoto.setFont(new Font("Roboto", Font.PLAIN, 24));
		testoTrascinaFoto.setBounds(27, 304, 650, 39);
		add(testoTrascinaFoto);
	}

	private void generaTestoInfo_1() {
		testoInfo_1 = new JLabel("<html>La tua recensione verr&#224 pubblicata e sar&#224 visibile a tutti gli utenti registrati</html>");
		testoInfo_1.setFont(new Font("Roboto", Font.PLAIN, 13));
		testoInfo_1.setBounds(27, 37, 470, 30);
		add(testoInfo_1);
	}

	private void generaTextAreaScriviRecensione() {
		textAreaScriviRecensione = new JTextArea();
		textAreaScriviRecensione.setRows(30);
		textAreaScriviRecensione.setWrapStyleWord(true);
		textAreaScriviRecensione.setLineWrap(true);
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
		textAreaScriviRecensione.setBounds(27, 72, 801, 221);
		add(textAreaScriviRecensione);
	}

	private void generaImmagineFoto_1() {
		immagineFoto_1 = new JLabel("");
		immagineFoto_1.addMouseListener(new MouseAdapter() {
			@Override
			public void mouseClicked(MouseEvent e) {
				aggiungiImmagineAVisualizzatore(ctrl.caricaImmagineRecensione());
				pannelloImmagini.revalidate();
			}
		});
		immagineFoto_1.setIcon(new ImageIcon(SchermataPrincipale.class.getResource("/Icone/camera.png")));
		immagineFoto_1.setBounds(700, 369, 128, 128);
		add(immagineFoto_1);
	}

	private void generaBottoneCancella() {
		bottoneCancella = new JButton("");
		bottoneCancella.addMouseListener(new MouseAdapter() {
			@Override
			public void mouseEntered(MouseEvent e) {
				bottoneCancella.setIcon(new ImageIcon(SchermataPrincipale.class.getResource("/Icone/bottoneCancellaFocus.png")));
			}
			@Override
			public void mouseExited(MouseEvent e) {
				bottoneCancella.setIcon(new ImageIcon(SchermataPrincipale.class.getResource("/Icone/bottoneCancella.png")));
			}
		});
		bottoneCancella.setIcon(new ImageIcon(SchermataPrincipale.class.getResource("/Icone/bottoneCancella.png")));
		bottoneCancella.setBounds(27, 541, 140, 50);
		bottoneCancella.setOpaque(false);
		bottoneCancella.setBorderPainted(false);
		bottoneCancella.setContentAreaFilled(false);
		add(bottoneCancella);
	}

	private void generaBottonePubblica() {
		bottonePubblica = new JButton("");
		bottonePubblica.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent e) {
				ctrl.pubblicaRecensione(textAreaScriviRecensione.getText(), numStelleSelezionate);
			}
		});
		bottonePubblica.addMouseListener(new MouseAdapter() {
			@Override
			public void mouseEntered(MouseEvent e) {
				bottonePubblica.setIcon(new ImageIcon(SchermataPrincipale.class.getResource("/Icone/bottonePubblicaFocus.png")));
			}
			@Override
			public void mouseExited(MouseEvent e) {
				bottonePubblica.setIcon(new ImageIcon(SchermataPrincipale.class.getResource("/Icone/bottonePubblica.png")));
			}
		});
		
		bottonePubblica.setIcon(new ImageIcon(SchermataPrincipale.class.getResource("/Icone/bottonePubblica.png")));
		bottonePubblica.setBounds(688, 541, 140, 50);
		bottonePubblica.setOpaque(false);
		bottonePubblica.setBorderPainted(false);
		bottonePubblica.setContentAreaFilled(false);
		add(bottonePubblica);
	}
	
	public void generaVisualizzatoreImmagini() {
		pannelloImmagini = new JPanel();
		pannelloImmagini.setBackground(Color.WHITE);
		pannelloImmagini.setLayout(new FlowLayout(FlowLayout.LEFT));
		
		ScrollPaneVerde elencoImmagini = new ScrollPaneVerde();
		elencoImmagini.setVerticalScrollBarPolicy(ScrollPaneConstants.VERTICAL_SCROLLBAR_NEVER);
		elencoImmagini.setHorizontalScrollBarPolicy(ScrollPaneConstants.HORIZONTAL_SCROLLBAR_ALWAYS);
		elencoImmagini.setBounds(27, 354, 650, 166);
		add(elencoImmagini);
		
		elencoImmagini.setViewportView(pannelloImmagini);
	}
	
	private void aggiungiImmagineAVisualizzatore(File nuovaImmagine) {
		try {
			Image imgScalata = new ImageIcon(ImageIO.read(nuovaImmagine)).getImage().getScaledInstance(210, 140, java.awt.Image.SCALE_SMOOTH);
			
			JLabel immagine = new JLabel();
			immagine.setSize(210, 140);
			immagine.setIcon(new ImageIcon(imgScalata));
			
			pannelloImmagini.add(immagine);
		} catch (IOException e) {
			e.printStackTrace();
		}
	}
	
	private void svuotaStelle() {
		immagineStella1.setIcon(new ImageIcon(ScriviRecensione.class.getResource("/Icone/stellaVuota.png")));
		immagineStella2.setIcon(new ImageIcon(ScriviRecensione.class.getResource("/Icone/stellaVuota.png")));
		immagineStella3.setIcon(new ImageIcon(ScriviRecensione.class.getResource("/Icone/stellaVuota.png")));
		immagineStella4.setIcon(new ImageIcon(ScriviRecensione.class.getResource("/Icone/stellaVuota.png")));
		immagineStella5.setIcon(new ImageIcon(ScriviRecensione.class.getResource("/Icone/stellaVuota.png")));
	}
	
	private void selezionaStelle(int flag) {
		svuotaStelle();
		numStelleSelezionate = flag;
		switch(flag) {
			case 1 :
				immagineStella1.setIcon(new ImageIcon(ScriviRecensione.class.getResource("/Icone/stella.png")));
				break;
				
			case 2:
				immagineStella1.setIcon(new ImageIcon(ScriviRecensione.class.getResource("/Icone/stella.png")));
				immagineStella2.setIcon(new ImageIcon(ScriviRecensione.class.getResource("/Icone/stella.png")));
				break;
				
			case 3:
				immagineStella1.setIcon(new ImageIcon(ScriviRecensione.class.getResource("/Icone/stella.png")));
				immagineStella2.setIcon(new ImageIcon(ScriviRecensione.class.getResource("/Icone/stella.png")));
				immagineStella3.setIcon(new ImageIcon(ScriviRecensione.class.getResource("/Icone/stella.png")));
				break;
				
			case 4:
				immagineStella1.setIcon(new ImageIcon(ScriviRecensione.class.getResource("/Icone/stella.png")));
				immagineStella2.setIcon(new ImageIcon(ScriviRecensione.class.getResource("/Icone/stella.png")));
				immagineStella3.setIcon(new ImageIcon(ScriviRecensione.class.getResource("/Icone/stella.png")));
				immagineStella4.setIcon(new ImageIcon(ScriviRecensione.class.getResource("/Icone/stella.png")));
				break;
				
			case 5:
				immagineStella1.setIcon(new ImageIcon(ScriviRecensione.class.getResource("/Icone/stella.png")));
				immagineStella2.setIcon(new ImageIcon(ScriviRecensione.class.getResource("/Icone/stella.png")));
				immagineStella3.setIcon(new ImageIcon(ScriviRecensione.class.getResource("/Icone/stella.png")));
				immagineStella4.setIcon(new ImageIcon(ScriviRecensione.class.getResource("/Icone/stella.png")));
				immagineStella5.setIcon(new ImageIcon(ScriviRecensione.class.getResource("/Icone/stella.png")));
				break;
		}
	}
}
