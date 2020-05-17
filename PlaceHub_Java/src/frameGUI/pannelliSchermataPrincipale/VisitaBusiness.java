package frameGUI.pannelliSchermataPrincipale;

import javax.swing.JPanel;

import gestione.Controller;
import oggettiServizio.Business;
import oggettiServizio.Recensione;
import miscellaneous.ScrollPaneVerde;
import miscellaneous.TextAreaConScrollPaneVerde;
import miscellaneousGUI.RecensioneGUI;
import miscellaneousGUI.StelleGUI;

import java.awt.Color;
import java.awt.FlowLayout;

import javax.swing.JButton;
import java.awt.event.MouseAdapter;
import java.awt.event.MouseEvent;
import java.awt.image.BufferedImage;
import java.io.File;
import java.io.IOException;
import java.net.URL;
import java.util.ArrayList;

import javax.swing.ImageIcon;
import javax.swing.JLabel;
import java.awt.Font;
import java.awt.Image;

import javax.swing.border.LineBorder;
import javax.swing.ScrollPaneConstants;
import javax.imageio.ImageIO;
import java.awt.event.ActionListener;
import java.awt.event.ActionEvent;
import javax.swing.SwingConstants;
import javax.swing.GroupLayout;
import javax.swing.GroupLayout.Alignment;
import net.miginfocom.swing.MigLayout;
import javax.swing.LayoutStyle.ComponentPlacement;

public class VisitaBusiness extends JPanel {
	private static final long serialVersionUID = 1L;
	
	private JButton bottoneRecensisci;
	private JLabel testoNomeBusiness;
	private StelleGUI stelle;
	private JLabel immagineIndirizzo;
	private JLabel testoIndirizzo;
	private JLabel immagineTelefono;
	private JLabel testoNumeroTelefono;
	private JLabel testoRaffinazioni;
	private ScrollPaneVerde scrollPaneImmagini;
	private JPanel pannelloImmagini;
	private JPanel pannelloRecensioni;
	private ScrollPaneVerde scrollPaneRecensioni;
	private TextAreaConScrollPaneVerde textAreaDescrizioneBusiness;
	
	private Controller ctrl;
	private JLabel immagineRaffinazioni;
	
