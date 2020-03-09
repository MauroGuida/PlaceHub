package gui;

import java.awt.BorderLayout;
import javax.swing.JFrame;
import javax.swing.JPanel;
import javax.swing.border.EmptyBorder;

import gestione.Controller;
import java.awt.Color;
import java.awt.FlowLayout;
import java.awt.GridLayout;
import javax.swing.JButton;

public class SchermataPrincipale extends JFrame {
	private static final long serialVersionUID = 1L;
	
	private JPanel pannelloInferiore;
	private Controller ctrl;

	public SchermataPrincipale(Controller Ctrl) {
		this.ctrl = Ctrl;
		setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
		setBounds(100, 100, 450, 300);
		setSize(1100,650);
		pannelloInferiore = new JPanel();
		pannelloInferiore.setBorder(new EmptyBorder(5, 5, 5, 5));
		setContentPane(pannelloInferiore);
		pannelloInferiore.setLayout(null);
		
		JPanel panel = new JPanel();
		panel.setBackground(Color.WHITE);
		panel.setBounds(0, -30, 250, 650);
		pannelloInferiore.add(panel);
		panel.setLayout(new GridLayout());
		
		JButton btnHomepage = new JButton("Homepage");
		panel.add(btnHomepage);
	}
}
