package gui.pannelliSchermataPrincipale;

import java.awt.Color;
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
import javax.swing.border.LineBorder;

import gestione.Controller;
import gui.DialogConfermaRegistrazioneBusiness;
import gui.SchermataPrincipale;
import res.ScrollPaneVerde;
import res.WrapLayout;

import java.awt.event.ActionListener;
import java.awt.event.ActionEvent;
import javax.swing.SwingConstants;

public class PubblicaBusiness2 extends JPanel {

	private static final long serialVersionUID = 1L;
	private JLabel testoDescriviBusiness;
	private JTextArea textAreaDescriviBusiness;
	private JLabel testoTrascinaImmagini;
	private JLabel iconaImmagine;
	private JButton bottoneIndietro;
	private JButton bottoneAvanti;
	private JLabel testoErroreInserisciDescrizione;
	private JLabel testoErroreInserisciImmagine;
	
	private JPanel pannelloImmagini;
	
	private DialogConfermaRegistrazioneBusiness dialogConferma;
	
	private Controller ctrl;
	
	 public PubblicaBusiness2(Controller ctrl) {
		this.ctrl = ctrl;
		setLayout(null);
		setSize(850, 614);
		setVisible(false);
		setBackground(Color.WHITE);
		
		generaCampoDescriviBusiness();
		generaTestoTrascinaImmagini();
		
		generaAggiungiImmagine();
		
		generaBottoneIndietro();
		generaBottoneAvanti();
		
		generaTestoErroreInserisciDescrizione();
		generaTestoErroreInserisciImmagine();
		
		generaVisualizzatoreImmagini();
		
		dialogConferma = new DialogConfermaRegistrazioneBusiness();
		dialogConferma.setVisible(false);
	}

	public void generaVisualizzatoreImmagini() {
		pannelloImmagini = new JPanel();
		pannelloImmagini.setBackground(Color.WHITE);
		pannelloImmagini.setLayout(new WrapLayout(WrapLayout.LEFT));
		ScrollPaneVerde elencoImmagini = new ScrollPaneVerde();
		elencoImmagini.setBounds(27, 380, 650, 128);
		add(elencoImmagini);
		
		elencoImmagini.setViewportView(pannelloImmagini);
	}

	private void generaTestoErroreInserisciImmagine() {
		testoErroreInserisciImmagine = new JLabel("Inserisci almeno una immagine");
		testoErroreInserisciImmagine.setHorizontalAlignment(SwingConstants.CENTER);
		testoErroreInserisciImmagine.setForeground(Color.RED);
		testoErroreInserisciImmagine.setFont(new Font("Roboto", Font.PLAIN, 16));
		testoErroreInserisciImmagine.setBounds(27, 510, 650, 22);
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
		bottoneAvanti.setBounds(682, 540, 140, 50);
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

	private void generaBottoneIndietro() {
		bottoneIndietro = new JButton("");
		bottoneIndietro.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent arg0) {
				Controller.getSchermataPrincipaleFrame().mostraPubblicaBusiness1();
			}
		});
		bottoneIndietro.setBounds(27, 540, 140, 50);
		bottoneIndietro.setIcon(new ImageIcon(SchermataPrincipale.class.getResource("/Icone/IndietroButton.png")));
		bottoneIndietro.setOpaque(false);
		bottoneIndietro.setContentAreaFilled(false);
		bottoneIndietro.setBorderPainted(false);
		bottoneIndietro.setFocusPainted(false);
		bottoneIndietro.addMouseListener(new MouseAdapter() {
			@Override
			public void mouseEntered(MouseEvent e) {
				bottoneIndietro.setIcon(new ImageIcon(SchermataPrincipale.class.getResource("/Icone/IndietroButtonFocus.png")));
			}
			@Override
			public void mouseExited(MouseEvent e) {
				bottoneIndietro.setIcon(new ImageIcon(SchermataPrincipale.class.getResource("/Icone/IndietroButton.png")));
			}
		});
		add(bottoneIndietro);
	}

	private void generaAggiungiImmagine() {
		iconaImmagine = new JLabel("");
		iconaImmagine.setBounds(694, 380, 128, 128);
		iconaImmagine.setIcon(new ImageIcon(SchermataPrincipale.class.getResource("/Icone/camera.png")));
		iconaImmagine.addMouseListener(new MouseAdapter() {
			@Override
			public void mouseClicked(MouseEvent e) {
				aggiungiImmagineAVisualizzatore(ctrl.caricaImmagine());
			}
		});
		add(iconaImmagine);
	}

	private void generaTestoTrascinaImmagini() {
		testoTrascinaImmagini = new JLabel("Trascina Immagini");
		testoTrascinaImmagini.setBounds(27, 331, 417, 37);
		testoTrascinaImmagini.setFont(new Font("Roboto", Font.PLAIN, 20));
		add(testoTrascinaImmagini);
	}

	private void generaCampoDescriviBusiness() {
		testoDescriviBusiness = new JLabel("Descrivi la tua attivita'");
		testoDescriviBusiness.setFont(new Font("Roboto", Font.PLAIN, 20));
		testoDescriviBusiness.setBounds(27, 8, 417, 23);
		add(testoDescriviBusiness);
		
		textAreaDescriviBusiness = new JTextArea();
		textAreaDescriviBusiness.setForeground(new Color(192, 192, 192));
		textAreaDescriviBusiness.setBackground(new Color(255, 255, 255));
		textAreaDescriviBusiness.setFont(new Font("Roboto", Font.PLAIN, 17));
		textAreaDescriviBusiness.setRows(20);
		textAreaDescriviBusiness.setColumns(55);
		textAreaDescriviBusiness.setText("Scrivi qui! MAX(2000 caratteri)");
		textAreaDescriviBusiness.setForeground(Color.DARK_GRAY);
		textAreaDescriviBusiness.setBorder(new LineBorder(Color.BLACK,1));
		textAreaDescriviBusiness.setBounds(27, 43, 795, 247);
		textAreaDescriviBusiness.addFocusListener(new FocusAdapter() {
			@Override
			public void focusGained(FocusEvent e) {
				textAreaDescriviBusiness.setText("");
				textAreaDescriviBusiness.setForeground(Color.BLACK);
			}
		});
		add(textAreaDescriviBusiness);
	}
	
	
	//METODI
	

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
			Image img = new ImageIcon(ImageIO.read(nuovaImmagine)).getImage();
			Image imgScalata = img.getScaledInstance(25, 25, java.awt.Image.SCALE_SMOOTH);
			
			JLabel immagine = new JLabel();
			immagine.setSize(25, 25);
			immagine.setIcon(new ImageIcon(imgScalata));
			System.out.println(immagine.toString());
			
			pannelloImmagini.add(immagine);
		} catch (IOException e) {
			e.printStackTrace();
		}
	}
}
