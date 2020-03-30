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
		GroupLayout groupLayout = new GroupLayout(this);
		groupLayout.setHorizontalGroup(
			groupLayout.createParallelGroup(Alignment.LEADING)
				.addGroup(groupLayout.createSequentialGroup()
					.addContainerGap()
					.addComponent(scrollPaneRecensioni, GroupLayout.DEFAULT_SIZE, 830, Short.MAX_VALUE)
					.addContainerGap())
				.addGroup(groupLayout.createSequentialGroup()
					.addGroup(groupLayout.createParallelGroup(Alignment.LEADING)
						.addGroup(groupLayout.createSequentialGroup()
							.addGap(27)
							.addGroup(groupLayout.createParallelGroup(Alignment.TRAILING)
								.addComponent(immagineIndirizzo, GroupLayout.PREFERRED_SIZE, 31, GroupLayout.PREFERRED_SIZE)
								.addComponent(immagineTelefono, GroupLayout.PREFERRED_SIZE, 31, GroupLayout.PREFERRED_SIZE))
							.addGap(10)
							.addGroup(groupLayout.createParallelGroup(Alignment.LEADING)
								.addGroup(groupLayout.createSequentialGroup()
									.addComponent(testoNumeroTelefono, GroupLayout.DEFAULT_SIZE, 245, Short.MAX_VALUE)
									.addGap(278))
								.addComponent(testoIndirizzo, GroupLayout.DEFAULT_SIZE, 523, Short.MAX_VALUE)))
						.addGroup(groupLayout.createSequentialGroup()
							.addContainerGap()
							.addComponent(testoNomeBusiness, GroupLayout.DEFAULT_SIZE, 581, Short.MAX_VALUE)))
					.addGap(18)
					.addGroup(groupLayout.createParallelGroup(Alignment.TRAILING)
						.addComponent(stelle, GroupLayout.DEFAULT_SIZE, 223, Short.MAX_VALUE)
						.addComponent(bottoneRecensisci, GroupLayout.PREFERRED_SIZE, 199, Short.MAX_VALUE))
					.addContainerGap())
				.addGroup(groupLayout.createSequentialGroup()
					.addContainerGap()
					.addComponent(scrollPaneImmagini, GroupLayout.DEFAULT_SIZE, 830, Short.MAX_VALUE)
					.addContainerGap())
				.addGroup(groupLayout.createSequentialGroup()
					.addContainerGap()
					.addComponent(testoDescrizioneBusiness, GroupLayout.DEFAULT_SIZE, 830, Short.MAX_VALUE)
					.addContainerGap())
				.addGroup(groupLayout.createSequentialGroup()
					.addContainerGap()
					.addComponent(testoTipoBusiness, GroupLayout.DEFAULT_SIZE, 830, Short.MAX_VALUE)
					.addContainerGap())
		);
		groupLayout.setVerticalGroup(
			groupLayout.createParallelGroup(Alignment.LEADING)
				.addGroup(groupLayout.createSequentialGroup()
					.addContainerGap()
					.addGroup(groupLayout.createParallelGroup(Alignment.TRAILING)
						.addComponent(testoNomeBusiness, GroupLayout.PREFERRED_SIZE, 54, GroupLayout.PREFERRED_SIZE)
						.addComponent(bottoneRecensisci, GroupLayout.PREFERRED_SIZE, 50, GroupLayout.PREFERRED_SIZE))
					.addGroup(groupLayout.createParallelGroup(Alignment.LEADING)
						.addGroup(groupLayout.createSequentialGroup()
							.addPreferredGap(ComponentPlacement.RELATED)
							.addGroup(groupLayout.createParallelGroup(Alignment.LEADING)
								.addComponent(immagineIndirizzo, GroupLayout.PREFERRED_SIZE, 31, GroupLayout.PREFERRED_SIZE)
								.addComponent(testoIndirizzo, GroupLayout.PREFERRED_SIZE, 31, GroupLayout.PREFERRED_SIZE))
							.addPreferredGap(ComponentPlacement.UNRELATED)
							.addGroup(groupLayout.createParallelGroup(Alignment.LEADING)
								.addComponent(testoNumeroTelefono, GroupLayout.PREFERRED_SIZE, 31, GroupLayout.PREFERRED_SIZE)
								.addComponent(immagineTelefono, GroupLayout.PREFERRED_SIZE, 31, GroupLayout.PREFERRED_SIZE)))
						.addGroup(groupLayout.createSequentialGroup()
							.addGap(21)
							.addComponent(stelle, GroupLayout.PREFERRED_SIZE, 24, GroupLayout.PREFERRED_SIZE)))
					.addPreferredGap(ComponentPlacement.UNRELATED)
					.addComponent(testoTipoBusiness, GroupLayout.PREFERRED_SIZE, 31, GroupLayout.PREFERRED_SIZE)
					.addGap(13)
					.addComponent(testoDescrizioneBusiness, GroupLayout.PREFERRED_SIZE, 84, GroupLayout.PREFERRED_SIZE)
					.addPreferredGap(ComponentPlacement.RELATED)
					.addComponent(scrollPaneImmagini, GroupLayout.DEFAULT_SIZE, 142, Short.MAX_VALUE)
					.addPreferredGap(ComponentPlacement.RELATED)
					.addComponent(scrollPaneRecensioni, GroupLayout.DEFAULT_SIZE, 142, Short.MAX_VALUE)
					.addGap(24))
		);
		setLayout(groupLayout);
	}
	

	private void generaTestoDescrizioneBusiness() {
		testoDescrizioneBusiness = new JTextArea("DINAMICO");
		testoDescrizioneBusiness.setFont(new Font("Roboto", Font.PLAIN, 15));
		testoDescrizioneBusiness.setBorder(new LineBorder(Color.BLACK,1));
		testoDescrizioneBusiness.setEditable(false);
	}


	private void generaTestoTipoBusiness() {
		testoTipoBusiness = new JLabel("DINAMICO");
		testoTipoBusiness.setHorizontalAlignment(SwingConstants.CENTER);
		testoTipoBusiness.setFont(new Font("Roboto", Font.PLAIN, 14));
	}


	private void generaTestoNumeroTelefono() {
		testoNumeroTelefono = new JLabel("DINAMICO");
		testoNumeroTelefono.setFont(new Font("Roboto", Font.PLAIN, 17));
	}

	
	private void generaImmagineTelefono() {
		immagineTelefono = new JLabel();
		immagineTelefono.setIcon(new ImageIcon(VisitaBusiness.class.getResource("/Icone/iconaTelefono.png")));
	}

	
	private void generaTestoIndirizzo() {
		testoIndirizzo = new JLabel("DINAMICO");
		testoIndirizzo.setFont(new Font("Roboto", Font.PLAIN, 12));
	}
	

	private void generaImmagineIndirizzo() {
		immagineIndirizzo = new JLabel("");
		immagineIndirizzo.setIcon(new ImageIcon(VisitaBusiness.class.getResource("/Icone/iconaIndirizzo.png")));
	}


	private void generaStelle() {
		stelle = new JPanel();
		stelle.setBackground(Color.WHITE);
		stelle.setLayout(new WrapLayout(WrapLayout.LEFT, 1 ,1));
	}


	private void generaTestoNomeBusiness() {
		testoNomeBusiness = new JLabel("DINAMICO");
		testoNomeBusiness.setHorizontalAlignment(SwingConstants.CENTER);
		testoNomeBusiness.setFont(new Font("Roboto", Font.BOLD, 17));
	}
	
	
	private void generaBottoneRecensisci() {
		bottoneRecensisci = new JButton("");
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
			Image imgScalata = new ImageIcon(ImageIO.read(nuovaImmagine)).getImage().getScaledInstance(200, 110, java.awt.Image.SCALE_SMOOTH);
			
			JLabel immagine = new JLabel();
			immagine.setSize(200, 110);
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
