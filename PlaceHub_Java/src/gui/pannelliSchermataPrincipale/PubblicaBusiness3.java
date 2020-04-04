package gui.pannelliSchermataPrincipale;

import java.awt.Color;
import java.awt.Font;
import java.awt.event.MouseAdapter;
import java.awt.event.MouseEvent;

import javax.swing.GroupLayout;
import javax.swing.ImageIcon;
import javax.swing.JButton;
import javax.swing.JLabel;
import javax.swing.JPanel;

import gestione.Controller;

import javax.swing.GroupLayout.Alignment;

import gui.SchermataPrincipale;
import java.awt.event.ActionListener;
import java.awt.event.ActionEvent;

public class PubblicaBusiness3 extends JPanel {
	private static final long serialVersionUID = 1L;
	
	private JLabel testoRegistrazioneAvvenutaConSuccesso;
	private JLabel immagineVerificato;
	private JButton bottoneOK;

	public PubblicaBusiness3() {
		setSize(850, 614);
		setVisible(false);
		setBackground(Color.WHITE);
		
		testoRegistrazioneAvvenutaConSuccesso = new JLabel("Registrazione avvenuta con successo!");
		testoRegistrazioneAvvenutaConSuccesso.setFont(new Font("Roboto", Font.PLAIN, 25));
		
		immagineVerificato = new JLabel("");
		immagineVerificato.setIcon(new ImageIcon(SchermataPrincipale.class.getResource("/Icone/verified.png")));
		
		bottoneOK = new JButton("");
		bottoneOK.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent e) {
				Controller.getSchermataPrincipaleFrame().mostraHomepage();
			}
		});
		bottoneOK.setOpaque(false);
		bottoneOK.setBorderPainted(false);
		bottoneOK.setContentAreaFilled(false);
		bottoneOK.addMouseListener(new MouseAdapter() {
			@Override
			public void mouseEntered(MouseEvent e) {
				bottoneOK.setIcon(new ImageIcon(SchermataPrincipale.class.getResource("/Icone/bottoneOKFocus.png")));
			}
			@Override
			public void mouseExited(MouseEvent e) {
				bottoneOK.setIcon(new ImageIcon(SchermataPrincipale.class.getResource("/Icone/bottoneOK.png")));
			}
		});
		bottoneOK.setIcon(new ImageIcon(SchermataPrincipale.class.getResource("/Icone/bottoneOK.png")));
		
		GroupLayout gl_pannelloGestisciBusiness3 = new GroupLayout(this);
		gl_pannelloGestisciBusiness3.setHorizontalGroup(
			gl_pannelloGestisciBusiness3.createParallelGroup(Alignment.TRAILING)
				.addGroup(gl_pannelloGestisciBusiness3.createSequentialGroup()
					.addGap(352)
					.addComponent(immagineVerificato, GroupLayout.DEFAULT_SIZE, GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
					.addGap(353))
				.addGroup(gl_pannelloGestisciBusiness3.createSequentialGroup()
					.addGap(197)
					.addComponent(testoRegistrazioneAvvenutaConSuccesso, GroupLayout.DEFAULT_SIZE, 430, Short.MAX_VALUE)
					.addGap(198))
				.addGroup(gl_pannelloGestisciBusiness3.createSequentialGroup()
					.addGap(643)
					.addComponent(bottoneOK, GroupLayout.PREFERRED_SIZE, 140, GroupLayout.PREFERRED_SIZE)
					.addGap(42))
		);
		gl_pannelloGestisciBusiness3.setVerticalGroup(
			gl_pannelloGestisciBusiness3.createParallelGroup(Alignment.LEADING)
				.addGroup(gl_pannelloGestisciBusiness3.createSequentialGroup()
					.addGap(180)
					.addComponent(immagineVerificato, GroupLayout.DEFAULT_SIZE, 120, Short.MAX_VALUE)
					.addGap(13)
					.addComponent(testoRegistrazioneAvvenutaConSuccesso, GroupLayout.PREFERRED_SIZE, 30, Short.MAX_VALUE)
					.addGap(194)
					.addComponent(bottoneOK, GroupLayout.PREFERRED_SIZE, 50, GroupLayout.PREFERRED_SIZE)
					.addGap(27))
		);
		setLayout(gl_pannelloGestisciBusiness3);
	}
}
