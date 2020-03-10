package oggetti;

import javax.swing.JPanel;
import java.awt.Color;
import javax.swing.JLabel;
import java.awt.Font;
import javax.swing.ImageIcon;

public class Locale extends JPanel {
	private JLabel lblStelle;
	
	public Locale() {
		setBackground(new Color(255, 255, 255));
		setBounds(0,0,274,204);
		setLayout(null);
		
		lblStelle = new JLabel();
		lblStelle.setIcon(new ImageIcon(Locale.class.getResource("/Icone/stella.png")));
		lblStelle.setFont(new Font("Roboto", Font.PLAIN, 13));
		lblStelle.setBounds(12, 169, 24, 24);
		add(lblStelle);
		
		JLabel labelNome = new JLabel("Nome");
		labelNome.setFont(new Font("Roboto", Font.PLAIN, 13));
		labelNome.setBounds(12, 137, 110, 20);
		add(labelNome);
		
		JLabel labelLuogo = new JLabel("Indirizzo,Città");
		labelLuogo.setFont(new Font("Roboto", Font.PLAIN, 13));
		labelLuogo.setBounds(139, 140, 123, 15);
		add(labelLuogo);
		
		JLabel labelmmagine = new JLabel("Immagine");
		labelmmagine.setBackground(new Color(255, 0, 0));
		labelmmagine.setBounds(12, 10, 244, 125);
		add(labelmmagine);
	}
}
