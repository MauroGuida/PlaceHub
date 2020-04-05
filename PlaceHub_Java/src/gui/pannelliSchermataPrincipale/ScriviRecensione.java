package gui.pannelliSchermataPrincipale;

import java.awt.Color;
import java.awt.FlowLayout;
import java.awt.Font;
import java.awt.Image;
import java.awt.event.MouseAdapter;
import java.awt.event.MouseEvent;
import java.io.File;
import java.io.IOException;

import javax.imageio.ImageIO;
import javax.swing.ImageIcon;
import javax.swing.JButton;
import javax.swing.JLabel;
import javax.swing.JPanel;
import javax.swing.ScrollPaneConstants;

import gestione.Controller;
import gui.SchermataPrincipale;
import oggetti.TextAreaConScrollPaneVerde;
import res.ScrollPaneVerde;
import java.awt.event.ActionListener;
import java.awt.event.ActionEvent;
import java.awt.event.ComponentAdapter;
import java.awt.event.ComponentEvent;
import javax.swing.GroupLayout;
import javax.swing.GroupLayout.Alignment;

public class ScriviRecensione extends JPanel {
	private static final long serialVersionUID = 1L;
	
	private JButton bottonePubblica;
	private JButton bottoneCancella;
	private JLabel immagineFoto_1;
	private JPanel pannelloImmagini;
	private TextAreaConScrollPaneVerde textAreaScriviRecensione;
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
	private ScrollPaneVerde elencoImmagini;

	public ScriviRecensione(Controller ctrl) {
		addComponentListener(new ComponentAdapter() {
			@Override
			public void componentShown(ComponentEvent e) {
				pulisciPannello();
			}
		});
		
		this.ctrl = ctrl;
		
		setSize(850, 614);
		setVisible(false);
		setBackground(Color.WHITE);
		
		generaBottonePubblica();
		generaBottoneCancella();
		
		generaImmagineFoto_1();
		generaVisualizzatoreImmagini();
		
		generaPannelloVotazioniStelle();
		
		generaTextAreaScriviRecensione();
		generaTestoInfo_1();
		generaTestoTrascinaFoto();
		
		
		GroupLayout groupLayout = new GroupLayout(this);
		groupLayout.setHorizontalGroup(
			groupLayout.createParallelGroup(Alignment.LEADING)
				.addGroup(groupLayout.createSequentialGroup()
					.addGap(27)
					.addGroup(groupLayout.createParallelGroup(Alignment.TRAILING)
						.addGroup(groupLayout.createSequentialGroup()
							.addComponent(testoInfo_1, GroupLayout.DEFAULT_SIZE, 470, Short.MAX_VALUE)
							.addGap(91)
							.addComponent(pannelloVotazioniStelle, GroupLayout.DEFAULT_SIZE, 240, Short.MAX_VALUE))
						.addComponent(textAreaScriviRecensione, GroupLayout.DEFAULT_SIZE, 801, Short.MAX_VALUE)
						.addGroup(groupLayout.createSequentialGroup()
							.addComponent(testoTrascinaFoto, GroupLayout.DEFAULT_SIZE, 650, Short.MAX_VALUE)
							.addGap(151))
						.addGroup(groupLayout.createSequentialGroup()
							.addComponent(elencoImmagini, GroupLayout.DEFAULT_SIZE, 650, Short.MAX_VALUE)
							.addGap(23)
							.addComponent(immagineFoto_1))
						.addGroup(groupLayout.createSequentialGroup()
							.addComponent(bottoneCancella, GroupLayout.PREFERRED_SIZE, 140, GroupLayout.PREFERRED_SIZE)
							.addGap(521)
							.addComponent(bottonePubblica, GroupLayout.PREFERRED_SIZE, 140, GroupLayout.PREFERRED_SIZE)))
					.addGap(22))
		);
		groupLayout.setVerticalGroup(
			groupLayout.createParallelGroup(Alignment.LEADING)
				.addGroup(groupLayout.createSequentialGroup()
					.addGap(26)
					.addGroup(groupLayout.createParallelGroup(Alignment.TRAILING)
						.addComponent(testoInfo_1, GroupLayout.PREFERRED_SIZE, 30, GroupLayout.PREFERRED_SIZE)
						.addComponent(pannelloVotazioniStelle, GroupLayout.PREFERRED_SIZE, 41, GroupLayout.PREFERRED_SIZE))
					.addGap(5)
					.addComponent(textAreaScriviRecensione, GroupLayout.DEFAULT_SIZE, 221, Short.MAX_VALUE)
					.addGap(11)
					.addComponent(testoTrascinaFoto, GroupLayout.PREFERRED_SIZE, 39, GroupLayout.PREFERRED_SIZE)
					.addGap(11)
					.addGroup(groupLayout.createParallelGroup(Alignment.LEADING)
						.addComponent(elencoImmagini, GroupLayout.DEFAULT_SIZE, 166, Short.MAX_VALUE)
						.addGroup(groupLayout.createSequentialGroup()
							.addGap(15)
							.addComponent(immagineFoto_1)))
					.addGap(21)
					.addGroup(groupLayout.createParallelGroup(Alignment.LEADING)
						.addComponent(bottoneCancella, GroupLayout.PREFERRED_SIZE, 50, GroupLayout.PREFERRED_SIZE)
						.addComponent(bottonePubblica, GroupLayout.PREFERRED_SIZE, 50, GroupLayout.PREFERRED_SIZE))
					.addGap(23))
		);
		setLayout(groupLayout);
	}

