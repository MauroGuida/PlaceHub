package gui.pannelliSchermataAccesso.menuATendina;

import java.awt.Color;
import java.awt.Graphics;
import java.awt.Image;
import java.io.InputStream;

import javax.swing.ImageIcon;
import javax.swing.JPanel;

import javax.imageio.ImageIO;
import javax.swing.GroupLayout;
import javax.swing.GroupLayout.Alignment;
import javax.swing.JButton;
import java.awt.event.ComponentAdapter;
import java.awt.event.ComponentEvent;

public class Alloggi extends JPanel {
	private static final long serialVersionUID = 1L;
	
	public Alloggi() {
		addComponentListener(new ComponentAdapter() {
			@Override
			public void componentResized(ComponentEvent e) {
				resize(184, 206);
			}
		});
		setSize(184,206);
		setBackground(new Color(0,0,0,0));
		setVisible(true);
		
		JButton btnNewButton = new JButton("New button");
		GroupLayout groupLayout = new GroupLayout(this);
		groupLayout.setHorizontalGroup(
			groupLayout.createParallelGroup(Alignment.LEADING)
				.addGroup(groupLayout.createSequentialGroup()
					.addGap(38)
					.addComponent(btnNewButton, GroupLayout.DEFAULT_SIZE, GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
					.addGap(57))
		);
		groupLayout.setVerticalGroup(
			groupLayout.createParallelGroup(Alignment.LEADING)
				.addGroup(groupLayout.createSequentialGroup()
					.addGap(97)
					.addComponent(btnNewButton, GroupLayout.DEFAULT_SIZE, GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
					.addGap(86))
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
