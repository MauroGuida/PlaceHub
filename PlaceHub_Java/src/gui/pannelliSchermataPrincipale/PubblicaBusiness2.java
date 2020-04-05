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
import javax.swing.ScrollPaneConstants;

import gestione.Controller;
import gui.SchermataPrincipale;
import res.ScrollPaneVerde;
import res.TextAreaConScrollPaneVerde;

import java.awt.event.ActionListener;
import java.awt.event.ActionEvent;
import javax.swing.SwingConstants;
import java.awt.event.ComponentAdapter;
import java.awt.event.ComponentEvent;
import javax.swing.GroupLayout;
import javax.swing.GroupLayout.Alignment;

public class PubblicaBusiness2 extends JPanel {

	private static final long serialVersionUID = 1L;
	private JLabel testoDescriviBusiness;
	private TextAreaConScrollPaneVerde areaDescrizione;
	
	private JButton bottoneCancella;
	private JButton bottoneAvanti;
	
	private JLabel testoErroreInserisciDescrizione;
	private JLabel testoErroreInserisciImmagine;
	
	private JLabel testoTrascinaImmagini;
	private JLabel iconaImmagine;
	private ScrollPaneVerde elencoImmagini;
	private JPanel pannelloImmagini;
	
	private Controller ctrl;
	
