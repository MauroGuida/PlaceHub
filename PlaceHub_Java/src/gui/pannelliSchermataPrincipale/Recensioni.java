package gui.pannelliSchermataPrincipale;

import javax.swing.JPanel;

import errori.NumeroStelleNonValidoException;
import oggetti.Locale;
import res.ScrollPaneVerde;
import res.WrapLayout;

import java.awt.Color;
import javax.swing.JButton;
import java.awt.event.MouseAdapter;
import java.awt.event.MouseEvent;
import javax.swing.ImageIcon;
import javax.swing.JLabel;
import java.awt.Font;
import javax.swing.JScrollPane;
import javax.swing.JTextArea;
import javax.swing.border.LineBorder;
import javax.swing.ScrollPaneConstants;
import javax.swing.GroupLayout;
import javax.swing.GroupLayout.Alignment;
import java.awt.event.ActionListener;
import java.awt.event.ActionEvent;

public class Recensioni extends JPanel {
	private static final long serialVersionUID = 1L;
	
	private JButton bottoneRecensisci;
	private JLabel testoNomeBusiness;
	private JPanel stelle;
	private JLabel immagineIndirizzo;
	private JLabel testoIndirizzo;
	private JLabel immagineTelefono;
	private JLabel testoNumeroTelefono;
	private JLabel testoTipoBusiness;
	private ScrollPaneVerde scrollPaneFoto;
	private JPanel pannelloContenitoreFoto;
	private JPanel pannelloContenitoreRecensioni;
	private ScrollPaneVerde scrollPaneRecensioni;
	private JTextArea testoDescrizioneBusiness;
	
	public Recensioni(String nomeBusiness, String indirizzoBusiness, 
					  String telefono, String tipoBusiness,
					  String descrizioneBusiness, int numStelle) {
		setBackground(Color.WHITE);
		setSize(850, 614);
		
		generaBottoneRecensisci();
		generaTestoNomeBusiness(nomeBusiness);
		generaStelle();
		generaImmagineIndirizzo();
		generaTestoIndirizzo(indirizzoBusiness);
		generaImmagineTelefono();
		generaTestoNumeroTelefono(telefono);
		generaTestoTipoBusiness(tipoBusiness);
		generaTestoDescrizioneBusiness(descrizioneBusiness);
		
		
		pannelloContenitoreFoto = new JPanel();
		pannelloContenitoreFoto.setBackground(Color.WHITE);
		pannelloContenitoreFoto.setLayout(new WrapLayout(WrapLayout.LEFT));
		pannelloContenitoreFoto.setBorder(new LineBorder(Color.DARK_GRAY,1));
		scrollPaneFoto = new ScrollPaneVerde();
		scrollPaneFoto.setVerticalScrollBarPolicy(ScrollPaneConstants.VERTICAL_SCROLLBAR_NEVER);
		scrollPaneFoto.setHorizontalScrollBarPolicy(ScrollPaneConstants.HORIZONTAL_SCROLLBAR_ALWAYS);
		scrollPaneFoto.setBackground(Color.WHITE);
		scrollPaneFoto.setViewportView(pannelloContenitoreFoto);
		
		
		
		pannelloContenitoreRecensioni = new JPanel();
		pannelloContenitoreRecensioni.setBackground(Color.WHITE);
		pannelloContenitoreRecensioni.setBorder(new LineBorder(Color.DARK_GRAY,1));
		
		scrollPaneRecensioni = new ScrollPaneVerde();
		scrollPaneRecensioni.setVerticalScrollBarPolicy(ScrollPaneConstants.VERTICAL_SCROLLBAR_ALWAYS);
		scrollPaneRecensioni.setHorizontalScrollBarPolicy(ScrollPaneConstants.HORIZONTAL_SCROLLBAR_NEVER);
		scrollPaneRecensioni.setViewportView(pannelloContenitoreRecensioni);
		add(testoIndirizzo);
		testoIndirizzo = new JLabel(indirizzoBusiness);
		testoIndirizzo.setFont(new Font("Roboto", Font.PLAIN, 14));
		GroupLayout groupLayout = new GroupLayout(this);
		groupLayout.setHorizontalGroup(
			groupLayout.createParallelGroup(Alignment.LEADING)
				.addGroup(groupLayout.createSequentialGroup()
					.addGap(42)
					.addGroup(groupLayout.createParallelGroup(Alignment.TRAILING)
						.addComponent(testoDescrizioneBusiness, GroupLayout.DEFAULT_SIZE, 766, Short.MAX_VALUE)
						.addComponent(scrollPaneFoto, GroupLayout.DEFAULT_SIZE, 766, Short.MAX_VALUE)
						.addComponent(scrollPaneRecensioni, GroupLayout.DEFAULT_SIZE, 766, Short.MAX_VALUE)
						.addGroup(groupLayout.createSequentialGroup()
							.addGroup(groupLayout.createParallelGroup(Alignment.LEADING)
								.addGroup(groupLayout.createSequentialGroup()
									.addComponent(testoNomeBusiness, GroupLayout.DEFAULT_SIZE, 270, Short.MAX_VALUE)
									.addGap(28)
									.addComponent(stelle, GroupLayout.PREFERRED_SIZE, 170, GroupLayout.PREFERRED_SIZE)
									.addGap(99))
								.addGroup(groupLayout.createSequentialGroup()
									.addComponent(immagineIndirizzo, GroupLayout.PREFERRED_SIZE, 31, GroupLayout.PREFERRED_SIZE)
									.addGap(12)
									.addComponent(testoIndirizzo, GroupLayout.DEFAULT_SIZE, 237, Short.MAX_VALUE)
									.addGap(18)
									.addComponent(immagineTelefono, GroupLayout.PREFERRED_SIZE, 31, GroupLayout.PREFERRED_SIZE)
									.addGap(24)
									.addComponent(testoNumeroTelefono, GroupLayout.DEFAULT_SIZE, 200, Short.MAX_VALUE)
									.addGap(14)))
							.addGroup(groupLayout.createParallelGroup(Alignment.LEADING, false)
								.addComponent(testoTipoBusiness, Alignment.TRAILING, GroupLayout.PREFERRED_SIZE, 199, GroupLayout.PREFERRED_SIZE)
								.addComponent(bottoneRecensisci, Alignment.TRAILING, GroupLayout.PREFERRED_SIZE, 199, GroupLayout.PREFERRED_SIZE))))
					.addGap(42))
		);
		groupLayout.setVerticalGroup(
			groupLayout.createParallelGroup(Alignment.LEADING)
				.addGroup(groupLayout.createSequentialGroup()
					.addGap(30)
					.addGroup(groupLayout.createParallelGroup(Alignment.LEADING)
						.addComponent(testoNomeBusiness, GroupLayout.PREFERRED_SIZE, 50, GroupLayout.PREFERRED_SIZE)
						.addGroup(groupLayout.createSequentialGroup()
							.addGap(12)
							.addComponent(stelle, GroupLayout.PREFERRED_SIZE, 24, GroupLayout.PREFERRED_SIZE))
						.addComponent(bottoneRecensisci, GroupLayout.PREFERRED_SIZE, 50, GroupLayout.PREFERRED_SIZE))
					.addGap(30)
					.addGroup(groupLayout.createParallelGroup(Alignment.LEADING)
						.addComponent(immagineIndirizzo, GroupLayout.PREFERRED_SIZE, 31, GroupLayout.PREFERRED_SIZE)
						.addComponent(immagineTelefono, GroupLayout.PREFERRED_SIZE, 31, GroupLayout.PREFERRED_SIZE)
						.addComponent(testoIndirizzo, GroupLayout.PREFERRED_SIZE, 31, GroupLayout.PREFERRED_SIZE)
						.addComponent(testoTipoBusiness, GroupLayout.PREFERRED_SIZE, 31, GroupLayout.PREFERRED_SIZE)
						.addComponent(testoNumeroTelefono, GroupLayout.PREFERRED_SIZE, 31, GroupLayout.PREFERRED_SIZE))
					.addGap(19)
					.addComponent(testoDescrizioneBusiness, GroupLayout.PREFERRED_SIZE, 100, GroupLayout.PREFERRED_SIZE)
					.addGap(30)
					.addComponent(scrollPaneFoto, GroupLayout.DEFAULT_SIZE, 140, Short.MAX_VALUE)
					.addGap(20)
					.addComponent(scrollPaneRecensioni, GroupLayout.DEFAULT_SIZE, 140, Short.MAX_VALUE)
					.addGap(24))
		);
		setLayout(groupLayout);
	}
	