	private void generaPannelloVotazioniStelle() {
		pannelloVotazioniStelle = new JPanel();
		pannelloVotazioniStelle.setBackground(Color.WHITE);
		pannelloVotazioniStelle.setLayout(new FlowLayout(FlowLayout.CENTER, 0, 0));
		
		generaImmagineStella1();
		generaImmagineStella2();		
		generaImmagineStella3();		
		generaImmagineStella4();	
		generaImmagineStella5();
	}

	private void generaImmagineStella5() {
		immagineStella5 = new JLabel("");
		immagineStella5.setIcon(new ImageIcon(ScriviRecensione.class.getResource("/Icone/stellaVuota.png")));
		immagineStella5.addMouseListener(new MouseAdapter() {
			@Override
			public void mouseClicked(MouseEvent e) {
				selezionaStelle(5);
			}
		});
		pannelloVotazioniStelle.add(immagineStella5);
	}

	private void generaImmagineStella4() {
		immagineStella4 = new JLabel("");
		immagineStella4.setIcon(new ImageIcon(ScriviRecensione.class.getResource("/Icone/stellaVuota.png")));
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
	}

	private void generaTestoInfo_1() {
		testoInfo_1 = new JLabel("<html>La tua recensione verr&#224 pubblicata e sar&#224 visibile a tutti gli utenti registrati</html>");
		testoInfo_1.setFont(new Font("Roboto", Font.PLAIN, 13));
	}

	private void generaTextAreaScriviRecensione() {
		textAreaScriviRecensione = new TextAreaConScrollPaneVerde();
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
		bottoneCancella.setOpaque(false);
		bottoneCancella.setBorderPainted(false);
		bottoneCancella.setContentAreaFilled(false);
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
		bottonePubblica.setOpaque(false);
		bottonePubblica.setBorderPainted(false);
		bottonePubblica.setContentAreaFilled(false);
	}
	
	public void generaVisualizzatoreImmagini() {
		pannelloImmagini = new JPanel();
		pannelloImmagini.setBackground(Color.WHITE);
		pannelloImmagini.setLayout(new FlowLayout(FlowLayout.LEFT));
		
		elencoImmagini = new ScrollPaneVerde();
		elencoImmagini.setVerticalScrollBarPolicy(ScrollPaneConstants.VERTICAL_SCROLLBAR_NEVER);
		elencoImmagini.setHorizontalScrollBarPolicy(ScrollPaneConstants.HORIZONTAL_SCROLLBAR_ALWAYS);
		
		elencoImmagini.setViewportView(pannelloImmagini);
	}
	
	private void aggiungiImmagineAVisualizzatore(File nuovaImmagine) {
		try {
			JLabel immagine = new JLabel();
			Image imgScalata = new ImageIcon(ImageIO.read(nuovaImmagine)).getImage().getScaledInstance(210, 140, java.awt.Image.SCALE_SMOOTH);
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

	public void pulisciPannello() {
		textAreaScriviRecensione.setText("Scrivi qui! MAX(2000 caratteri)");
		textAreaScriviRecensione.setForeground(Color.DARK_GRAY);
		pannelloImmagini.removeAll();
		numStelleSelezionate = 0;
		svuotaStelle();
	}
}
