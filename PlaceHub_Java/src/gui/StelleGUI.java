package gui;

import java.awt.Color;
import java.awt.FlowLayout;

import javax.swing.ImageIcon;
import javax.swing.JLabel;
import javax.swing.JPanel;

import errori.NumeroStelleNonValidoException;
import oggetti.Locale;

public class StelleGUI extends JPanel {
	private static final long serialVersionUID = 1L;
	
	public StelleGUI() {
		setSize(185, 43);
		setBackground(Color.WHITE);
		setLayout(new FlowLayout(FlowLayout.LEFT));
	}
	
	public void aggiungiStelle(float numStelle) throws NumeroStelleNonValidoException{
		if(numStelle>5)
			throw new NumeroStelleNonValidoException();
		
		for(int i=0; i<numStelle; i++) {
			JLabel stellaPiena = new JLabel();
			stellaPiena.setIcon(new ImageIcon(Locale.class.getResource("/Icone/stella.png")));
			add(stellaPiena);
		}
	}
}
