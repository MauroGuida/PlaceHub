package gui;

import java.awt.Color;
import java.awt.Font;
import java.awt.Image;

import javax.swing.GroupLayout;
import javax.swing.ImageIcon;
import javax.swing.JLabel;
import javax.swing.JPanel;
import javax.swing.GroupLayout.Alignment;
import javax.swing.border.LineBorder;

import errori.NumeroStelleNonValidoException;
import oggetti.Locale;
import res.WrapLayout;

public class LocaleGUI extends JPanel {
	private static final long serialVersionUID = 1L;
	
	private JPanel stelle;
	private JLabel testoNome;
	private JLabel testoIndirizzo;
	private JLabel labelImmaginePrincipale;
	
	private Locale locale;

	public LocaleGUI(Locale locale) {
		this.locale = locale;
		
		try {
			aggiungiStelle(Math.round(locale.getStelle()), false);
		} catch (NumeroStelleNonValidoException e) {
			e.printStackTrace();
		}
		
		generaEsteticaPannello();
		
		generaStelle();
		generaTestoNome();
		generaTestoIndirizzo();
		generaImmaginePrincipale();
		
		generaLayout();
	}
	
	private void generaEsteticaPannello() {
		setBackground(Color.WHITE);
		setSize(400,250);
		setVisible(true);
		setBorder(new LineBorder(Color.DARK_GRAY,1));
	}

	private void generaStelle() {
		stelle = new JPanel();
		stelle.setBackground(Color.WHITE);
		stelle.setLayout(new WrapLayout(WrapLayout.LEFT, 1 ,1));
	}

	
	private void generaTestoIndirizzo() {
		testoIndirizzo = new JLabel(locale.getIndirizzo());
		testoIndirizzo.setFont(new Font("Roboto", Font.PLAIN, 17));
	}

	private void generaTestoNome() {
		testoNome = new JLabel(locale.getNome());
		testoNome.setFont(new Font("Roboto", Font.PLAIN, 17));
	}

	private void generaImmaginePrincipale() {
		labelImmaginePrincipale = new JLabel();
		try {
			Image immagine = new ImageIcon(locale.getImmaginePrincipale()).getImage();
			Image immagineScalata = immagine.getScaledInstance(374, 180, java.awt.Image.SCALE_SMOOTH);
			labelImmaginePrincipale.setIcon(new ImageIcon(immagineScalata));
		} catch(IndexOutOfBoundsException e) {
			e.printStackTrace();
		}
	}

	private void generaLayout() {
		GroupLayout groupLayout = new GroupLayout(this);
		groupLayout.setHorizontalGroup(
			groupLayout.createParallelGroup(Alignment.LEADING)
				.addGroup(groupLayout.createSequentialGroup()
					.addGap(12)
					.addGroup(groupLayout.createParallelGroup(Alignment.LEADING)
						.addGroup(groupLayout.createSequentialGroup()
							.addComponent(testoNome, GroupLayout.DEFAULT_SIZE, 185, Short.MAX_VALUE)
							.addGap(189))
						.addComponent(labelImmaginePrincipale, GroupLayout.DEFAULT_SIZE, 374, Short.MAX_VALUE)
						.addGroup(groupLayout.createSequentialGroup()
							.addGap(195)
							.addComponent(testoIndirizzo, GroupLayout.DEFAULT_SIZE, 179, Short.MAX_VALUE))
						.addComponent(stelle, GroupLayout.PREFERRED_SIZE, 170, GroupLayout.PREFERRED_SIZE))
					.addGap(12))
		);
		groupLayout.setVerticalGroup(
			groupLayout.createParallelGroup(Alignment.LEADING)
				.addGroup(groupLayout.createSequentialGroup()
					.addGap(16)
					.addGroup(groupLayout.createParallelGroup(Alignment.LEADING)
						.addGroup(groupLayout.createSequentialGroup()
							.addGap(179)
							.addComponent(testoNome, GroupLayout.PREFERRED_SIZE, 24, GroupLayout.PREFERRED_SIZE))
						.addGroup(groupLayout.createSequentialGroup()
							.addComponent(labelImmaginePrincipale, GroupLayout.DEFAULT_SIZE, 180, Short.MAX_VALUE)
							.addGap(23))
						.addGroup(groupLayout.createSequentialGroup()
							.addGap(179)
							.addComponent(testoIndirizzo, GroupLayout.PREFERRED_SIZE, 24, GroupLayout.PREFERRED_SIZE)))
					.addGap(6)
					.addComponent(stelle, GroupLayout.PREFERRED_SIZE, 24, GroupLayout.PREFERRED_SIZE))
		);
		setLayout(groupLayout);
	}

	
	//METODI
	
	
	public void aggiungiStelle(int numStelle, boolean mezzaStella) throws NumeroStelleNonValidoException{
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
