package oggetti;


import javax.swing.JPanel;

import java.awt.Color;
import javax.swing.JLabel;
import java.awt.Font;
import java.awt.Image;
import java.awt.image.BufferedImage;
import java.io.IOException;
import java.net.URL;

import javax.swing.ImageIcon;
import javax.imageio.ImageIO;
import javax.swing.GroupLayout;
import javax.swing.GroupLayout.Alignment;
import javax.swing.LayoutStyle.ComponentPlacement;
import javax.swing.border.LineBorder;

public class Locale extends JPanel {
	private static final long serialVersionUID = 1L;
	private BufferedImage immagine;
	private JLabel lblStelle;
	
	public Locale(String nomeBusiness, String indirizzo, int numStelle, String urlImmagine) {
		setBackground(Color.WHITE);
		setSize(400,250);
		setVisible(true);
		setBorder(new LineBorder(Color.DARK_GRAY,1));
		JLabel labelNome = new JLabel(nomeBusiness);
		labelNome.setFont(new Font("Roboto", Font.PLAIN, 17));
		
		JLabel labelLuogo = new JLabel(indirizzo);
		labelLuogo.setFont(new Font("Roboto", Font.PLAIN, 17));
		
		lblStelle = new JLabel();
		lblStelle.setIcon(new ImageIcon(Locale.class.getResource("/Icone/stella.png")));
		lblStelle.setFont(new Font("Roboto", Font.PLAIN, 13));
		
		JLabel labelmmagine = new JLabel();
		try {
			URL url = new URL(urlImmagine);
			Image immagine = new ImageIcon(ImageIO.read(url)).getImage();
			Image immagineScalata = immagine.getScaledInstance(374, 180, java.awt.Image.SCALE_SMOOTH);
			labelmmagine.setIcon(new ImageIcon(immagineScalata));
		}catch(IOException e) {
			e.printStackTrace();
		}
		labelmmagine.setBackground(Color.RED);
		GroupLayout groupLayout = new GroupLayout(this);
		groupLayout.setHorizontalGroup(
			groupLayout.createParallelGroup(Alignment.LEADING)
				.addGroup(groupLayout.createSequentialGroup()
					.addGap(12)
					.addGroup(groupLayout.createParallelGroup(Alignment.LEADING)
						.addGroup(groupLayout.createSequentialGroup()
							.addComponent(labelNome, GroupLayout.PREFERRED_SIZE, 185, GroupLayout.PREFERRED_SIZE)
							.addGap(10)
							.addComponent(labelLuogo, GroupLayout.PREFERRED_SIZE, 179, GroupLayout.PREFERRED_SIZE))
						.addComponent(labelmmagine, GroupLayout.DEFAULT_SIZE, 374, Short.MAX_VALUE)
						.addComponent(lblStelle, GroupLayout.PREFERRED_SIZE, 185, GroupLayout.PREFERRED_SIZE))
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
							.addGap(179)
							.addComponent(labelLuogo, GroupLayout.PREFERRED_SIZE, 24, GroupLayout.PREFERRED_SIZE))
						.addComponent(labelmmagine, GroupLayout.PREFERRED_SIZE, 180, GroupLayout.PREFERRED_SIZE))
					.addComponent(lblStelle, GroupLayout.PREFERRED_SIZE, 30, GroupLayout.PREFERRED_SIZE))
		);
		setLayout(groupLayout);
		
	}
}
