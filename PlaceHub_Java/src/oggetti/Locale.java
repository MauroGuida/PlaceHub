package oggetti;


import javax.swing.JPanel;

import java.awt.Color;
import javax.swing.JLabel;
import java.awt.Font;
import java.awt.image.BufferedImage;
import java.io.IOException;
import java.net.URL;

import javax.swing.ImageIcon;
import javax.imageio.ImageIO;
import javax.swing.GroupLayout;
import javax.swing.GroupLayout.Alignment;
import javax.swing.LayoutStyle.ComponentPlacement;

public class Locale extends JPanel {
	private static final long serialVersionUID = 1L;
	private BufferedImage immagine;
	private JLabel lblStelle;
	
	public Locale(String nomeBusiness, String indirizzo, int numStelle, String urlImmagine) {
		setBackground(Color.WHITE);
		setSize(260,210);
		setVisible(true);
		
		JLabel labelNome = new JLabel(nomeBusiness);
		labelNome.setFont(new Font("Roboto", Font.PLAIN, 13));
		
		JLabel labelLuogo = new JLabel(indirizzo);
		labelLuogo.setFont(new Font("Roboto", Font.PLAIN, 13));
		
		lblStelle = new JLabel();
		lblStelle.setIcon(new ImageIcon(Locale.class.getResource("/Icone/stella.png")));
		lblStelle.setFont(new Font("Roboto", Font.PLAIN, 13));
		
		JLabel labelmmagine = new JLabel();
		try {
			URL url = new URL(urlImmagine);
			immagine = ImageIO.read(url);
			labelmmagine.setIcon(new ImageIcon(immagine));
		}catch(IOException e) {
			e.printStackTrace();
		}
		labelmmagine.setBackground(Color.RED);
		GroupLayout groupLayout = new GroupLayout(this);
		groupLayout.setHorizontalGroup(
			groupLayout.createParallelGroup(Alignment.LEADING)
				.addGroup(groupLayout.createSequentialGroup()
					.addGap(5)
					.addComponent(labelmmagine, GroupLayout.DEFAULT_SIZE, 250, Short.MAX_VALUE)
					.addGap(5))
				.addGroup(groupLayout.createSequentialGroup()
					.addGap(5)
					.addComponent(labelNome, GroupLayout.DEFAULT_SIZE, 115, Short.MAX_VALUE)
					.addGap(17)
					.addComponent(labelLuogo, GroupLayout.DEFAULT_SIZE, 111, Short.MAX_VALUE)
					.addGap(12))
				.addGroup(groupLayout.createSequentialGroup()
					.addGap(15)
					.addComponent(lblStelle, GroupLayout.DEFAULT_SIZE, 187, Short.MAX_VALUE)
					.addGap(58))
		);
		groupLayout.setVerticalGroup(
			groupLayout.createParallelGroup(Alignment.LEADING)
				.addGroup(groupLayout.createSequentialGroup()
					.addGap(10)
					.addComponent(labelmmagine, GroupLayout.PREFERRED_SIZE, 120, GroupLayout.PREFERRED_SIZE)
					.addGap(12)
					.addGroup(groupLayout.createParallelGroup(Alignment.LEADING)
						.addComponent(labelNome, GroupLayout.PREFERRED_SIZE, 30, GroupLayout.PREFERRED_SIZE)
						.addComponent(labelLuogo, GroupLayout.PREFERRED_SIZE, 30, GroupLayout.PREFERRED_SIZE))
					.addGap(8)
					.addComponent(lblStelle, GroupLayout.PREFERRED_SIZE, 30, GroupLayout.PREFERRED_SIZE))
		);
		setLayout(groupLayout);
	}
}