	public VisitaBusiness(Controller ctrl) {
		this.ctrl = ctrl;
		
		setBackground(Color.WHITE);
		setSize(850, 614);
		setVisible(false);
		
		generaBottoneRecensisci();
		generaTestoNomeBusiness();
		generaStelle();
		generaImmagineIndirizzo();
		generaTestoIndirizzo();
		generaImmagineTelefono();
		generaTestoRaffinazioni();
		generaImmagineRaffinazioni();
		generaTestoNumeroTelefono();
		generaTextAreaDescrizioneBusiness();
		
		generaContenitoreFoto();
		generaContenitoreRecensioni();

		GroupLayout groupLayout = new GroupLayout(this);
		groupLayout.setHorizontalGroup(
			groupLayout.createParallelGroup(Alignment.TRAILING)
				.addGroup(groupLayout.createSequentialGroup()
					.addGap(18)
					.addComponent(testoNomeBusiness, GroupLayout.DEFAULT_SIZE, 523, Short.MAX_VALUE)
					.addGap(69)
					.addComponent(stelle, GroupLayout.PREFERRED_SIZE, 199, GroupLayout.PREFERRED_SIZE)
					.addGap(41))
				.addGroup(groupLayout.createSequentialGroup()
					.addGap(28)
					.addComponent(immagineRaffinazioni, GroupLayout.PREFERRED_SIZE, 31, GroupLayout.PREFERRED_SIZE)
					.addGap(12)
					.addComponent(testoRaffinazioni, GroupLayout.PREFERRED_SIZE, 767, GroupLayout.PREFERRED_SIZE)
					.addContainerGap(12, Short.MAX_VALUE))
				.addGroup(groupLayout.createSequentialGroup()
					.addGap(28)
					.addGroup(groupLayout.createParallelGroup(Alignment.LEADING)
						.addGroup(groupLayout.createSequentialGroup()
							.addComponent(immagineTelefono, GroupLayout.PREFERRED_SIZE, 31, GroupLayout.PREFERRED_SIZE)
							.addGap(12)
							.addComponent(testoNumeroTelefono, GroupLayout.PREFERRED_SIZE, 529, GroupLayout.PREFERRED_SIZE)
							.addGap(0, 0, Short.MAX_VALUE))
						.addGroup(groupLayout.createSequentialGroup()
							.addComponent(immagineIndirizzo, GroupLayout.PREFERRED_SIZE, 31, GroupLayout.PREFERRED_SIZE)
							.addGap(12)
							.addComponent(testoIndirizzo, GroupLayout.PREFERRED_SIZE, 529, GroupLayout.PREFERRED_SIZE)
							.addPreferredGap(ComponentPlacement.UNRELATED, GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)))
					.addGap(10)
					.addComponent(bottoneRecensisci, GroupLayout.PREFERRED_SIZE, 199, GroupLayout.PREFERRED_SIZE)
					.addGap(41))
				.addGroup(groupLayout.createSequentialGroup()
					.addGap(28)
					.addGroup(groupLayout.createParallelGroup(Alignment.TRAILING)
						.addGroup(groupLayout.createSequentialGroup()
							.addComponent(scrollPaneImmagini, GroupLayout.DEFAULT_SIZE, 380, Short.MAX_VALUE)
							.addGap(21)
							.addComponent(textAreaDescrizioneBusiness, GroupLayout.DEFAULT_SIZE, 385, Short.MAX_VALUE))
						.addComponent(scrollPaneRecensioni, GroupLayout.DEFAULT_SIZE, 786, Short.MAX_VALUE))
					.addGap(36))
		);
		groupLayout.setVerticalGroup(
			groupLayout.createParallelGroup(Alignment.LEADING)
				.addGroup(groupLayout.createSequentialGroup()
					.addGap(11)
					.addGroup(groupLayout.createParallelGroup(Alignment.LEADING)
						.addGroup(groupLayout.createSequentialGroup()
							.addGap(1)
							.addComponent(testoNomeBusiness, GroupLayout.PREFERRED_SIZE, 54, GroupLayout.PREFERRED_SIZE))
						.addComponent(stelle, GroupLayout.PREFERRED_SIZE, 43, GroupLayout.PREFERRED_SIZE))
					.addGap(12)
					.addGroup(groupLayout.createParallelGroup(Alignment.LEADING)
						.addComponent(testoIndirizzo, GroupLayout.PREFERRED_SIZE, 31, GroupLayout.PREFERRED_SIZE)
						.addComponent(immagineIndirizzo, GroupLayout.PREFERRED_SIZE, 31, GroupLayout.PREFERRED_SIZE)
						.addGroup(groupLayout.createSequentialGroup()
							.addGap(3)
							.addComponent(bottoneRecensisci, GroupLayout.PREFERRED_SIZE, 50, GroupLayout.PREFERRED_SIZE)))
					.addGroup(groupLayout.createParallelGroup(Alignment.LEADING)
						.addComponent(immagineTelefono, GroupLayout.PREFERRED_SIZE, 31, GroupLayout.PREFERRED_SIZE)
						.addComponent(testoNumeroTelefono, GroupLayout.PREFERRED_SIZE, 31, GroupLayout.PREFERRED_SIZE))
					.addGap(22)
					.addGroup(groupLayout.createParallelGroup(Alignment.LEADING)
						.addComponent(immagineRaffinazioni, GroupLayout.PREFERRED_SIZE, 31, GroupLayout.PREFERRED_SIZE)
						.addComponent(testoRaffinazioni, GroupLayout.PREFERRED_SIZE, 31, GroupLayout.PREFERRED_SIZE))
					.addGap(25)
					.addGroup(groupLayout.createParallelGroup(Alignment.LEADING, false)
						.addComponent(textAreaDescrizioneBusiness, GroupLayout.PREFERRED_SIZE, 198, GroupLayout.PREFERRED_SIZE)
						.addComponent(scrollPaneImmagini, GroupLayout.PREFERRED_SIZE, 198, GroupLayout.PREFERRED_SIZE))
					.addGap(21)
					.addComponent(scrollPaneRecensioni, GroupLayout.DEFAULT_SIZE, 145, Short.MAX_VALUE)
					.addGap(10))
		);
		setLayout(groupLayout);
	}

	private void generaTextAreaDescrizioneBusiness() {
		textAreaDescrizioneBusiness = new TextAreaConScrollPaneVerde();
		textAreaDescrizioneBusiness.setEditable(false);
	}


	private void generaTestoRaffinazioni() {
		testoRaffinazioni = new JLabel("DINAMICO");
		testoRaffinazioni.setHorizontalAlignment(SwingConstants.LEFT);
		testoRaffinazioni.setFont(new Font("Roboto", Font.PLAIN, 20));
	}
	
	private void generaImmagineRaffinazioni() {
		immagineRaffinazioni = new JLabel("");
		immagineRaffinazioni.setIcon(new ImageIcon(VisitaBusiness.class.getResource("/Icone/immagineRaffinazioni.png")));
	}

	private void generaTestoNumeroTelefono() {
		testoNumeroTelefono = new JLabel("DINAMICO");
		testoNumeroTelefono.setFont(new Font("Roboto", Font.PLAIN, 20));
	}

	
	private void generaImmagineTelefono() {
		immagineTelefono = new JLabel();
		immagineTelefono.setIcon(new ImageIcon(VisitaBusiness.class.getResource("/Icone/iconaTelefono.png")));
	}

	
	private void generaTestoIndirizzo() {
		testoIndirizzo = new JLabel("DINAMICO");
		testoIndirizzo.setFont(new Font("Roboto", Font.PLAIN, 20));
	}
	

	private void generaImmagineIndirizzo() {
		immagineIndirizzo = new JLabel("");
		immagineIndirizzo.setIcon(new ImageIcon(VisitaBusiness.class.getResource("/Icone/iconaIndirizzo.png")));
	}