	private void generaTestoDescrizioneBusiness(String descrizioneBusiness) {
		testoDescrizioneBusiness = new JTextArea(descrizioneBusiness);
		testoDescrizioneBusiness.setFont(new Font("Roboto", Font.PLAIN, 13));
		testoDescrizioneBusiness.setBorder(new LineBorder(Color.W,1));
		testoDescrizioneBusiness.setEditable(false);
	}


	private void generaTestoTipoBusiness(String tipoBusiness) {
		testoTipoBusiness = new JLabel(tipoBusiness);
		testoTipoBusiness.setFont(new Font("Roboto", Font.PLAIN, 14));
	}


	private void generaTestoNumeroTelefono(String telefono) {
		testoNumeroTelefono = new JLabel(telefono);
		testoNumeroTelefono.setFont(new Font("Roboto", Font.PLAIN, 14));
	}

	
	private void generaImmagineTelefono() {
		immagineTelefono = new JLabel("");
		immagineTelefono.setIcon(new ImageIcon(Recensioni.class.getResource("/Icone/iconaTelefono.png")));
	}

	
	private void generaTestoIndirizzo(String indirizzoBusiness) {

	}
	

	private void generaImmagineIndirizzo() {
		immagineIndirizzo = new JLabel("");
		immagineIndirizzo.setIcon(new ImageIcon(Recensioni.class.getResource("/Icone/iconaIndirizzo.png")));
	}


	private void generaStelle() {
		stelle = new JPanel();
		stelle.setBackground(Color.WHITE);
		stelle.setLayout(new WrapLayout(WrapLayout.LEFT, 1 ,1));
	}


	private void generaTestoNomeBusiness(String nomeBusiness) {
		testoNomeBusiness = new JLabel(nomeBusiness);
		testoNomeBusiness.setFont(new Font("Roboto", Font.PLAIN, 17));
	}
	
	
	private void generaBottoneRecensisci() {
		bottoneRecensisci = new JButton("");
		bottoneRecensisci.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent arg0) {
			}
		});
		bottoneRecensisci.setIcon(new ImageIcon(Recensioni.class.getResource("/Icone/bottoneRecensione.png")));
		bottoneRecensisci.setOpaque(false);
		bottoneRecensisci.setBorderPainted(false);
		bottoneRecensisci.setContentAreaFilled(false);
		bottoneRecensisci.setFocusPainted(false);
		bottoneRecensisci.addMouseListener(new MouseAdapter() {
			@Override
			public void mouseEntered(MouseEvent e) {
				bottoneRecensisci.setIcon(new ImageIcon(Recensioni.class.getResource("/Icone/bottoneRecensioneFocus.png")));
			}
			@Override
			public void mouseExited(MouseEvent e) {
				bottoneRecensisci.setIcon(new ImageIcon(Recensioni.class.getResource("/Icone/bottoneRecensione.png")));
			}
		});
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
