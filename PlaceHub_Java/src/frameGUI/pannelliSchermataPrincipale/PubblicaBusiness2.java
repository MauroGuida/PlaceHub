package frameGUI.pannelliSchermataPrincipale;

import java.awt.Color;
import java.awt.FlowLayout;
import java.awt.Font;
import java.awt.Image;
import java.awt.event.MouseAdapter;
import java.awt.event.MouseEvent;
import java.awt.image.BufferedImage;
import java.io.File;
import java.io.IOException;
import java.net.URL;

import javax.imageio.ImageIO;
import javax.swing.ImageIcon;
import javax.swing.JButton;
import javax.swing.JLabel;
import javax.swing.JOptionPane;
import javax.swing.JPanel;
import javax.swing.ScrollPaneConstants;

import gestione.Controller;
import miscellaneous.FileChooser;
import miscellaneous.ScrollPaneVerde;
import miscellaneous.TextAreaConScrollPaneVerde;

import java.awt.event.ActionListener;
import java.awt.event.ActionEvent;
import javax.swing.SwingConstants;
import javax.swing.border.LineBorder;

import frameGUI.SchermataPrincipale;

import java.awt.event.ComponentAdapter;
import java.awt.event.ComponentEvent;
import javax.swing.GroupLayout;
import javax.swing.GroupLayout.Alignment;
import java.awt.CardLayout;
import javax.swing.LayoutStyle.ComponentPlacement;

import net.iharder.dnd.FileDrop;
import net.miginfocom.swing.MigLayout;
import oggettiServizio.Business;

import java.awt.Component;
import javax.swing.Box;

public class PubblicaBusiness2 extends JPanel {

	private static final long serialVersionUID = 1L;
	private JLabel testoDescriviBusiness;
	private TextAreaConScrollPaneVerde areaDescrizione;
	
	private JButton bottoneCancella;
	private JButton bottoneAvanti;
	
	private JLabel testoErroreInserisciDescrizione;
	private JLabel testoErrore;
	
	private JLabel testoTrascinaImmagini;
	private JLabel iconaImmagine;
	private ScrollPaneVerde elencoImmagini;
	private JPanel pannelloImmagini;
	
	private Controller ctrl;
	private JPanel pannelloBot;
	private Component horizontalGlue;
	private Component horizontalGlue_1;
	
	private FileChooser selettoreFile = new FileChooser();
	
