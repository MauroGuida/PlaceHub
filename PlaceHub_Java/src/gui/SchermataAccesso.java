package gui;

import java.awt.BorderLayout;

import javax.swing.JFrame;
import javax.swing.JPanel;
import javax.swing.border.EmptyBorder;

import gestione.Controller;

public class SchermataAccesso extends JFrame {
	private static final long serialVersionUID = 1L;
	
	private JPanel contentPane;
	
	private Controller ctrl;

	//Generazione finestra
	public SchermataAccesso(Controller Ctrl) {
		this.ctrl=Ctrl;
		
		setLocationRelativeTo(null);
		setUndecorated(true);
		setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
		setBounds(100, 100, 450, 300);
		setSize(1100,650);
		
		contentPane = new JPanel();
		contentPane.setBorder(new EmptyBorder(5, 5, 5, 5));
		contentPane.setLayout(new BorderLayout(0, 0));
		setContentPane(contentPane);
	}

}
