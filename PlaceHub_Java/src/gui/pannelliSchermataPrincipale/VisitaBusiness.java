package gui.pannelliSchermataPrincipale;

import javax.swing.JPanel;

import gestione.Controller;
import gui.StelleGUI;
import oggetti.Locale;
import res.ScrollPaneVerde;

import java.awt.Color;
import java.awt.FlowLayout;

import javax.swing.JButton;
import java.awt.event.MouseAdapter;
import java.awt.event.MouseEvent;
import java.io.File;
import java.io.IOException;

import javax.swing.ImageIcon;
import javax.swing.JLabel;
import java.awt.Font;
import java.awt.Image;

import javax.swing.JTextArea;
import javax.swing.border.LineBorder;
import javax.swing.ScrollPaneConstants;
import javax.imageio.ImageIO;
import java.awt.event.ActionListener;
import java.awt.event.ActionEvent;
import javax.swing.SwingConstants;

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
	private JTextArea textAreaDescrizioneBusiness;
	
	private Controller ctrl;
	
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

		generaLayout();
	}

	private void generaLayout() {
		setLayout(null);
		add(scrollPaneRecensioni);
		add(scrollPaneImmagini);
		add(stelle);
		add(bottoneRecensisci);
		add(testoRaffinazioni);
		add(testoNomeBusiness);
		add(immagineTelefono);
		add(testoNumeroTelefono);
		add(immagineIndirizzo);
		add(testoIndirizzo);
		add(textAreaDescrizioneBusiness);
	}
	

	private void generaTextAreaDescrizioneBusiness() {
		textAreaDescrizioneBusiness = new JTextArea("DINAMICO");
		textAreaDescrizioneBusiness.setWrapStyleWord(true);
		textAreaDescrizioneBusiness.setLineWrap(true);
		textAreaDescrizioneBusiness.setBounds(429, 240, 380, 199);
		textAreaDescrizioneBusiness.setFont(new Font("Roboto", Font.PLAIN, 15));
		textAreaDescrizioneBusiness.setBorder(new LineBorder(Color.BLACK,1));
		textAreaDescrizioneBusiness.setEditable(false);
	}


	private void generaTestoRaffinazioni() {
		testoRaffinazioni = new JLabel("DINAMICO");
		testoRaffinazioni.setBounds(71, 184, 767, 31);
		testoRaffinazioni.setHorizontalAlignment(SwingConstants.LEFT);
		testoRaffinazioni.setFont(new Font("Roboto", Font.PLAIN, 20));
	}
	
	private void generaImmagineRaffinazioni() {
		JLabel immagineRaffinazioni = new JLabel("");
		immagineRaffinazioni.setIcon(new ImageIcon(VisitaBusiness.class.getResource("/Icone/immagineRaffinazioni.png")));
		immagineRaffinazioni.setBounds(28, 184, 31, 31);
		add(immagineRaffinazioni);
	}

	private void generaTestoNumeroTelefono() {
		testoNumeroTelefono = new JLabel("DINAMICO");
		testoNumeroTelefono.setBounds(71, 131, 210, 31);
		testoNumeroTelefono.setFont(new Font("Roboto", Font.PLAIN, 20));
	}

	
	private void generaImmagineTelefono() {
		immagineTelefono = new JLabel();
		immagineTelefono.setBounds(28, 131, 31, 31);
		immagineTelefono.setIcon(new ImageIcon(VisitaBusiness.class.getResource("/Icone/iconaTelefono.png")));
	}

	
	private void generaTestoIndirizzo() {
		testoIndirizzo = new JLabel("DINAMICO");
		testoIndirizzo.setBounds(71, 78, 456, 31);
		testoIndirizzo.setFont(new Font("Roboto", Font.PLAIN, 20));
	}
	

	private void generaImmagineIndirizzo() {
		immagineIndirizzo = new JLabel("");
		immagineIndirizzo.setBounds(28, 78, 31, 31);
		immagineIndirizzo.setIcon(new ImageIcon(VisitaBusiness.class.getResource("/Icone/iconaIndirizzo.png")));
	}


	private void generaStelle() {
		stelle = new StelleGUI();
		stelle.setSize(199, 43);
		stelle.setLocation(610, 11);
	}


	private void generaTestoNomeBusiness() {
		testoNomeBusiness = new JLabel("DINAMICO");
		testoNomeBusiness.setBounds(18, 12, 523, 54);
		testoNomeBusiness.setHorizontalAlignment(SwingConstants.CENTER);
		testoNomeBusiness.setFont(new Font("Roboto", Font.BOLD, 25));
	}
	
	
	private void generaBottoneRecensisci() {
		bottoneRecensisci = new JButton("");
		bottoneRecensisci.setBounds(610, 81, 199, 50);
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
		scrollPaneImmagini.setBounds(28, 240, 380, 198);
		scrollPaneImmagini.setVerticalScrollBarPolicy(ScrollPaneConstants.VERTICAL_SCROLLBAR_NEVER);
		scrollPaneImmagini.setHorizontalScrollBarPolicy(ScrollPaneConstants.HORIZONTAL_SCROLLBAR_AS_NEEDED);
		scrollPaneImmagini.setBackground(Color.WHITE);
		scrollPaneImmagini.setViewportView(pannelloImmagini);
	}
	
	private void generaContenitoreRecensioni() {
		pannelloRecensioni = new JPanel();
		pannelloRecensioni.setBackground(Color.WHITE);
		pannelloRecensioni.setBorder(new LineBorder(Color.DARK_GRAY,1));
		scrollPaneRecensioni = new ScrollPaneVerde();
		scrollPaneRecensioni.setBounds(28, 459, 786, 145);
		scrollPaneRecensioni.setVerticalScrollBarPolicy(ScrollPaneConstants.VERTICAL_SCROLLBAR_AS_NEEDED);
		scrollPaneRecensioni.setHorizontalScrollBarPolicy(ScrollPaneConstants.HORIZONTAL_SCROLLBAR_NEVER);
		scrollPaneRecensioni.setViewportView(pannelloRecensioni);
	}
	
	
	//METODI
	
	
	public void configuraPannello(Locale locale) {
		pulisciPannello();
		
		testoNomeBusiness.setText(locale.getNome());
		testoIndirizzo.setText(locale.getIndirizzo());
		testoNumeroTelefono.setText(locale.getTelefono());
		textAreaDescrizioneBusiness.setText(locale.getDescrizione());
		testoRaffinazioni.setText(locale.getRaffinazioni());
		stelle.aggiungiStelle(locale.getStelle());
		
		for (String immagine: locale.getListaImmagini())
			aggiungiImmagineAVisualizzatore(new File(immagine));
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
	
	private void aggiungiImmagineAVisualizzatore(File nuovaImmagine) {
		Image imgScalata = null;
		
		final int W = 290;
		final int H = 170;
		
		try {
			imgScalata = new ImageIcon(ImageIO.read(nuovaImmagine)).getImage().getScaledInstance(W, H, java.awt.Image.SCALE_SMOOTH);
		} catch (IOException e) {
			imgScalata = new ImageIcon(Locale.class.getResource("/Icone/placeholder.gif")).getImage().getScaledInstance(W, H, java.awt.Image.SCALE_SMOOTH);
		} finally{
			JLabel immagine = new JLabel();
			immagine.setSize(W, H);
			immagine.setIcon(new ImageIcon(imgScalata));
			
			pannelloImmagini.add(immagine);
		}
	}
}