	private void generaStelle() {
		stelle = new StelleGUI();
	}


	private void generaTestoNomeBusiness() {
		testoNomeBusiness = new JLabel("DINAMICO");
		testoNomeBusiness.setHorizontalAlignment(SwingConstants.CENTER);
		testoNomeBusiness.setFont(new Font("Roboto", Font.BOLD, 25));
	}
	
	
	private void generaBottoneRecensisci() {
		bottoneRecensisci = new JButton("");
		bottoneRecensisci.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent arg0) {
				ctrl.vaiAScriviRecensione();
			}
		});
		bottoneRecensisci.setIcon(new ImageIcon(VisitaBusiness.class.getResource("/Icone/bottoneRecensione.png")));
		bottoneRecensisci.setOpaque(false);
		bottoneRecensisci.setBorderPainted(false);
		bottoneRecensisci.setContentAreaFilled(false);
		bottoneRecensisci.setFocusPainted(false);
		bottoneRecensisci.addMouseListener(new MouseAdapter() {
			@Override
			public void mouseEntered(MouseEvent e) {
				bottoneRecensisci.setIcon(new ImageIcon(VisitaBusiness.class.getResource("/Icone/bottoneRecensioneFocus.png")));
			}
			@Override
			public void mouseExited(MouseEvent e) {
				bottoneRecensisci.setIcon(new ImageIcon(VisitaBusiness.class.getResource("/Icone/bottoneRecensione.png")));
			}
		});
	}
	
	private void generaContenitoreFoto() {
		pannelloImmagini = new JPanel();
		pannelloImmagini.setBackground(Color.WHITE);
		pannelloImmagini.setLayout(new FlowLayout(FlowLayout.LEFT));
		pannelloImmagini.setBorder(new LineBorder(Color.DARK_GRAY,1));
		scrollPaneImmagini = new ScrollPaneVerde();
		scrollPaneImmagini.setVerticalScrollBarPolicy(ScrollPaneConstants.VERTICAL_SCROLLBAR_NEVER);
		scrollPaneImmagini.setHorizontalScrollBarPolicy(ScrollPaneConstants.HORIZONTAL_SCROLLBAR_AS_NEEDED);
		scrollPaneImmagini.setBackground(Color.WHITE);
		scrollPaneImmagini.setViewportView(pannelloImmagini);
	}
	
	private void generaContenitoreRecensioni() {
		pannelloRecensioni = new JPanel();
		pannelloRecensioni.setLayout(new MigLayout());
		pannelloRecensioni.setBackground(Color.WHITE);
		pannelloRecensioni.setBorder(new LineBorder(Color.DARK_GRAY,1));
		
		scrollPaneRecensioni = new ScrollPaneVerde();
		scrollPaneRecensioni.setVerticalScrollBarPolicy(ScrollPaneConstants.VERTICAL_SCROLLBAR_AS_NEEDED);
		scrollPaneRecensioni.setHorizontalScrollBarPolicy(ScrollPaneConstants.HORIZONTAL_SCROLLBAR_NEVER);
		scrollPaneRecensioni.setViewportView(pannelloRecensioni);
	}
	
	
	//METODI
	
	
	public void configuraPannello(Business locale, ArrayList<Recensione> recensioni) {
		pulisciPannello();
		
		testoNomeBusiness.setText(locale.getNome());
		testoIndirizzo.setText(locale.getIndirizzo() + " " + locale.getLuogo());
		testoNumeroTelefono.setText(locale.getTelefono());
		textAreaDescrizioneBusiness.setText(locale.getDescrizione());
		testoRaffinazioni.setText(locale.getRaffinazioni());
		stelle.aggiungiStelle(locale.getStelle());
		
		for(String immagine: locale.getListaImmagini())
			aggiungiImmagineAVisualizzatore(immagine);
		
		for(Recensione recensione: recensioni) 
			aggiungiRecensioniAPannello(recensione);
	}
	
	public void disattivaBottoneRecensione() {
		bottoneRecensisci.setEnabled(false);
	}
	
	private void pulisciPannello() {
		testoNomeBusiness.setText("");
		testoIndirizzo.setText("");
		testoNumeroTelefono.setText("");
		textAreaDescrizioneBusiness.setText("");
		testoRaffinazioni.setText("");
		
		pannelloImmagini.removeAll();
		pannelloRecensioni.removeAll();
		
		bottoneRecensisci.setEnabled(true);
	}
	
	private void aggiungiImmagineAVisualizzatore(String nuovaImmagine) {
		final int W = 290;
		final int H = 170;
		
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
		} finally{
			JLabel immagine = new JLabel();
			immagine.setSize(W, H);
			immagine.setIcon(new ImageIcon(imgScalata));
			
			pannelloImmagini.add(immagine);
		}
	}
	
	private void aggiungiRecensioniAPannello(Recensione recensione) {
		RecensioneGUI pannelloNuovaRecensione = new RecensioneGUI();
		pannelloNuovaRecensione.configuraPannello(recensione);
		pannelloRecensioni.add(pannelloNuovaRecensione, "wrap, pushx, grow");
	}
}
