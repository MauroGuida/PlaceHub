package oggetti;

import javax.swing.JPanel;

import java.awt.Color;
import javax.swing.JLabel;
import java.awt.Font;
import javax.swing.ImageIcon;
import javax.swing.GroupLayout;
import javax.swing.GroupLayout.Alignment;
import javax.swing.LayoutStyle.ComponentPlacement;

public class Locale extends JPanel {
	private static final long serialVersionUID = 1L;
	
	private JLabel lblStelle;
	
	public Locale() {
		setBackground(Color.BLUE);
		setSize(225,185);
		setVisible(true);
		
		JLabel labelNome = new JLabel("Nome");
		labelNome.setFont(new Font("Roboto", Font.PLAIN, 13));
		
		JLabel labelLuogo = new JLabel("Indirizzo, Citta'");
		labelLuogo.setFont(new Font("Roboto", Font.PLAIN, 13));
		
		lblStelle = new JLabel();
		lblStelle.setIcon(new ImageIcon(Locale.class.getResource("/Icone/stella.png")));
		lblStelle.setFont(new Font("Roboto", Font.PLAIN, 13));
		
		JLabel labelmmagine = new JLabel("");
		labelmmagine.setBackground(new Color(255, 0, 0));
		GroupLayout groupLayout = new GroupLayout(this);
		groupLayout.setHorizontalGroup(
			groupLayout.createParallelGroup(Alignment.LEADING)
				.addComponent(labelmmagine, GroupLayout.DEFAULT_SIZE, 225, Short.MAX_VALUE)
				.addComponent(labelLuogo, GroupLayout.DEFAULT_SIZE, 225, Short.MAX_VALUE)
				.addGroup(groupLayout.createSequentialGroup()
					.addComponent(labelNome, GroupLayout.PREFERRED_SIZE, 120, GroupLayout.PREFERRED_SIZE)
					.addGap(10)
					.addComponent(lblStelle, GroupLayout.PREFERRED_SIZE, 95, GroupLayout.PREFERRED_SIZE))
		);
		groupLayout.setVerticalGroup(
			groupLayout.createParallelGroup(Alignment.LEADING)
				.addGroup(groupLayout.createSequentialGroup()
					.addComponent(labelmmagine, GroupLayout.PREFERRED_SIZE, 110, GroupLayout.PREFERRED_SIZE)
					.addComponent(labelLuogo, GroupLayout.PREFERRED_SIZE, 33, GroupLayout.PREFERRED_SIZE)
					.addGap(2)
					.addGroup(groupLayout.createParallelGroup(Alignment.LEADING)
						.addComponent(labelNome, GroupLayout.PREFERRED_SIZE, 40, GroupLayout.PREFERRED_SIZE)
						.addComponent(lblStelle, GroupLayout.PREFERRED_SIZE, 40, GroupLayout.PREFERRED_SIZE)))
		);
		setLayout(groupLayout);
	}
}
