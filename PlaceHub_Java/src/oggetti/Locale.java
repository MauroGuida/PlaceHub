package oggetti;


import javax.swing.JPanel;

import java.awt.Color;
import javax.swing.JLabel;
import java.awt.Font;
import java.awt.Image;
import java.io.IOException;
import java.net.URL;

import javax.swing.ImageIcon;
import javax.imageio.ImageIO;
import javax.swing.border.LineBorder;

import errori.NumeroStelleNonValidoException;
import res.WrapLayout;
import javax.swing.GroupLayout;
import javax.swing.GroupLayout.Alignment;

public class Locale extends JPanel {
	private static final long serialVersionUID = 1L;
	
	private JPanel stelle;
	
	public Locale(String nomeBusiness, String indirizzo, String urlImmagine) {
		setBackground(Color.WHITE);
		setSize(400,250);
		setVisible(true);
		setBorder(new LineBorder(Color.DARK_GRAY,1));
		
		stelle = new JPanel();
		stelle.setBackground(Color.WHITE);
		stelle.setLayout(new WrapLayout(WrapLayout.LEFT, 1 ,1));
		
		JLabel labelNome = new JLabel(nomeBusiness);
		labelNome.setFont(new Font("Roboto", Font.PLAIN, 17));
		
		JLabel labelLuogo = new JLabel(indirizzo);
		labelLuogo.setFont(new Font("Roboto", Font.PLAIN, 17));
		
		JLabel labelmmagine = new JLabel();
		try {
			URL url = new URL(urlImmagine);
			Image immagine = new ImageIcon(ImageIO.read(url)).getImage();
			Image immagineScalata = immagine.getScaledInstance(374, 180, java.awt.Image.SCALE_SMOOTH);
			labelmmagine.setIcon(new ImageIcon(immagineScalata));
		}catch(IOException e) {
			e.printStackTrace();
		}
		
		GroupLayout groupLayout = new GroupLayout(this);
		groupLayout.setHorizontalGroup(
			groupLayout.createParallelGroup(Alignment.LEADING)
				.addGroup(groupLayout.createSequentialGroup()
					.addGap(12)
					.addGroup(groupLayout.createParallelGroup(Alignment.LEADING)
						.addGroup(groupLayout.createSequentialGroup()
							.addComponent(labelNome, GroupLayout.DEFAULT_SIZE, 185, Short.MAX_VALUE)
							.addGap(189))
						.addComponent(labelmmagine, GroupLayout.DEFAULT_SIZE, 374, Short.MAX_VALUE)
						.addGroup(groupLayout.createSequentialGroup()
							.addGap(195)
							.addComponent(labelLuogo, GroupLayout.DEFAULT_SIZE, 179, Short.MAX_VALUE))
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
							.addComponent(labelNome, GroupLayout.PREFERRED_SIZE, 24, GroupLayout.PREFERRED_SIZE))
						.addGroup(groupLayout.createSequentialGroup()
							.addComponent(labelmmagine, GroupLayout.DEFAULT_SIZE, 180, Short.MAX_VALUE)
							.addGap(23))
						.addGroup(groupLayout.createSequentialGroup()
							.addGap(179)
							.addComponent(labelLuogo, GroupLayout.PREFERRED_SIZE, 24, GroupLayout.PREFERRED_SIZE)))
					.addGap(6)
					.addComponent(stelle, GroupLayout.PREFERRED_SIZE, 24, GroupLayout.PREFERRED_SIZE))
		);
		setLayout(groupLayout);
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
