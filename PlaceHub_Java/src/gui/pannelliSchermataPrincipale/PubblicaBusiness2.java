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

public class PubblicaBusiness2 extends JPanel {

	private static final long serialVersionUID = 1L;
	private JLabel testoDescriviBusiness;
	private JTextArea textAreaDescriviBusiness;
	private JLabel testoTrascinaImmagini;
	private JLabel immagineFoto_1;
	private JLabel immagineFoto_2;
	private JLabel immagineFoto_3;
	private JButton bottoneIndietro;
	private JButton bottoneAvanti;
	
	 public PubblicaBusiness2() {
		setLayout(null);
		setSize(850, 614);
		setBackground(Color.WHITE);
		
		generaCampoDescriviBusiness();
		generaTestoTrascinaImmagini();
		
		generaImmagineFoto_1();
		generaImmagineFoto_2();
		generaImmagineFoto_3();
		
		generaBottoneIndietro();
		generaBottoneAvanti();
	}

	private void generaBottoneAvanti() {
		bottoneAvanti = new JButton("");
		bottoneAvanti.setBounds(682, 540, 140, 50);
		bottoneAvanti.setIcon(new ImageIcon(SchermataPrincipale.class.getResource("/Icone/AvantiButton.png")));
		bottoneAvanti.setOpaque(false);
		bottoneAvanti.setContentAreaFilled(false);
		bottoneAvanti.setBorderPainted(false);
		bottoneAvanti.setFocusPainted(false);
		bottoneAvanti.addMouseListener(new MouseAdapter() {
			@Override
			public void mouseEntered(MouseEvent e) {
				bottoneAvanti.setIcon(new ImageIcon(SchermataPrincipale.class.getResource("/Icone/AvantiButtonFocus.png")));

			}
			@Override
			public void mouseExited(MouseEvent e) {
				bottoneAvanti.setIcon(new ImageIcon(SchermataPrincipale.class.getResource("/Icone/AvantiButton.png")));
			}
		});
		add(bottoneAvanti);
	}

	private void generaBottoneIndietro() {
		bottoneIndietro = new JButton("");
		bottoneIndietro.setBounds(27, 540, 140, 50);
		bottoneIndietro.setIcon(new ImageIcon(SchermataPrincipale.class.getResource("/Icone/IndietroButton.png")));
		bottoneIndietro.setOpaque(false);
		bottoneIndietro.setContentAreaFilled(false);
		bottoneIndietro.setBorderPainted(false);
		bottoneIndietro.setFocusPainted(false);
		bottoneIndietro.addMouseListener(new MouseAdapter() {
			@Override
			public void mouseEntered(MouseEvent e) {
				bottoneIndietro.setIcon(new ImageIcon(SchermataPrincipale.class.getResource("/Icone/IndietroButtonFocus.png")));
			}
			@Override
			public void mouseExited(MouseEvent e) {
				bottoneIndietro.setIcon(new ImageIcon(SchermataPrincipale.class.getResource("/Icone/IndietroButton.png")));
			}
		});
		add(bottoneIndietro);
	}

	private void generaImmagineFoto_3() {
		immagineFoto_3 = new JLabel("");
		immagineFoto_3.setBounds(625, 380, 128, 128);
		immagineFoto_3.setIcon(new ImageIcon(SchermataPrincipale.class.getResource("/Icone/camera.png")));
		add(immagineFoto_3);
	}

	private void generaImmagineFoto_2() {
		immagineFoto_2 = new JLabel("");
		immagineFoto_2.setBounds(362, 380, 141, 128);
		immagineFoto_2.setIcon(new ImageIcon(SchermataPrincipale.class.getResource("/Icone/camera.png")));
		add(immagineFoto_2);
	}

	private void generaImmagineFoto_1() {
		immagineFoto_1 = new JLabel("");
		immagineFoto_1.setBounds(100, 380, 140, 128);
		immagineFoto_1.setIcon(new ImageIcon(SchermataPrincipale.class.getResource("/Icone/camera.png")));
		add(immagineFoto_1);
	}

	private void generaTestoTrascinaImmagini() {
		testoTrascinaImmagini = new JLabel("Trascina Immagini");
		testoTrascinaImmagini.setBounds(27, 331, 252, 37);
		testoTrascinaImmagini.setFont(new Font("Roboto", Font.PLAIN, 20));
		add(testoTrascinaImmagini);
	}

	private void generaCampoDescriviBusiness() {
		testoDescriviBusiness = new JLabel("Descrivi la tua attivita'");
		testoDescriviBusiness.setFont(new Font("Roboto", Font.PLAIN, 20));
		testoDescriviBusiness.setBounds(27, 8, 417, 23);
		add(testoDescriviBusiness);
		
		textAreaDescriviBusiness = new JTextArea();
		textAreaDescriviBusiness.setForeground(new Color(192, 192, 192));
		textAreaDescriviBusiness.setBackground(new Color(255, 255, 255));
		textAreaDescriviBusiness.setFont(new Font("Roboto", Font.PLAIN, 17));
		textAreaDescriviBusiness.setRows(20);
		textAreaDescriviBusiness.setColumns(55);
		textAreaDescriviBusiness.setText("Scrivi qui! MAX(2000 caratteri)");
		textAreaDescriviBusiness.setForeground(Color.DARK_GRAY);
		textAreaDescriviBusiness.setBorder(new LineBorder(Color.BLACK,1));
		textAreaDescriviBusiness.setBounds(27, 43, 795, 247);
		textAreaDescriviBusiness.addFocusListener(new FocusAdapter() {
			@Override
			public void focusGained(FocusEvent e) {
				textAreaDescriviBusiness.setText("");
				textAreaDescriviBusiness.setForeground(Color.BLACK);
			}
		});
		add(textAreaDescriviBusiness);
	}
}
