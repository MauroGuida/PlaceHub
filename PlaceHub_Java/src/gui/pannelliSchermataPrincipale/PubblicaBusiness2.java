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
import oggetti.GUI.ScrollPaneVerde;
import oggetti.GUI.TextAreaConScrollPaneVerde;

import java.awt.event.ActionListener;
import java.awt.event.ActionEvent;
import javax.swing.SwingConstants;
import javax.swing.border.LineBorder;

import java.awt.event.ComponentAdapter;
import java.awt.event.ComponentEvent;
import javax.swing.GroupLayout;
import javax.swing.GroupLayout.Alignment;
import java.awt.CardLayout;
import javax.swing.LayoutStyle.ComponentPlacement;
import java.awt.GridBagLayout;
import java.awt.GridBagConstraints;
import java.awt.Insets;

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
	private JPanel pannelloBottom;
	
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
		
		generaTestoErroreInserisciDescrizione();
		generaVisualizzatoreImmagini();
		
		generaPannelloBottom();
		
		generaBottoneCancella();
		generaTestoErroreInserisciImmagine();

		generaBottoneAvanti(ctrl);
		
		GroupLayout groupLayout = generaLayout();
		setLayout(groupLayout);
		
	}

	private void generaPannelloBottom() {
		pannelloBottom = new JPanel();
		pannelloBottom.setBackground(Color.WHITE);
		pannelloBottom.setBorder(new LineBorder(Color.WHITE, 1));
		GridBagLayout gbl_pannelloBottom = new GridBagLayout();
		gbl_pannelloBottom.columnWidths = new int[]{174, 452, 174, 0};
		gbl_pannelloBottom.rowHeights = new int[]{60, 0};
		gbl_pannelloBottom.columnWeights = new double[]{1.0, 1.0, 1.0, Double.MIN_VALUE};
		gbl_pannelloBottom.rowWeights = new double[]{0.0, Double.MIN_VALUE};
		pannelloBottom.setLayout(gbl_pannelloBottom);
	}

	private GroupLayout generaLayout() {
		GroupLayout groupLayout = new GroupLayout(this);
		groupLayout.setHorizontalGroup(
			groupLayout.createParallelGroup(Alignment.LEADING)
				.addGroup(groupLayout.createSequentialGroup()
					.addGap(27)
					.addComponent(testoDescriviBusiness, GroupLayout.DEFAULT_SIZE, 417, Short.MAX_VALUE)
					.addGap(406))
				.addGroup(groupLayout.createSequentialGroup()
					.addGap(27)
					.addComponent(elencoImmagini, GroupLayout.DEFAULT_SIZE, 650, Short.MAX_VALUE)
					.addGap(17)
					.addComponent(iconaImmagine)
					.addGap(28))
				.addGroup(groupLayout.createSequentialGroup()
					.addGap(27)
					.addGroup(groupLayout.createParallelGroup(Alignment.LEADING)
						.addComponent(areaDescrizione, GroupLayout.DEFAULT_SIZE, GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
						.addGroup(groupLayout.createSequentialGroup()
							.addComponent(testoTrascinaImmagini, GroupLayout.DEFAULT_SIZE, 315, Short.MAX_VALUE)
							.addGap(480))
						.addComponent(testoErroreInserisciDescrizione, GroupLayout.DEFAULT_SIZE, 795, Short.MAX_VALUE))
					.addGap(28))
				.addGroup(groupLayout.createSequentialGroup()
					.addContainerGap()
					.addComponent(pannelloBottom, GroupLayout.DEFAULT_SIZE, 826, Short.MAX_VALUE)
					.addContainerGap())
		);
		groupLayout.setVerticalGroup(
			groupLayout.createParallelGroup(Alignment.LEADING)
				.addGroup(groupLayout.createSequentialGroup()
					.addGap(8)
					.addComponent(testoDescriviBusiness, GroupLayout.PREFERRED_SIZE, 23, GroupLayout.PREFERRED_SIZE)
					.addGap(12)
					.addComponent(areaDescrizione, GroupLayout.DEFAULT_SIZE, 246, Short.MAX_VALUE)
					.addGap(10)
					.addGroup(groupLayout.createParallelGroup(Alignment.LEADING, false)
						.addGroup(groupLayout.createSequentialGroup()
							.addGap(18)
							.addComponent(testoTrascinaImmagini, GroupLayout.PREFERRED_SIZE, 37, GroupLayout.PREFERRED_SIZE))
						.addComponent(testoErroreInserisciDescrizione, GroupLayout.PREFERRED_SIZE, 25, GroupLayout.PREFERRED_SIZE))
					.addGap(13)
					.addGroup(groupLayout.createParallelGroup(Alignment.LEADING)
						.addComponent(elencoImmagini, Alignment.TRAILING, GroupLayout.DEFAULT_SIZE, 166, Short.MAX_VALUE)
						.addGroup(groupLayout.createSequentialGroup()
							.addGap(14)
							.addComponent(iconaImmagine, GroupLayout.DEFAULT_SIZE, GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
							.addGap(24)))
					.addPreferredGap(ComponentPlacement.RELATED)
					.addComponent(pannelloBottom, GroupLayout.PREFERRED_SIZE, 70, GroupLayout.PREFERRED_SIZE)
					.addGap(6))
		);
		return groupLayout;
	}

	private void generaBottoneAvanti(Controller ctrl) {
		bottoneAvanti = new JButton("");
		bottoneAvanti.setIcon(new ImageIcon(SchermataPrincipale.class.getResource("/Icone/AvantiButton.png")));
		bottoneAvanti.setOpaque(false);
		bottoneAvanti.setContentAreaFilled(false);
		bottoneAvanti.setBorderPainted(false);
		bottoneAvanti.setFocusPainted(false);
		GridBagConstraints gbc_bottoneAvanti = new GridBagConstraints();
		gbc_bottoneAvanti.fill = GridBagConstraints.VERTICAL;
		gbc_bottoneAvanti.gridx = 2;
		gbc_bottoneAvanti.gridy = 0;
		pannelloBottom.add(bottoneAvanti, gbc_bottoneAvanti);
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

	private void generaTestoErroreInserisciImmagine() {
		testoErroreInserisciImmagine = new JLabel("Inserisci almeno una immagine");
		testoErroreInserisciImmagine.setHorizontalAlignment(SwingConstants.CENTER);
		testoErroreInserisciImmagine.setForeground(Color.RED);
		testoErroreInserisciImmagine.setFont(new Font("Roboto", Font.PLAIN, 16));
		testoErroreInserisciImmagine.setVisible(false);
		GridBagConstraints gbc_testoErroreInserisciImmagine = new GridBagConstraints();
		gbc_testoErroreInserisciImmagine.fill = GridBagConstraints.BOTH;
		gbc_testoErroreInserisciImmagine.insets = new Insets(0, 0, 0, 5);
		gbc_testoErroreInserisciImmagine.gridx = 1;
		gbc_testoErroreInserisciImmagine.gridy = 0;
		pannelloBottom.add(testoErroreInserisciImmagine, gbc_testoErroreInserisciImmagine);
	}

	private void generaBottoneCancella() {
		bottoneCancella = new JButton("");
		bottoneCancella.setIcon(new ImageIcon(PubblicaBusiness2.class.getResource("/Icone/bottoneCancella.png")));
		bottoneCancella.setOpaque(false);
		bottoneCancella.setContentAreaFilled(false);
		bottoneCancella.setBorderPainted(false);
		bottoneCancella.setFocusPainted(false);
		GridBagConstraints gbc_bottoneCancella = new GridBagConstraints();
		gbc_bottoneCancella.fill = GridBagConstraints.VERTICAL;
		gbc_bottoneCancella.insets = new Insets(0, 0, 0, 5);
		gbc_bottoneCancella.gridx = 0;
		gbc_bottoneCancella.gridy = 0;
		pannelloBottom.add(bottoneCancella, gbc_bottoneCancella);
		bottoneCancella.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent arg0) {
				if(JOptionPane.showConfirmDialog(null, "Annullando perderai tutte le modifiche fatte, vuoi procedere?", "Conferma", JOptionPane.YES_NO_OPTION) == JOptionPane.YES_OPTION) {
					Controller.getSchermataPrincipaleFrame().mostraHomepage();
				}
			}
		});
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

	public void generaVisualizzatoreImmagini() {
		pannelloImmagini = new JPanel();
		pannelloImmagini.setBackground(Color.WHITE);
		pannelloImmagini.setLayout(new FlowLayout(FlowLayout.LEFT));
		
		elencoImmagini = new ScrollPaneVerde();
		elencoImmagini.setVerticalScrollBarPolicy(ScrollPaneConstants.VERTICAL_SCROLLBAR_NEVER);
		elencoImmagini.setHorizontalScrollBarPolicy(ScrollPaneConstants.HORIZONTAL_SCROLLBAR_ALWAYS);
		
		elencoImmagini.setViewportView(pannelloImmagini);
	}

	private void generaTestoErroreInserisciDescrizione() {
		testoErroreInserisciDescrizione = new JLabel("Inserisci la descrizione");
		testoErroreInserisciDescrizione.setHorizontalAlignment(SwingConstants.CENTER);
		testoErroreInserisciDescrizione.setFont(new Font("Roboto", Font.PLAIN, 16));
		testoErroreInserisciDescrizione.setForeground(Color.RED);
		testoErroreInserisciDescrizione.setVisible(false);
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
		areaDescrizione.setLayout(new CardLayout(0, 0));
	}
	
	
	//METODI
	
	
	public void pulisciPannello() {
		areaDescrizione.setText("Scrivi qui! MAX(2000 caratteri)");
		areaDescrizione.setForeground(Color.DARK_GRAY);
		testoErroreInserisciDescrizione.setVisible(false);
		testoErroreInserisciImmagine.setVisible(false);
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
