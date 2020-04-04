package gui;

import javax.swing.JPanel;
import javax.swing.ScrollPaneConstants;
import javax.swing.border.LineBorder;

import oggetti.Recensione;
import res.ScrollPaneVerde;

import java.awt.Color;
import java.awt.FlowLayout;

import javax.imageio.ImageIO;
import javax.swing.ImageIcon;
import javax.swing.JLabel;
import java.awt.Font;
import java.awt.Image;
import java.io.File;
import java.io.IOException;

import javax.swing.JTextArea;

public class RecensioneGUI extends JPanel {
	private static final long serialVersionUID = 1L;
	
	private JPanel pannelloImmagini;
	private ScrollPaneVerde scrollPaneImmagini;
	private JLabel testoUsername;
	private JTextArea textAreaRecensione;
	private StelleGUI stelle;
	
	public RecensioneGUI() {
		setBackground(Color.WHITE);
		setSize(750,250);
		setLayout(null);
		
	    generaTestoUsername();	
		generaContenitoreFoto();
		generaTextAreaRecensione();
		generaPannelloStelle();
	}
	
	private void generaPannelloStelle() {
		stelle = new StelleGUI();
		stelle.setLocation(540, 1);
		add(stelle);
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
	
	
	//Metodi
	
	
	public void configuraPannello(Recensione recensioneLocale) {
		testoUsername.setText(recensioneLocale.getCodUtente());
		textAreaRecensione.setText(recensioneLocale.getTestoRecensione());
		
		try {
            for (String immagine : recensioneLocale.getListaImmagini()) {
            	Image imgScalata = new ImageIcon(ImageIO.read(new File(immagine))).getImage().getScaledInstance(130, 90, java.awt.Image.SCALE_SMOOTH);

                JLabel nuovaImmagine = new JLabel();
                nuovaImmagine.setSize(130, 90);
                nuovaImmagine.setIcon(new ImageIcon(imgScalata));

                pannelloImmagini.add(nuovaImmagine);
			}
        } catch (IOException e) {
            e.printStackTrace();
        }
		
		stelle.aggiungiStelle(recensioneLocale.getStelle());
	}
}
