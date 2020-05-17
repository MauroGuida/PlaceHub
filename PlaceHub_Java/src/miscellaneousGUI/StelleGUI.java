package miscellaneousGUI;

import java.awt.Color;
import java.awt.FlowLayout;
import java.awt.Image;

import javax.swing.ImageIcon;
import javax.swing.JLabel;
import javax.swing.JPanel;

import oggettiServizio.Business;

public class StelleGUI extends JPanel {
	private static final long serialVersionUID = 1L;
	
	private final int stellaW = 30;
	private final int stellaH = 30;
	
	public StelleGUI() {
		setSize(185, 45);
		setBackground(Color.WHITE);
		setLayout(new FlowLayout(FlowLayout.LEFT));
	}
	
	public void aggiungiStelle(double numStelle){
		removeAll();
		if(numStelle>5)
			System.err.print("Numero stelle non Valido!");
		else {
			double parteDecimale = numStelle - (int) numStelle;
			
			for(int i=0; i< (int)numStelle; i++) {
				JLabel stellaPiena = new JLabel();
				Image immagineScalata = new ImageIcon(Business.class.getResource("/Icone/stella.png")).getImage().getScaledInstance(stellaW, stellaH, java.awt.Image.SCALE_SMOOTH);
				stellaPiena.setIcon(new ImageIcon(immagineScalata));
				add(stellaPiena);
			}
			
			if(parteDecimale >= 0.5) {
				JLabel mezzaStella = new JLabel();
				Image immagineScalata = new ImageIcon(Business.class.getResource("/Icone/mezzaStella.png")).getImage().getScaledInstance(stellaW, stellaH, java.awt.Image.SCALE_SMOOTH);
				mezzaStella.setIcon(new ImageIcon(immagineScalata));
				add(mezzaStella);
			}
		}
	}
}
