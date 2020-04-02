package gui;

import javax.swing.JPanel;
import javax.swing.ScrollPaneConstants;
import javax.swing.border.LineBorder;

import res.ScrollPaneVerde;

import java.awt.Color;
import java.awt.FlowLayout;

import javax.swing.JLabel;
import java.awt.Font;
import javax.swing.JTextArea;

public class RecensioneGUI extends JPanel {
	private static final long serialVersionUID = 1L;
	
	private JPanel pannelloImmagini;
	private ScrollPaneVerde scrollPaneImmagini;
	private JLabel testoUsername;
	private JTextArea textAreaRecensione;
	
	public RecensioneGUI() {
		setBackground(Color.WHITE);
		setSize(750,250);
		setLayout(null);
		
	    generaTestoUsername();	
		generaContenitoreFoto();
		generaTextAreaRecensione();
	}

	private void generaTextAreaRecensione() {
		textAreaRecensione = new JTextArea();
		textAreaRecensione.setEditable(false);
		textAreaRecensione.setFont(new Font("Roboto", Font.PLAIN, 15));
		textAreaRecensione.setText("DINAMICO");
		textAreaRecensione.setBounds(25, 177, 700, 61);
		add(textAreaRecensione);
	}

	private void generaContenitoreFoto() {
		pannelloImmagini = new JPanel();
		pannelloImmagini.setBackground(Color.WHITE);
		pannelloImmagini.setLayout(new FlowLayout(FlowLayout.LEFT));
		pannelloImmagini.setBorder(new LineBorder(Color.DARK_GRAY,1));
		
		scrollPaneImmagini = new ScrollPaneVerde();
		scrollPaneImmagini.setBounds(25, 50, 700, 115);
		scrollPaneImmagini.setVerticalScrollBarPolicy(ScrollPaneConstants.VERTICAL_SCROLLBAR_NEVER);
		scrollPaneImmagini.setHorizontalScrollBarPolicy(ScrollPaneConstants.HORIZONTAL_SCROLLBAR_AS_NEEDED);
		scrollPaneImmagini.setBackground(Color.WHITE);
		scrollPaneImmagini.setViewportView(pannelloImmagini);
		add(scrollPaneImmagini);
	}

	private void generaTestoUsername() {
		testoUsername = new JLabel("DINAMICO");
		testoUsername.setFont(new Font("Roboto", Font.PLAIN, 20));
		testoUsername.setBounds(25, 12, 466, 31);
		add(testoUsername);
	}
}
