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
import javax.swing.JOptionPane;
import javax.swing.JPanel;
import javax.swing.JTextArea;
import javax.swing.ScrollPaneConstants;
import javax.swing.border.LineBorder;

import gestione.Controller;
import gui.SchermataPrincipale;
import res.ScrollPaneVerde;

import java.awt.event.ActionListener;
import java.awt.event.ActionEvent;
import javax.swing.SwingConstants;
import java.awt.event.KeyAdapter;
import java.awt.event.KeyEvent;
import java.awt.event.ComponentAdapter;
import java.awt.event.ComponentEvent;

public class PubblicaBusiness2 extends JPanel {

	private static final long serialVersionUID = 1L;
	private JLabel testoDescriviBusiness;
	private JTextArea textAreaDescriviBusiness;
	private JLabel testoTrascinaImmagini;
	private JLabel iconaImmagine;
	private JButton bottoneCancella;
	private JButton bottoneAvanti;
	private JLabel testoErroreInserisciDescrizione;
	private JLabel testoErroreInserisciImmagine;
	
	private JPanel pannelloImmagini;
	
	private Controller ctrl;
	
	 public PubblicaBusiness2(Controller ctrl) {
	 	addComponentListener(new ComponentAdapter() {
	 		@Override
	 		public void componentHidden(ComponentEvent e) {
	 			pulisciPannello();
	 		}
	 	});

		this.ctrl = ctrl;
		setLayout(null);
		setSize(850, 614);
		setVisible(false);
		setBackground(Color.WHITE);
		
		generaCampoDescriviBusiness();
		generaTestoTrascinaImmagini();
		
		generaAggiungiImmagine();
		
		generaBottoneCancella();
		generaBottoneAvanti();
		
		generaTestoErroreInserisciDescrizione();
		generaTestoErroreInserisciImmagine();
		
		generaVisualizzatoreImmagini();
	}

	public void generaVisualizzatoreImmagini() {
		pannelloImmagini = new JPanel();
		pannelloImmagini.setBackground(Color.WHITE);
		pannelloImmagini.setLayout(new FlowLayout(FlowLayout.LEFT));
		
		ScrollPaneVerde elencoImmagini = new ScrollPaneVerde();
		elencoImmagini.setVerticalScrollBarPolicy(ScrollPaneConstants.VERTICAL_SCROLLBAR_NEVER);
		elencoImmagini.setHorizontalScrollBarPolicy(ScrollPaneConstants.HORIZONTAL_SCROLLBAR_ALWAYS);
		elencoImmagini.setBounds(27, 366, 650, 166);
		add(elencoImmagini);
		
		elencoImmagini.setViewportView(pannelloImmagini);
	}

	private void generaTestoErroreInserisciImmagine() {
		testoErroreInserisciImmagine = new JLabel("Inserisci almeno una immagine");
		testoErroreInserisciImmagine.setHorizontalAlignment(SwingConstants.CENTER);
		testoErroreInserisciImmagine.setForeground(Color.RED);
		testoErroreInserisciImmagine.setFont(new Font("Roboto", Font.PLAIN, 16));
		testoErroreInserisciImmagine.setBounds(177, 558, 495, 22);
		testoErroreInserisciImmagine.setVisible(false);
		add(testoErroreInserisciImmagine);
	}

	private void generaTestoErroreInserisciDescrizione() {
		testoErroreInserisciDescrizione = new JLabel("Inserisci la descrizione");
		testoErroreInserisciDescrizione.setHorizontalAlignment(SwingConstants.CENTER);
		testoErroreInserisciDescrizione.setFont(new Font("Roboto", Font.PLAIN, 16));
		testoErroreInserisciDescrizione.setForeground(Color.RED);
		testoErroreInserisciDescrizione.setBounds(27, 300, 795, 23);
		testoErroreInserisciDescrizione.setVisible(false);
		add(testoErroreInserisciDescrizione);
	}

