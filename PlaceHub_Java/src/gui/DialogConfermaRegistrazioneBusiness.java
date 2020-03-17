package gui;

import java.awt.Color;
import java.awt.Font;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.awt.event.MouseAdapter;
import java.awt.event.MouseEvent;
import javax.swing.ImageIcon;
import javax.swing.JButton;
import javax.swing.JDialog;
import javax.swing.JLabel;
import javax.swing.JPanel;

import gestione.Controller;

public class DialogConfermaRegistrazioneBusiness extends JDialog {

	private static final long serialVersionUID = 1L;
	private JButton bottoneOKConfermaRegistrazione;
	private JButton bottoneEsciConfermaRegistrazione;
	private JButton bottoneCancellaConfermaRegistrazione;
	private JLabel testoConfermaRegistrazione;
	private JLabel immagineAvvertenzaConfermaRegistrazione;
	private JPanel pannelloBottoniConfermaRegistrazione;
	private Controller ctrl;
	
	public DialogConfermaRegistrazioneBusiness(Controller Ctrl) {
		this.ctrl = Ctrl;
		layoutGeneraleDialog();
		generaBottoneOKConfermaRegistrazione();
		generaBottoneEsciConfermaRegistrazione();
		generaBottoneCancellaConfermaRegistrazione();	
		generaTestoConfermaRegistrazione();
		generaImmagineAvvertenzaConfermaRegistrazione();
		generaPannelloBottoniConfermaRegistrazione();	
	}


	private void layoutGeneraleDialog() {
		setBackground(Color.WHITE);
		setBounds(100, 100, 560, 270);
		getContentPane().setBounds(100, 100, 560, 270);
		setBackground(Color.WHITE);
		getContentPane().setLayout(null);
		setUndecorated(true);
		setResizable(false);
		getContentPane().setBackground(Color.WHITE);
		setAlwaysOnTop(true);
	}


	private void generaPannelloBottoniConfermaRegistrazione() {
		pannelloBottoniConfermaRegistrazione = new JPanel();
		pannelloBottoniConfermaRegistrazione.setBackground(Color.WHITE);
		pannelloBottoniConfermaRegistrazione.setBounds(1, 1, 558, 36);
		pannelloBottoniConfermaRegistrazione.setLayout(null);
		getContentPane().add(pannelloBottoniConfermaRegistrazione);
	}


	private void generaImmagineAvvertenzaConfermaRegistrazione() {
		immagineAvvertenzaConfermaRegistrazione = new JLabel("");
		immagineAvvertenzaConfermaRegistrazione.setIcon(new ImageIcon(SchermataPrincipale.class.getResource("/Icone/immagineAvvertenza.png")));
		immagineAvvertenzaConfermaRegistrazione.setBounds(248, 50, 64, 64);
		getContentPane().add(immagineAvvertenzaConfermaRegistrazione);
	}


	private void generaTestoConfermaRegistrazione() {
		testoConfermaRegistrazione = new JLabel("Confermi quanto scritto?");
		testoConfermaRegistrazione.setFont(new Font("Roboto", Font.PLAIN, 36));
		testoConfermaRegistrazione.setBounds(75, 121, 410, 35);
		getContentPane().add(testoConfermaRegistrazione);
	}


	private void generaBottoneCancellaConfermaRegistrazione() {
		bottoneCancellaConfermaRegistrazione = new JButton("");
		bottoneCancellaConfermaRegistrazione.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent e) {
				dispose();
			}
		});
		bottoneCancellaConfermaRegistrazione.setIcon(new ImageIcon(SchermataPrincipale.class.getResource("/Icone/bottoneCancella.png")));
		bottoneCancellaConfermaRegistrazione.setBounds(232, 202, 140, 50);
		bottoneCancellaConfermaRegistrazione.setOpaque(false);
		bottoneCancellaConfermaRegistrazione.setBorderPainted(false);
		bottoneCancellaConfermaRegistrazione.setFocusPainted(false);
		bottoneCancellaConfermaRegistrazione.setContentAreaFilled(false);
		bottoneCancellaConfermaRegistrazione.addMouseListener(new MouseAdapter() {
			@Override
			public void mouseEntered(MouseEvent e) {
				bottoneCancellaConfermaRegistrazione.setIcon(new ImageIcon(SchermataPrincipale.class.getResource("/Icone/bottoneCancellaFocus.png")));
			}
			@Override
			public void mouseExited(MouseEvent e) {
				bottoneCancellaConfermaRegistrazione.setIcon(new ImageIcon(SchermataPrincipale.class.getResource("/Icone/bottoneCancella.png")));
			}
		});
		getContentPane().add(bottoneCancellaConfermaRegistrazione);
	}


	private void generaBottoneEsciConfermaRegistrazione() {
		bottoneEsciConfermaRegistrazione = new JButton("");
		bottoneEsciConfermaRegistrazione.setOpaque(false);
		bottoneEsciConfermaRegistrazione.setBorderPainted(false);
		bottoneEsciConfermaRegistrazione.setContentAreaFilled(false);
		bottoneEsciConfermaRegistrazione.setFocusPainted(false);
		bottoneEsciConfermaRegistrazione.setIcon(new ImageIcon(SchermataPrincipale.class.getResource("/Icone/X.png")));
		bottoneEsciConfermaRegistrazione.setBounds(525, 6, 25, 25);
		bottoneEsciConfermaRegistrazione.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent arg0) {
				dispose();
			}
		});
		getContentPane().add(bottoneEsciConfermaRegistrazione);
	}


	private void generaBottoneOKConfermaRegistrazione() {
		bottoneOKConfermaRegistrazione = new JButton("");
		bottoneOKConfermaRegistrazione.setIcon(new ImageIcon(SchermataPrincipale.class.getResource("/Icone/bottoneOK.png")));
		bottoneOKConfermaRegistrazione.setBounds(396, 202, 140, 50);
		bottoneOKConfermaRegistrazione.setOpaque(false);
		bottoneOKConfermaRegistrazione.setBorderPainted(false);
		bottoneOKConfermaRegistrazione.setContentAreaFilled(false);
		bottoneOKConfermaRegistrazione.addMouseListener(new MouseAdapter() {
			@Override
			public void mouseEntered(MouseEvent e) {
				bottoneOKConfermaRegistrazione.setIcon(new ImageIcon(SchermataPrincipale.class.getResource("/Icone/bottoneOKFocus.png")));
			}
			@Override
			public void mouseExited(MouseEvent e) {
				bottoneOKConfermaRegistrazione.setIcon(new ImageIcon(SchermataPrincipale.class.getResource("/Icone/bottoneOK.png")));
			}
		});
		getContentPane().add(bottoneOKConfermaRegistrazione);
	}
}