	 public PubblicaBusiness2(Controller ctrl) {
	 	addComponentListener(new ComponentAdapter() {
	 		@Override
	 		public void componentHidden(ComponentEvent e) {
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
		
		generaBottoneCancella();
		generaTestoErroreInserisciImmagine();

		generaBottoneAvanti(ctrl);
		
		generaPannelloBot();
		
		GroupLayout groupLayout = new GroupLayout(this);
		groupLayout.setHorizontalGroup(
			groupLayout.createParallelGroup(Alignment.TRAILING)
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
				.addComponent(pannelloBot, GroupLayout.DEFAULT_SIZE, 850, Short.MAX_VALUE)
		);
		groupLayout.setVerticalGroup(
			groupLayout.createParallelGroup(Alignment.LEADING)
				.addGroup(groupLayout.createSequentialGroup()
					.addGap(8)
					.addComponent(testoDescriviBusiness, GroupLayout.PREFERRED_SIZE, 23, GroupLayout.PREFERRED_SIZE)
					.addGap(12)
					.addComponent(areaDescrizione, GroupLayout.DEFAULT_SIZE, 245, Short.MAX_VALUE)
					.addGap(10)
					.addGroup(groupLayout.createParallelGroup(Alignment.LEADING, false)
						.addGroup(groupLayout.createSequentialGroup()
							.addGap(18)
							.addComponent(testoTrascinaImmagini, GroupLayout.PREFERRED_SIZE, 37, GroupLayout.PREFERRED_SIZE))
						.addComponent(testoErroreInserisciDescrizione, GroupLayout.PREFERRED_SIZE, 25, GroupLayout.PREFERRED_SIZE))
					.addGap(13)
					.addGroup(groupLayout.createParallelGroup(Alignment.LEADING, false)
						.addComponent(elencoImmagini, Alignment.TRAILING, GroupLayout.PREFERRED_SIZE, 166, GroupLayout.PREFERRED_SIZE)
						.addGroup(groupLayout.createSequentialGroup()
							.addGap(14)
							.addComponent(iconaImmagine)
							.addPreferredGap(ComponentPlacement.RELATED, 24, Short.MAX_VALUE)))
					.addPreferredGap(ComponentPlacement.RELATED)
					.addComponent(pannelloBot, GroupLayout.PREFERRED_SIZE, 70, GroupLayout.PREFERRED_SIZE)
					.addGap(6))
		);
		setLayout(groupLayout);
	}

	private void generaPannelloBot() {
		pannelloBot = new JPanel();
		pannelloBot.setBackground(Color.WHITE);
		pannelloBot.setBorder(new LineBorder(Color.WHITE, 1));
		pannelloBot.setLayout(new MigLayout("", "[][grow,center][][grow,center][]", "[]"));

		horizontalGlue = Box.createHorizontalGlue();
		pannelloBot.add(horizontalGlue, "cell 1 0");

		horizontalGlue_1 = Box.createHorizontalGlue();
		pannelloBot.add(horizontalGlue_1, "cell 3 0");

		pannelloBot.add(bottoneAvanti, "cell 4 0,alignx right,growy");
		pannelloBot.add(testoErrore, "cell 2 0,grow");
		pannelloBot.add(bottoneCancella, "cell 0 0,alignx left,growy");
	}

	private void generaBottoneAvanti(Controller ctrl) {
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

	private void generaTestoErroreInserisciImmagine() {
		testoErrore = new JLabel("Inserisci almeno una immagine");
		testoErrore.setHorizontalAlignment(SwingConstants.CENTER);
		testoErrore.setForeground(Color.RED);
		testoErrore.setFont(new Font("Roboto", Font.PLAIN, 16));
		testoErrore.setVisible(false);
	}

	private void generaBottoneCancella() {
		bottoneCancella = new JButton("");
		bottoneCancella.setIcon(new ImageIcon(PubblicaBusiness2.class.getResource("/Icone/bottoneCancella.png")));
		bottoneCancella.setOpaque(false);
		bottoneCancella.setContentAreaFilled(false);
		bottoneCancella.setBorderPainted(false);
		bottoneCancella.setFocusPainted(false);
		
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
				File daAggiungere = selettoreFile.selezionaFile();
				if(ctrl.caricaImmagineLocale(daAggiungere))
					aggiungiImmagineAVisualizzatore(daAggiungere.getAbsolutePath());
				
				pannelloImmagini.revalidate();
			}
		});
		
		new FileDrop(iconaImmagine, new FileDrop.Listener()	{
			public void filesDropped( File[] files ) {
				for( int i = 0; i < files.length; i++ ) {
					if(ctrl.caricaImmagineLocale(files[i]))
						aggiungiImmagineAVisualizzatore(files[i].getAbsolutePath());
                }
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
		testoErrore.setVisible(false);
		pannelloImmagini.removeAll();
	}

	public void resettaVisibilitaErrori() {
		testoErroreInserisciDescrizione.setVisible(false);
		testoErrore.setVisible(false);
	}
	
	public void mostraErroreInserisciDescrizione() {
		testoErroreInserisciDescrizione.setText("Inserisci la descrizione");
		testoErroreInserisciDescrizione.setVisible(true);
	}
	
	public void mostraErroreInserisciImmagine() {
		testoErrore.setText("Inserisci almeno una immagine");
		testoErrore.setVisible(true);
	}
	
	private void aggiungiImmagineAVisualizzatore(String nuovaImmagine) {
		final int W = 210;
		final int H = 140;
		
		Image imgScalata = new ImageIcon(Business.class.getResource("/Icone/placeholder.gif")).getImage().getScaledInstance(W, H, java.awt.Image.SCALE_SMOOTH);
		
		try {
			if(nuovaImmagine.contains("http://") || nuovaImmagine.contains("https://")) {
				URL url = new URL(nuovaImmagine);
				BufferedImage img = ImageIO.read(url);
				imgScalata = new ImageIcon(img).getImage().getScaledInstance(W, H, java.awt.Image.SCALE_SMOOTH);
			}else {
				File fileImmagine = new File(nuovaImmagine);
				if(fileImmagine.exists())
					imgScalata = new ImageIcon(fileImmagine.getAbsolutePath()).getImage().getScaledInstance(W, H, java.awt.Image.SCALE_SMOOTH);
			}
		} catch (IOException e) {
//			Verra' visualizzato il placehoder
		} finally {
			JLabel immagine = new JLabel();
			immagine.setSize(W, H);
			immagine.setIcon(new ImageIcon(imgScalata));
			
			pannelloImmagini.add(immagine);
		}
	}
	
	public void impostaBusinessPreesistente(Business locale) {
		areaDescrizione.setText(locale.getDescrizione());
		
		for (String immagine: locale.getListaImmagini())
			aggiungiImmagineAVisualizzatore(immagine);
	}
}