	 public PubblicaBusiness2(Controller ctrl) {
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
		
		generaCampoDescriviBusiness();
		generaTestoTrascinaImmagini();
		
		generaAggiungiImmagine();
		
		generaBottoneCancella();
		generaBottoneAvanti();
		
		generaTestoErroreInserisciDescrizione();
		generaTestoErroreInserisciImmagine();
		
		generaVisualizzatoreImmagini();
		
		GroupLayout groupLayout = new GroupLayout(this);
		groupLayout.setHorizontalGroup(
			groupLayout.createParallelGroup(Alignment.LEADING)
				.addGroup(groupLayout.createSequentialGroup()
					.addGap(27)
					.addGroup(groupLayout.createParallelGroup(Alignment.LEADING)
						.addGroup(groupLayout.createSequentialGroup()
							.addComponent(testoDescriviBusiness, GroupLayout.DEFAULT_SIZE, 417, Short.MAX_VALUE)
							.addGap(378))
						.addComponent(areaDescrizione, GroupLayout.DEFAULT_SIZE, 795, Short.MAX_VALUE)
						.addGroup(groupLayout.createSequentialGroup()
							.addComponent(testoTrascinaImmagini, GroupLayout.DEFAULT_SIZE, 315, Short.MAX_VALUE)
							.addGap(480))
						.addComponent(testoErroreInserisciDescrizione, GroupLayout.DEFAULT_SIZE, 795, Short.MAX_VALUE)
						.addGroup(groupLayout.createSequentialGroup()
							.addComponent(elencoImmagini, GroupLayout.DEFAULT_SIZE, 650, Short.MAX_VALUE)
							.addGap(17)
							.addComponent(iconaImmagine))
						.addGroup(groupLayout.createSequentialGroup()
							.addComponent(bottoneCancella, GroupLayout.PREFERRED_SIZE, 140, GroupLayout.PREFERRED_SIZE)
							.addGap(10)
							.addComponent(testoErroreInserisciImmagine, GroupLayout.DEFAULT_SIZE, 495, Short.MAX_VALUE)
							.addGap(10)
							.addComponent(bottoneAvanti, GroupLayout.PREFERRED_SIZE, 140, GroupLayout.PREFERRED_SIZE)))
					.addGap(28))
		);
		groupLayout.setVerticalGroup(
			groupLayout.createParallelGroup(Alignment.LEADING)
				.addGroup(groupLayout.createSequentialGroup()
					.addGap(8)
					.addComponent(testoDescriviBusiness, GroupLayout.PREFERRED_SIZE, 23, GroupLayout.PREFERRED_SIZE)
					.addGap(12)
					.addComponent(areaDescrizione, GroupLayout.DEFAULT_SIZE, 247, Short.MAX_VALUE)
					.addGap(10)
					.addGroup(groupLayout.createParallelGroup(Alignment.LEADING)
						.addGroup(groupLayout.createSequentialGroup()
							.addGap(18)
							.addComponent(testoTrascinaImmagini, GroupLayout.PREFERRED_SIZE, 37, GroupLayout.PREFERRED_SIZE))
						.addComponent(testoErroreInserisciDescrizione, GroupLayout.PREFERRED_SIZE, 23, GroupLayout.PREFERRED_SIZE))
					.addGap(11)
					.addGroup(groupLayout.createParallelGroup(Alignment.LEADING)
						.addComponent(elencoImmagini, GroupLayout.DEFAULT_SIZE, 166, Short.MAX_VALUE)
						.addGroup(groupLayout.createSequentialGroup()
							.addGap(14)
							.addComponent(iconaImmagine)))
					.addGap(11)
					.addGroup(groupLayout.createParallelGroup(Alignment.LEADING, false)
						.addComponent(bottoneCancella, GroupLayout.PREFERRED_SIZE, 50, GroupLayout.PREFERRED_SIZE)
						.addGroup(groupLayout.createSequentialGroup()
							.addGap(15)
							.addComponent(testoErroreInserisciImmagine, GroupLayout.PREFERRED_SIZE, 22, GroupLayout.PREFERRED_SIZE))
						.addComponent(bottoneAvanti, GroupLayout.PREFERRED_SIZE, 50, GroupLayout.PREFERRED_SIZE))
					.addGap(21))
		);
		setLayout(groupLayout);
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

	private void generaTestoErroreInserisciImmagine() {
		testoErroreInserisciImmagine = new JLabel("Inserisci almeno una immagine");
		testoErroreInserisciImmagine.setHorizontalAlignment(SwingConstants.CENTER);
		testoErroreInserisciImmagine.setForeground(Color.RED);
		testoErroreInserisciImmagine.setFont(new Font("Roboto", Font.PLAIN, 16));
		testoErroreInserisciImmagine.setVisible(false);
	}

	private void generaTestoErroreInserisciDescrizione() {
		testoErroreInserisciDescrizione = new JLabel("Inserisci la descrizione");
		testoErroreInserisciDescrizione.setHorizontalAlignment(SwingConstants.CENTER);
		testoErroreInserisciDescrizione.setFont(new Font("Roboto", Font.PLAIN, 16));
		testoErroreInserisciDescrizione.setForeground(Color.RED);
		testoErroreInserisciDescrizione.setVisible(false);
	}

	private void generaBottoneAvanti() {
		bottoneAvanti = new JButton("");
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
				ctrl.procediInPubblicaBusiness3(areaDescrizione.getText());
			}
		});
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
	}

	private void generaAggiungiImmagine() {
		iconaImmagine = new JLabel("");
		iconaImmagine.setIcon(new ImageIcon(SchermataPrincipale.class.getResource("/Icone/camera.png")));
		iconaImmagine.addMouseListener(new MouseAdapter() {
			@Override
			public void mouseClicked(MouseEvent e) {
				aggiungiImmagineAVisualizzatore(ctrl.caricaImmagineLocale());
				pannelloImmagini.revalidate();
			}
		});
	}

	private void generaTestoTrascinaImmagini() {
		testoTrascinaImmagini = new JLabel("Trascina Immagini");
		testoTrascinaImmagini.setFont(new Font("Roboto", Font.PLAIN, 20));
	}

	private void generaCampoDescriviBusiness() {
		testoDescriviBusiness = new JLabel("Descrivi la tua attivita'");
		testoDescriviBusiness.setFont(new Font("Roboto", Font.PLAIN, 20));
		
		areaDescrizione = new TextAreaConScrollPaneVerde();
	}
	
	
	//METODI
	
	
	public void pulisciPannello() {
		areaDescrizione.setText("Scrivi qui! MAX(2000 caratteri)");
		areaDescrizione.setForeground(Color.DARK_GRAY);
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