	private void generaBottoneAvanti() {
		bottoneAvanti = new JButton("");
		bottoneAvanti.setBounds(682, 543, 140, 50);
		bottoneAvanti.setIcon(new ImageIcon(SchermataPrincipale.class.getResource("/Icone/AvantiButton.png")));
		bottoneAvanti.setOpaque(false);
		bottoneAvanti.setContentAreaFilled(false);
		bottoneAvanti.setBorderPainted(false);
		bottoneAvanti.setFocusPainted(false);
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
			public void actionPerformed(ActionEvent e) {
				ctrl.procediInPubblicaBusiness3(textAreaDescriviBusiness.getText());
			}
		});
		add(bottoneAvanti);
	}
	
	private void generaBottoneCancella() {
		bottoneCancella = new JButton("");
		bottoneCancella.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent arg0) {
				if(JOptionPane.showConfirmDialog(null, "Annullando perderai tutte le modifiche fatte, vuoi procedere?", "Conferma", JOptionPane.YES_NO_OPTION) == JOptionPane.YES_OPTION) {
					Controller.getSchermataPrincipaleFrame().mostraHomepage();
				}
			}
		});
		bottoneCancella.setBounds(27, 543, 140, 50);
		bottoneCancella.setIcon(new ImageIcon(PubblicaBusiness2.class.getResource("/Icone/bottoneCancella.png")));
		bottoneCancella.setOpaque(false);
		bottoneCancella.setContentAreaFilled(false);
		bottoneCancella.setBorderPainted(false);
		bottoneCancella.setFocusPainted(false);
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
		add(bottoneCancella);
	}

	private void generaAggiungiImmagine() {
		iconaImmagine = new JLabel("");
		iconaImmagine.setBounds(694, 380, 128, 128);
		iconaImmagine.setIcon(new ImageIcon(SchermataPrincipale.class.getResource("/Icone/camera.png")));
		iconaImmagine.addMouseListener(new MouseAdapter() {
			@Override
			public void mouseClicked(MouseEvent e) {
				aggiungiImmagineAVisualizzatore(ctrl.caricaImmagineLocale());
				pannelloImmagini.revalidate();
			}
		});
		add(iconaImmagine);
	}

	private void generaTestoTrascinaImmagini() {
		testoTrascinaImmagini = new JLabel("Trascina Immagini");
		testoTrascinaImmagini.setBounds(27, 318, 315, 37);
		testoTrascinaImmagini.setFont(new Font("Roboto", Font.PLAIN, 20));
		add(testoTrascinaImmagini);
	}

	private void generaCampoDescriviBusiness() {
		testoDescriviBusiness = new JLabel("Descrivi la tua attivita'");
		testoDescriviBusiness.setFont(new Font("Roboto", Font.PLAIN, 20));
		testoDescriviBusiness.setBounds(27, 8, 417, 23);
		add(testoDescriviBusiness);
		
		textAreaDescriviBusiness = new JTextArea();
		textAreaDescriviBusiness.addKeyListener(new KeyAdapter() {
			@Override
			public void keyPressed(KeyEvent e) {
				if((((e.getKeyChar() >= '0' && e.getKeyChar() <= '9') || (e.getKeyChar() >= 'A' && e.getKeyChar() <= 'Z') || (e.getKeyChar() >= 'a' && e.getKeyChar() <= 'z'))
						&& textAreaDescriviBusiness.getText().length() <= 1999) || e.getKeyCode() ==  KeyEvent.VK_BACK_SPACE || e.getKeyCode() ==  KeyEvent.VK_SPACE ||
						e.getKeyCode() ==  KeyEvent.VK_DELETE)
					textAreaDescriviBusiness.setEditable(true);
				else
					textAreaDescriviBusiness.setEditable(false);
			}
		});
		textAreaDescriviBusiness.setForeground(new Color(192, 192, 192));
		textAreaDescriviBusiness.setBackground(new Color(255, 255, 255));
		textAreaDescriviBusiness.setFont(new Font("Roboto", Font.PLAIN, 17));
		textAreaDescriviBusiness.setRows(20);
		textAreaDescriviBusiness.setColumns(55);
		textAreaDescriviBusiness.setText("Scrivi qui! MAX(2000 caratteri)");
		textAreaDescriviBusiness.setForeground(Color.DARK_GRAY);
		textAreaDescriviBusiness.setBorder(new LineBorder(Color.BLACK,1));
		textAreaDescriviBusiness.setBounds(27, 43, 795, 247);
		textAreaDescriviBusiness.setLineWrap(true);
		textAreaDescriviBusiness.setWrapStyleWord(true);
		textAreaDescriviBusiness.addMouseListener(new MouseAdapter() {
			@Override
			public void mouseClicked(MouseEvent e) {
				if((textAreaDescriviBusiness.getText().isEmpty() || textAreaDescriviBusiness.getText().isBlank()) ||
						textAreaDescriviBusiness.getText().equals("Scrivi qui! MAX(2000 caratteri)")) {
					textAreaDescriviBusiness.setText("");
					textAreaDescriviBusiness.setForeground(Color.BLACK);
				}
			}
		});
		add(textAreaDescriviBusiness);
	}
	
	
	//METODI
	
	
	public void pulisciPannello() {
		textAreaDescriviBusiness.setText("Scrivi qui! MAX(2000 caratteri)");
		textAreaDescriviBusiness.setForeground(Color.DARK_GRAY);
		pannelloImmagini.removeAll();
	}

	public void resettaVisibilitaErrori() {
		testoErroreInserisciDescrizione.setVisible(false);
		testoErroreInserisciImmagine.setVisible(false);
	}
	
	public void mostraErroreInserisciDescrizione() {
		testoErroreInserisciDescrizione.setText("Inserisci la descrizione");
		testoErroreInserisciDescrizione.setVisible(true);
	}
	
	public void mostraErroreInserisciImmagine() {
		testoErroreInserisciImmagine.setText("Inserisci almeno una immagine");
		testoErroreInserisciImmagine.setVisible(true);
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
}
