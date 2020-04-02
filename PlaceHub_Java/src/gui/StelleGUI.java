package gui;

import java.awt.Color;
import java.awt.FlowLayout;

import javax.swing.ImageIcon;
import javax.swing.JLabel;
import javax.swing.JPanel;

import oggetti.Locale;

public class StelleGUI extends JPanel {
	private static final long serialVersionUID = 1L;
	
	public StelleGUI() {
		setSize(185, 45);
		setBackground(Color.WHITE);
		setLayout(new FlowLayout(FlowLayout.LEFT));
	}
	
	public void aggiungiStelle(float numStelle){
		if(numStelle>5)
			System.err.print("Numero stelle non Valido!");
		else {
			double parteDecimale = numStelle - (int) numStelle;
			
			for(int i=0; i<numStelle; i++) {
				JLabel stellaPiena = new JLabel();
				stellaPiena.setIcon(new ImageIcon(Locale.class.getResource("/Icone/stella.png")));
				add(stellaPiena);
			}
			
			if(parteDecimale >= 0.5) {
				JLabel stellaPiena = new JLabel();
				stellaPiena.setIcon(new ImageIcon(Locale.class.getResource("/Icone/mezzaStella.png")));
				add(stellaPiena);
			}
		}
	}
}
