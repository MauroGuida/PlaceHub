package gui.pannelliSchermataAccesso.menuATendina;

import java.awt.Color;
import java.awt.Graphics;
import java.awt.Image;
import java.io.InputStream;

import javax.imageio.ImageIO;
import javax.swing.ImageIcon;
import javax.swing.JPanel;
import javax.swing.JButton;
import javax.swing.GroupLayout;
import javax.swing.GroupLayout.Alignment;
import javax.swing.JLabel;
import javax.swing.LayoutStyle.ComponentPlacement;

public class Alloggi extends JPanel {
	private static final long serialVersionUID = 1L;
	
	public Alloggi() {
		setSize(184,206);
		setBackground(new Color(0,0,0,0));
		setVisible(true);
		
		JButton btnNewButton = new JButton("New button");
		
		JLabel lblNewLabel = new JLabel("");
		GroupLayout groupLayout = new GroupLayout(this);
		groupLayout.setHorizontalGroup(
			groupLayout.createParallelGroup(Alignment.LEADING)
				.addGroup(Alignment.TRAILING, groupLayout.createSequentialGroup()
					.addGap(21)
					.addComponent(btnNewButton, GroupLayout.PREFERRED_SIZE, 132, GroupLayout.PREFERRED_SIZE)
					.addPreferredGap(ComponentPlacement.RELATED)
					.addComponent(lblNewLabel, GroupLayout.DEFAULT_SIZE, 27, Short.MAX_VALUE))
		);
		groupLayout.setVerticalGroup(
			groupLayout.createParallelGroup(Alignment.LEADING)
				.addGroup(groupLayout.createSequentialGroup()
					.addComponent(lblNewLabel, GroupLayout.DEFAULT_SIZE, 177, Short.MAX_VALUE)
					.addGap(29))
				.addGroup(groupLayout.createSequentialGroup()
					.addGap(52)
					.addComponent(btnNewButton, GroupLayout.DEFAULT_SIZE, 103, Short.MAX_VALUE)
					.addGap(51))
		);
		setLayout(groupLayout);
	}
	
	@Override
	  protected void paintComponent(Graphics g) {
		try {
			InputStream stream = getClass().getResourceAsStream("/Icone/MenuAlloggi.png");
			Image immagine = new ImageIcon(ImageIO.read(stream)).getImage();
			
		    super.paintComponent(g);
		        g.drawImage(immagine, 0, 0, null);
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
}
