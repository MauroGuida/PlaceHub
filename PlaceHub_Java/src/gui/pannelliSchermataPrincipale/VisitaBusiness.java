package gui.pannelliSchermataPrincipale;

import javax.swing.JPanel;

import errori.NumeroStelleNonValidoException;
import gestione.Controller;
import oggetti.Locale;
import res.ScrollPaneVerde;
import res.WrapLayout;

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
import javax.swing.GroupLayout;
import javax.swing.GroupLayout.Alignment;
import java.awt.event.ActionListener;
import java.awt.event.ActionEvent;
import javax.swing.LayoutStyle.ComponentPlacement;
import javax.swing.SwingConstants;

public class VisitaBusiness extends JPanel {
	private static final long serialVersionUID = 1L;
	
	private JButton bottoneRecensisci;
	private JLabel testoNomeBusiness;
	private JPanel stelle;
	private JLabel immagineIndirizzo;
	private JLabel testoIndirizzo;
	private JLabel immagineTelefono;
	private JLabel testoNumeroTelefono;
	private JLabel testoTipoBusiness;
	private ScrollPaneVerde scrollPaneImmagini;
	private JPanel pannelloImmagini;
	private JPanel pannelloRecensioni;
	private ScrollPaneVerde scrollPaneRecensioni;
	private JTextArea testoDescrizioneBusiness;
	
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
		generaTestoNumeroTelefono();
		generaTestoTipoBusiness();
		generaTestoDescrizioneBusiness();
		
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
		add(testoTipoBusiness);
		add(testoNomeBusiness);
		add(immagineTelefono);
		add(testoNumeroTelefono);
		add(immagineIndirizzo);
		add(testoIndirizzo);
		add(testoDescrizioneBusiness);
		
		JLabel immagineRaffinazioni = new JLabel("");
		immagineRaffinazioni.setIcon(new ImageIcon(VisitaBusiness.class.getResource("/Icone/immagineRaffinazioni.png")));
		immagineRaffinazioni.setBounds(28, 184, 31, 31);
		add(immagineRaffinazioni);
	}
	

	private void generaTestoDescrizioneBusiness() {
		testoDescrizioneBusiness = new JTextArea("DINAMICO");
		testoDescrizioneBusiness.setBounds(429, 240, 380, 199);
		testoDescrizioneBusiness.setFont(new Font("Roboto", Font.PLAIN, 15));
		testoDescrizioneBusiness.setBorder(new LineBorder(Color.BLACK,1));
		testoDescrizioneBusiness.setEditable(false);
	}


	private void generaTestoTipoBusiness() {
		testoTipoBusiness = new JLabel("DINAMICO");
		testoTipoBusiness.setBounds(71, 184, 767, 31);
		testoTipoBusiness.setHorizontalAlignment(SwingConstants.LEFT);
		testoTipoBusiness.setFont(new Font("Roboto", Font.PLAIN, 20));
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
		stelle = new JPanel();
		stelle.setBounds(559, 12, 249, 50);
		stelle.setBackground(Color.WHITE);
		stelle.setLayout(new WrapLayout(WrapLayout.LEFT, 1 ,1));
	}


	private void generaTestoNomeBusiness() {
		testoNomeBusiness = new JLabel("DINAMICO");
		testoNomeBusiness.setBounds(18, 12, 523, 54);
		testoNomeBusiness.setHorizontalAlignment(SwingConstants.CENTER);
		testoNomeBusiness.setFont(new Font("Roboto", Font.BOLD, 25));
	}
	
	
	private void generaBottoneRecensisci() {
		bottoneRecensisci = new JButton("");
		bottoneRecensisci.setBounds(545, 90, 269, 50);
		bottoneRecensisci.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent arg0) {
				ctrl.scriviUnaRecensione();
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
		testoDescrizioneBusiness.setText(locale.getDescrizione());
		testoTipoBusiness.setText(locale.getRaffinazioni());
		
		for (String immagine: locale.getListaImmagini())
			aggiungiImmagineAVisualizzatore(new File(immagine));
	}
	
	private void pulisciPannello() {
		testoNomeBusiness.setText("");
		testoIndirizzo.setText("");
		testoNumeroTelefono.setText("");
		testoDescrizioneBusiness.setText("");
		testoTipoBusiness.setText("");
		
		pannelloImmagini.removeAll();
		pannelloRecensioni.removeAll();
	}
	
	private void aggiungiImmagineAVisualizzatore(File nuovaImmagine) {
		try {
			Image imgScalata = new ImageIcon(ImageIO.read(nuovaImmagine)).getImage().getScaledInstance(280, 160, java.awt.Image.SCALE_SMOOTH);
			
			JLabel immagine = new JLabel();
			immagine.setSize(280, 160);
			immagine.setIcon(new ImageIcon(imgScalata));
			
			pannelloImmagini.add(immagine);
		} catch (IOException e) {
			e.printStackTrace();
		}
	}
	
	public void gestioneStelle(int numStelle, boolean mezzaStella) throws NumeroStelleNonValidoException{
		if((numStelle==5 && mezzaStella) || numStelle>5)
			throw new NumeroStelleNonValidoException();
		
		for(int i=0; i<numStelle; i++) {
			JLabel stellaPiena = new JLabel();
			stellaPiena.setIcon(new ImageIcon(Locale.class.getResource("/Icone/stella.png")));
			stelle.add(stellaPiena);
		}
		
		if(mezzaStella) {
			JLabel stellaPiena = new JLabel();
			stellaPiena.setIcon(new ImageIcon(Locale.class.getResource("/Icone/mezzaStella.png")));
			stelle.add(stellaPiena);
		}
	}
}
