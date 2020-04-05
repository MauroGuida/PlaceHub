package oggetti.GUI;

import javax.swing.JPanel;
import javax.swing.ScrollPaneConstants;
import javax.swing.border.LineBorder;

import oggetti.Recensione;

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
import javax.swing.GroupLayout;
import javax.swing.GroupLayout.Alignment;
import javax.swing.LayoutStyle.ComponentPlacement;

public class RecensioneGUI extends JPanel {
	private static final long serialVersionUID = 1L;
	
	private JPanel pannelloImmagini;
	private ScrollPaneVerde scrollPaneImmagini;
	private JLabel testoUsername;
	private JTextArea textAreaRecensione;
	private StelleGUI stelle;
	
	public RecensioneGUI() {
		setBackground(Color.WHITE);
		setSize(750,210);
		setBorder(new LineBorder(Color.BLACK,1));
		
	    generaTestoUsername();	
		generaContenitoreFoto();
		generaTextAreaRecensione();
		generaPannelloStelle();
	}
	
	private void generaPannelloStelle() {
		stelle = new StelleGUI();
		GroupLayout groupLayout = new GroupLayout(this);
		groupLayout.setHorizontalGroup(
			groupLayout.createParallelGroup(Alignment.LEADING)
				.addGroup(groupLayout.createSequentialGroup()
					.addGap(25)
					.addGroup(groupLayout.createParallelGroup(Alignment.LEADING)
						.addGroup(groupLayout.createSequentialGroup()
							.addComponent(textAreaRecensione, GroupLayout.DEFAULT_SIZE, 687, Short.MAX_VALUE)
							.addGap(23))
						.addGroup(groupLayout.createSequentialGroup()
							.addGroup(groupLayout.createParallelGroup(Alignment.LEADING)
								.addGroup(groupLayout.createSequentialGroup()
									.addComponent(testoUsername, GroupLayout.PREFERRED_SIZE, 466, GroupLayout.PREFERRED_SIZE)
									.addPreferredGap(ComponentPlacement.RELATED, 49, Short.MAX_VALUE)
									.addComponent(stelle, GroupLayout.PREFERRED_SIZE, 185, GroupLayout.PREFERRED_SIZE))
								.addComponent(scrollPaneImmagini, GroupLayout.DEFAULT_SIZE, 700, Short.MAX_VALUE))
							.addGap(23))))
		);
		groupLayout.setVerticalGroup(
			groupLayout.createParallelGroup(Alignment.LEADING)
				.addGroup(groupLayout.createSequentialGroup()
					.addGap(1)
					.addGroup(groupLayout.createParallelGroup(Alignment.LEADING)
						.addGroup(groupLayout.createSequentialGroup()
							.addGap(11)
							.addComponent(testoUsername, GroupLayout.PREFERRED_SIZE, 31, GroupLayout.PREFERRED_SIZE))
						.addComponent(stelle, GroupLayout.PREFERRED_SIZE, 45, GroupLayout.PREFERRED_SIZE))
					.addGap(4)
					.addComponent(scrollPaneImmagini, GroupLayout.PREFERRED_SIZE, 115, GroupLayout.PREFERRED_SIZE)
					.addGap(12)
					.addComponent(textAreaRecensione, GroupLayout.DEFAULT_SIZE, 24, Short.MAX_VALUE)
					.addGap(9))
		);
		setLayout(groupLayout);
	}

	private void generaTextAreaRecensione() {
		textAreaRecensione = new JTextArea();
		textAreaRecensione.setEditable(false);
		textAreaRecensione.setLineWrap(true);
		textAreaRecensione.setFont(new Font("Roboto", Font.PLAIN, 15));
		textAreaRecensione.setText("DINAMICO");
	}

	private void generaContenitoreFoto() {
		pannelloImmagini = new JPanel();
		pannelloImmagini.setBackground(Color.WHITE);
		pannelloImmagini.setLayout(new FlowLayout(FlowLayout.LEFT));
		pannelloImmagini.setBorder(new LineBorder(Color.DARK_GRAY,1));
		
		scrollPaneImmagini = new ScrollPaneVerde();
		scrollPaneImmagini.setVerticalScrollBarPolicy(ScrollPaneConstants.VERTICAL_SCROLLBAR_NEVER);
		scrollPaneImmagini.setHorizontalScrollBarPolicy(ScrollPaneConstants.HORIZONTAL_SCROLLBAR_AS_NEEDED);
		scrollPaneImmagini.setBackground(Color.WHITE);
		scrollPaneImmagini.setViewportView(pannelloImmagini);
		scrollPaneImmagini.setVisible(false);
	}

	private void generaTestoUsername() {
		testoUsername = new JLabel("DINAMICO");
		testoUsername.setFont(new Font("Roboto", Font.PLAIN, 20));
	}
	
	
	//Metodi
	
	
	public void configuraPannello(Recensione recensioneLocale) {
		testoUsername.setText(recensioneLocale.getUsernameUtente());
		textAreaRecensione.setText(recensioneLocale.getTestoRecensione());
		
		try {
            for (String immagine : recensioneLocale.getListaImmagini()) {
            	scrollPaneImmagini.setVisible(true);
            	
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
