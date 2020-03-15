package gui.pannelliSchermataPrincipale;

import java.awt.Color;
import java.awt.Font;
import java.awt.event.FocusAdapter;
import java.awt.event.FocusEvent;
import java.awt.event.MouseAdapter;
import java.awt.event.MouseEvent;

import javax.swing.ImageIcon;
import javax.swing.JButton;
import javax.swing.JLabel;
import javax.swing.JPanel;
import javax.swing.JTextArea;
import javax.swing.border.LineBorder;

import gui.SchermataPrincipale;

public class ScriviRecensione extends JPanel {
	
	private JButton bottonePubblica;
	private JButton bottoneCancella;
	private JLabel immagineFoto_1;
	private JLabel immagineFoto_2;
	private JLabel immagineFoto_3;
	private JTextArea textAreaScriviRecensione;
	private JLabel testoInfo_1;
	private JLabel testoInfo_2;
	private JLabel testoTrascinaFoto;
	
	public ScriviRecensione() {
		setSize(850, 614);
		setBackground(Color.WHITE);
		setLayout(null);
		
		generaBottonePubblica();
		generaBottoneCancella();
		
		generaImmagineFoto_1();
		generaImmagineFoto_2();
		generaImmagineFoto_3();
		
		generaTextAreaScriviRecensione();
		generaTestoInfo_1();
		generaTestoInfo_2();
		generaTestoTrascinaFoto();
		
	}

	private void generaTestoTrascinaFoto() {
		testoTrascinaFoto = new JLabel("Trascina qui le tue immagini");
		testoTrascinaFoto.setFont(new Font("Roboto", Font.PLAIN, 24));
		testoTrascinaFoto.setBounds(42, 340, 766, 39);
		add(testoTrascinaFoto);
	}

	private void generaTestoInfo_2() {
		testoInfo_2 = new JLabel("Una volta pubblicata la recensione non sara' piu' possibile recensire di nuovo questa attivita' ");
		testoInfo_2.setFont(new Font("Roboto", Font.PLAIN, 13));
		testoInfo_2.setBounds(42, 303, 766, 26);
		add(testoInfo_2);
	}

	private void generaTestoInfo_1() {
		testoInfo_1 = new JLabel("La tua recensione verra'\u00A0 pubblicata e sara'\u00A0 visibile a tutti gli utenti registrati");
		testoInfo_1.setFont(new Font("Roboto", Font.PLAIN, 13));
		testoInfo_1.setBounds(42, 11, 447, 30);
		add(testoInfo_1);
	}

	private void generaTextAreaScriviRecensione() {
		textAreaScriviRecensione = new JTextArea();
		textAreaScriviRecensione.setRows(30);
		textAreaScriviRecensione.addFocusListener(new FocusAdapter() {
			@Override
			public void focusGained(FocusEvent e) {
				textAreaScriviRecensione.setText("");
				textAreaScriviRecensione.setForeground(Color.BLACK);
			}
		});
		textAreaScriviRecensione.setForeground(Color.DARK_GRAY);
		textAreaScriviRecensione.setBorder(new LineBorder(Color.BLACK,1));
		textAreaScriviRecensione.setFont(new Font("Roboto", Font.PLAIN, 17));
		textAreaScriviRecensione.setText("Scrivi qui la tua recensione (MAX 2000 caratteri)");
		textAreaScriviRecensione.setBounds(42, 53, 766, 240);
		add(textAreaScriviRecensione);
	}

	private void generaImmagineFoto_3() {
		immagineFoto_3 = new JLabel("");
		immagineFoto_3.setIcon(new ImageIcon(SchermataPrincipale.class.getResource("/Icone/camera.png")));
		immagineFoto_3.setBounds(617, 390, 128, 128);
		add(immagineFoto_3);
	}

	private void generaImmagineFoto_2() {
		immagineFoto_2 = new JLabel("");
		immagineFoto_2.setIcon(new ImageIcon(SchermataPrincipale.class.getResource("/Icone/camera.png")));
		immagineFoto_2.setBounds(361, 390, 128, 128);
		add(immagineFoto_2);
	}

	private void generaImmagineFoto_1() {
		immagineFoto_1 = new JLabel("");
		immagineFoto_1.setIcon(new ImageIcon(SchermataPrincipale.class.getResource("/Icone/camera.png")));
		immagineFoto_1.setBounds(104, 390, 128, 128);
		add(immagineFoto_1);
	}

	private void generaBottoneCancella() {
		bottoneCancella = new JButton("");
		bottoneCancella.addMouseListener(new MouseAdapter() {
			@Override
			public void mouseEntered(MouseEvent e) {
				bottoneCancella.setIcon(new ImageIcon(SchermataPrincipale.class.getResource("/Icone/bottoneCancellaFocus.png")));
			}
			@Override
			public void mouseExited(MouseEvent e) {
				bottoneCancella.setIcon(new ImageIcon(SchermataPrincipale.class.getResource("/Icone/bottoneCancella.png")));
			}
		});
		bottoneCancella.setIcon(new ImageIcon(SchermataPrincipale.class.getResource("/Icone/bottoneCancella.png")));
		bottoneCancella.setBounds(42, 537, 140, 50);
		bottoneCancella.setOpaque(false);
		bottoneCancella.setBorderPainted(false);
		bottoneCancella.setContentAreaFilled(false);
		add(bottoneCancella);
	}

	private void generaBottonePubblica() {
		bottonePubblica = new JButton("");
		bottonePubblica.addMouseListener(new MouseAdapter() {
			@Override
			public void mouseEntered(MouseEvent e) {
				bottonePubblica.setIcon(new ImageIcon(SchermataPrincipale.class.getResource("/Icone/bottonePubblicaFocus.png")));
			}
			@Override
			public void mouseExited(MouseEvent e) {
				bottonePubblica.setIcon(new ImageIcon(SchermataPrincipale.class.getResource("/Icone/bottonePubblica.png")));
			}
		});
		
		bottonePubblica.setIcon(new ImageIcon(SchermataPrincipale.class.getResource("/Icone/bottonePubblica.png")));
		bottonePubblica.setBounds(668, 537, 140, 50);
		bottonePubblica.setOpaque(false);
		bottonePubblica.setBorderPainted(false);
		bottonePubblica.setContentAreaFilled(false);
		add(bottonePubblica);
	}
}
